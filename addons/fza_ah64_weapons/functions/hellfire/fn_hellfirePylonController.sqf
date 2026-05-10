/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_hellfirePylonController

Description:
    Manages HML pylon elevation for velocity and altitude compensation.
    CPG is authoritative when present; PLT handles it when flying alone.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params ["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
#define SCALE_METERS_FEET 3.28084

if !(local _heli) exitWith {};

private _authSeat = [_heli, WAS_WEAPON_MSL] call fza_weapons_fnc_getWasSeat;
private _was      = [WAS_WEAPON_NONE, WAS_WEAPON_MSL] select (_authSeat != "");
private _sight    = if (_authSeat != "") then { [_heli, "fza_ah64_sight", _authSeat] call fza_fnc_getSeatVariable } else { SIGHT_HMD };
private _onGnd    = [_heli] call fza_sfmplus_fnc_onGround;

private _pylonMagazines = getPylonMagazines _heli;
private _firstPylonMags = [_pylonMagazines # 0, _pylonMagazines # 4, _pylonMagazines # 8, _pylonMagazines # 12];
private _pylonAdjustment = 0;

private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI"    < SYS_MIN_HYD_PSI);

if (_was == WAS_WEAPON_MSL) then {
    private _velYZ         = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    private _hellfiretable = [[33, 4], [1000, -15]];
    private _hellfireZero  = ([_hellfiretable, ((getPos _heli) # 2 * SCALE_METERS_FEET)] call fza_fnc_linearInterp) # 1;
    private _velocityComp  = [[0, _hellfireZero], [VEL_ETL, 0]];
    _pylonAdjustment = ([_velocityComp, _velYZ] call fza_fnc_linearInterp) # 1;
};

for "_i" from 0 to 3 do {
    if (_utilHydFailed || _utilLevelMin) exitWith {};
    private _pylon  = "pylon" + str (_i + 1);
    private _pylonD = [4, 0] select _onGnd;
    if (WEP_TYPE(_firstPylonMags # _i) == "hellfire") then {
        if (_was == WAS_WEAPON_MSL) exitWith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
    };
};
