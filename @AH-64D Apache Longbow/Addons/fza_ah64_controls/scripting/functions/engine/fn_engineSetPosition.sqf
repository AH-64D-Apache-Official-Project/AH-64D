params ["_heli", "_engNum", "_position"];

[_heli, 0] call fza_fnc_engineUpdate;
[_heli, 1] call fza_fnc_engineUpdate;

private _otherEngineNum = if (_engNum == 0) then {1} else {0};
(fza_ah64_engineStates select _engNum) params ["_state", "_stateParams"];
(fza_ah64_engineStates select _otherEngineNum) params ["_otherState", "_otherStateParams"];

private _engineSwitch = format ["plt_eng%1_start", _engNum+1];
private _throttleAnimName = format ["plt_eng%1_throttle", _engNum+1];

private _changeMade = false;

switch (_state) do {
	case "OFF": {
		if (_position == -1) then {
			_state = "OFFSTARTED";
			_stateParams = time;
			_changeMade = true;

			_heli animate [_engineSwitch,1];
			["fza_ah64_switch_flip4",0.1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
			_heli say3D ["fza_ah64_estart_3D",100,1];
		};
	};
	case "STARTED": {
		if (_position == -1) then {
			_state = "STARTEDOFF";
			_stateParams = time;
			_changeMade = true;

			_heli animate [_engineSwitch,0];
			["fza_ah64_switch_flip4",0.1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
			_heli say3D ["fza_ah64_estart_3D",100,1];
		};
		if (_position == 1) then {
			_stateParams = time;
			_state = "STARTEDIDLE";
			_changeMade = true;

			if (_otherState == "OFF") then {
				_heli setWantedRPMRTD [0, 80, -1];
				_heli setVariable ["fza_ah64_engineGovernFinish", time + 80, true];
			};

			_heli animate [_engineSwitch,0];
			["fza_ah64_switch_flip4",0.1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
			_heli animate [_throttleAnimName, 0.25];
		};
	};
	case "IDLE": {
		switch (_position) do {
			case 0: {
				_stateParams = time;
				_state = "IDLEOFF";
				_changeMade = true;

				if (_otherState == "IDLEOFF" || _otherState == "OFF") then {
					_heli setWantedRPMRTD [0, 30, -1];
					_heli setVariable ["fza_ah64_engineGovernFinish", time + 30, true];
				};

				_heli animate [_throttleAnimName,0];
			};
			case 2: {
				if(_otherState == "IDLE") then {
					_state = "IDLEFLY";
					_otherState = "IDLEFLY";
					_stateParams = time;
					_otherStateParams = time;
					_changeMade = true;

					_heli setWantedRPMRTD [21109, 30, -1];
					_heli setVariable ["fza_ah64_engineGovernFinish", time + 30, true];

					_heli animate ["plt_eng1_throttle",1];
					_heli animate ["plt_eng2_throttle",1];
				}
			};
		};
	};
	case "FLY": {
		if (_position == 1) then {
			_state = "FLYIDLE";
			_otherState = "FLYIDLE";
			_stateParams = time;
			_otherStateParams = time;
			_changeMade = true;

			_heli setWantedRPMRTD [14776, 10, -1];
			_heli setVariable ["fza_ah64_engineGovernFinish", time + 10, true];

			_heli animate ["plt_eng1_throttle",0.25];
			_heli animate ["plt_eng2_throttle",0.25];
		};
	};
};

if (_changeMade) then {
	if (_engNum == 0) then {
		_heli setVariable ["fza_ah64_engineStates", [[_state, _stateParams], [_otherState, _otherStateParams]], true];
	} else {
		_heli setVariable ["fza_ah64_engineStates", [[_otherState, _otherStateParams], [_state, _stateParams]], true];
	};
}