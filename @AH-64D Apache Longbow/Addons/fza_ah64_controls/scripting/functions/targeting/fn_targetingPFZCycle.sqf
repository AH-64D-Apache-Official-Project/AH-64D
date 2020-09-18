/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingPFZCycle

Description:
	Switches the current PFZ between all options.

Parameters:
	_heli - The helicopter to act on

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_targetingPFZCycle
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];
_count = _heli getVariable "fza_ah64_pfz_count";
_count = _count + 1;
if(_count == 9) then {
    _count = 0;
};
_heli setVariable ["fza_ah64_pfz_count", _count, true];