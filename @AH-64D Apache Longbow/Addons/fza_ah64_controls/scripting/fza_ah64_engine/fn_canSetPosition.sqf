params ["_object", "_position"];

switch (_object getVariable "fza_ah64_engineState") do {
	case "OFF": { _position == 1; };
	case "IDLE": { _position == 0 || _position == 2; };
	case "FLY": { _position == 1; };
	default { false; };
};