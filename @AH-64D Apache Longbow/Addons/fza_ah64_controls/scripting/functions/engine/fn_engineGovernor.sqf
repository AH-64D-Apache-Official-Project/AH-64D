params ["_heli"];

(fza_ah64_engineStates # 0) params ["_e1state", "_e1time"];
(fza_ah64_engineStates # 1) params ["_e2state", "_e2time"];

if(time < fza_ah64_engineGovernFinish) exitWith {};

if ((_e1state in ["IDLEFLY", "FLY"] && _e2state in ["IDLEFLY", "FLY"])) exitWith {
	_heli setWantedRPMRTD [21109, 20, -1];
	fza_ah64_engineGovernFinish = time + 20;
};

if (
	(_e1state in ["OFF", "IDLE"] || (_e1state == "OFFIDLE" && (time - _e1time > 24))) ||
	(_e2state in ["OFF", "IDLE"] || (_e2state == "OFFIDLE" && (time - _e2time > 24)))) exitWith {
	_heli setWantedRPMRTD [14776, 30, -1];
	fza_ah64_engineGovernFinish = time + 30;
};

if (_e1state == "FLYIDLE" && _e2state == "FLYIDLE") exitWith {
	_heli setWantedRPMRTD [14776, 20, -1];
	fza_ah64_engineGovernFinish = time + 20;
};

if (
	(_e1state == "OFF" || (_e1state == "OFFIDLE" && (time - _e1time <= 24))) &&
	(_e2state == "OFF" || (_e2state == "OFFIDLE" && (time - _e2time <= 24)))) exitWith {
	_heli setWantedRPMRTD [0, 10, -1];
	fza_ah64_engineGovernFinish = time + 10;
};

["Engine governor hit unknown situation, E1: %1, E2: %2", [_e1state, _e1time], [_e2state, _e2time]] call BIS_fnc_error;