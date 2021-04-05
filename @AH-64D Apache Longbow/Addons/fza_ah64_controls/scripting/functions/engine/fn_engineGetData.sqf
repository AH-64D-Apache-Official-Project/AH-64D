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
	[Np (rpm), Ng (%), TGT (*C), Oil Pressure (PSI), Torque (Nm), State]

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

private _npMul     = 0;
private _torqueMul = 0;
private _tgt       = 0;
private _oil       = 0;
private _ng        = 0;

//--------------------------------Time--NP----NG---TGT--OIL--TQ
private _offStartedTransition = [[ 0.0, 0.0,  0.0, 0.0, 0.0, 0.0], 
								 [ 2.0, 0.0,  0.0, 0.0, 0.0, 0.0], 
								 [ 4.0, 0.0,  6.4, 0.0, 0.0, 0.0], 
								 [ 6.0, 0.0, 14.6, 0.0, 0.0, 0.0], 
								 [ 8.0, 0.0, 19.9, 0.0, 1.0, 0.0], 
								 [10.0, 0.0, 23.0, 0.0, 1.0, 0.0]];
//--------------------------------Time--NP----NG---TGT--OIL--TQ
private _startedOffTransition = [[0.0, 0.0, 23.0, 0.0, 1.0, 0.0], 
								 [10.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
//---------------------------------Time---NP----Ng-----TGT----Oil----TQ
private _startedIdleTransition = [[0.0,   0.0, 23.0,   0.0,  1.0,   0.0], 
								  [2.0,   0.0, 26.2,   3.0,  2.0,   0.0], 
								  [4.0,   0.0, 31.8, 244.0, 10.0,   0.0], 
								  [6.0,   0.0, 35.5, 339.0, 17.0,   0.0], 
								  [8.0,   0.0, 40.7, 435.0, 27.0,   0.0], 
								  [10.0,  0.0, 45.5, 513.0, 37.0,   0.0], 
								  [12.0,  0.0, 54.8, 622.0, 47.0,   0.0], 
								  [14.0,  0.0, 64.3, 678.0, 60.0,   0.0], 
								  [16.0,  3.0, 67.0, 582.0, 74.0,   0.0], 
								  [18.0,  3.0, 67.0, 519.0, 83.0,   0.0], 
								  [20.0,  3.0, 67.2, 485.0, 88.0,   0.0], 
								  [22.0,  5.0, 67.3, 475.0, 89.0,   0.0], 
								  [24.0,  7.0, 67.3, 472.0, 90.0,   0.0], 
								  [26.0,  9.0, 67.4, 472.0, 90.0,   0.0], 
								  [28.0, 12.0, 67.4, 473.0, 90.0,   0.0], 
								  [30.0, 16.0, 67.4, 475.0, 89.0,   0.0], 
								  [32.0, 20.0, 67.5, 479.0, 88.0,   0.0], 
								  [34.0, 24.0, 67.7, 482.0, 88.0,   0.0], 
								  [36.0, 27.0, 67.7, 483.0, 87.0,   0.0], 
								  [38.0, 29.0, 67.7, 485.0, 86.0,   0.0], 
								  [40.0, 31.0, 67.7, 486.0, 85.0,   0.0], 
								  [42.0, 33.0, 67.8, 488.0, 84.0,   0.0], 
								  [44.0, 34.0, 67.8, 489.0, 83.0,   0.0], 
								  [46.0, 36.0, 67.8, 491.0, 82.0,   0.0], 
								  [48.0, 37.0, 67.9, 492.0, 82.0,   7.0], 
								  [50.0, 38.0, 67.9, 493.0, 81.0,   7.0], 
								  [52.0, 39.0, 67.9, 494.0, 80.0,   7.0], 
								  [54.0, 40.0, 67.9, 494.0, 79.0,   7.0], 
								  [56.0, 41.0, 67.8, 494.0, 78.0,   7.0], 
								  [58.0, 41.0, 67.7, 494.0, 78.0,   7.0], 
								  [60.0, 42.0, 67.7, 495.0, 77.0,   7.0], 
								  [62.0, 42.0, 67.7, 497.0, 76.0,   7.0], 
								  [64.0, 43.0, 67.7, 497.0, 76.0,   7.0], 
								  [66.0, 43.0, 67.7, 498.0, 75.0,   7.0], 
								  [68.0, 43.0, 67.8, 498.0, 74.0,   7.0], 
								  [70.0, 44.0, 67.8, 498.0, 74.0,   7.0], 
								  [72.0, 45.0, 67.8, 499.0, 73.0,   7.0],
								  [74.0, 47.0, 67.8, 499.0, 72.0,   7.0], 
								  [76.0, 49.0, 67.9, 500.0, 72.0,   7.0], 
								  [78.0, 51.0, 67.9, 500.0, 71.0,   7.0], 
								  [80.0, 52.0, 67.9, 500.0, 71.0,   7.0], 
								  [82.0, 53.0, 67.9, 500.0, 70.0,   7.0], 
								  [84.0, 54.0, 67.9, 500.0, 70.0,   7.0], 
								  [86.0, 55.0, 67.9, 500.0, 70.0,   7.0]];

private _idleOffTransition = [[ 0.0, 100.0, 67.9, 500.0, 70.0, 100.0],
							  [30.0,   0.0,  0.0,   0.0,  0.0,  0.0]];
//-----------------------------Time----NP----Ng----TGT---Oil----TQ
private _idleFlyTransition = [[ 0.0,  55.0, 67.9, 500.0, 70.0,   7.0], 
						      [ 2.0,  59.0, 72.1, 525.0, 68.0,   8.0], 
							  [ 4.0,  63.0, 76.7, 550.0, 72.0,  10.0], 
							  [ 6.0,  67.0, 81.2, 566.0, 76.0,  14.0], 
							  [ 8.0,  71.0, 84.4, 564.0, 81.0,  18.0], 
							  [10.0,  78.0, 87.8, 571.0, 86.0,  24.0], 
							  [12.0,  82.0, 85.7, 552.0, 87.0,  30.0], 
							  [14.0,  95.0, 84.2, 546.0, 88.0,  22.5], 
							  [16.0, 100.0, 83.4, 541.0, 88.0,  15.0]];
//-----------------------------Time----NP----Ng----TGT---Oil----TQ
private _flyIdleTransition = [[ 0.0, 100.0, 83.0, 541.0, 88.0,  15.0], 
							  [ 8.0,  55.0, 67.9, 500.0, 70.0,  7.0]];

switch (_state) do {
	case "OFF" : {
		_npMul 	   = 0;
		_torqueMul = 0;
		_tgt 	   = 0;
		_ng 	   = 0;
		_oil       = 0;
	};
	case "OFFSTARTED" : {
		private _result = [_offStartedTransition, time - _stateParams] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "STARTEDOFF" : {
		private _result = [_startedOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "STARTED" : {
		private _result = _startedOffTransition # 0;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "STARTEDIDLE": {
		private _result = [_startedIdleTransition, time - _stateParams+10] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "IDLEOFF": {
		private _result = [_idleOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "IDLE": {
		_npMul = 55;
		_ng    = 67.9;
		_tgt   = 500;
		_oil   = 70;
		_torqueMul = 7;
	};
	case "IDLEFLY": {
		private _result = [_idleFlyTransition, time - _stateParams] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "FLYIDLE": {
		private _result = [_flyIdleTransition, time - _stateParams] call fza_fnc_linearInterp;
		_npMul = _result select 1;
		_ng    = _result select 2;
		_tgt   = _result select 3;
		_oil   = _result select 4;
		_torqueMul = _result select 5;
	};
	case "FLY": {
		_npMul = 100;
		_ng    = 83.4;
		_tgt   = 540;
		_oil   = 70;
		//_torqueMul = 100;
	};
	default {
		["Invalid engine state reached (%1)", _state] call BIS_fnc_error;
	};
};

if(isObjectRTD _heli && difficultyEnabledRTD && count enginesTorqueRTD _heli == 2) then {
	[_npMul / 100.0 * (enginesRpmRTD _heli select _engNum), _ng, _tgt, _oil, _torqueMul / 100.0 * (enginesTorqueRTD _heli select _engNum)];
} else {
	private _data = [_heli] call fza_fnc_sfmplusGetData;

	private _curTQ  = 0;
	if (_state in ["FLY"]) then {
		_curTQ = (_data select 0) * 481;
	} else {
		_curTQ = (_torqueMul / 100) * 481;
	};

	private _curTGT = 0;
	if (_state in ["FLY"]) then {
		_curTGT = _data select 1;
	} else {
		_curTGT = _tgt;
	};

	[(_npMul / 100) * 21109, _ng, _curTGT, _oil, _curTQ];
};