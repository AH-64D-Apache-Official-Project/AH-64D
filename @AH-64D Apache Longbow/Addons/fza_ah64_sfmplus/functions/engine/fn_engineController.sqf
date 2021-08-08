/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusUpdate

Description:
	
Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _engState  = _heli getVariable "fza_sfmplus_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

if (_eng1State == "STARTING" || _eng2State == "STARTING") then {
	_heli setVariable ["fza_ah64_estarted", true, true];
	_heli engineOn true;
};

private _isSingleEng     = _heli getVariable "fza_sfmplus_isSingleEng";
private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _eng1TqMult = 1;
private _eng2TqMult = 1;

if ((_eng1State == "ON" && _eng1PwrLvrState in "IDLE") && (_eng2State == "ON" && _eng2PwrLvrState == "IDLE")) then {
	_isSingleEng = false;
} else {
	if (_eng1State == "ON" && _eng2PwrLvrState == "IDLE") then {
		_eng1TqMult = 2;
		_eng2TqMult = 0;
		_isSingleEng = true;
	};

	if (_eng2State == "ON" && _eng1PwrLvrState == "IDLE") then {
		_eng1TqMult = 0;
		_eng2TqMult = 2;
		_isSingleEng = true;
	};
};

if ((_eng1State == "ON" && _eng2State == "ON") && (_eng1PwrLvrState == "FLY" && _eng2PwrLvrState == "FLY")) then {
	_isSingleEng = false;
};

_heli setVariable ["fza_sfmplus_isSingleEng", _isSingleEng];

[_heli, 0, _deltaTime, _eng1TqMult] call fza_sfmplus_fnc_engine;
[_heli, 1, _deltaTime, _eng2TqMult] call fza_sfmplus_fnc_engine;

if (_eng1State == "OFF" && _eng2State == "OFF") then {
	_heli setVariable ["fza_ah64_estarted", false, true];
	_heli engineOn false;
};