/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetData

Description:
    Retrieves avionics data for a single engine.
	
	Can modify state, if it was meant to transition to another state according to fza_fnc_engineUpdate

Parameters:
	_heli - The apache helicopter to get information from [Unit].
	_engNum - The engine number that data should be retrieved for, 0 or 1.

Returns:
	Array of the engine data:
	[Np (rpm), Ng (%), TGT (*C), Oil Pressure (PSI), Torque (Nm)]

Examples:
	--- Code
    _data = [_heli, 0] call fza_fnc_engineGetData
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];

[_heli, _engNum] call fza_fnc_engineUpdate;

((_heli getVariable "fza_ah64_engineStates") select _engNum) params ["_state", "_stateParams"];

private _npMul = 0;
private _torqueMul = 0;
private _tgt = 0;
private _oil = 0;
private _ng = 0;

//2D array schema ["Time", "NpMultiplier", "Ng", "TGT" , "Oil", "TorqueMultiplier"]
private _offStartedTransition = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [2.0, 0.0, 0.0, 0.0, 0.0, 0.0], [4.0, 0.0, 6.4, 0.0, 0.0, 0.0], [6.0, 0.0, 14.6, 0.0, 0.0, 0.0], [8.0, 0.0, 19.9, 0.0, 1.0, 0.0], [10.0, 0.0, 23.0, 0.0, 1.0, 0.0]];
private _startedOffTransition = [[0.0, 0.0, 23.0, 0.0, 1.0, 0.0], [10.0, 0.0, 0.0, 0.0, 0.0, 0.0]];

