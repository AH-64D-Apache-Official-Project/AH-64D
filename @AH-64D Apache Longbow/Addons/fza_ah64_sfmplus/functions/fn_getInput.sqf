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
params ["_heli"];

//private _collectiveVal = -1.0; private _collectiveOut  = 0.0;
/*
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
};*/

private _collectiveVal = _heli animationSourcePhase "collective";

private _collectiveOut = 0.0;
if (fza_ah64_sfmPlusKeyboardOnly) then {
	_collectiveOut = linearConversion[ 0.5, 1.0, _collectiveVal, 0.0, 2.0];

	private _V_mps            = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
	private _collectiveOutMod = linearConversion [0.00, 12.35, _V_mps, 0.780, 0.940, true];

	_collectiveOut = [_collectiveOut, 0.0, _collectiveOutMod] call BIS_fnc_clamp;
} else {
	_collectiveOut = linearConversion[-1.0, 1.0, _collectiveVal, 0.0, 1.0];
};

systemChat format ["collectivVal %1
					\ncollectiveOut %2", _collectiveVal, _collectiveOut];

//Global variable for use by other scripts, returns -1 to 1
fza_sfmplus_collectiveOutput = _collectiveOut

