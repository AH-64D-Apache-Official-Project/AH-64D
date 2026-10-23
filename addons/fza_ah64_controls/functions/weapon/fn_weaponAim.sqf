/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponAim

Description:
    Aims the actioned weapon along the line of sight of the crew station
    driving it (fza_fnc_wasUpdate): the WAS holder's own sight and range drive
    the gun, the rocket pylons and steering cursor, the missile pylons, and
    the weapon inhibits. In COOP the CPG drives, so the TADS does. With no
    weapon actioned the CPG, or without a player CPG the pilot, stows them.

    Run on every crew station's machine; only the aiming crew station's
    acts. It animates the gun and pylons, and publishes the steering azimuth,
    pylon elevation, rocket time of flight, gun aim and inhibit for the other.
    A blocking inhibit is applied to the turret where it is local, which
    swaps in an inhibit weapon so the trigger cannot fire.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden), BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
#include "\bmkhs_helisim\functions\core\core.hpp"
params["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_METERS_FEET 3.28084
#define GUN_FIXED_EL 6
// Hellfire rate limit deg/s; the ballistic limits m
#define MSL_RATE_LIMIT 30
#define MSL_BAL_LIMIT 8000
#define RKT_BAL_LIMIT 7500

// The blocking inhibit, on the turret's machine: 1 the pylon inhibit weapon, 2 the gun's
if (_heli turretLocal [0]) then {
    private _block   = _heli getVariable ["fza_ah64_weaponBlock", 0];
    private _blocker = ["", "fza_pylon_inhibit", "fza_gun_inhibit"] select _block;
    private _current = currentWeapon _heli;
    if (_blocker != "" && {_current != _blocker}) then {_heli selectWeaponTurret [_blocker, [0], _blocker]};
    if (_blocker == "" && {_current in ["fza_pylon_inhibit", "fza_gun_inhibit"]}) then {[_heli] call fza_fnc_weaponUpdateSelected};
};

// The aiming crew station: the one driving the weapon, else the CPG, or the pilot without a player CPG
private _aiming = _heli getVariable ["fza_ah64_wasDriver", ""];
if (_aiming == "") then {_aiming = ["plt", "cpg"] select (isPlayer gunner _heli)};
if (([_heli] call fza_fnc_getSeat) != _aiming) exitWith {};

private _was             = _heli getVariable "fza_ah64_was";
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
// The HMD sight's LOS is the head's, tracked by the IHADSS helmet; without it, the aircraft's nose
private _hasHelmet       = [player] call fza_ihadss_fnc_hasHelmet;
private _hmdOrigin       = [getPosASLVisual _heli, AGLToASL positionCameraToWorld [0, 0, 0]] select _hasHelmet;
private _onGnd           = [_heli] call bmkhs_fnc_stateOnGround;
private _nts             = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntspos          = (_heli getVariable "fza_ah64_fcrNts") # 1;
private _pylonMagazines  = getPylonMagazines _heli;
private _firstPylonMags  = [_pylonMagazines#0,_pylonMagazines#4,_pylonMagazines#8,_pylonMagazines#12];
private _inhibit         = "";
private _block           = 0;
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

// Without AC power the sights and the gun are fixed forward
private _sightFixed = !_acBusOn;
if _sightFixed then {_sight = -1};

// The aiming crew station's line of sight
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
    };
    case SIGHT_HMD:{
        _targPos = if (_hasHelmet) then {AGLToASL (positionCameraToWorld [0, 0, 1000])} else {_heli modelToWorldVisualWorld [0, 1000, 0]};
    };
    case SIGHT_TADS:{
        private _camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
        _worldTargetpos = _camPosASL vectorAdd (([_heli, "TADS"] call fza_fnc_targetingAcqVec) vectorMultiply 50000);
        _targPos = terrainIntersectAtASL [_camPosASL, _worldTargetpos];
    };
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
        case SIGHT_HMD:  {_hmdOrigin};
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
    // too little G for the rotor to stay clear, the solution beyond the pylons' travel. Beyond it is only a warning in
    // the air; on the ground the rockets could strike it.
    private _rktInhibit = "";
    if !(_pylonMin < _pylonAdjustment && _pylonAdjustment < HYDRA_PYLON_MAX) then {_rktInhibit = "PYLON LIMIT"};
    if (([_heli] call fza_fnc_avionicsLoadFactor) < HYDRA_ACCEL_LIMIT_G) then {_rktInhibit = "ACCEL LIMIT"};
    if (_utilHydFailed || _utilLevelMin) then {_rktInhibit = "PYLON ERROR"};
    if (_rktInhibit == "" && {_targDistance > RKT_BAL_LIMIT}) then {_rktInhibit = "BAL LIMIT"};
    // Beyond the pylons' travel in the air only warns
    if (_rktInhibit != "") then {
        _inhibit = _rktInhibit;
        if !(_rktInhibit == "PYLON LIMIT" && !_onGnd) then {_block = 1};
    };
};

