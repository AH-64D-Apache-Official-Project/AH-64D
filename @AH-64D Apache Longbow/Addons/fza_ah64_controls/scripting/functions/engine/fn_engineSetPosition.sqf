params ["_heli", "_engNum", "_position"];

[_heli, 0] call fza_fnc_engineUpdate;
[_heli, 1] call fza_fnc_engineUpdate;
(fza_ah64_engineStates select _engNum) params ["_state", "_stateStartTime"];
private _otherEngineNum = if (_engNum == 0) then {1} else {0};
(fza_ah64_engineStates select _otherEngineNum) params ["_otherState", "_otherStateStartTime"];

private _throttleAnimName = format ["plt_eng%1_throttle", _engNum+1];

switch (_state) do {
	case "OFF": {
		if (_position == 1) then {
			_stateStartTime = time;
			_state = "OFFIDLE";
			if (_otherState == "OFF") then {
				systemChat "Set to 147776";
				_heli setWantedRPMRTD [14776, 80, -1];
				fza_ah64_engineGovernFinish = time + 80;
			};
			_heli animate [_throttleAnimName, 0.25];
		};
	};
	case "IDLE": {
		switch (_position) do {
			case 0: {
				_stateStartTime = time;
				_state = "IDLEOFF";
				if (_otherState == "IDLEOFF" || _otherState == "OFF") then {
					systemChat "Set to 0";
					_heli setWantedRPMRTD [0, 30, -1];
					fza_ah64_engineGovernFinish = time + 30;
				};
				_heli animate [_throttleAnimName,0];
			};
			case 2: {
				if(_otherState == "IDLE") then {
					systemChat "Set to 21109";
					_stateStartTime = time;
					_state = "IDLEFLY";
					_otherStateStartTime = time;
					_otherState = "IDLEFLY";
					_heli setWantedRPMRTD [21109, 30, -1];
					fza_ah64_engineGovernFinish = time + 30;
					_heli animate ["plt_eng1_throttle",1];
					_heli animate ["plt_eng2_throttle",1];
				}
			};
		};
	};
	case "FLY": {
		if (_position == 1) then {
			systemChat "Set to 147776";
			_stateStartTime = time;
			_state = "FLYIDLE";
			_otherStateStartTime = time;
			_otherState = "FLYIDLE";
			_heli setWantedRPMRTD [14776, 10, -1];
			fza_ah64_engineGovernFinish = time + 10;
			_heli animate ["plt_eng1_throttle",0.25];
			_heli animate ["plt_eng2_throttle",0.25];
		};
	};
	default {
	};
};

if (_engNum == 0) then {
	fza_ah64_engineStates = [[_state, _stateStartTime], [_otherState, _otherStateStartTime]]
} else {
	fza_ah64_engineStates = [[_otherState, _otherStateStartTime], [_state, _stateStartTime]]
}