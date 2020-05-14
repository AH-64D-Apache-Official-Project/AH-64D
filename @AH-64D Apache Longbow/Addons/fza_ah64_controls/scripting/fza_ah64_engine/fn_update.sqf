params ["_object"];

switch(_object getVariable "fza_ah64_engineState") do {
	case "OFFIDLE": {
		if (time - _object getVariable "fza_ah64_engineState" > 96.0) then {
			_object setVariable ["fza_ah64_engineState", "IDLE"];
		};
	};
	case "IDLEOFF": {
		if (time - _object getVariable "fza_ah64_engineState" > 30) then {
			_object setVariable ["fza_ah64_engineState", "OFF"];
		};
	};
	case "IDLEFLY": {
		if (time - _object getVariable "fza_ah64_engineState" > 22) then {
			_object setVariable ["fza_ah64_engineState", "FLY"];
		};
	};
	case "FLYIDLE": {
		if (time - _object getVariable "fza_ah64_engineState" > 20) then {
			_object setVariable ["fza_ah64_engineState", "IDLE"];
		};
	};
}