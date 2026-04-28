/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_rocketPylonController

Description:
    Manages rocket pylon elevation for ballistic trajectory compensation.
    The seat with RKT WAS'd drives the pylon; CPG takes priority when both seats
    have RKT selected. PLT drives only when CPG has not WAS'd RKT.
    When neither seat has RKT selected the pylons stow and the inhibit is cleared.

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
#define SCALE_KM_METERS 0.001
#define HYDRA_TIME_KM   1.353

// Only the machine that owns the vehicle drives the pylons
if !(local _heli) exitWith {};

// Either or both seats may have WAS_WEAPON_RKT simultaneously; CPG takes priority.
// When neither has RKT, _was = NONE so pylons hold their stow position and inhibit is cleared.
private _authSeat = [_heli, WAS_WEAPON_RKT] call fza_weapons_fnc_getWasSeat;
private _was      = [WAS_WEAPON_NONE, WAS_WEAPON_RKT] select (_authSeat != "");
private _sight    = if (_authSeat != "") then { [_heli, "fza_ah64_sight", _authSeat] call fza_fnc_getSeatVariable } else { SIGHT_HMD };
private _onGnd = [_heli] call fza_sfmplus_fnc_onGround;

private _pylonMagazines = getPylonMagazines _heli;
private _firstPylonMags = [_pylonMagazines # 0, _pylonMagazines # 4, _pylonMagazines # 8, _pylonMagazines # 12];

private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI"    < SYS_MIN_HYD_PSI);

private _inhibit         = "";
private _pylonAdjustment = 0;

if (_was == WAS_WEAPON_RKT) then {
    // Published per-seat by fn_controller from the local player's machine
    (_heli getVariable ["fza_ah64_sightData_" + _authSeat, [[0,0,0],[0,0,0],0,""]]) params ["_targPos", "_targVel", "_targDistance", "_inhibit"];

    if (_sight != SIGHT_FXD) then {
        private _rocketTable    = [[0,2],[500,7],[750,11],[1000,16],[2000,50],[3100,116],[4200,201],[5300,313],[6400,434],[7500,580]];
        private _elevationComp  = ([_rocketTable, _targDistance] call fza_fnc_linearInterp) # 1;
        private _tof            = _targDistance * SCALE_KM_METERS * HYDRA_TIME_KM;
        private _aimLocation    = _targPos vectorAdd ((_targVel vectorDiff velocity _heli) vectorMultiply _tof) vectorAdd [0, 0, _elevationComp];
        _pylonAdjustment = ([0, -0.35, -1.69] vectorAdd ((_heli worldToModel ASLToAGL _aimLocation)) call CBA_fnc_vect2Polar) # 2;

        if !(-15 < _pylonAdjustment && _pylonAdjustment < 4) then {
            _inhibit = "PYLON LIMIT";
        };
    };

    [_heli, "fza_ah64_rocketInhibit", _inhibit] call fza_fnc_updateNetworkGlobal;
} else {
    // Clear inhibit when RKT is not WAS'd
    [_heli, "fza_ah64_rocketInhibit", ""] call fza_fnc_updateNetworkGlobal;
};

for "_i" from 0 to 3 do {
    if (_utilHydFailed || _utilLevelMin) exitWith {};
    private _pylon  = "pylon" + str (_i + 1);
    private _pylonD = [4, 0] select _onGnd;
    if (WEP_TYPE(_firstPylonMags # _i) == "rocket") then {
        if (_was == WAS_WEAPON_RKT) exitWith {
            [_heli, _pylon, _pylonAdjustment] call fza_fnc_updateAnimations;
            [_heli, "fza_ah64_rocketPylonElev", _pylonAdjustment] call fza_fnc_updateNetworkGlobal;
        };
        [_heli, _pylon, _pylonD] call fza_fnc_updateAnimations;
    };
};
