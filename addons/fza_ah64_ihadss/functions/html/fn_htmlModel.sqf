/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlModel

Description:
    Builds the JSON model the HTML IHADSS page draws from. Virtual symbols
    are placed natively by fza_ihadss_fnc_htmlIcons instead.

Parameters:
    _heli         - The helicopter
    _headsDown    - True when the CPG is looking through the TADS
    _weaponFormat - True when the weapon symbology format is shown
    _tadsVideo    - True when the TADS picture is on the CPG's HDU

Returns:
    JSON text

Examples:
    --- Code
    private _json = [_heli, false, false, false] call fza_ihadss_fnc_htmlModel
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_headsDown", "_weaponFormat", ["_tadsVideo", false]];

private _m        = createHashMap;
private _isPilot  = player == driver _heli;
private _sight    = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};
private _mode     = _heli getVariable ["fza_ah64_hmdfsmode", "trans"];
private _was      = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];
private _heliDir  = getDir _heli;
private _tadsAz   = _heli getVariable ["fza_ah64_tadsAzimuth", 0];
private _tadsEl   = _heli getVariable ["fza_ah64_tadsElevation", 0];
private _fcrOn    = _heli animationPhase "fcr_enable" == 1;
(_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) params [["_ntsObj", objNull], ["_ntsPos", [0, 0, 0]]];

private _camASL   = AGLToASL positionCameraToWorld [0, 0, 0];
private _camFwd   = vectorNormalized ((AGLToASL positionCameraToWorld [0, 0, 1]) vectorDiff _camASL);
private _camUp    = vectorNormalized ((AGLToASL positionCameraToWorld [0, 1, 0]) vectorDiff _camASL);
private _camRight = _camFwd vectorCrossProduct _camUp;

