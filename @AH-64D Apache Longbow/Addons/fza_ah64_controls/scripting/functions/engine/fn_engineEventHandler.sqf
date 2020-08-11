params ["_heli", "_engineState"];

if( local _heli && _heli getVariable "fza_ah64_estarted" && _engineState) then {
	_heli engineOn false;
};