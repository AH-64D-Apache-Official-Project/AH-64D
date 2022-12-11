params ["_heli", "_engNum"];

private _engState = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engStart = _heli getVariable "bmk_helisim_engStart" select _engNum;

switch (_engState) do {
	case "STARTING": {
		_engStart = false;
		[_heli, "bmk_helisim_engStart", _engNum, _engStart] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	case "OFF": {
		_engStart = true;
		[_heli, "bmk_helisim_engStart", _engNum, _engStart] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	default {
		false;
	}
};