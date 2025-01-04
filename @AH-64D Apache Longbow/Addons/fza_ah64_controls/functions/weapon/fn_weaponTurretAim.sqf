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
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_METERS_FEET 3.28084
#define SCALE_KM_METERS 0.001
#define HYDRA_TIME_KM 1.353

private _was             = _heli getVariable "fza_ah64_was";
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _onGnd           = [_heli] call fza_sfmplus_fnc_onGround;
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
private _magDamage     = (_heli getHitPointDamage "hit_msnEquip_magandrobbie" > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1);
private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI" < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _gunFailed = (_utilHydFailed || _utilLevelMin || _gunDamage || !_acBusOn || !_dcBusOn || _magDamage);
private _mainturret = 0;
private _maingun = 0.298;

if !_acBusOn then {
    _sight = SIGHT_FXD;
};

switch (_sight) do {
    case SIGHT_FCR:{
        _targpos = _heli modelToWorldVisual [0,1000,0];
        if (!isNull _nts) exitwith {
            _targPos = _ntspos;
            if (isVehicleRadarOn _heli) then {
                _targPos = aimPos _nts;
                _targVel = velocity _nts;
            };
            _heli lockCameraTo [_targPos, [0], false];
        };
        _heli lockCameraTo [_targpos, [0], false];
        _inhibit = "NO TARGET";
    };
    case SIGHT_HMD:{
        _targPos = aglToAsl (positionCameraToWorld [0, 0, 1000]);
        if (cameraView == "GUNNER") exitwith {
            _heli lockCameraTo [objNull, [0], false];
        };
        _heli lockCameraTo [_targPos, [0], false];
    };
    case SIGHT_TADS:{
        if !(_heli getVariable "fza_ah64_LmcActive") then {    
            _heli lockCameraTo [objNull, [0], false];
        };
        _camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
        _flirDir   = _camPosASL vectorFromTo (_heli modelToWorldVisualWorld (_heli selectionPosition "laserBegin"));
        _worldTargetpos = _camPosASL vectorAdd (_flirDir vectorMultiply 50000);
        _targPos = terrainIntersectAtASL [_camPosASL, _worldTargetpos];
    };
    case SIGHT_FXD:{
        _heli lockCameraTo [_heli modelToWorldVisual [0,1000,0],[0], false];
    };
};

private _targDistance = _heli distance _targPos;
if (_targPos isequalto [0,0,0] && _sight == SIGHT_TADS) then {
    _targDistance = 1000;
    _targPos = _worldTargetpos;
};

if (_was == WAS_WEAPON_RKT && _sight != SIGHT_FXD) then {
    private _rocketTable = [[0, 2],[500, 7],[750, 11],[1000, 16],[2000, 50],[3100, 116],[4200, 201],[5300, 313],[6400, 434],[7500, 580]];
    private _elevationComp = ([_rocketTable, _targDistance] call fza_fnc_linearInterp) # 1;
    private _tof = _targDistance * SCALE_KM_METERS * HYDRA_TIME_KM;
    private _aimLocation = _targPos vectorAdd((_targVel vectorDiff velocity _heli) vectorMultiply _tof) vectorAdd[0, 0, _elevationComp];    
    _pylonAdjustment = ([0, -0.35, -1.69] vectorAdd ((_heli worldToModel aslToAgl _aimLocation)) call CBA_fnc_vect2Polar)# 2;
    
    if !(-15 < _pylonAdjustment && _pylonAdjustment < 4) then {
        _inhibit = "PYLON LIMIT";
        _heli selectweapon "fza_pylon_inhibit";
    };
    if (_utilHydFailed || _utilLevelMin) exitwith {
        _heli selectweapon "fza_pylon_inhibit";
    };
};

if (_was == WAS_WEAPON_MSL && _sight != SIGHT_FXD) then {
    private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    private _hellfiretable = [[33, 4],[1000, -15]];
    private _hellfireZero = ([_hellfiretable, ((getpos _heli)#2*SCALE_METERS_FEET)] call fza_fnc_linearInterp) # 1;
    private _velocityComp  = [[0, _hellfireZero], [VEL_ETL, 0]];
    _pylonAdjustment = ([_velocityComp, _velYZ] call fza_fnc_linearInterp) # 1;
};

if (Currentweapon _heli == "fza_pylon_inhibit" && _inhibit == "") then {
    [_heli] call fza_fnc_weaponUpdateSelected;
};

for "_i" from 0 to 3 do {
    if ((_utilHydFailed || _utilLevelMin)) exitwith {};
    private _pylon = "pylon" + str(_i + 1);
    private _pylonD = if _onGnd then {0;} else {4;};
    if (WEP_TYPE(_firstPylonMags#_i) == "rocket") then {
        _heli setVariable ["fza_ah64_rocketPylonElev", _pylonAdjustment];
        if (_was == WAS_WEAPON_RKT) exitwith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
        
    };
    if (WEP_TYPE(_firstPylonMags#_i) == "hellfire") then {
        if (_was == WAS_WEAPON_MSL) exitwith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
    };
};

if (_was == WAS_WEAPON_GUN) then {
    if (_gunFailed) exitwith {
        _heli selectweapon "fza_cannon_inhibit";
    };
    private _pan = _heli animationPhase "tads_tur";
    private _tilt = _heli animationPhase "tads";
    if !(-86 < deg _pan && deg _pan < 86) then {
        _inhibit = "AZ LIMIT";
    };
    if !(-60 < deg _tilt && deg _tilt < 11) then {
        _inhibit = "EL LIMIT";
    };
    if (_inhibit != "") then {
        _safemessage = "_inhibit";
        _heli selectweapon "fza_cannon_inhibit";
    } else {
        if (Currentweapon _heli == "fza_cannon_inhibit") then {
            _heli selectweapon "fza_m230";
        };
    };
    if (_sight == SIGHT_FXD) exitwith {
        _mainturret = 0;
        _maingun = 0;
        _inhibit = "GUN FIXED";
    };
    _mainturret = [_pan, rad -86, rad 86] call BIS_fnc_clamp;
    _maingun = [_tilt, rad -60, rad 11] call BIS_fnc_clamp;
};
if (_gunFailed) then {
    _mainturret = _heli animationphase "mainTurret";
    _maingun = 0.298;
};

[_heli, "mainTurret", _mainturret] call fza_fnc_updateAnimations;
[_heli, "mainGun", _maingun] call fza_fnc_updateAnimations;

for "_i" from 0 to 3 do {
    if (WEP_TYPE(_firstPylonMags#_i) == "auxTank") then {
        _pylon = "pylon" + str(_i + 1);
        [_heli, _pylon, +4] call fza_fnc_updateAnimations;
    };
};

_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];

#ifdef __A3_DEBUG__
drawIcon3d["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 0, 1], asltoagl _targPos, 0.5, 0.5, 0, "Target pos ATL"];
drawIcon3d["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 0, 1], _worldTargetpos, 0.5, 0.5, 0, "Target vector"];
#endif