private _camAngles = {
    private _f = _this vectorDotProduct _camFwd;
    private _r = _this vectorDotProduct _camRight;
    [_r atan2 _f, (_this vectorDotProduct _camUp) atan2 (sqrt (_f * _f + _r * _r))]
};
private _modelAngles = {
    (_heli vectorWorldToModelVisual _this) params ["_x", "_y", "_z"];
    [_x atan2 _y, _z atan2 (sqrt (_x * _x + _y * _y))]
};
private _sightAz = {
    params ["_seatSight", "_unit"];
    switch (_seatSight) do {
        case SIGHT_HMD:  { if (isNull _unit) then {nil} else {((eyeDirection _unit) call _modelAngles) # 0} };
        case SIGHT_TADS: { _tadsAz };
        default { nil };
    };
};

private _camModel = (_camFwd call _modelAngles) apply {round _x};

_m set ["hd", _headsDown];
// The format is referenced to the TADS picture, as heads down
_m set ["tv", _tadsVideo];
_m set ["white", _headsDown];
_m set ["fmt", ["flt", "wpn"] select _weaponFormat];
_m set ["mode", _mode];
_m set ["hdg", _heliDir];

///////////////////////////////////////////////////////////////////////////////
// Heading tape
///////////////////////////////////////////////////////////////////////////////
private _nextPoint    = (_heli getVariable "fza_dms_routeNext") # 0;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;

if _weaponFormat then {
    private _losAz = if (_sight == SIGHT_HMD && !_headsDown) then {_camModel # 0} else {_tadsAz};
    _m set ["cmdHdg", _losAz];
} else {
    if (_mode == "bobup") then {
        _m set ["cmdHdg", (_heli getVariable ["fza_ah64_bobhdg", _heliDir]) - _heliDir];
    } else {
        if (!isNil "_nextPointPos") then {
            _m set ["cmdHdg", _heli getRelDir _nextPointPos];
        };
    };
};

private _otherSeat = ["plt", "cpg"] select _isPilot;
private _otherUnit = [driver _heli, gunner _heli] select _isPilot;
private _altSight  = [_heli, "fza_ah64_sight", _otherSeat] call fza_fnc_getSeatVariable;
// An AI CPG never selects a sight, the pilot's sight points its TADS
if (_isPilot && {!isPlayer _otherUnit}) then {_altSight = SIGHT_TADS};
private _altBrg    = [_altSight, _otherUnit] call _sightAz;
if (!isNil "_altBrg" && !isNull _otherUnit) then {
    _m set ["altBrg", _altBrg];
};

if _fcrOn then {
    private _fcrBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];
    _m set ["fcrBrg", _fcrBias];
    _m set ["fcrCur", _fcrBias];
    _heli getVariable "fza_ah64_fcrLastScan" params ["_lastDir"];
    if (!isNil "_lastDir") then {
        // Where the last scan looked (fza_fcr_fnc_update)
        private _last = [_lastDir - _heliDir] call CBA_fnc_simplifyAngle180;
        if (abs (_last - _fcrBias) > 1) then {
            _m set ["fcrLast", _last];
        };
    };
};

///////////////////////////////////////////////////////////////////////////////
// Flight data
///////////////////////////////////////////////////////////////////////////////
private _tq = _heli getVariable ["bmkhs_engPctTq", [0, 0]];
_m set ["tq", ((_tq # 0) max (_tq # 1)) * 100];
_m set ["tqSplit", abs ((_tq # 0) - (_tq # 1)) > 0.12];
_m set ["tas", round ((_heli getVariable ["bmkhs_vel2D", 0]) * MPS_TO_KNOTS)];
_m set ["vne", _heli getVariable ["fza_ah64_tas_vne", 0]];

// TGT shows in the last 2 minutes of a TGT timer, and all through the single engine 878 C timer
private _engTgt    = _heli getVariable ["bmkhs_engTgt", []];
private _engTimers = _heli getVariable ["bmkhs_engLimitTimers", []];
private _singleEng = (_heli getVariable ["bmkhs_isSingleEng", false]) || {({_x == "ON"} count (_heli getVariable ["bmkhs_engState", []])) == 1};
private _tgtShown  = -1;
{
    private _left = (_engTimers param [_forEachIndex, []]) param [2, -1];
    if (_left >= 0 && {_left <= 120 || {_singleEng && {_x > 878}}}) then {_tgtShown = _tgtShown max _x};
} forEach _engTgt;
if (_tgtShown >= 0) then {_m set ["tgt", round _tgtShown]};
_m set ["g", round (([_heli] call fza_fnc_avionicsLoadFactor) * 10) / 10];
_m set ["gLimit", _heli getVariable ["fza_ah64_loadFactorLimit", -1]];

private _radAlt = (_heli getVariable ["bmkhs_radAlt", 0]) * METERS_TO_FEET;
if (_radAlt <= 1428) then {
    _m set ["radAlt", [round (_radAlt max 0), round (_radAlt / 10) * 10] select (_radAlt > 50)];
};
_m set ["radAltHi", _heli getVariable ["fza_ah64_radAltHi", 200]];
_m set ["radAltLo", _heli getVariable ["fza_ah64_radAltLo", 33]];
_m set ["baroAlt", ((round ((_heli getVariable ["bmkhs_barAlt", 0]) / 10) * 10) max 0) min 20000];
_m set ["vsi", ((_heli getVariable ["bmkhs_velWorldSpace", [0, 0, 0]]) # 2) * MPS_TO_FPM];
_m set ["attHold", _heli getVariable ["bmkhs_attHoldActive", false]];
_m set ["altHold", _heli getVariable ["bmkhs_altHoldActive", false]];
_m set ["slip", fza_ah64_sideslip];

(_heli call fza_fnc_getPitchBank) params ["_pitch", "_bank"];
_m set ["pitch", _pitch];
_m set ["roll", _bank];
// Pitch bias of the HMD horizon line and pitch ladder, for a FLT SET page to set
_m set ["pitchBias", _heli getVariable ["fza_ah64_pitchBias", 5]];

private _velModel = _heli getVariable ["bmkhs_velModelSpaceNoWind", [0, 0, 0]];
_m set ["vel", [(_velModel # 0) * MPS_TO_KNOTS, (_velModel # 1) * MPS_TO_KNOTS]];
_m set ["acc", [_heli getVariable ["bmkhs_accelX", 0], _heli getVariable ["bmkhs_accelY", 0]]];

if (_mode == "bobup") then {
    private _bobPos = _heli getVariable ["fza_ah64_bobpos", getPosASL _heli];
    private _dx     = (_bobPos # 0) - (getPosASL _heli # 0);
    private _dy     = (_bobPos # 1) - (getPosASL _heli # 1);
    _m set ["bob",
        [ (_dx * cos _heliDir - _dy * sin _heliDir) * METERS_TO_FEET
        , (_dx * sin _heliDir + _dy * cos _heliDir) * METERS_TO_FEET
        ]];
};

if (!_weaponFormat && {_mode in ["trans", "cruise"]}) then {
    private _wpt = [_heli] call fza_mpd_fnc_tsdWaypointStatusText;
    // No time to go at or below 15 kt ground speed
    if ((_heli getVariable ["bmkhs_gndSpeed", 0]) * MPS_TO_KNOTS <= 15) then {_wpt set [3, ""]};
    _m set ["wpt", _wpt];
};

([_heli] call fza_ihadss_fnc_nvsState) params ["_nvsMode", "_nvsSensor"];
if (!_weaponFormat && {_nvsMode != NVS_MODE_OFF}) then {
    _m set ["nvsSensor", "FLIR"];
};

// The selected sight at a gimbal limit, or the night vision sensor's for the head: PNVS +-90 az, +20/-45 el, TADS +-120,
// +30/-60
private _atLimit = _nvsMode != NVS_MODE_OFF && {[
    abs (_camModel # 0) >= 90 || {(_camModel # 1) >= 20 || {(_camModel # 1) <= -45}},
    abs (_camModel # 0) >= 119.5 || {(_camModel # 1) >= 29.5 || {(_camModel # 1) <= -59.5}}
] select (_nvsSensor == "TADS")};
if (!_isPilot && {_sight in [SIGHT_HMD, SIGHT_TADS]}) then {
    private _tadsLos = [[_tadsAz, _tadsEl], _camModel] select (_sight == SIGHT_HMD && !_headsDown);
    _atLimit = _atLimit || {abs (_tadsLos # 0) >= 119.5 || {(_tadsLos # 1) >= 29.5 || {(_tadsLos # 1) <= -59.5}}};
};
private _gunFailed = _was == WAS_WEAPON_GUN && {
    _heli getHitPointDamage "hit_msnEquip_gun_turret" > SYS_WPN_DMG_THRESH
    || {_heli getHitPointDamage "hit_msnEquip_magAndRobbie" > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1}
    || {(_heli getVariable ["bmkhs_utilLevel_pct", 1]) < SYS_HYD_MIN_LVL}
    || {(_heli getVariable ["bmkhs_utilHydPsi", 3000]) < SYS_MIN_HYD_PSI}
};
_m set ["losFlash", _atLimit || _gunFailed];

///////////////////////////////////////////////////////////////////////////////
// Sensors
///////////////////////////////////////////////////////////////////////////////
_m set ["forType", ["tads", "pnvs"] select _isPilot];
_m set ["forFov", [[_tadsAz, _tadsEl], _camModel] select (_isPilot || (_sight == SIGHT_HMD && !_headsDown))];

private _curAcq = [_heli, [_heli] call fza_fnc_currentTurret] call fza_fnc_targetingCurAcq;
private _acqVec = [_heli, [_heli] call fza_fnc_currentTurret] call fza_fnc_targetingAcqCue;
if (!isNil "_acqVec") then {
    _acqVec = vectorNormalized _acqVec;
    _m set ["forCue", (_acqVec call _modelAngles) apply {round _x}];
    // The cueing dots point from the selected sight's LOS: the TADS LOS with TADS as the CPG's sight, otherwise the head
    private _cueAngles = _camAngles;
    private ["_tadsFwd", "_tadsRight", "_tadsUp"];
    if (!_isPilot && {_sight == SIGHT_TADS}) then {
        _tadsFwd   = vectorNormalized ([_heli, "TADS"] call fza_fnc_targetingAcqVec);
        _tadsRight = vectorNormalized (_tadsFwd vectorCrossProduct (_heli vectorModelToWorldVisual [0, 0, 1]));
        _tadsUp    = _tadsRight vectorCrossProduct _tadsFwd;
        _cueAngles = {
            private _f = _this vectorDotProduct _tadsFwd;
            private _r = _this vectorDotProduct _tadsRight;
            [_r atan2 _f, (_this vectorDotProduct _tadsUp) atan2 (sqrt (_f * _f + _r * _r))]
        };
    };
    _m set ["acq", (_acqVec call _cueAngles) apply {round _x}];
};

///////////////////////////////////////////////////////////////////////////////
// Weapon format
///////////////////////////////////////////////////////////////////////////////
if (_weaponFormat && {_headsDown || _tadsVideo}) then {
    private _visionMode = [_heli] call fza_ihadss_fnc_getVisionMode;
    _m set ["sensor", ["DTV", "FLIR", "FLIR", "DVO"] select (_visionMode max 0 min 3)];

    private _opticsMode = _heli getTurretOpticsMode [0];
    private _groups     = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 10, 11], [12, 13]];
    private _group      = _groups select {_opticsMode in _x};
    if (_group isNotEqualTo []) then {
        _group = _group # 0;
        private _next = _group find _opticsMode;
        if (_next >= 0 && _next < count _group - 1) then {
            _m set ["fovNext", (fza_ah64_tadsFOVs # (_group # (_next + 1))) / (fza_ah64_tadsFOVs # _opticsMode)];
        };
    };
    _m set ["lmc", _heli getVariable ["fza_ah64_LmcActive", false]];
    _m set ["laser", !isNull laserTarget _heli];
};

///////////////////////////////////////////////////////////////////////////////
// Weapon symbols
///////////////////////////////////////////////////////////////////////////////
if (_was == WAS_WEAPON_MSL) then {
    private _msl = [_heli] call fza_ihadss_fnc_htmlConstraints;
    if (_msl isNotEqualTo []) then {_m set ["msl", _msl]};
};

///////////////////////////////////////////////////////////////////////////////
// High action display
///////////////////////////////////////////////////////////////////////////////
private _prefix = ["C-", "P-"] select _isPilot;
private _linked = !_isPilot && {CPG_LINK(_heli)};
private _sightSel = switch (_sight) do {
    case SIGHT_HMD:  { _prefix + "HMD" };
    case SIGHT_TADS: { ["TADS", "TADSL"] select _linked };
    case SIGHT_FCR:  { [_prefix + "FCR", "C-FCRL"] select _linked };
    default { "?" };
};

private _range = ([_heli, player] call fza_fnc_targetingRange) # 1;

private _wpnCtl  = "";
private _wpnStat = "";
private _manual  = ["C", "P"] select (isManualFire _heli);
switch (_was) do {
    case WAS_WEAPON_GUN: {
        _wpnCtl  = _manual + "GUN";
        _wpnStat = format ["ROUNDS %1", _heli ammo "fza_m230"];
    };
    case WAS_WEAPON_RKT: {
        _wpnCtl = _manual + "RKT";
        private _curAmmo   = getText (configFile >> "CfgWeapons" >> (_heli getVariable ["fza_ah64_selectedRocket", ""]) >> "fza_ammoType");
        private _rktCode   = getText (configFile >> "CfgAmmo" >> _curAmmo >> "fza_shortCode");
        private _inventory = [_heli] call fza_fnc_weaponRocketInventory;
        private _invIndex  = _inventory findIf {_x isNotEqualTo [] && {_x # 0 == _curAmmo}};
        private _qty       = 0;
        if (_invIndex != -1) then {_qty = (_inventory # _invIndex) # 1};
        _wpnStat = format ["%1 NORM %2", _rktCode, _qty];
        // RTOF=NN until the last volley launched arrives
        private _rtof = (_heli getVariable ["fza_ah64_rocketTofEnd", -1]) - CBA_missionTime;
        if (_rtof > 0) then {
            _wpnStat = "RTOF=" + ([str (ceil _rtof), "00"] call fza_fnc_padString);
        };
    };
    case WAS_WEAPON_MSL: {
        _wpnCtl  = _manual + "MSL";
        _wpnStat = (_heli getVariable ["fza_ah64_hellfireTrajectory", "LO"]) + "-MAN";
        // Shared by both crew stations (fza_hellfire_fnc_tofStart); each drops the missiles that have arrived from its own copy
        private _tofList = _heli getVariable ["fza_ah64_tofCountDown", []];
        private _pending = _tofList select {_x > CBA_missionTime};
        if (count _pending != count _tofList) then {
            _heli setVariable ["fza_ah64_tofCountDown", _pending];
        };
        if (_pending isNotEqualTo []) then {
            _wpnStat = "HF TOF=" + ([str (ceil ((_pending # 0) - CBA_missionTime)), "00"] call fza_fnc_padString);
        };
    };
};

private _sightStat = "";
private _fcrState  = (_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0;
if (_fcrOn && {_fcrState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]}) then {_sightStat = "FCR XMIT"};
if (_nvsMode == NVS_MODE_FIXED) then {_sightStat = "NVS FIXED"};
if (_atLimit) then {_sightStat = "LIMITS"};
if (_fcrOn && {_fcrState == FCR_MODE_FAULT}) then {_sightStat = "FCR FAIL"};
if (_isPilot && {_heli getHitPointDamage "hit_msnEquip_pnvs_flir" >= SYS_SIGHT_DMG_THRESH}) then {_sightStat = "NVS FAIL"};
if (!_isPilot && {_heli getHitPointDamage "hit_msnEquip_tads_flir" >= SYS_SIGHT_DMG_THRESH && _heli getHitPointDamage "hit_msnEquip_tads_dtv" >= SYS_SIGHT_DMG_THRESH}) then {_sightStat = "TADS FAIL"};

// A target just stored (fza_fnc_targetingStore) shows for 3 seconds in place of the inhibit message
private _inhibit = _heli getVariable ["fza_ah64_weaponInhibited", ""];
(_heli getVariable ["fza_ah64_targetStoreMsg", ["", 0]]) params ["_storeMsg", "_storeUntil"];
if (CBA_missionTime < _storeUntil) then {_inhibit = _storeMsg};

_m set ["had", [_sightSel, _range, _wpnCtl, _curAcq, _sightStat, _wpnStat, _inhibit, ""]];

toJSON _m
