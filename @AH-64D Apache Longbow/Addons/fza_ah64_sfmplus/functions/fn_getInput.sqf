/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusConfig

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

//HOTAS Input
//Cyclic
private _cyclicLeft     = inputAction "HeliCyclicLeft";
private _cyclicRight    = inputAction "HeliCyclicRight";
private _cyclicForward  = inputAction "HeliCyclicForward";
private _cyclicBackward = inputAction "HeliCyclicBack";

//Collective
private _collectiveLow  = inputAction "HeliCollectiveLowerCont";
private _collectiveHigh = inputAction "HeliCollectiveRaiseCont";
private _collectiveVal  = _collectiveHigh - _collectiveLow;
private _collectiveOut  = linearConversion [-1, 1, _collectiveVal, 0, 1];

//Keyboard Input
private _collKeyLow  = inputAction "HeliCollectiveLower";
private _collKeyHigh = inputAction "HeliCollectiveRaise";

private _curAlt = getPos _heli select 2;

if (_curAlt <= 0.6 && _collectiveLow == 0 && _collectiveHigh == 0) then {	//~2 feet
	_collectiveOut = 0.0;
} else {
	if (_collectiveLow == 0 && _collectiveHigh == 0) then {
		private _collectiveOutKey = (_collKeyHigh * 0.05) - (_collKeyLow * 0.2);
		_collectiveOut = 0.7 + _collectiveOutKey;
	};
};

//Global variable for use by other scripts, returns -1 to 1
fza_ah64_cyclicRollOut    = _cyclicRight - _cyclicLeft;
fza_ah64_cyclicPitchOut   = _cyclicForward - _cyclicBackward;
fza_ah64_collectiveOutput = _collectiveOut

