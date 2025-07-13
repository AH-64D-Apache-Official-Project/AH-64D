/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_rocketPylonController

Description:
    Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_TurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

if (_heli getVariable "fza_ah64_was_cpg" == WAS_WEAPON_RKT && ([_heli] call fza_fnc_getSeat != "cpg")) exitWith {};
if (_heli getVariable "fza_ah64_was_cpg" != WAS_WEAPON_RKT && ([_heli] call fza_fnc_getSeat == "cpg")) exitwith {};

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_KM_METERS 0.001
#define HYDRA_TIME_KM 1.353

private _was             = [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable;
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _onGnd           = [_heli] call fza_sfmplus_fnc_onGround;
private _pylonMagazines  = getPylonMagazines _heli;
private _firstPylonMags  = [_pylonMagazines#0,_pylonMagazines#4,_pylonMagazines#8,_pylonMagazines#12];
private _pylonAdjustment = 0;
private _inhibit         = "";

private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI" < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";

(_heli call fza_weapons_fnc_sightData) params ["_targPos", "_targVel", "_targDistance", "_inhibit"];

if (_was == WAS_WEAPON_RKT && _sight != SIGHT_FXD) then {
    private _rocketTable = [[0, 2],[500, 7],[750, 11],[1000, 16],[2000, 50],[3100, 116],[4200, 201],[5300, 313],[6400, 434],[7500, 580]];
    private _elevationComp = ([_rocketTable, _targDistance] call fza_fnc_linearInterp) # 1;
    private _tof = _targDistance * SCALE_KM_METERS * HYDRA_TIME_KM;
    private _aimLocation = _targPos vectorAdd((_targVel vectorDiff velocity _heli) vectorMultiply _tof) vectorAdd[0, 0, _elevationComp];    
    _pylonAdjustment = ([0, -0.35, -1.69] vectorAdd ((_heli worldToModel aslToAgl _aimLocation)) call CBA_fnc_vect2Polar)# 2;
    
    if !(-15 < _pylonAdjustment && _pylonAdjustment < 4) then {
        _inhibit = "PYLON LIMIT";
    };
    [_heli, "fza_ah64_rocketInhibit", _inhibit] call fza_fnc_updateNetworkGlobal;
};

for "_i" from 0 to 3 do {
    if ((_utilHydFailed || _utilLevelMin)) exitwith {};
    private _pylon = "pylon" + str(_i + 1);
    private _pylonD = if _onGnd then {0;} else {4;};
    if (WEP_TYPE(_firstPylonMags#_i) == "rocket") then {
        if (_was == WAS_WEAPON_RKT) exitwith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
            [_heli, "fza_ah64_rocketPylonElev", _pylonAdjustment] call fza_fnc_updateNetworkGlobal;
            
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
    };
};
