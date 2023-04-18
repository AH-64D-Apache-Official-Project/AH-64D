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

private _config         = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel    = getText (_configVehicles >> "flightModel");

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
private _engSimTime 		 = getNumber (_config >> "engSimTime");

//Torque - TQ
private _engIdleTQ  = getNumber (_config >> "engIdleTQ");
private _engFlyTQ   = getNumber (_config >> "engFlyTQ");
private _engBaseTQ  = 0.0; 
private _engSetTQ   = 0.0;
private _engLimitTQ = 0.0;

private _hvrIGE     = _heli getVariable "fza_sfmplus_hvrTQ_IGE";
private _hvrOGE     = _heli getVariable "fza_sfmplus_hvrTQ_OGE";
private _maxTQ_CONT = _heli getVariable "fza_sfmplus_maxTQ_CONT";
private _maxTQ_DE   = _heli getVariable "fza_sfmplus_maxTQ_DE";
private _maxTQ_SE   = _heli getVariable "fza_sfmplus_maxTQ_SE";
private _maxTQ      = getNumber (_config >> "engMaxTQ");
//Gas producer - Ng
private _engStartNG = getNumber (_config >> "engStartNG");
private _engIdleNG  = getNumber (_config >> "engIdleNG");
private _engFlyNG   = getNumber (_config >> "engFlyNG");
private _engMaxNG   = getNumber (_config >> "engMaxNG");
private _engBaseNG  = 0.0; 
private _engSetNG   = 0.0;
//Power turbine - Np
private _engStartNP = getNumber (_config >> "engStartNP");
private _engIdleNP  = getNumber (_config >> "engIdleNP");
private _engFlyNP   = getNumber (_config >> "engFlyNP");
private _engBaseNP  = 0.0; 
private _engSetNP   = 0.0;

//Throttle
if (_engPowerLeverState in ["OFF", "IDLE"]) then {
	_engThrottle = 0.0;
} else { _engThrottle = 1.0; };

//Tq
if (_engPowerLeverState != "OFF") then {
	_engBaseTQ = _engIdleTQ + (_engFlyTQ - _engIdleTQ) * _engThrottle;
} else {
	_engBaseTQ = 0.0;
};
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
			//Set the engine state
			//[_heli, "fza_sfmplus_engState", _engNum, "OFF", true] call fza_sfmplus_fnc_setArrayVariable;
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
		if (_flightModel == "SFMPlus") then {
			_engPctNP = [_engPctNP, _engBaseNP, _deltaTime] call BIS_fnc_lerp;
		} else {
			if (_isSingleEng) then {
				_engLimitTQ = _maxTQ_SE;
			} else {
				_engLimitTQ = _maxTQ_DE;
			};
			
			private _droopFactor = 1 - (_engPctTQ / _engLimitTQ);
			_droopFactor = [_droopFactor, -1.0, 0.0] call BIS_fnc_clamp;

			_engPctNP    = [_engPctNP, _engBaseNP + _droopFactor, _deltaTime] call BIS_fnc_lerp;
			systemChat format ["Eng Pct Np = %1", _engPctNP];
		};
	};
};

private _intEngBaseTable = [getArray (_config >> "engBaseTable"), _engPctNG] call fza_fnc_linearInterp;
//Base TGT
private _engBaseTGT      = _intEngBaseTable select 1;
//Base Oil
private _engBaseOilPSI   = _intEngBaseTable select 4;
//Torque
private _heightAGL  = ASLToAGL getPosASL _heli # 2;
private _hvrTQ      = linearConversion [15.24, 1.52, _heightAGL, _hvrOGE, _hvrIGE, true];

if (_flightModel == "SFMPlus") then {
	private _engHvrTQTable = [[]];
	//----------------------Coll-----TQ---
	if (fza_ah64_sfmPlusKeyboardOnly) then {
		_engHvrTQTable = [[ 0.00, _engBaseTQ]
						 ,[ 0.58,     _hvrTQ]
						 ,[ 0.68,     _hvrTQ]
						 ,[ 1.00,     _maxTQ]];
	} else {
		_engHvrTQTable = [[ 0.00, _engBaseTQ]
						 ,[ 0.645,    _hvrTQ]
						 ,[ 0.670,    _hvrTQ]
						 ,[ 1.00,     _maxTQ]];
	};
	private _cruiseTable = _heli getVariable "fza_sfmplus_cruiseTable";

	private _engCruiseTQTable = [[]];
	//-------------------------Coll-----TQ---
	if (fza_ah64_sfmPlusKeyboardOnly) then {
		_engCruiseTQTable = [[ 0.00, 		          0.03],
							[ 0.82, _cruiseTable select 4],
							[ 0.90, _cruiseTable select 6],
							[ 1.00, _maxTQ               ]];
	} else {
		_engCruiseTQTable = [[ 0.00, 		          0.03],
							[ 0.70, _cruiseTable select 4],  //
							[ 0.89, _cruiseTable select 6],  //
							[ 1.00, _maxTQ               ]];
	};

	private _curHvrTQ = [_engHvrTQTable,    fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;
	private _cruiseTQ = [_engCruiseTQTable, fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp select 1;

	private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
	_engSetTQ      = linearConversion [0.00, 12.35, _V_mps, _curHvrTQ, _cruiseTQ, true];
	if (_isSingleEng) then {
		_engPctTQ = [_engPctTQ, (_engBaseTq * 2.0) + ((_engSetTQ - _engBaseTQ) * 2.0) * _engThrottle, _deltaTime] call BIS_fnc_lerp;
	} else {
		_engPctTQ = [_engPctTQ, _engBaseTq + (_engSetTQ - _engBaseTQ) * _engThrottle, _deltaTime] call BIS_fnc_lerp;
	};
} else {
	//HeliSim engine handling
	_engPctTQ = (_heli getVariable "fza_sfmplus_reqEngTorque") / 481.0;
	if (_isSingleEng) then {
			_engPctTQ = _engPctTQ;
	} else {
		_engPctTQ = _engPctTQ / 2.0;
	};
};

private _engTable = [[  _engBaseTQ, _engBaseTGT, _engBaseNG, _engBaseOilPSI],
					 [ _maxTQ_CONT,         810,      0.950,           0.91],	//30 min
					 [   _maxTQ_DE,         867,	  0.990,           0.94],	//10 min
					 [   _maxTQ_SE,         896,	  0.997,           0.99]];	//2.5 Min

_engTGT    = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 1;
if (_isSingleEng) then {
	if (_engTGT > 896) then { _engTGT = 896; };
} else {
	if (_engTGT > 867) then { _engTGT = 867; };
};

_engOilPSI = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 3;
_engFF     = [getArray (_config >> "engFFTable"), _engPctTQ] call fza_fnc_linearInterp select 1;

//Update variables
[_heli, "fza_sfmplus_engPctNG",      _engNum, _engPctNG] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNP",      _engNum, _engPctNP] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",      _engNum, _engPctTQ] call fza_sfmplus_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engBaseTGT",    _engNum, _engBaseTGT] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseOilPSI", _engNum, _engBaseOilPSI] call fza_sfmplus_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engTGT",        _engNum, _engTGT] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engOilPSI",     _engNum, _engOilPSI] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engFF",         _engNum, _engFF] call fza_sfmplus_fnc_setArrayVariable;