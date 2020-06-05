params ["_heli", "_engNum"];

if(!local _heli) exitWith {};

((_heli getVariable "fza_ah64_engineStates") select _engNum) params ["_state", "_stateParams"];

private _changeMade = false;
private _nextState = _state;
switch(_state) do {
	case "OFFSTARTED": {
		if (time - _stateParams > 10) then {
			_nextState = "STARTED";
			_changeMade = true;
		}
	};
	case "STARTEDOFF": {
		if (time - _stateParams > 10) then {
			_nextState = "OFF";
			_changeMade = true;
		}
	};
	case "STARTEDIDLE": {
		if (time - _stateParams > 86.0) then {
			_nextState = "IDLE";
			_changeMade = true;
		};
	};
	case "IDLEOFF": {
		if (time - _stateParams > 30) then {
			_nextState = "OFF";
			_changeMade = true;
		};
	};
	case "IDLEFLY": {
		if (time - _stateParams > 22) then {
			_nextState = "FLY";
			_changeMade = true;
		};
	};
	case "FLYIDLE": {
		if (time - _stateParams > 20) then {
			_nextState = "IDLE";
			_changeMade = true;
		};
	};
};

if(_changeMade) then {
	_newVal = (_heli getVariable "fza_ah64_engineStates");
	(_newVal # _engNum) set [0, _nextState];
	_heli setVariable ["fza_ah64_engineStates", _newVal, true];
};