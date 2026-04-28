/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_fireHellfire

Description:
    Scripted AGM-114 Hellfire fire loop. Holds for 1 second while defaultAction
    is held before launching, simulating seeker acquisition time.
    Exclusive interlock (fza_ah64_isFiringMsl) prevents double-launch.
    Runs on the vehicle owner's machine; BIS_fnc_fire is called locally.

Parameters:
    _heli    - The helicopter
    _seat    - "plt" or "cpg" — the seat that initiated firing

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat"];

private _selectedMissile = _heli getVariable "fza_ah64_selectedMissile";
private _launchTime      = CBA_missionTime;

while {true} do {
    if ((_heli getVariable ["fza_ah64_was_" + _seat, WAS_WEAPON_NONE]) != WAS_WEAPON_MSL) exitWith {};
    if (!(_heli getVariable "fza_ah64_armSafeArmed"))                                     exitWith {};
    if (inputAction "defaultAction" < 0.5)                                                exitWith {};

    // Fire once acquisition hold time has elapsed
    if (_launchTime + 1 < CBA_missionTime) exitWith {
        if (local _heli) then {
            [_heli, _selectedMissile] call BIS_fnc_fire;
        } else {
            [_heli, _selectedMissile] remoteExec ["BIS_fnc_fire", owner _heli];
        };
    };

    sleep 0.01;
};

_heli setVariable ["fza_ah64_isFiringMsl", false];
