/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusStartSwitch

Description:

Parameters:

Returns:


Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_deltaTime"];

private _engState            = _heli getVariable "fza_ah64_engState" select _engNum;
private _engPctNG            = _heli getVariable "fza_ah64_engPctNG" select _engNum;
private _engPctNP            = _heli getVariable "fza_ah64_engPctNP" select _engNum;
private _engPctTQ            = _heli getVariable "fza_ah64_engPctTQ" select _engNum;
private _engTGT              = _heli getVariable "fza_ah64_engTGT" select _engNum;
private _engStartSwitchState = _heli getVariable "fza_ah64_engStartSwitchState" select _engNum;
private _engPowerLeverState  = _heli getVariable "fza_ah64_engPowerLeverState" select _engNum;

//Local variables
private _maxVal    = 0;
private _curVal    = 0;
private _timeToVal = 0;
private _valPerUnitTime = 0;

//Ng variables
private _engStartNg = _heli getVariable "fza_ah64_engStartNg";
private _engIdleNg  = _heli getVariable "fza_ah64_engIdleNg";
private _engFlyNg   = _heli getVariable "fza_ah64_engFlyNg";

//Np variables
private _engStartNp = _heli getVariable "fza_ah64_engStartNp";
private _engIdleNp  = _heli getVariable "fza_ah64_engIdleNp";
private _engFlyNp   = _heli getVariable "fza_ah64_engFlyNp"; 

if (_engStartSwitchState == "START") then {
	_engState = "STARTING";
	[_heli, "fza_ah64_engStartSwitchState", _engNum, "OFF"] call fza_fnc_sfmplusSetArrayVariable;
};

switch (_engState) do {
	case "OFF": {
		_maxVal    = 0;
		_curVal    = _engPctNG;
		_timeToVal = 10;
		_valPerUnitTime = _curVal / _timeToVal;
	};
	case "STARTING": {
		if (_engPowerLeverState == "OFF") then {
			_maxVal    = _engStartNg;
			_curVal    = _engPctNG;
			_timeToVal = 8;
			_valPerUnitTime = _maxVal / _timeToVal;
		};
		if (_engPowerLeverState == "IDLE") then {
			_maxVal    = _engIdleNg;
			_curVal    = _engPctNG;
			_timeToVal = 24;
			_valPerUnitTime = _maxVal / _timeToVal;
		};
	};
	case "ON": {
		if (_engPowerLeverState == "OFF") then {
			_engState  = "OFF";
			_maxVal    = 0;
			_curVal    = _engPctNG;
			_timeToVal = 10;
			_valPerUnitTime = _curVal / _timeToVal;
		};
		if (_engPowerLeverState == "IDLE") then {
			_maxVal    = _engIdleNg;
			_curVal    = _engPctNG;
			_timeToVal = 24;
			_valPerUnitTime = _maxVal / _timeToVal;
		};
		if (_engPowerLeverState == "FLY") then {
			_maxVal    = _engFlyNg;
			_curVal    = _engPctNG;
			_timeToVal = 12;
			_valPerUnitTime = _maxVal / _timeToVal;
		};
	};
};

_engPctNG = [_maxVal, _curVal, _deltaTime, _valPerUnitTime] call fza_fnc_sfmplusClampedMove;

if (_engPctNG >= 0.52) then {
	_engState = "ON";
};

private _intEngBaseTable = [_heli getVariable "fza_ah64_engBaseTable", _engPctNG] call fza_fnc_linearInterp;
private _baseTGT = _intEngBaseTable select 1;
private _baseTQ  = _intEngBaseTable select 2;

private _curGWT_kg     = getMass _heli;
private _intHvrTQTable = [_heli getVariable "fza_ah64_engHvrTqTable", _curGWT_kg] call fza_fnc_linearInterp;
private _hvrIGE = _intHvrTQTable select 1;
private _hvrOGE = _intHvrTQTable select 2;

private _heightAGL = getPos _heli select 2;
private _hvrTQ     = linearConversion [1.52, 15.24, _heightAGL, _hvrIGE, _hvrOGE, true];

_hvrTQ = _hvrTQ - _baseTQ;
//----------------------Coll-----TQ---
private _engTQTable = [[ 0.0,  _baseTQ],
					   [ 0.7,   _hvrTQ],
					   [ 1.0,    1.34]];

_engPctTQ = [_engTQTable, fza_ah64_collectiveOutput] call fza_fnc_linearInterp select 1;
//-------------------------TQ----------TGT--
private _engTGTTable = [[ _baseTQ,	_baseTGT],
						[ 1.00, 		 810],	//Cont
					    [ 1.29, 	     867],	//10 min
						[ 1.34, 	     896]];	//2.5 Min

_engTGT = [_engTGTTable, _engPctTQ] call fza_fnc_linearInterp select 1;

[_heli, "fza_ah64_engState", _engNum, _engState] call fza_fnc_sfmplusSetArrayVariable;
[_heli, "fza_ah64_engPctNG", _engNum, _engPctNG] call fza_fnc_sfmplusSetArrayVariable;
[_heli, "fza_ah64_engPctTQ", _engNum, _engPctTQ] call fza_fnc_sfmplusSetArrayVariable;
[_heli, "fza_ah64_engTGT",   _engNum, _engTGT] call fza_fnc_sfmplusSetArrayVariable;