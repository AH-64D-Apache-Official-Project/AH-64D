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
								
//----------------------------------Time----NP_s-----TQ_s----NP_a-------TQ_a------NG------TGT----OIL
private _startedIdleTransition = [[    0,      0,       0,      0,         0,     23,       0,     1],
								  [    2,      0,       0,      0,         0,   26.2,       3,     2],
								  [    4,      0,       0,      0,         0,   31.8,     244,    10],
								  [    6,      0,       0,      0,         0,   35.5,     339,    17],
								  [    8,      0,       0,      0, 		   0,   40.7,     435,    27],
								  [   10,      0,       0,      0,         0,   45.5,     513,    37],
								  [   12,      0,       0,      0,         0,   54.8,     622,    47],
								  [   14,      0,       0,      0,     17.24,   64.3,     678,    60],
								  [   16,      3,       0,      3,     27.58,   67.0,     582,    74],
								  [   18,      3,       0,      3,     34.48,   67.0,     519,    83],
								  [   20,      3,       0,      3,     41.37,   67.2,     485,    88],
								  [   22,      5,       0,      5,     46.55,   67.3,     475,    89],
								  [   24,      7,       0,      7,     51.72,   67.3,     472,    90],
								  [   26,      9,       0,      9,     55.17,   67.4,     472,    90],
								  [   28,      12,      0,      12,    58.62,   67.4,     473,    90],
								  [   30,      16,      0,      16,    62.06,   67.4,     475,    89],
								  [   32,      20,      0,      20,    65.51,   67.5,     479,    88],
								  [   34,      24,      0,      24,    67.24,   67.7,     482,    88],
								  [   36,      27,      0,      27,    68.96,   67.7,     483,    87],
								  [   38,      29,      0,      29,    70.68,   67.7,     485,    86],
								  [   40,      31,      0,      31,    72.41,   67.7,     486,    85],
								  [   42,      33,      0,      33,    74.13,   67.8,     488,    84],
								  [   44,      34,      0,      34,    74.13,   67.8,     489,    83],
								  [   46,      36,      0,      36,    75.86,   67.8,     491,    82],
								  [   48,      37,      7,      37,    75.86,   67.9,     492,    82],
								  [   50,      38,      7,      38,    77.58,   67.9,     493,    81],
								  [   52,      39,      7,      39,    77.58,   67.9,     494,    80],
								  [   54,      40,      7,      40,    79.31,   67.9,     494,    79],
								  [   56,      41,      7,      41,    82.75,   67.8,     494,    78],
								  [   58,      41,      7,      41,    87.93,   67.7,     494,    78],
							      [   60,      42,      7,      42,    89.65,   67.7,     495,    77],
							      [   62,      42,      7,      42,    93.10,   67.7,     497,    76],
							      [   64,      43,      7,      43,    94.82,   67.7,     497,    76],
							      [   66,      43,      7,      43,    96.55,   67.7,     498,    75],
							      [   68,      43,      7,      43,    96.55,   67.8,     498,    74],
							      [   70,      44,      7,      44,    98.27,   67.8,     498,    74],
							      [   72,      45,      7,      45,    98.27,   67.8,     499,    73],
							      [   74,      47,      7,      47,   100.00,   67.8,     499,    72],
							      [   76,      49,      7,      49,   100.00,   67.9,     500,    72],
							      [   78,      51,      7,      51,   100.00,   67.9,     500,    71],
							      [   80,      52,      7,      52,   100.00,   67.9,     500,    71],
							      [   82,      53,      7,      53,   100.00,   67.9,     500,    70],
							      [   84,      54,      7,      54,   100.00,   67.9,     500,    70],
							      [   86,      55,      7,      55,   100.00,   67.9,     500,    70]];

private _idleOffTransition = [[0, 100, 100, 100, 100, 67.9, 500, 70],
							  [30,  0,   0,   0,   0,    0,   0,  0]];
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
							  [ 8.0,  55.0, 67.9, 500.0, 70.0,   7.0]];

private _sfmNpMul     = 0;
private _sfmTorqueMul = 0;
private _afmNpMul     = 0;
private _afmTorqueMul = 0;
private _tgt          = 0;
private _oil          = 0;
private _ng           = 0;

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
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = _result select 1;
		_afmTorqueMul = _result select 5;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "STARTEDOFF" : {
		private _result = [_startedOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = _result select 1;
		_afmTorqueMul = _result select 5;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "STARTED" : {
		private _result = _startedOffTransition # 0;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = _result select 1;
		_afmTorqueMul = _result select 5;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "STARTEDIDLE": {
		private _result = [_startedIdleTransition, time - _stateParams+10] call fza_fnc_linearInterp;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 2;
		_afmNpMul     = _result select 3;
		_afmTorqueMul = _result select 4;
		_ng           = _result select 5;
		_tgt          = _result select 6;
		_oil          = _result select 7;
	};
	case "IDLEOFF": {
		private _result = [_idleOffTransition, time - _stateParams] call fza_fnc_linearInterp;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = _result select 1;
		_afmTorqueMul = _result select 5;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "IDLE": {
		private _result = _idleOffTransition # 0;
		_sfmNpMul     = 55;
		_sfmTorqueMul = 7;
		_afmNpMul     = 100;
		_afmTorqueMul = 100;
		_ng           = 67.9;
		_tgt          = 500;
		_oil          = 70;
	};
	case "IDLEFLY": {
		private _result = [_idleFlyTransition, time - _stateParams] call fza_fnc_linearInterp;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = 100;
		_afmTorqueMul = 100;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "FLYIDLE": {
		private _result = [_flyIdleTransition, time - _stateParams] call fza_fnc_linearInterp;
		_sfmNpMul     = _result select 1;
		_sfmTorqueMul = _result select 5;
		_afmNpMul     = 100;
		_afmTorqueMul = 100;
		_ng           = _result select 2;
		_tgt          = _result select 3;
		_oil          = _result select 4;
	};
	case "FLY": {
		private _result = _flyIdleTransition # 0;
		_sfmNpMul     = 100;
		_afmNpMul     = 100;
		_afmTorqueMul = 100;
		_ng           = 83.4;
		_tgt          = 540;
		_oil          = 70;
	};
	default {
		["Invalid engine state reached (%1)", _state] call BIS_fnc_error;
	};
};

private _data = [_heli] call fza_fnc_sfmplusGetData;

private _curTQ  = 0;
if (_state in ["FLY"]) then {
	_curTQ = (_data select 0) * 481;
} else {
	_curTQ = (_sfmTorqueMul / 100) * 481;
};

private _curTGT = 0;
if (_state in ["FLY"]) then {
	_curTGT = _data select 1;
} else {
	_curTGT = _tgt;
};

[(_sfmNpMul / 100) * 21109, _ng, _curTGT, _oil, _curTQ];