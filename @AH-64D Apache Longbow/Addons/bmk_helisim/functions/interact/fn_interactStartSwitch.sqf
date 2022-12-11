params ["_heli", "_engNum"];

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

private _engState = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engStart = _heli getVariable "bmk_helisim_engStart" select _engNum;

switch (_engState) do {
	case "STARTING": {
		_engStart = true;
		[_heli, "bmk_helisim_engStart", _engNum, _engStart, true] call fza_sfmplus_fnc_setArrayVariable;

		false;
	};
	case "OFF": {
		_engStart = true;
		[_heli, "bmk_helisim_engStart", _engNum, _engStart, true] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	default {
		false;
	}
};