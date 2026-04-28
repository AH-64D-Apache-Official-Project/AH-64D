/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_fireCannon

Description:
    Scripted M230 cannon fire loop. Runs as a spawned thread on the vehicle
    owner's machine. Fires while defaultAction is held, respecting the burst
    limit, gun inhibit, and arm/safe state.
    ArmA's native fire-blocking (dialog, map, 3DEN, curator) is handled by the
    trigger weapon: the Fired EH that spawns this loop cannot fire unless those
    conditions allow it. inputAction "defaultAction" handles hold-release exit.

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

private _cannonFired = 0;
private _deltaAccum  = 0;

while {true} do {
    if ((_heli getVariable ["fza_ah64_was_" + _seat, WAS_WEAPON_NONE]) != WAS_WEAPON_GUN) exitWith {};
    if (_heli getVariable "fza_ah64_gunInhibited" != "")                                  exitWith {};
    if (!(_heli getVariable "fza_ah64_armSafeArmed"))                                     exitWith {};
    if ((_heli getVariable "fza_ah64_burst_limit") != -1 && _cannonFired >= (_heli getVariable "fza_ah64_burst_limit")) exitWith {};
    if (inputAction "defaultAction" < 0.5)                                                exitWith {};

    private _deltaTime = ["wpn_testdelta"] call BIS_fnc_deltaTime;
    _deltaAccum = _deltaAccum + _deltaTime;

    if (_deltaAccum > 0.109) then {
        if (local _heli) then {
            [_heli, "fza_m230"] call BIS_fnc_fire;
        } else {
            [_heli, "fza_m230"] remoteExec ["BIS_fnc_fire", owner _heli];
        };
        _cannonFired = _cannonFired + 1;
        _deltaAccum  = 0;

        // ACE overheating - called locally; ACE handles propagation internally
        [_heli, "fza_m230", 3500] call ace_overheating_fnc_updateTemperature;
        [_heli] call fza_cannon_fnc_update;
    };

    sleep 0.001;
};

_heli setVariable ["fza_ah64_isFiringGun", false];
