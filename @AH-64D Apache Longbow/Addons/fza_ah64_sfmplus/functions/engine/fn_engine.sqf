/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engine

Description:
	Provides a visually accurate simulation of a turbine engine based on table
	interpolation and collective input.

Parameters:
	_heli      - The helicopter to get information from [Unit].
	_engNum    - The engine to simulate
	_deltaTime - Passed delta time from core update.

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_deltaTime"];

private _engState            = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _isSingleEng         = _heli getVariable "fza_sfmplus_isSingleEng";
private _engPowerLeverState  = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _engPctNG            = _heli getVariable "fza_sfmplus_engPctNG" select _engNum;
private _engPctNP            = _heli getVariable "fza_sfmplus_engPctNP" select _engNum;
private _engPctTQ            = _heli getVariable "fza_sfmplus_engPctTQ" select _engNum;
private _engTGT              = _heli getVariable "fza_sfmplus_engTGT" select _engNum;
private _engOilPSI           = _heli getVariable "fza_sfmplus_engOilPSI" select _engNum; 
private _engFF               = _heli getVariable "fza_sfmplus_engFF" select _engNum;

private _engThrottle         = 0.0;
private _engSimTime 		 = 8.0;	//sec

//Torque - TQ
private _engIdleTQ  = 0.055;
private _engFlyTQ   = 0.18;
private _engMaxTQ   = 1.34;
private _engBaseTQ  = 0.0; private _engSetTQ = 0.0;
//Gas producer - Ng
private _engStartNG = 0.23;
private _engIdleNG  = 0.679;
private _engFlyNG   = 0.834;
private _engMaxNG   = 1.04;
private _engBaseNG  = 0.0; private _engSetNG = 0.0;
//Power turbine - Np
private _engStartNP  = 0.10;
private _engIdleNP   = 0.57;
private _engOnIdleNP = 0.94;
private _engFlyNP    = 1.01;
private _engBaseNP   = 0.0; private _engSetNP = 0.0;

//Throttle
if (_engPowerLeverState in ["OFF", "IDLE"]) then {
	_engThrottle = 0.0;
} else { _engThrottle = 1.0; };

//Tq
_engBaseTQ = _engIdleTQ + (_engFlyTQ - _engIdleTQ) * _engThrottle;
//Ng
_engBaseNG = _engIdleNG + (_engFlyNG - _engIdleNG) * _engThrottle;
//Np
_engBaseNP = _engIdleNP + (_engFlyNP - _engIdleNP) * _engThrottle; 

switch (_engState) do {
	case "OFF": {
		//Ng
		_engPctNG = [_engPctNG, 0.0, _deltaTime] call BIS_fnc_lerp;
		//Np
		_engPctNP = [_engPctNP, 0.0, _deltaTime] call BIS_fnc_lerp;
		//Tq
		_engPctTQ = [_engPctTQ, 0.0, _deltaTime] call BIS_fnc_lerp;
	};
	case "STARTING": {
		if (_engPowerLeverState == "OFF") then {
			//Ng
			_engPctNG = [_engPctNG, _engStartNG, (1.0 / (_engSimTime / 2.0)) * _deltaTime] call BIS_fnc_lerp;
			//Np
			_engPctNP = [_engPctNP, _engStartNP, (1.0 / _engSimTime) * _deltaTime] call BIS_fnc_lerp;
		} else {
			//Ng
			_engPctNG = [_engPctNG, _engBaseNG, (1.0 / _engSimTime) * _deltaTime] call BIS_fnc_lerp;
			//Np
			_engPctNP = [_engPctNP, _engBaseNP, (1.0 / _engSimTime) * _deltaTime] call BIS_fnc_lerp;
		};

		//Transition state to ON
		if (_engPctNG > 0.52) then {
			_engState = "ON";
			[_heli, "fza_sfmplus_engState", _engNum, "ON", true] call fza_sfmplus_fnc_setArrayVariable;
		};
	};
	case "ON": {
		if (_engPowerLeverState == "OFF") then {
			_engState = "OFF";
			[_heli, "fza_sfmplus_engState", _engNum, "ON", true] call fza_sfmplus_fnc_setArrayVariable;
		};
		//Ng
		_engSetNG = _engBaseNG + (_engMaxNG - _engBaseNG) * _engThrottle * fza_sfmplus_collectiveOutput;
		_engPctNG = [_engPctNG, _engSetNG, _deltaTime] call BIS_fnc_lerp;
		//Np
		_engPctNP = [_engPctNP, _engBaseNP, _deltaTime] call BIS_fnc_lerp;
	};
};

