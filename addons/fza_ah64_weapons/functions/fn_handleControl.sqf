/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_handleControl

Description:
    Dispatches the scripted weapon fire loop when the player activates
    the trigger (defaultAction). Enforces per-weapon exclusivity interlocks:
      - GUN  : exclusive - only one seat may fire at a time
      - MSL  : exclusive - only one seat may fire at a time
      - RKT  : non-exclusive - both seats may fire simultaneously,

    Always called on the vehicle owner's machine (via remoteExecCall from
    fn_eventFired). _seat identifies who pressed fire so the correct per-seat
    WAS and interlock variables are read.

Parameters:
    _heli - The helicopter
    _seat - The firing seat: "plt" or "cpg"

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat"];

private _was = _heli getVariable ["fza_ah64_was_" + _seat, WAS_WEAPON_NONE];

switch (_was) do {
    case WAS_WEAPON_GUN: {
        if (_heli getVariable ["fza_ah64_isFiringGun", false]) exitWith {};
        _heli setVariable ["fza_ah64_isFiringGun", true];
        [_heli, _seat] spawn fza_weapons_fnc_fireCannon;
    };
    case WAS_WEAPON_RKT: {
        private _varName = "fza_ah64_isFiringRkt_" + _seat;
        if (_heli getVariable [_varName, false]) exitWith {};
        _heli setVariable [_varName, true];
        [_heli, _seat] spawn fza_weapons_fnc_fireRocket;
    };
    case WAS_WEAPON_MSL: {
        if (_heli getVariable ["fza_ah64_isFiringMsl", false]) exitWith {};
        _heli setVariable ["fza_ah64_isFiringMsl", true];
        [_heli, _seat] spawn fza_weapons_fnc_fireHellfire;
    };
};
