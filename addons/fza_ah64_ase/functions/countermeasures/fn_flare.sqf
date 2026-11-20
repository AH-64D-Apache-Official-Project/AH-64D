/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_Flare

Description:
    The Flare/Emergency control, HIDAS only: flares in MAN, the emergency program in
    SEMI and AUTO.

Parameters:
    _heli - the helicopter calling this

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_Flare;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

// HIDAS arming is a UTIL page item, not built: power alone dispenses
if !(ASE_HIDAS_ON(_heli)) exitWith {};

private _manual = _heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN] == ASE_CMDS_MAN;
[_heli, [ASE_CMDS_PGM_EMERGENCY, ASE_CMDS_PGM_MAN_FLARE] select _manual, "B"] call fza_ase_fnc_cmdsDispense;
