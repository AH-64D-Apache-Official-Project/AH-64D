/* ----------------------------------------------------------------------------
Function: fza_fnc_engineAPUOn

Description:
    Returns whether the APU is on.

Parameters:
	_heli - The apache helicopter to check if the APU is on for

Returns:
	Boolean - whether the APU is on

Examples:
	--- Code
    _ret = [_heli] call fza_fnc_engineAPUOn
    //_ret => true
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
_heli animationSourcePhase "plt_apu" > 0.5