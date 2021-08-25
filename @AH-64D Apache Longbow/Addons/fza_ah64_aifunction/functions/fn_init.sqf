/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_init


Description:
	To set up the aircraft for full ai crew

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_aifunction_fnc_fireControl
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//sight select ai
if (isplayer driver _heli == false) then {
    _heli setVariable ["fza_ah64_sight_plt", 3, true];
};
if (isplayer gunner _heli == false) then {
    _heli setVariable ["fza_ah64_sight_plt", 2, true];
    _heli setVariable ["fza_ah64_rocketsalvo", 2, true];
	_heli setVariable ["fza_ah64_burst_limit", 100];
};