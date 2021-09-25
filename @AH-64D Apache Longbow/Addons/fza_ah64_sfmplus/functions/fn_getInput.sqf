/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getInput

Description:
	Handles keyboard and HOTAS input for the simulation.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _cyclicLeft    = 0.0; private _cyclicRight    = 0.0;
private _cyclicForward = 0.0; private _cyclicBackward = 0.0;
private _collectiveLow = 0.0; private _collectiveHigh = 0.0;
private _collectiveVal = 0.0; private _collectiveOut  = 0.0;

if (fza_ah64_sfmPlusKeyboardOnly) then {
	//Keyboard Input
	_collectiveLow  = inputAction "HeliCollectiveLower";
	_collectiveHigh = inputAction "HeliCollectiveRaise";

		private _curAlt = getPos _heli select 2;

		if (_curAlt <= 0.6 && _collectiveLow == 0 && _collectiveHigh == 0) then {	//~2 feet
			_collectiveOut = 0.0;
		} else {
			_collectiveVal = (_collectiveHigh * 0.05) - (_collectiveLow * 0.2);
			_collectiveOut = 0.7 + _collectiveVal;
		};
	/*
	_collectiveLow  = inputAction "HeliCollectiveLower";
	_collectiveHigh = inputAction "HeliCollectiveRaise";

	private _keyCollOut = _heli getVariable "fza_sfmplus_keyCollOut";

	if (_collectiveHigh == 1) then {
		_keyCollOut = _keyCollOut + (_collectiveHigh * _deltaTime);
	};

	if (_collectiveLow == 1) then {
		_keyCollOut = _keyCollOut - (_collectiveLow * _deltaTime);
	};

	systemchat format ["Coll Low = %1", _collectiveLow];
	systemchat format ["Coll High = %1", _collectiveHigh];

	_keyCollOut = [_keyCollOut, 0, 1] call BIS_fnc_clamp;
	_keyCollOut = [_keyCollOut, 1] call BIS_fnc_cutDecimals;

	_heli setVariable ["fza_sfmplus_keyCollOut", _keyCollOut];
	_collectiveOut = _keyCollOut;*/
} else {
	//HOTAS Input
	//Cyclic
	_cyclicLeft     = inputAction "HeliCyclicLeft";
	_cyclicRight    = inputAction "HeliCyclicRight";
	_cyclicForward  = inputAction "HeliCyclicForward";
	_cyclicBackward = inputAction "HeliCyclicBack";

	//Collective
	_collectiveLow  = inputAction "HeliCollectiveLowerCont";
	_collectiveHigh = inputAction "HeliCollectiveRaiseCont";
	_collectiveVal  = _collectiveHigh - _collectiveLow;
	_collectiveOut  = linearConversion [-1, 1, _collectiveVal, 0, 1];
};

//Global variable for use by other scripts, returns -1 to 1
fza_sfmplus_cyclicRollOut    = _cyclicRight - _cyclicLeft;
fza_sfmplus_cyclicPitchOut   = _cyclicForward - _cyclicBackward;
fza_sfmplus_collectiveOutput = _collectiveOut

