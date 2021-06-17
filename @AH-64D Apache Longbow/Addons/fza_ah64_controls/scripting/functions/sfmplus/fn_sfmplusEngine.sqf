/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusEngine

Description:

Parameters:

Returns:


Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_deltaTime", "_engTQMult"];

private _engState            = _heli getVariable "fza_ah64_engState" select _engNum;
private _engBaseFF           = _heli getVariable "fza_ah64_engBaseFF" select _engNum;
private _engFF               = _heli getVariable "fza_ah64_engFF" select _engNum;
private _engBaseNG			 = _heli getVariable "fza_ah64_engBaseNG" select _engNum;
private _engPctNG            = _heli getVariable "fza_ah64_engPctNG" select _engNum;
private _engBaseNP           = _heli getVariable "fza_ah64_engBaseNP" select _engNum;
private _engPctNP            = _heli getVariable "fza_ah64_engPctNP" select _engNum;
private _engBaseTQ           = _heli getVariable "fza_ah64_engBaseTQ" select _engNum;
private _engPctTQ            = _heli getVariable "fza_ah64_engPctTQ" select _engNum;
private _engBaseTGT          = _heli getVariable "fza_ah64_engBaseTGT" select _engNum;
private _engTGT              = _heli getVariable "fza_ah64_engTGT" select _engNum;
private _engStartSwitchState = _heli getVariable "fza_ah64_engStartSwitchState" select _engNum;
private _engPowerLeverState  = _heli getVariable "fza_ah64_engPowerLeverState" select _engNum;
private _engClutchState      = _heli getVariable "fza_ah64_engClutchState" select _engNum;

//Ng variables
private _ngMaxVal    = 0;
private _ngCurVal    = 0;
private _ngTimeToVal = 0;
private _ngValPerUnitTime = 0;

private _engStartNg = _heli getVariable "fza_ah64_engStartNg";
private _engIdleNg  = _heli getVariable "fza_ah64_engIdleNg";
private _engFlyNg   = _heli getVariable "fza_ah64_engFlyNg";

//Np variables
private _npMaxVal    = 0;
private _npCurVal    = 0;
private _npTimeToVal = 0;
private _npValPerUnitTime = 0;

private _engStartNp = _heli getVariable "fza_ah64_engStartNp";
private _engIdleNp  = _heli getVariable "fza_ah64_engIdleNp";
private _engFlyNp   = _heli getVariable "fza_ah64_engFlyNp"; 

if (_engStartSwitchState == "START") then {
	_engState = "STARTING";
	[_heli, "fza_ah64_engStartSwitchState", _engNum, "OFF"] call fza_fnc_sfmplusSetArrayVariable;
};

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
_engBaseNG = [_ngMaxVal, _ngCurVal, _deltaTime, _ngValPerUnitTime] call fza_fnc_sfmplusClampedMove;
[_heli, "fza_ah64_engBaseNG", _engNum, _engBaseNG] call fza_fnc_sfmplusSetArrayVariable;

_engPctNP = [_npMaxVal, _npCurVal, _deltaTime, _npValPerUnitTime] call fza_fnc_sfmplusClampedMove;
[_heli, "fza_ah64_engPctNP", _engNum, _engPctNP] call fza_fnc_sfmplusSetArrayVariable;

if (_engBaseNG >= 0.52) then {
	_engState = "ON";
};
[_heli, "fza_ah64_engState", _engNum, _engState] call fza_fnc_sfmplusSetArrayVariable;

if (_engState != "OFF") then {
	private _intEngBaseTable = [_heli getVariable "fza_ah64_engBaseTable", _engBaseNG] call fza_fnc_linearInterp;
	//TGT
	_engBaseTGT = _intEngBaseTable select 1;
	[_heli, "fza_ah64_engBaseTGT", _engNum, _engBaseTGT] call fza_fnc_sfmplusSetArrayVariable;
	//TQ
	_engBaseTQ = _intEngBaseTable select 2;
	[_heli, "fza_ah64_engBaseTQ",  _engNum, _engBaseTQ] call fza_fnc_sfmplusSetArrayVariable;

	private _curGWT_kg     = getMass _heli;
	private _intHvrTQTable = [_heli getVariable "fza_ah64_hvrTqTable", _curGWT_kg] call fza_fnc_linearInterp;
	private _hvrIGE = _intHvrTQTable select 1;
	private _hvrOGE = _intHvrTQTable select 2;

	private _heightAGL = getPos _heli select 2;
	private _hvrTQ     = linearConversion [15.24, 1.52, _heightAGL, _hvrOGE, _hvrIGE, true];

	//--------------------------Coll-----TQ---
	private _engHvrTQTable = [[ 0.0, _engBaseTQ],
							  [ 0.7,     _hvrTQ],
							  [ 1.0,       1.34]];

	private _intCruiseTQTable = [_heli getVariable "fza_ah64_cruiseTable", _curGWT_kg] call fza_fnc_linearInterp;

	//----------------------------Coll-----TQ---
	private _engCruiseTQTable = [[ 0.00, 		               0.03],
								 [ 0.67, _intCruiseTQTable select 4],
								 [ 0.70, _intCruiseTQTable select 5],
								 [ 0.89, _intCruiseTQTable select 7],
								 [ 1.00, _intCruiseTQTable select 9]];

	private _curHvrTQ = [_engHvrTQTable,    fza_ah64_collectiveOutput] call fza_fnc_linearInterp select 1;
	private _cruiseTQ = [_engCruiseTQTable, fza_ah64_collectiveOutput] call fza_fnc_linearInterp select 1;
	
	private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
	_engPctTQ = linearConversion [0.00, 12.35, _V_mps, _curHvrTQ, _cruiseTQ, true];
	_engPctTQ = _engPctTQ * _engTQMult;
	[_heli, "fza_ah64_engPctTQ", _engNum, _engPctTQ] call fza_fnc_sfmplusSetArrayVariable;

	//-------------------------TQ----------TGT------------NG---------
	private _engTable = [[ _engBaseTQ,	_engBaseTGT,	_engBaseNG],
						 [ 1.00, 		810,			0.950	  ],	//Cont
						 [ 1.29, 	    867,			0.990	  ],	//10 min
						 [ 1.34, 	    896,			0.997	  ]];	//2.5 Min

	//----------------------TQ----FF (kg/s)
	private _engFFTable = [[0.00, 0.0000],
						   [0.30, 0.0428],
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
	[_heli, "fza_ah64_engTGT", _engNum, _engTGT] call fza_fnc_sfmplusSetArrayVariable;

	_engPctNG = [_engTable, _engPctTQ] call fza_fnc_linearInterp select 2;
	[_heli, "fza_ah64_engPctNG", _engNum, _engPctNG] call fza_fnc_sfmplusSetArrayVariable;

	_engFF = [_engFFTable, _engPctTQ] call fza_fnc_linearInterp select 1;
	[_heli, "fza_ah64_engFF", _engNum, _engFF] call fza_fnc_sfmplusSetArrayVariable;
};