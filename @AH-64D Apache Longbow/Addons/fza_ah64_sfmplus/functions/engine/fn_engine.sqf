/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engine

Description:
    Provides a visually accurate simulation of a turbine engine based on table
    interpolation and collective input.

Parameters:
    _heli      - The helicopter to get information from [Unit].
    _engNum    - The engine to simulate

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _engState            = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _isSingleEng         = _heli getVariable "fza_sfmplus_isSingleEng";
private _isAutorotating      = _heli getVariable "fza_sfmplus_isAutorotating";
private _engOverspeed        = _heli getVariable "fza_ah64_engineOverspeed" select _engNum;
private _engPowerLeverState  = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _engPctNG            = _heli getVariable "fza_sfmplus_engPctNG" select _engNum;
private _engPctNP            = _heli getVariable "fza_sfmplus_engPctNP" select _engNum;
private _engPctTQ            = _heli getVariable "fza_sfmplus_engPctTQ" select _engNum;
private _engTGT              = _heli getVariable "fza_sfmplus_engTGT" select _engNum;
private _engOilPSI           = _heli getVariable "fza_sfmplus_engOilPSI" select _engNum; 
private _engFF               = _heli getVariable "fza_sfmplus_engFF" select _engNum;

private _engThrottle         = 0.0;
private _engSimTime          = getNumber (_sfmPlusConfig >> "engSimTime");

//Torque - TQ
private _engIdleTQ  = getNumber (_sfmPlusConfig >> "engIdleTQ");
private _engFlyTQ   = getNumber (_sfmPlusConfig >> "engFlyTQ");
private _engBaseTQ  = 0.0; 
private _engSetTQ   = 0.0;
private _engLimitTQ = 0.0;

private _hvrIGE      = _heli getVariable "fza_sfmplus_hvrTQ_IGE";
private _hvrOGE      = _heli getVariable "fza_sfmplus_hvrTQ_OGE";
private _maxTQ_CONT  = _heli getVariable "fza_sfmplus_maxTQ_CONT";
private _maxTQ_DE    = _heli getVariable "fza_sfmplus_maxTQ_DE";
private _maxTQ_SE    = _heli getVariable "fza_sfmplus_maxTQ_SE";
private _maxTQ       = getNumber (_sfmPlusConfig >> "engMaxTQ");
private _ovrspdTQ    = getNumber (_sfmPlusConfig >> "engOvrspdTQ");
//Gas producer - Ng
private _engStartNG  = getNumber (_sfmPlusConfig >> "engStartNG");
private _engIdleNG   = getNumber (_sfmPlusConfig >> "engIdleNG");
private _engFlyNG    = getNumber (_sfmPlusConfig >> "engFlyNG");
private _engMaxNG    = getNumber (_sfmPlusConfig >> "engMaxNG");
private _engBaseNG   = 0.0; 
private _engSetNG    = 0.0;
//Power turbine - Np
private _engStartNP  = getNumber (_sfmPlusConfig >> "engStartNP");
private _engIdleNP   = getNumber (_sfmPlusConfig >> "engIdleNP");
private _engFlyNP    = getNumber (_sfmPlusConfig >> "engFlyNP");
private _engOvrspdNP = getNumber (_sfmPlusConfig >> "engOvrspdNP");
private _engBaseNP   = 0.0; 
private _engSetNP    = 0.0;

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
        if (!_isAutorotating) then { 
		    _engPctNP = [_engPctNP, 0.0, _deltaTime] call BIS_fnc_lerp;
        } else {
            _engPctNP    = 1.01;
        };
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
			//[_heli, "fza_sfmplus_engState", _engNum, "OFF", true] call fza_fnc_setArrayVariable;
		} else {
			//Ng
			_engPctNG = [_engPctNG, _engBaseNG, (1.0 / _engSimTime) * _deltaTime] call BIS_fnc_lerp;
			//Np
			_engPctNP = [_engPctNP, _engBaseNP, (1.0 / _engSimTime) * _deltaTime] call BIS_fnc_lerp;
		};

		//Transition state to ON
		if (_engPctNG > 0.52) then {
			_engState = "ON";
			[_heli, "fza_sfmplus_engState", _engNum, "ON", true] call fza_fnc_setArrayVariable;
		};
	};
	case "ON": {
		if (_engPowerLeverState == "OFF") then {
			_engState = "OFF";
			[_heli, "fza_sfmplus_engState", _engNum, "ON", true] call fza_fnc_setArrayVariable;
		};
		//Ng
		_engSetNG = _engBaseNG + (_engMaxNG - _engBaseNG) * _engThrottle * (_heli getVariable "fza_sfmplus_collectiveOutput");
		_engPctNG = [_engPctNG, _engSetNG, _deltaTime] call BIS_fnc_lerp;
		//Np
        if (_isSingleEng) then {
            _engLimitTQ = _maxTQ_SE;
        } else {
            _engLimitTQ = _maxTQ_DE;
        };
        //If the engine isn't overspeed, do normal engine things
        if (!_engOverspeed) then {
            private _droopFactor = 1 - (_engPctTQ / _engLimitTQ);
            _droopFactor    = [_droopFactor, -1.0, 0.0] call BIS_fnc_clamp;
            //Autorotation handler
            if (!_isAutorotating) then { 
                _engPctNP   = [_engPctNP, _engBaseNP + _droopFactor, _deltaTime] call BIS_fnc_lerp;
            } else {
                _engPctNP   = 1.01;
            };
        } else {
            //If the engine is overspeeding, then do over speed things
            _engPctNP   = [_engPctNP, _engOvrspdNP, (1 / 6) * _deltaTime] call BIS_fnc_lerp;
        };
	};
};

