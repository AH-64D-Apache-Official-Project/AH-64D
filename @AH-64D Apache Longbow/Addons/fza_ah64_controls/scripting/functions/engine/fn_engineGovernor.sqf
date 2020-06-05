params ["_heli"];

if(!local _heli) exitWith {};

_states = _heli getVariable "fza_ah64_engineStates";
(_states # 0) params ["_e1state", "_e1params"];
(_states # 1) params ["_e2state", "_e2params"];

if((_e1state == "STARTEDIDLE" && (time - _e1params) > 10) || (_e1state == "STARTEDIDLE" && (time - _e1params) > 10)) then {
	private _transTime = 86;
	if(_e1state == "STARTEDIDLE") then {
		_transTime = _transTime min (86-(time - _e1params))
	};
	if(_e2state == "STARTEDIDLE") then {
		_transTime = _transTime min (86-(time - _e2params))
	};
	_heli setWantedRPMRTD [14476,_transTime, -1];
};

if(time < _heli getVariable "fza_ah64_engineGovernFinish") exitWith {};
if ((_e1state in ["IDLEFLY", "FLY"] && _e2state in ["IDLEFLY", "FLY"])) exitWith {
	_heli setWantedRPMRTD [21109, 20, -1];
	_heli setVariable ["fza_ah64_engineGovernFinish", time + 20, true];
};

if (
	(_e1state in ["OFF", "IDLE"] || (_e1state == "STARTEDIDLE" && (time - _e1params > 24))) ||
	(_e2state in ["OFF", "IDLE"] || (_e2state == "STARTEDIDLE" && (time - _e2params > 24)))) exitWith {
	_heli setWantedRPMRTD [14776, 30, -1];
	_heli setVariable ["fza_ah64_engineGovernFinish", time + 30, true];
};

if (_e1state == "FLYIDLE" && _e2state == "FLYIDLE") exitWith {
	_heli setWantedRPMRTD [14776, 20, -1];
	_heli setVariable ["fza_ah64_engineGovernFinish", time + 20, true];
};

if (
	(_e1state in ["OFF", "OFFSTARTED", "STARTEDOFF", "STARTED"] || (_e1state == "STARTEDIDLE" && (time - _e1params <= 24))) &&
	(_e2state == "OFF" || (_e2state == "STARTEDIDLE" && (time - _e2params <= 24)))) exitWith {
	_heli setWantedRPMRTD [0, 10, -1];
	_heli setVariable ["fza_ah64_engineGovernFinish", time + 10, true];
};

["Engine governor hit unknown situation, E1: %1, E2: %2", [_e1state, _e1params], [_e2state, _e2params]] call BIS_fnc_error;