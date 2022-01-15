/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingVariable
Description:
	Handles repetitive Heavy Variable management. Should be run in the Slowscheduler.
Parameters:
	_heli - The helicopter to act on
Returns:
	Nothing
Examples:
	--- Code
    [_heli] call fza_fnc_targetingVariable;
	---
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if (!(player in _heli)) exitwith {};

//TODO: cscope
fza_ah64_Cscopelist;
