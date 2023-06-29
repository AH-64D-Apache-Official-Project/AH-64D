/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_Flare

Description:
    Action to deploy Flares
    
Parameters:
    _heli - the helicopter calling this
    
Returns:
Examples:
    _this Call fza_ase_fnc_Flare;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _irJamState = _heli getVariable "fza_ah64_ase_irJamState";

if (_irJamState == ASE_IRJAM_STATE_OPER) exitWith {
    [vehicle player, "fza_CMFlareLauncher", [-1]] call BIS_fnc_fire;
};
