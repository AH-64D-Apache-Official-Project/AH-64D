/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engine

Description:
	Provides a visually accurate simulation of a turbine engine based on table
	interpolation and collective input.

Parameters:
	_heli      - The helicopter to get information from [Unit].
	_engNum    - The engine to simulate
	_deltaTime - Passed delta time from core update.
	_engTQMult - Is either 0, 1 or 2 depending on the state of the engine

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_deltaTime", "_engTQMult"];

private _engState            = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _engBaseFF           = _heli getVariable "fza_sfmplus_engBaseFF" select _engNum;
private _engFF               = _heli getVariable "fza_sfmplus_engFF" select _engNum;
private _engBaseNG			 = _heli getVariable "fza_sfmplus_engBaseNG" select _engNum;
private _engPctNG            = _heli getVariable "fza_sfmplus_engPctNG" select _engNum;
private _engBaseNP           = _heli getVariable "fza_sfmplus_engBaseNP" select _engNum;
private _engPctNP            = _heli getVariable "fza_sfmplus_engPctNP" select _engNum;
private _engBaseTQ           = _heli getVariable "fza_sfmplus_engBaseTQ" select _engNum;
private _engPctTQ            = _heli getVariable "fza_sfmplus_engPctTQ" select _engNum;
private _engBaseTGT          = _heli getVariable "fza_sfmplus_engBaseTGT" select _engNum;
private _engTGT              = _heli getVariable "fza_sfmplus_engTGT" select _engNum;
private _engBaseOilPSI       = _heli getVariable "fza_sfmplus_engBaseOilPSI" select _engNum;
private _engOilPSI           = _heli getVariable "fza_sfmplus_engOilPSI" select _engNum; 
private _engPowerLeverState  = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;

//Ng variables
private _ngMaxVal    = 0;
private _ngCurVal    = 0;
private _ngTimeToVal = 0;
private _ngValPerUnitTime = 0;

private _engStartNg = _heli getVariable "fza_sfmplus_engStartNg";
private _engIdleNg  = _heli getVariable "fza_sfmplus_engIdleNg";
private _engFlyNg   = _heli getVariable "fza_sfmplus_engFlyNg";

//Np variables
private _npMaxVal    = 0;
private _npCurVal    = 0;
private _npTimeToVal = 0;
private _npValPerUnitTime = 0;

private _engStartNp = _heli getVariable "fza_sfmplus_engStartNp";
private _engIdleNp  = _heli getVariable "fza_sfmplus_engIdleNp";
private _engFlyNp   = _heli getVariable "fza_sfmplus_engFlyNp"; 

//Tq Variables
private _tqMaxVal    = 0;
private _tqCurVal    = 0;
private _tqTimeToVal = 0;
private _tqValPerUnitTime = 0;   

