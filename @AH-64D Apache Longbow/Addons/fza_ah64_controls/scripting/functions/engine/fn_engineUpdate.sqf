params ["_heli", "_engNum"];

(fza_ah64_engineStates select _engNum) params ["_state", "_stateStartTime"];

private _nextState = _state;
switch(_state) do {
	case "OFFIDLE": {
		if (time - _stateStartTime > 96.0) then {
			_nextState = "IDLE";
		};
	};
	case "IDLEOFF": {
		if (time - _stateStartTime > 30) then {
			_nextState = "OFF";
		};
	};
	case "IDLEFLY": {
		if (time - _stateStartTime > 22) then {
			_nextState = "FLY";
		};
	};
	case "FLYIDLE": {
		if (time - _stateStartTime > 20) then {
			_nextState = "IDLE";
		};
	};
};

(fza_ah64_engineStates select _engNum) set [0, _nextState]