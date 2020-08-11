params ["_unit"];

{
	if(_unit isKindOf _x) exitWith {true};
	false;
} forEach fza_ah64_ada_units