switch (_engState) do {
	case "OFF": {
		_ngMaxVal    = 0;
		_ngCurVal    = _engPctNG;
		_ngTimeToVal = 10;
		_ngValPerUnitTime = _ngCurVal / _ngTimeToVal;

		_npMaxVal    = 0;
		_npCurVal    = _engPctNP;
		_npTimeToVal = 10;
		_npValPerUnitTime = _npCurVal / _npTimeToVal;
	};
	case "STARTING": {
		if (_engPowerLeverState == "OFF") then {
			_ngMaxVal    = _engStartNg;
			_ngCurVal    = _engPctNG;
			_ngTimeToVal = 8;
			_ngValPerUnitTime = _ngMaxVal / _ngTimeToVal;

			_npMaxVal    = _engStartNp;
			_npCurVal    = _engPctNP;
			_npTimeToVal = 20;
			_npValPerUnitTime = _npMaxVal / _npTimeToVal;
		};
		if (_engPowerLeverState == "IDLE") then {
			_ngMaxVal    = _engIdleNg;
			_ngCurVal    = _engPctNG;
			_ngTimeToVal = 24;
			_ngValPerUnitTime = _ngMaxVal / _ngTimeToVal;

			_npMaxVal    = _engIdleNp;
			_npCurVal    = _engPctNP;
			_npTimeToVal = 26;
			_npValPerUnitTime = _npMaxVal / _npTimeToVal;
		};
	};
	case "ON": {
		if (_engPowerLeverState == "OFF") then {
			_engState  = "OFF";
			[_heli, "fza_sfmplus_engState", _engNum, "OFF", true] call fza_sfmplus_fnc_setArrayVariable;
			_ngMaxVal    = 0;
			_ngCurVal    = _engPctNG;
			_ngTimeToVal = 10;
			_ngValPerUnitTime = _ngCurVal / _ngTimeToVal;

			_npMaxVal    = 0;
			_npCurVal    = _engPctNP;
			_npTimeToVal = 10;
			_npValPerUnitTime = _npCurVal / _npTimeToVal;
		};
		if (_engPowerLeverState == "IDLE") then {
			_ngMaxVal    = _engIdleNg;
			_ngCurVal    = _engPctNG;
			_ngTimeToVal = 24;
			_ngValPerUnitTime = _ngMaxVal / _ngTimeToVal;

			_npMaxVal    = _engIdleNp;
			_npCurVal    = _engPctNP;
			_npTimeToVal = 26;
			_npValPerUnitTime = _npMaxVal / _npTimeToVal;
		};
		if (_engPowerLeverState == "FLY") then {
			_ngMaxVal    = _engFlyNg;
			_ngCurVal    = _engPctNG;
			_ngTimeToVal = 12;
			_ngValPerUnitTime = _ngMaxVal / _ngTimeToVal;

			_npMaxVal    = _engFlyNp;
			_npCurVal    = _engPctNP;
			_npTimeToVal = 16;
			_npValPerUnitTime = _npMaxVal / _npTimeToVal;
		};
	};
	case "DEST": {
		_ngMaxVal    = 0;
		_ngCurVal    = _engPctNG;
		_ngTimeToVal = 10;
		_ngValPerUnitTime = _ngCurVal / _ngTimeToVal;

		_npMaxVal    = 0;
		_npCurVal    = _engPctNP;
		_npTimeToVal = 10;
		_npValPerUnitTime = _npCurVal / _npTimeToVal;
	};
};

_engBaseNG = [_ngMaxVal, _ngCurVal, _deltaTime, _ngValPerUnitTime] call fza_sfmplus_fnc_clampedMove;
[_heli, "fza_sfmplus_engBaseNG", _engNum, _engBaseNG] call fza_sfmplus_fnc_setArrayVariable;

_engPctNP = [_npMaxVal, _npCurVal, _deltaTime, _npValPerUnitTime] call fza_sfmplus_fnc_clampedMove;
[_heli, "fza_sfmplus_engPctNP", _engNum, _engPctNP] call fza_sfmplus_fnc_setArrayVariable;

if (_engBaseNG >= 0.52 && _engState == "STARTING") then {
	_engState = "ON";
	[_heli, "fza_sfmplus_engState", _engNum, "ON", true] call fza_sfmplus_fnc_setArrayVariable;
};

