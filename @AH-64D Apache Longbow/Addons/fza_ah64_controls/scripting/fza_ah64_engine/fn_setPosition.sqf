params ["_object", "_position"];

[_object] call BIS_OO_fza_ah64_engine_update;

switch (_object getVariable "fza_ah64_engineState") do {
	case "OFF": {
		if (_position == 1) then {
			_object setVariable ["fza_ah64_stateStartTime", time];
			_object setVariable ["fza_ah64_engineState", "OFFIDLE"];
			true;
		};
		false;
	};
	case "IDLE": {
		switch (_position) do {
			case 0: {
				_object setVariable ["fza_ah64_stateStartTime", time];
				_object setVariable ["fza_ah64_engineState", "IDLEOFF"];
				true;
			};
			case 2: {
				_object setVariable ["fza_ah64_stateStartTime", time];
				_object setVariable ["fza_ah64_engineState", "IDLEFLY"];
				true;
			};
			default {
				false;
			};
		};
	};
	case "FLY": {
		if (_position == 1) then {
			_object setVariable ["fza_ah64_stateStartTime", time];
			_object setVariable ["fza_ah64_engineState", "FLYIDLE"];
			true;
		};
		false;
	};
	default {
		false;
	};
};