if (_was == WAS_WEAPON_MSL && !_sightFixed) then {
    private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    private _hellfiretable = [[33, 4],[1000, -15]];
    private _hellfireZero = ([_hellfiretable, ((getPos _heli)#2*SCALE_METERS_FEET)] call fza_fnc_linearInterp) # 1;
    private _velocityComp  = [[0, _hellfireZero], [VEL_ETL, 0]];
    _pylonAdjustment = ([_velocityComp, _velYZ] call fza_fnc_linearInterp) # 1;

    // Safety inhibits stop the launch; performance inhibits only warn the missile may not hit. The first safety inhibit
    // is shown, else the first performance one.
    private _safety      = [];
    private _performance = [];
    private _selectedMissile = _heli getVariable ["fza_ah64_selectedMissile", ""];
    // An RF missile cannot be fired until it is powered and aligned (fza_hellfire_fnc_rfPowerUpdate)
    if (_selectedMissile == "fza_agm114l_wep" && {([_heli] call fza_hellfire_fnc_rfState) != RF_STATE_READY}) then {
        _safety pushBack "MSL NOT RDY";
    };
    private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
    if (_selectedMissile == "fza_agm114l_wep" && _sight == SIGHT_TADS && _handoffData isEqualTo []) then {
        _safety pushBack "TGT DATA?";
    };
    if (_targDistance > MSL_BAL_LIMIT) then {_safety pushBack "BAL LIMIT"};
    // Too little G for the rotor to stay clear of the missile
    if (([_heli] call fza_fnc_avionicsLoadFactor) < HYDRA_ACCEL_LIMIT_G) then {_safety pushBack "ACCEL LIMIT"};
    // Beyond the articulation limits: on the ground the missile could strike it
    if !(_pylonMin <= _pylonAdjustment && _pylonAdjustment <= HYDRA_PYLON_MAX) then {
        ([_performance, _safety] select _onGnd) pushBack "PYLON LIMIT";
    };
    // The launchers over 10 deg off the launch angle, or unknown with the pylons failed
    private _mslPylon = _firstPylonMags findIf {WEP_TYPE(_x) == "hellfire"};
    if (_utilHydFailed || _utilLevelMin
        || {_mslPylon != -1 && {abs ((_heli animationPhase ("pylon" + str (_mslPylon + 1))) - _pylonAdjustment) > 10}}) then {
        _performance pushBack "PYLON ANGLE";
    };
    // The aircraft turning or rolling too hard for the missile to be launched accurately
    (angularVelocityModelSpace _heli) params ["_pitchRate", "_rollRate", "_yawRate"];
    if ((deg abs _pitchRate) max (deg abs _rollRate) max (deg abs _yawRate) > MSL_RATE_LIMIT) then {_performance pushBack "RATE LIMIT"};
    // Roll and yaw: an RF missile 20 deg each, the yaw to the target to be handed over. A SAL missile locked on before
    // launch 20 deg of roll; locked on after, 10 deg of roll and the target (no target at all too) 7.5 deg off the nose.
    private _isRf    = _selectedMissile == "fza_agm114l_wep";
    private _salLobl = !_isRf && {!isNil {[_heli] call fza_hellfire_fnc_salFindLaserDesignation}};
    if (abs ((_heli call fza_fnc_getPitchBank) # 1) > ([[10, 20] select _salLobl, 20] select _isRf)) then {_performance pushBack "ROLL LIMIT"};
    private _offNose = {
        (_heli worldToModelVisual (ASLToAGL _this)) params ["_tx", "_ty"];
        abs (_tx atan2 _ty)
    };
    if (_isRf) then {
        private _handoffPos = (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) param [1, [0, 0, 0]];
        if (_sight == SIGHT_TADS) then {
            private _loblTarget = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];
            _handoffPos = [_handoffData param [0, [0, 0, 0]], getPosASL _loblTarget] select !isNull _loblTarget;
        };
        if (_handoffPos isNotEqualTo [0, 0, 0] && {(_handoffPos call _offNose) > 20}) then {_performance pushBack "YAW LIMIT"};
    } else {
        if (!_salLobl && {_targPos isEqualTo [0, 0, 0] || {(_targPos call _offNose) > 7.5}}) then {_performance pushBack "YAW LIMIT"};
    };

    if (_safety isNotEqualTo []) then {
        _inhibit = _safety # 0;
        _block   = 1;
    } else {
        if (_performance isNotEqualTo []) then {_inhibit = _performance # 0};
    };
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
        _block = 2;
    };
    // The gun's own solution: the sight LOS at the range source range, through the round's flight, leading a moving radar
    // target (fza_cannon_fnc_aimSolve)
    private _origin = switch (_sight) do {
        case SIGHT_TADS: {_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")};
        case SIGHT_HMD:  {_hmdOrigin};
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
    if (_inhibit != "") then {_block = 2};
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

// The gun's aim for the other crew station, whose fired rounds leave along it too (fza_cannon_fnc_fired), 10 times a second
if (isMultiplayer && {time - (_heli getVariable ["fza_ah64_gunAimPropagated", -1]) > 0.1}) then {
    _heli setVariable ["fza_ah64_gunAimPropagated", time];
    _heli setVariable ["fza_cannon_gunAim", _heli getVariable "fza_cannon_gunAim", true];
};

// The gun's trigger pressed straight after a rocket or missile launch
if (_was == WAS_WEAPON_GUN && {[_heli] call fza_fnc_weaponAltLaunch}) then {
    _inhibit = "ALT LAUNCH";
    _block   = 2;
};

// Not armed at the armament panel, nothing fires (fza_fnc_weaponUpdateSelected)
if (_was != WAS_WEAPON_NONE && {!(_heli getVariable ["fza_ah64_armSafeArmed", false])}) then {_inhibit = "SAFE"};

[_heli, "fza_ah64_weaponInhibited", _inhibit] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_weaponBlock", _block] call fza_fnc_updateNetworkGlobal;
