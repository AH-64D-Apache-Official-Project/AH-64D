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
    [_heli] call fza_aifunction_fnc_init
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (isplayer driver _heli == false) then {
    //_heli setVariable ["fza_ah64_sight_plt", 3, true];
};
if (isplayer gunner _heli == false) then {
    //_heli setVariable ["fza_ah64_sight_cpg", 2, true];
    _heli setVariable ["fza_ah64_rocketsalvo", 2, true];
	_heli setVariable ["fza_ah64_burst_limit", 100];
};

if !(isplayer driver _heli && isplayer gunner _heli) then {
	_heli animateSource["pylon1", 5]; 
	_heli animateSource["pylon2", 5]; 
	_heli animateSource["pylon3", 5]; 
	_heli animateSource["pylon4", 5];
};