if (_engState != "OFF") then {
	private _intEngBaseTable = [_heli getVariable "fza_sfmplus_engBaseTable", _engBaseNG] call fza_fnc_linearInterp;
	//TGT
	_engBaseTGT = _intEngBaseTable select 1;
	[_heli, "fza_sfmplus_engBaseTGT", _engNum, _engBaseTGT] call fza_sfmplus_fnc_setArrayVariable;
	//TQ
	_engBaseTQ = _intEngBaseTable select 2;
	[_heli, "fza_sfmplus_engBaseTQ",  _engNum, _engBaseTQ] call fza_sfmplus_fnc_setArrayVariable;
	//Oil
	_engBaseOilPSI = _intEngBaseTable select 4;
	[_heli, "fza_sfmplus_engBaseOilPSI",  _engNum, _engBaseOilPSI] call fza_sfmplus_fnc_setArrayVariable;

	private _curGWT_kg     = getMass _heli;
	private _intHvrTQTable = [_heli getVariable "fza_sfmplus_hvrTqTable", _curGWT_kg] call fza_fnc_linearInterp;
	private _hvrIGE        = _intHvrTQTable select 1;
	private _hvrOGE        = _intHvrTQTable select 2;

	private _heightAGL = getPos _heli select 2;
	private _hvrTQ     = linearConversion [15.24, 1.52, _heightAGL, _hvrOGE, _hvrIGE, true];

	//--------------------------Coll-----TQ---
	private _engHvrTQTable = [[ 0.0, _engBaseTQ],
							  [ 0.7,     _hvrTQ],
							  [ 1.0,       1.34]];

	private _intCruiseTQTable = [_heli getVariable "fza_sfmplus_cruiseTable", _curGWT_kg] call fza_fnc_linearInterp;

	//----------------------------Coll-----TQ---
	private _engCruiseTQTable = [[ 0.00, 		               0.03],
								 [ 0.67, _intCruiseTQTable select 4],
								 [ 0.70, _intCruiseTQTable select 5],
								 [ 0.89, _intCruiseTQTable select 7],
								 [ 1.00, _intCruiseTQTable select 9]];

	private _curHvrTQ = [_engHvrTQTable,    fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;
	private _cruiseTQ = [_engCruiseTQTable, fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;
	
	private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
	_engPctTQ      = linearConversion [0.00, 12.35, _V_mps, _curHvrTQ, _cruiseTQ, true];
	
	if (_engTQMult != 0) then {
		_tqMaxVal    = 0;
		_tqCurVal    = _engPctTQ * _engTQMult;
		_tqTimeToVal = 4;
		_tqValPerUnitTime = _tqCurVal / _tqTimeToVal;  

		_engPctTQ = [_tqMaxVal, _tqCurVal, _deltaTime, _tqValPerUnitTime] call fza_sfmplus_fnc_clampedMove;
	} else {
		_engPctTQ = _engPctTQ * _engTQMult;
	};
	[_heli, "fza_sfmplus_engPctTQ", _engNum, _engPctTQ] call fza_sfmplus_fnc_setArrayVariable;

	//--------------------0-TQ--------1-TGT---------2-NG--------3-Oil
	private _engTable = [[_engBaseTQ, _engBaseTGT,	_engBaseNG, _engBaseOilPSI],
						 [1.00,       810,			0.950	  ,	0.91		  ],	//Cont
						 [1.29, 	  867,			0.990	  , 0.94          ],	//10 min
						 [1.34, 	  896,			0.997	  , 0.99          ]];	//2.5 Min

	//----------------------TQ----FF (kg/s)
	private _engFFTable = [[0.00, 0.0000],
						   [0.07, 0.0216],
						   [0.15, 0.0350],
						   [0.30, 0.0432],
						   [0.40, 0.0480],
						   [0.50, 0.0535],
						   [0.60, 0.0598],
						   [0.70, 0.0661],
						   [0.80, 0.0732],
						   [0.90, 0.0803],
						   [1.00, 0.0866],
						   [1.10, 0.0929],
						   [1.20, 0.0992],
						   [1.30, 0.1055],
						   [1.40, 0.1118]];

	_engTGT = [_engTable, _engPctTQ] call fza_fnc_linearInterp select 1;
	[_heli, "fza_sfmplus_engTGT", _engNum, _engTGT] call fza_sfmplus_fnc_setArrayVariable;

	_engPctNG = [_engTable, _engPctTQ] call fza_fnc_linearInterp select 2;
	[_heli, "fza_sfmplus_engPctNG", _engNum, _engPctNG] call fza_sfmplus_fnc_setArrayVariable;

	_engOilPSI = [_engTable, _engPctTQ] call fza_fnc_linearInterp select 3;
	[_heli, "fza_sfmplus_engOilPSI", _engNum, _engOilPSI] call fza_sfmplus_fnc_setArrayVariable;

	if (_engTQMult != 0) then {
		_engFF = [_engFFTable, _engPctTQ] call fza_fnc_linearInterp select 1;
	} else {
		_engFF = [_engFFTable, _engBaseTQ] call fza_fnc_linearInterp select 1;
	};
	[_heli, "fza_sfmplus_engFF", _engNum, _engFF] call fza_sfmplus_fnc_setArrayVariable;
} else {
	_engBaseNG = [_ngMaxVal, _ngCurVal, _deltaTime, _ngValPerUnitTime] call fza_sfmplus_fnc_clampedMove;
	[_heli, "fza_sfmplus_engPctNG", _engNum, _engBaseNG] call fza_sfmplus_fnc_setArrayVariable;
};