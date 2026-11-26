/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmdsConsent

Description:
    Gives consent to a SEMI dispense request (fza_ase_fnc_cmds): runs its program once,
    where the aircraft is local. While another program is still firing the request waits.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_cmdsConsent;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

if !(local _heli) exitWith {
    [_heli] remoteExec ["fza_ase_fnc_cmdsConsent", _heli];
};

private _pending = _heli getVariable ["fza_ah64_ase_cmdsConsent", []];
if (_pending isEqualTo []) exitWith {};
if (CBA_missionTime < (_heli getVariable ["fza_ah64_ase_cmdsBusy", -1])) exitWith {};

_heli setVariable ["fza_ah64_ase_cmdsConsent", [], true];
_pending params ["_program", "_side"];
[_heli, _program, _side] call fza_ase_fnc_cmdsDispense;
