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
private _collLow  = inputAction "HeliCollectiveLowerCont";
private _collHigh = inputAction "HeliCollectiveRaiseCont";
private _collVal  = _collHigh - _collLow;
private _collOut  = linearConversion [-1, 1, _collVal, 0, 1];
//Keyboard Input
private _collKeyLow  = inputAction "HeliCollectiveLower";
private _collKeyHigh = inputAction "HeliCollectiveRaise";

private _curAlt = getPos _heli select 2;

if (_curAlt <= 0.6 && _collLow == 0 && _collHigh == 0) then {	//~2 feet
	_collOut = 0.0;
} else {
	if (_collLow == 0 && _collHigh == 0) then {
		private _collOutKey = (_collKeyHigh * 0.05) - (_collKeyLow * 0.2);
		_collOut = 0.7 + _collOutKey;
	};
};
version = 2;
fza_ah64_collectiveOutput = _collOut