private _intEngBaseTable = [getArray (_sfmPlusConfig >> "engBaseTable"), _engPctNG] call fza_fnc_linearInterp;
//Base TGT
private _engBaseTGT      = _intEngBaseTable select 1;
//Base Oil
private _engBaseOilPSI   = _intEngBaseTable select 4;
//Torque
private _heightAGL  = ASLToAGL getPosASL _heli # 2;
private _hvrTQ      = linearConversion [15.24, 1.52, _heightAGL, _hvrOGE, _hvrIGE, true];

//If the engine isn't overspeed, do normal engine things
if (!_engOverspeed) then {
    _engPctTQ = (_heli getVariable "fza_sfmplus_reqEngTorque") / 481.0;
    if (_isSingleEng) then {
        if (_engPowerLeverState in ["OFF", "IDLE"]) then {
            _engPctTQ = 0.0;
        } else {
            _engPctTQ = _engPctTQ;
        };
    } else {
        _engPctTQ = _engPctTQ / 2.0;
    };
} else {
    //If the engine is overspeeding, then do over speed things
    _engPctTQ = [_engPctTQ, _ovrspdTQ, (1 / 6) * _deltaTime] call BIS_fnc_lerp;
};
_engPctTQ = [_engPctTQ, 0.0, 2.55] call BIS_fnc_clamp;

private _engTable = [[  _engBaseTQ, _engBaseTGT, _engBaseNG, _engBaseOilPSI],
                     [ _maxTQ_CONT,         810,      0.950,           0.91],   //30 min
                     [   _maxTQ_DE,         867,      0.990,           0.94],   //10 min
                     [   _maxTQ_SE,         896,      0.997,           0.99]];  //2.5 Min

_engTGT    = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 1;
if (_isSingleEng) then {
    if (_engTGT > 896) then { _engTGT = 896; };
} else {
    if (_engTGT > 867) then { _engTGT = 867; };
};

_engOilPSI = [_engTable,   _engPctTQ] call fza_fnc_linearInterp select 3;
_engFF     = [getArray (_sfmPlusConfig >> "engFFTable"), _engPctTQ] call fza_fnc_linearInterp select 1;

if (_engPctNP >= 1.196) then {
    _engState     = "OFF";

    [_heli, "fza_sfmplus_engState",     _engNum, _engState,     true] call fza_fnc_setArrayVariable;
};

//Update variables
[_heli, "fza_sfmplus_engPctNG",      _engNum, _engPctNG] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNP",      _engNum, _engPctNP] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",      _engNum, _engPctTQ] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engBaseTGT",    _engNum, _engBaseTGT] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseOilPSI", _engNum, _engBaseOilPSI] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engTGT",        _engNum, _engTGT] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engOilPSI",     _engNum, _engOilPSI] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engFF",         _engNum, _engFF] call fza_fnc_setArrayVariable;