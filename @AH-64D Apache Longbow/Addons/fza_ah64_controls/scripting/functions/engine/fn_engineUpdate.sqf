params ["_heli", "_engNum"];

(fza_ah64_engineStates select _engNum) params ["_state", "_stateParams"];

private _nextState = _state;
switch(_state) do {
	case "OFFSTARTED": {
		if (time - _stateParams > 10) then {
			_nextState = "STARTED"
		}
	};
	case "STARTEDOFF": {
		if (time - _stateParams > 10) then {
			_nextState = "OFF"
		}
	};
	case "STARTEDIDLE": {
		if (time - _stateParams > 86.0) then {
			_nextState = "IDLE";
		};
	};
	case "IDLEOFF": {
		if (time - _stateParams > 30) then {
			_nextState = "OFF";
		};
	};
	case "IDLEFLY": {
		if (time - _stateParams > 22) then {
			_nextState = "FLY";
		};
	};
	case "FLYIDLE": {
		if (time - _stateParams > 20) then {
			_nextState = "IDLE";
		};
	};
};

(fza_ah64_engineStates select _engNum) set [0, _nextState]