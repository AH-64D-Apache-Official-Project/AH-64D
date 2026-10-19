/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponTurretAim

Description:
    Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_weaponTurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
#include "\bmkhs_helisim\functions\core\core.hpp"
params["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_METERS_FEET 3.28084
#define GUN_FIXED_EL 6

private _currentTurret = _heli call fza_fnc_currentTurret;
private _gunnnerUnit = _heli turretUnit [0];

if (_currentTurret isNotEqualTo [0] && (isPlayer _gunnnerUnit)) exitWith {};

// The turret's angles and the turn added while the TADS is an NVS sensor (fza_ihadss_fnc_tadsNvsControl), 0 otherwise
private _azimuth = -deg ((_heli animationPhase "tads_tur") + (_heli animationPhase "tads_nvs_tur"));
private _elevation = deg ((_heli animationPhase "tads") + (_heli animationPhase "tads_nvs"));
_heli setVariable ["fza_ah64_tadsAzimuth",   _azimuth];
_heli setVariable ["fza_ah64_tadsElevation", _elevation];

if (isMultiplayer && (_heli getVariable "fza_ah64_lastTimePropagated") + 0.1 < time) then {
{
    _heli setVariable [_x, _heli getVariable _x, true];
} forEach [
    "fza_ah64_tadsAzimuth",
    "fza_ah64_tadsElevation",
    "fza_cannon_gunAim"
];
_heli setVariable ["fza_ah64_lastTimePropagated", time, true];
};


private _was             = _heli getVariable "fza_ah64_was";
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _onGnd           = [_heli] call bmkhs_fnc_stateOnGround;
private _nts             = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntspos          = (_heli getVariable "fza_ah64_fcrNts") # 1;
private _pylonMagazines  = getPylonMagazines _heli;
private _firstPylonMags  = [_pylonMagazines#0,_pylonMagazines#4,_pylonMagazines#8,_pylonMagazines#12];
private _inhibit         = "";
private _pylonAdjustment = 0;
private _targVel         = [0, 0, 0];
private _targPos         = [0, 0, 0];
private _worldTargetpos  = [0, 0, 0];

private _gunDamage     = (_heli getHitPointDamage "hit_msnEquip_gun_turret" > SYS_WPN_DMG_THRESH);
private _magDamage     = (_heli getHitPointDamage "hit_msnEquip_magAndRobbie" > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1);
private _utilLevelMin  = (_heli getVariable "bmkhs_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "bmkhs_utilHydPsi" < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn       = _heli getVariable "bmkhs_dcBusOn";
private _gunFailed = (_utilHydFailed || _utilLevelMin || _gunDamage || !_acBusOn || !_dcBusOn || _magDamage);
private _mainturret = 0;
private _maingun = 0.298;
private _cameraTarget = objNull;

// Without AC power the sights and the gun are fixed forward
private _sightFixed = !_acBusOn;
if _sightFixed then {_sight = -1};

switch (_sight) do {
    case SIGHT_FCR:{
        _targpos = _heli modelToWorldVisual [0,1000,0];
        if (isNull _nts) then {
            _inhibit = "NO TARGET";
        } else {
            _targPos = _ntspos;
            if (isVehicleRadarOn _heli) then {
                _targPos = aimPos _nts;
                _targVel = velocity _nts;
            };
        };
        // The FCR commands the TADS only in FCR-L while slaved: on the NTS, jumping to each new one, fixed forward without
        // one. Otherwise the TADS is the CPG's to move as with TADS as the sight.
        if (CPG_LINK(_heli) && {_heli getVariable ["fza_ah64_cpgSlaved", false]}) then {
            _cameraTarget = [_targPos, _heli modelToWorldVisualWorld [0, 1000, 0]] select (isNull _nts);
        } else {
            if (missionNamespace getVariable ["fza_ihadss_tadsVideo", false] && {player == gunner _heli}) then {
                _cameraTarget = [_heli] call fza_ihadss_fnc_tadsSlew;
            };
        };
    };
    case SIGHT_HMD:{
        _targPos = AGLToASL (positionCameraToWorld [0, 0, 1000]);
    };
    case SIGHT_TADS:{
        _camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
        _worldTargetpos = _camPosASL vectorAdd (([_heli, "TADS"] call fza_fnc_targetingAcqVec) vectorMultiply 50000);
        _targPos = terrainIntersectAtASL [_camPosASL, _worldTargetpos];
        if (missionNamespace getVariable ["fza_ihadss_tadsVideo", false] && {player == gunner _heli}) then {
            _cameraTarget = [_heli] call fza_ihadss_fnc_tadsSlew;
        };
        // Slaved, the TADS follows the CPG's acquisition source instead of the manual tracker
        if (_heli getVariable ["fza_ah64_cpgSlaved", false]) then {
            private _slavePos = [_heli, [_heli, [0]] call fza_fnc_targetingCurAcq] call fza_fnc_targetingAcqPoint;
            if (_slavePos isNotEqualTo []) then {_cameraTarget = _slavePos};
        };
    };
    default {
        _cameraTarget = _heli modelToWorldVisualWorld [0, 1000, 0];
    };
};

// With no player CPG the pilot's acquisition source points the TADS; TADS leaves it to the AI gunner to be driven
if (!isPlayer _gunnnerUnit && {_currentTurret isEqualTo [-1]}) then {
    private _acq = [_heli, [-1]] call fza_fnc_targetingCurAcq;
    _cameraTarget = objNull;
    if (_acq != "TADS") then {
        private _slavePos = [_heli, _acq] call fza_fnc_targetingAcqPoint;
        if (_slavePos isNotEqualTo []) then {_cameraTarget = _slavePos};
    };
};

// The TADS as an NVS sensor is turned by fza_ihadss_fnc_tadsNvsControl on top of the turret, which is held straight ahead:
// the CPG's view is referenced to the turret while not flying, so a turret following the head would turn the view with it
([_heli] call fza_ihadss_fnc_tadsNvs) params ["_nvsMode"];
private _tadsNvs = _nvsMode != NVS_MODE_OFF;
if _tadsNvs then {
    _cameraTarget = (_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")) vectorAdd (_heli vectorModelToWorldVisual [0, 1000, 0]);
};

if ((_currentTurret isEqualTo [0] || !(isPlayer _gunnnerUnit)) && {_tadsNvs || {!(_heli getVariable "fza_ah64_LmcActive")}}) then {
    [_heli, _cameraTarget] call fza_fnc_targetingTadsLockTo;
};

private _targDistance = _heli distance _targPos;
// Rocket pylon travel, less on the ground
private _pylonMin = [HYDRA_PYLON_MIN_AIR, HYDRA_PYLON_MIN_GROUND] select _onGnd;
if (_targPos isEqualTo [0,0,0] && _sight == SIGHT_TADS) then {
    _targDistance = 1000;
    _targPos = _worldTargetpos;
};

if (_was == WAS_WEAPON_RKT && !_sightFixed) then {
    // Aimed along the sight line at the crew station's range source range, not the true range to what it looks at
    private _origin = switch (_sight) do {
        case SIGHT_TADS: {_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")};
        case SIGHT_HMD:  {AGLToASL positionCameraToWorld [0, 0, 0]};
        default          {getPosASLVisual _heli};
    };
    private _losDir = _origin vectorFromTo _targPos;
    if (_losDir isEqualTo [0, 0, 0]) then {_losDir = _heli vectorModelToWorldVisual [0, 1, 0]};
    _targDistance = ([_heli, player] call fza_fnc_targetingRange) # 0;
    _targPos      = _origin vectorAdd (_losDir vectorMultiply _targDistance);

    // The rocket's own solution through its flight, leading a moving radar target (fza_hydra_fnc_aimSolve). Solved 20 times
    // a second for its correction, which is applied to the aim point every frame. The pylons are commanded to its
    // elevation and the steering cursor to its azimuth from the nose; the pylons still take their time to get there.
    private _rktIndex = _firstPylonMags findIf {WEP_TYPE(_x) == "rocket"};
    private _rktMag   = "";
    if (_rktIndex != -1) then {_rktMag = _firstPylonMags # _rktIndex};
    private _solution = _heli getVariable ["fza_hydra_solution", [-1, [0, 0, 0]]];
    if (time - (_solution # 0) > 0.05) then {
        ([_heli, _targPos, _targVel, _solution # 1, _rktMag] call fza_hydra_fnc_aimSolve) params ["", "_rktTof", "_correction"];
        _solution = [time, _correction];
        _heli setVariable ["fza_hydra_solution", _solution];
        // The time of flight a volley is launched with (RTOF, fza_hydra_fnc_fired), to the tenth of a second
        [_heli, "fza_ah64_rocketSolutionTof", (round (_rktTof * 10)) / 10] call fza_fnc_updateNetworkGlobal;
    };
    (_heli vectorWorldToModelVisual ((_heli modelToWorldVisualWorld HYDRA_LAUNCH_POS(_heli)) vectorFromTo (_targPos vectorAdd (_solution # 1)))) params ["_solX", "_solY", "_solZ"];
    _pylonAdjustment = _solZ atan2 (sqrt (_solX * _solX + _solY * _solY));
    [_heli, "fza_ah64_rocketSteerAz", round ((_solX atan2 _solY) * 10) / 10] call fza_fnc_updateNetworkGlobal;

    // Inhibits, the most serious shown: the pylons failed with the utility hydraulics as on the WPN page,
    // too little G for the rotor to stay clear, the solution beyond the pylons' travel
    private _rktInhibit = "";
    if !(_pylonMin < _pylonAdjustment && _pylonAdjustment < HYDRA_PYLON_MAX) then {_rktInhibit = "PYLON LIMIT"};
    if (([_heli] call fza_fnc_avionicsLoadFactor) < HYDRA_ACCEL_LIMIT_G) then {_rktInhibit = "ACCEL LIMIT"};
    if (_utilHydFailed || _utilLevelMin) then {_rktInhibit = "PYLON ERROR"};
    if (_rktInhibit != "") then {
        _inhibit = _rktInhibit;
        _heli selectWeaponTurret ["fza_pylon_inhibit", [0], "fza_pylon_inhibit"];
    };
};

if (_was == WAS_WEAPON_MSL && !_sightFixed) then {
    private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    private _hellfiretable = [[33, 4],[1000, -15]];
    private _hellfireZero = ([_hellfiretable, ((getPos _heli)#2*SCALE_METERS_FEET)] call fza_fnc_linearInterp) # 1;
    private _velocityComp  = [[0, _hellfireZero], [VEL_ETL, 0]];
    _pylonAdjustment = ([_velocityComp, _velYZ] call fza_fnc_linearInterp) # 1;

    private _selectedMissile = _heli getVariable ["fza_ah64_selectedMissile", ""];
    private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
    if (_selectedMissile == "fza_agm114l_wep" && _sight == SIGHT_TADS && _handoffData isEqualTo []) then {
        _inhibit = "TGT DATA?";
        _heli selectWeaponTurret ["fza_pylon_inhibit", [0], "fza_pylon_inhibit"];
    };
};

if (currentWeapon _heli == "fza_pylon_inhibit" && _inhibit == "") then {
    [_heli] call fza_fnc_weaponUpdateSelected;
};

for "_i" from 0 to 3 do {
    if ((_utilHydFailed || _utilLevelMin)) exitWith {};
    private _pylon = "pylon" + str(_i + 1);
    private _pylonD = [4, 0] select _onGnd;
    if (WEP_TYPE(_firstPylonMags#_i) == "rocket") then {
        if (_was == WAS_WEAPON_RKT) exitWith {
            [_heli, _pylon, (_pylonAdjustment max _pylonMin) min HYDRA_PYLON_MAX] call fza_anim_fnc_updateAnimations;
            [_heli, "fza_ah64_rocketPylonElev", _pylonAdjustment] call fza_fnc_updateNetworkGlobal;

        };
        [_heli, _pylon, _pylonD] call fza_anim_fnc_updateAnimations;

    };
    if (WEP_TYPE(_firstPylonMags#_i) == "hellfire") then {
        if (_was == WAS_WEAPON_MSL) exitWith {
            [_heli, _pylon, _pylonAdjustment] call fza_anim_fnc_updateAnimations;
        };
        [_heli, _pylon, _pylonD] call fza_anim_fnc_updateAnimations;
    };
};

if (_was == WAS_WEAPON_GUN) then {
    if (_gunFailed) exitWith {
        _heli selectWeaponTurret ["fza_gun_inhibit", [0], "fza_gun_inhibit"];
    };
    // The gun's own solution: the sight LOS at the range source range, through the round's flight, leading a moving radar
    // target (fza_cannon_fnc_aimSolve)
    private _origin = switch (_sight) do {
        case SIGHT_TADS: {_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")};
        case SIGHT_HMD:  {AGLToASL positionCameraToWorld [0, 0, 0]};
        default          {getPosASLVisual _heli};
    };
    private _losDir = _origin vectorFromTo _targPos;
    if (_losDir isEqualTo [0, 0, 0]) then {_losDir = _heli vectorModelToWorldVisual [0, 1, 0]};
    private _gunRange = ([_heli, player] call fza_fnc_targetingRange) # 0;
    private _aimPoint = _origin vectorAdd (_losDir vectorMultiply _gunRange);
    // Beyond the ballistic range of the round; not solved there, the gun holds its last solution
    private _outOfRange = _gunRange > 4200;
    if (_outOfRange) then {_inhibit = "BAL LIMIT"};
    // Solved 20 times a second for its correction (superelevation and lead), which is applied to the aim point every
    // frame, so the gun follows the sight smoothly between solutions
    private _solution = _heli getVariable ["fza_cannon_solution", [-1, [0, 0, 0]]];
    if (!_outOfRange && {time - (_solution # 0) > 0.05}) then {
        _solution = [time, ([_heli, _aimPoint, _targVel, _solution # 1] call fza_cannon_fnc_aimSolve) # 2];
        _heli setVariable ["fza_cannon_solution", _solution];
    };
    private _muzzle = _heli modelToWorldVisualWorld (_heli selectionPosition ["usti hlavne", "Memory"]);
    (_heli vectorWorldToModelVisual (_muzzle vectorFromTo (_aimPoint vectorAdd (_solution # 1)))) params ["_solX", "_solY", "_solZ"];
    private _gunAzimuth   = _solX atan2 _solY;
    private _gunElevation = _solZ atan2 (sqrt (_solX * _solX + _solY * _solY));
    if !(-86 < _gunAzimuth && _gunAzimuth < 86) then {
        _inhibit = "AZ LIMIT";
    };
    if !(-60 < _gunElevation && _gunElevation < 11) then {
        _inhibit = "EL LIMIT";
    };
    // Out of coincidence while the gun is still slewing onto its commanded position, more than 1 deg off in either axis
    private _gunMode  = [_heli, "fza_ah64_gunMode"] call fza_fnc_getSeatVariable;
    private _gunFixed = _sightFixed || {!isNil "_gunMode" && {_gunMode == "FXD"}};
    (_heli getVariable ["fza_cannon_gunAim", [0, deg 0.298]]) params ["_gunAimAz", "_gunAimEl"];
    private _wantAz = [([_gunAzimuth, -86, 86] call BIS_fnc_clamp), 0] select _gunFixed;
    private _wantEl = [([_gunElevation, -60, 11] call BIS_fnc_clamp), GUN_FIXED_EL] select _gunFixed;
    if (_inhibit == "" && {abs (_wantAz - _gunAimAz) > 1 || {abs (_wantEl - _gunAimEl) > 1}}) then {
        _inhibit = "COINCIDENCE";
    };
    if (_inhibit != "") then {
        _safemessage = "_inhibit";
        _heli selectWeaponTurret ["fza_gun_inhibit", [0], "fza_gun_inhibit"];
    } else {
        if (currentWeapon _heli == "fza_gun_inhibit") then {
            _heli selectWeaponTurret ["fza_m230", [0], "fza_m230"];
        };
    };
    // Gun MODE FXD (WPN page) fixes the gun to the aircraft centerline, 6 deg up
    if (_gunFixed) exitWith {
        _mainturret = 0;
        _maingun = rad GUN_FIXED_EL;
        _inhibit = "GUN FIXED";
    };
    _mainturret = -rad ([_gunAzimuth, -86, 86] call BIS_fnc_clamp);
    _maingun = rad ([_gunElevation, -60, 11] call BIS_fnc_clamp);
};
if (_gunFailed) then {
    _mainturret = _heli animationPhase "mainTurret";
    _maingun = 0.298;
};

// The gun turns to its commanded position at its own slew rate. Fired rounds leave along this exact direction
// (fza_cannon_fnc_fired); the animation is rounded and lags, so it only shows the barrel.
private _slewDt = ["fza_cannon_gunSlew"] call BIS_fnc_deltaTime;
(_heli getVariable ["fza_cannon_gunAim", [0, deg 0.298]]) params ["_gunAz", "_gunEl"];
private _slewStep = 120 * (_slewDt min 0.1);
_gunAz = _gunAz + ((((-deg _mainturret) - _gunAz) max -_slewStep) min _slewStep);
_gunEl = _gunEl + ((((deg _maingun) - _gunEl) max -_slewStep) min _slewStep);
_heli setVariable ["fza_cannon_gunAim", [_gunAz, _gunEl]];
_mainturret = -rad _gunAz;
_maingun    = rad _gunEl;

[_heli, "mainTurret", _mainturret] call fza_anim_fnc_updateAnimations;
[_heli, "mainGun", _maingun] call fza_anim_fnc_updateAnimations;

for "_i" from 0 to 3 do {
    if (WEP_TYPE(_firstPylonMags#_i) == "auxTank") then {
        _pylon = "pylon" + str(_i + 1);
        [_heli, _pylon, +4] call fza_anim_fnc_updateAnimations;
    };
};

[_heli, "fza_ah64_weaponInhibited", _inhibit] call fza_fnc_updateNetworkGlobal;
