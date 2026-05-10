/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_fireRocket

Description:
    Scripted Hydra-70 rocket fire loop. Runs as a spawned thread on the
    vehicle owner's machine. Fires while defaultAction is held, respecting
    the salvo limit and rocket inhibit. Both seats may fire simultaneously
    (no cross-seat interlock for rockets).
    ArmA's native fire-blocking conditions are handled by the trigger weapon;
    inputAction "defaultAction" handles hold-release exit.

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg" — the seat that initiated firing

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat"];

private _selectedRockets = _heli getVariable "fza_ah64_selectedRocket";
private _salvoSize       = _heli getVariable "fza_ah64_rocketsalvo";
private _varName         = "fza_ah64_isFiringRkt_" + _seat;

private _rocketsFired = 0;
private _deltaAccum   = 0;

while {true} do {
    if ((_heli getVariable ["fza_ah64_was_" + _seat, WAS_WEAPON_NONE]) != WAS_WEAPON_RKT) exitWith {};
    if (_heli getVariable "fza_ah64_rocketInhibit" != "")                                  exitWith {};
    if (!(_heli getVariable "fza_ah64_armSafeArmed"))                                      exitWith {};
    if (_salvoSize != 99 && _rocketsFired >= _salvoSize)                                   exitWith {};
    if (inputAction "defaultAction" < 0.5)                                                 exitWith {};

    private _deltaTime = ["wpn_testdelta"] call BIS_fnc_deltaTime;
    _deltaAccum = _deltaAccum + _deltaTime;

    if (_deltaAccum > 0.09) then {
        if (local _heli) then {
            [_heli, _selectedRockets] call BIS_fnc_fire;
        } else {
            [_heli, _selectedRockets] remoteExec ["BIS_fnc_fire", owner _heli];
        };
        _rocketsFired = _rocketsFired + 1;
        _deltaAccum   = 0;
    };

    sleep 0.001;
};

_heli setVariable [_varName, false];
