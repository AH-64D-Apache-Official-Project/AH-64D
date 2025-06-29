/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_hellfirePylonController

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

if (_heli getVariable "fza_ah64_was_cpg" == WAS_WEAPON_MSL && ([_heli] call fza_fnc_getSeat != "cpg")) exitWith {};
if (_heli getVariable "fza_ah64_was_cpg" != WAS_WEAPON_MSL && ([_heli] call fza_fnc_getSeat == "cpg")) exitwith {};

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_METERS_FEET 3.28084

private _was             = [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable;
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _onGnd           = [_heli] call fza_sfmplus_fnc_onGround;
private _pylonMagazines  = getPylonMagazines _heli;
private _firstPylonMags  = [_pylonMagazines#0,_pylonMagazines#4,_pylonMagazines#8,_pylonMagazines#12];
private _pylonAdjustment = 0;

private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI" < SYS_MIN_HYD_PSI);

(_heli call fza_weapons_fnc_sightData) params ["_targPos", "_targVel", "_targDistance", "_inhibit"];

if (_was == WAS_WEAPON_MSL && _sight != SIGHT_FXD) then {
    private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    private _hellfiretable = [[33, 4],[1000, -15]];
    private _hellfireZero = ([_hellfiretable, ((getpos _heli)#2*SCALE_METERS_FEET)] call fza_fnc_linearInterp) # 1;
    private _velocityComp  = [[0, _hellfireZero], [VEL_ETL, 0]];
    _pylonAdjustment = ([_velocityComp, _velYZ] call fza_fnc_linearInterp) # 1;
};
for "_i" from 0 to 3 do {
    if ((_utilHydFailed || _utilLevelMin)) exitwith {};
    private _pylon = "pylon" + str(_i + 1);
    private _pylonD = if _onGnd then {0;} else {4;};
    if (WEP_TYPE(_firstPylonMags#_i) == "hellfire") then {
        if (_was == WAS_WEAPON_MSL) exitwith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
    };
};