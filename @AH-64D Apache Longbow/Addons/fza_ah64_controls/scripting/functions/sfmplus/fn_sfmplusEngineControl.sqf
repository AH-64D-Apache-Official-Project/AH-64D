/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusEngineControl

Description:

Parameters:

Returns:


Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

[_heli, 0, _deltaTime] call fza_fnc_sfmplusEngine;
[_heli, 1, _deltaTime] call fza_fnc_sfmplusEngine;

private _engState  = _heli getVariable "fza_ah64_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

private _engPwrLvrState  = _heli getVariable "fza_ah64_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _isSingleEng = _heli getVariable "fza_ah64_isSingleEng";
private _engTqMult   = _heli getVariable "fza_ah64_engTqMult";

//Is eng1 off and eng2 on? Is engine1 on and eng 2 off? Is eng1 destroyed? is engine 2 destroyed?
if ((_eng1State == "OFF" && _eng2State == "ON") || (_eng1State == "ON" && _eng2State == "OFF") || _eng1State == "DEST" || _eng2State == "DEST") then {
	_isSingleEng = true;
} else {
	_isSingleEng = false;
};

//Eng 1 is on and it's associated power lever is at idle, meanwhile the opposite engine power lever is at fly
if (_eng1State == "ON" && _eng1PwrLvrState == "IDLE" && _eng2PwrLvrState == "FLY") then {
	_isSingleEng = true;
} else {
	_isSingleEng = false;
};

//Eng 2 is on and it's associated power lever is at idle, meanwhile the opposite engine power lever is at fly
if (_eng2State == "ON" && _eng1PwrLvrState == "FLY" && _eng2PwrLvrState == "IDLE") then {
	_isSingleEng = true;
} else {
	_isSingleEng = false;
};

if (_isSingleEng == true) then {
	_engTqMult = 2;
} else {
	_engTqMult = 1;
};



_heli setVariable ["fza_ah64_isSingleEng", _isSingleEng];
_heli setVariable ["fza_ah64_engTqMult", _engTqMult];