private _startedIdleTransition = [[0.0, 0.0, 23.0, 0.0, 1.0, 0.0], [2.0, 0.0, 26.2, 3.0, 2.0, 0.0], [4.0, 0.0, 31.8, 244.0, 10.0, 0.0], [6.0, 0.0, 35.5, 339.0, 17.0, 0.0], [8.0, 0.0, 40.7, 435.0, 27.0, 0.0], [10.0, 0.0, 45.5, 513.0, 37.0, 0.0], [12.0, 0.0, 54.8, 622.0, 47.0, 0.0], [14.0, 17.2413793103448, 64.3, 678.0, 60.0, 0.0], [16.0, 27.5862068965517, 67.0, 582.0, 74.0, 0.0], [18.0, 34.4827586206897, 67.0, 519.0, 83.0, 0.0], [20.0, 41.3793103448276, 67.2, 485.0, 88.0, 0.0], [22.0, 46.551724137931, 67.3, 475.0, 89.0, 0.0], [24.0, 51.7241379310345, 67.3, 472.0, 90.0, 0.0], [26.0, 55.1724137931034, 67.4, 472.0, 90.0, 0.0], [28.0, 58.6206896551724, 67.4, 473.0, 90.0, 0.0], [30.0, 62.0689655172414, 67.4, 475.0, 89.0, 100.0], [32.0, 65.5172413793104, 67.5, 479.0, 88.0, 100.0], [34.0, 67.2413793103448, 67.7, 482.0, 88.0, 100.0], [36.0, 68.9655172413793, 67.7, 483.0, 87.0, 100.0], [38.0, 70.6896551724138, 67.7, 485.0, 86.0, 100.0], [40.0, 72.4137931034483, 67.7, 486.0, 85.0, 100.0], [42.0, 74.1379310344828, 67.8, 488.0, 84.0, 100.0], [44.0, 74.1379310344828, 67.8, 489.0, 83.0, 100.0], [46.0, 75.8620689655172, 67.8, 491.0, 82.0, 100.0], [48.0, 75.8620689655172, 67.9, 492.0, 82.0, 100.0], [50.0, 77.5862068965517, 67.9, 493.0, 81.0, 100.0], [52.0, 77.5862068965517, 67.9, 494.0, 80.0, 100.0], [54.0, 79.3103448275862, 67.9, 494.0, 79.0, 100.0], [56.0, 82.7586206896552, 67.8, 494.0, 78.0, 100.0], [58.0, 87.9310344827586, 67.7, 494.0, 78.0, 100.0], [60.0, 89.6551724137931, 67.7, 495.0, 77.0, 100.0], [62.0, 93.1034482758621, 67.7, 497.0, 76.0, 100.0], [64.0, 94.8275862068966, 67.7, 497.0, 76.0, 100.0], [66.0, 96.551724137931, 67.7, 498.0, 75.0, 100.0], [68.0, 96.551724137931, 67.8, 498.0, 74.0, 100.0], [70.0, 98.2758620689655, 67.8, 498.0, 74.0, 100.0], [72.0, 98.2758620689655, 67.8, 499.0, 73.0, 100.0], [74.0, 100.0, 67.8, 499.0, 72.0, 100.0], [76.0, 100.0, 67.9, 500.0, 72.0, 100.0], [78.0, 100.0, 67.9, 500.0, 71.0, 100.0], [80.0, 100.0, 67.9, 500.0, 71.0, 100.0], [82.0, 100.0, 67.9, 500.0, 70.0, 100.0], [84.0, 100.0, 67.9, 500.0, 70.0, 100.0], [86.0, 100.0, 67.9, 500.0, 70.0, 100.0]];
private _idleOffTransition = [[0, 100.0, 67.9, 500.0, 70.0, 100.0], [30.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
//2D array schema ["Time","Ng","TGT","PSI"]
private _idleFlyTransition = [[0.0, 67.9, 500.0, 70.0], [2.0, 72.1, 525.0, 68.0], [4.0, 76.7, 550.0, 72.0], [6.0, 81.2, 566.0, 76.0], [8.0, 84.4, 564.0, 81.0], [10.0, 87.8, 571.0, 86.0], [12.0, 85.7, 552.0, 87.0], [14.0, 84.2, 546.0, 88.0], [16.0, 85.5, 556.0, 88.0], [18.0, 85.3, 542.0, 88.0], [20.0, 84.0, 542.0, 88.0], [22.0, 83.4, 541.0, 88.0]];
private _flyIdleTransition = [[0, 83.0, 541.0, 88.0], [20, 67.9, 500.0, 70.0]];

switch (_state) do {
	case "OFF" : {
		_tgt = 0;
		_ng = 0;
		_oil = 0;
		_torqueMul = 0;
		_npMul = 0;
	};
	case "OFFSTARTED" : {
		private _result = [_offStartedTransition, time - _stateParams] call fza_fnc_linearInterp;
		_ng = _result select 2;
		_tgt = _result select 3;
		_oil = _result select 4;
		_torqueMul = _result select 5;
		_npMul = _result select 1;
	};
	case "STARTEDOFF" : {
		private _result = [_startedOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_ng = _result select 2;
		_tgt = _result select 3;
		_oil = _result select 4;
		_torqueMul = _result select 5;
		_npMul = _result select 1;
	};
	case "STARTED" : {
		private _result = _startedOffTransition # 0;
		_ng = _result select 2;
		_tgt = _result select 3;
		_oil = _result select 4;
		_torqueMul = _result select 5;
		_npMul = _result select 1;
	};
	case "STARTEDIDLE": {
		private _result = [_startedIdleTransition, time - _stateParams+10] call fza_fnc_linearInterp;
		_ng = _result select 2;
		_tgt = _result select 3;
		_oil = _result select 4;
		_torqueMul = _result select 5;
		_npMul = _result select 1;
	};
	case "IDLEOFF": {
		private _result = [_idleOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_ng = _result select 2;
		_tgt = _result select 3;
		_oil = _result select 4;
		_torqueMul = _result select 5;
		_npMul = _result select 1;
	};
	case "IDLE": {
		_ng = 67.9;
		_tgt = 500;
		_oil = 70;
		_torqueMul = 100;
		_npMul = 100;
	};
	case "IDLEFLY": {
		private _result = [_idleFlyTransition, time - _stateParams] call fza_fnc_linearInterp;
		_ng = _result select 1;
		_tgt = _result select 2;
		_oil = _result select 3;
		_torqueMul = 100;
		_npMul = 100;
	};
	case "FLYIDLE": {
		private _result = [_flyIdleTransition, time - _stateParams] call fza_fnc_linearInterp;
		_ng = _result select 1;
		_tgt = _result select 2;
		_oil = _result select 3;
		_torqueMul = 100;
		_npMul = 100;
	};
	case "FLY": {
		_ng = 83.4;
		_tgt = 500;
		_oil = 70;
		_torqueMul = 100;
		_npMul = 100;
	};
	default {
		["Invalid engine state reached (%1)", _state] call BIS_fnc_error;
	};
};

//RTD...we shall burn it with holy fire...
if(isObjectRTD _heli && difficultyEnabledRTD && count enginesTorqueRTD _heli == 2) then {
	[_npMul / 100.0 * (enginesRpmRTD _heli select _engNum), _ng, _tgt, _oil, _torqueMul / 100.0 * (enginesTorqueRTD _heli select _engNum)];
} 
else {
	//First we need to get the analog collective input, both of these are positive values: low is 1 to 0, and high is 0 to 1
	_collLow  = inputAction "HeliCollectiveLowerCont";
	_collHigh = inputAction "HeliCollectiveRaiseCont";
	//If we take high - low, we get an output from -1 to 1 
	_collVal = _collHigh - _collLow;
	//Now that convert the -1 to 1 to a 0 to 1 output
	_collOut = linearConversion [-1, 1, _collVal, 0, 1];
	
	//[Np (rpm), Ng (%), TGT (*C), Oil Pressure (PSI), Torque (Nm)]	
	
	//tqOut takes in the collective input from 0 to 1, and interpolates from 70 Nm Tq to 645 Nm torque this corresponds to a TQ % of 15% at
	//flat pitch to 131% at 100% collective. This is temporary, but should make the engine page torque be dynamic.
	_tqOut = linearConversion[0, 1, _collOut, 70, 630];
	
	[(_npMul / 100) * 21109, _ng, _tgt, _oil, _tqOut];
};

/***
[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		_collLow  = inputAction "HeliCollectiveLowerCont";
		_collHigh = inputAction "HeliCollectiveRaiseCont";
		_collVal = _collHigh - _collLow;
		
		_collOut = linearConversion [-1, 1, _collVal, 0, 1];
		
		_tqOut = linearConversion[0, 1, _collOut, 70, 630];
		
		hintSilent format ["Lower %1\nUpper %2\nColl Out %3\nTq Out %4", inputAction "HeliCollectiveLowerCont", inputAction "HeliCollectiveRaiseCont", _collOut, _tqOut];
		sleep 0.03;
	}
};
***/