private _intEngBaseTable = [_heli getVariable "fza_sfmplus_engBaseTable", _engPctNG] call fza_fnc_linearInterp;
//Base TGT
private _engBaseTGT      = _intEngBaseTable select 1;
//Base Oil
private _engBaseOilPSI   = _intEngBaseTable select 4;
//Torque
private _curGWT_kg     = getMass _heli;
private _intHvrTQTable = [_heli getVariable "fza_sfmplus_hvrTqTable", _curGWT_kg] call fza_fnc_linearInterp;
private _hvrIGE        = _intHvrTQTable select 1;
private _hvrOGE        = _intHvrTQTable select 2;

private _heightAGL = getPos _heli select 2;
private _hvrTQ     = linearConversion [15.24, 1.52, _heightAGL, _hvrOGE, _hvrIGE, true];

private _engHvrTQTable = [[]];
//--------------------------Coll-----TQ---
if (fza_ah64_sfmPlusKeyboardOnly) then {
	_engHvrTQTable = [[ 0.00, _engBaseTQ],
					  [ 0.58,     _hvrTQ],
					  [ 0.68,     _hvrTQ],
					  [ 1.00,       1.34]];
} else {
	_engHvrTQTable = [[ 0.00, _engBaseTQ],
					  [ 0.645,     _hvrTQ],
					  [ 0.670,     _hvrTQ],
					  [ 1.00,       1.34]];
};

private _intCruiseTQTable = [_heli getVariable "fza_sfmplus_cruiseTable", _curGWT_kg] call fza_fnc_linearInterp;

private _engCruiseTQTable = [[]];
//-------------------------Coll-----TQ---
if (fza_ah64_sfmPlusKeyboardOnly) then {
	_engCruiseTQTable = [[ 0.00, 		               0.03],
					 	 [ 0.82, _intCruiseTQTable select 5],
					 	 [ 1.00, _intCruiseTQTable select 9]];
} else {
	_engCruiseTQTable = [[ 0.00, 		               0.03],
						 [ 0.67, _intCruiseTQTable select 4],
						 [ 0.70, _intCruiseTQTable select 5],
						 [ 0.89, _intCruiseTQTable select 7],
						 [ 1.00, _intCruiseTQTable select 9]];
};

private _curHvrTQ = [_engHvrTQTable,    fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;
private _cruiseTQ = [_engCruiseTQTable, fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;

private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
_engSetTQ      = linearConversion [0.00, 12.35, _V_mps, _curHvrTQ, _cruiseTQ, true];
if (_isSingleEng) then {
	_engPctTQ = [_engPctTQ, _engBaseTq * 2.0 + (_engSetTQ - _engBaseTQ) * 2.0 * _engThrottle, _deltaTime] call BIS_fnc_lerp;
} else {
	_engPctTQ = [_engPctTQ, _engBaseTq + (_engSetTQ - _engBaseTQ) * _engThrottle, _deltaTime] call BIS_fnc_lerp;
};

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

_engTGT    = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 1;
_engOilPSI = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 3;
_engFF     = [_engFFTable, _engPctTQ] call fza_fnc_linearInterp select 1;

//Update variables
[_heli, "fza_sfmplus_engPctNG",      _engNum, _engPctNG] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNP",      _engNum, _engPctNP] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",      _engNum, _engPctTQ] call fza_sfmplus_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engBaseTGT",    _engNum, _engBaseTGT] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseOilPSI", _engNum, _engBaseOilPSI] call fza_sfmplus_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engTGT",        _engNum, _engTGT] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engOilPSI",     _engNum, _engOilPSI] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engFF",         _engNum, _engFF] call fza_sfmplus_fnc_setArrayVariable;