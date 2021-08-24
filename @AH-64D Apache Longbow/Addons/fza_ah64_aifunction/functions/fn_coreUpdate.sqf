/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_coreUpdate

Description:
	handles the spawning of the ai functions

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_aifunction_fnc_coreUpdate
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];



if ((isplayer driver _heli == false) && isengineon _heli == false) then {
	_this remoteExec ["fza_aifunction_fnc_fireControl", _heli turretUnit [0]];
	_this remoteExec ["fza_aifunction_fnc_fireControl", _heli turretUnit [-1]];
};