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

private _collLow   = inputAction "HeliCollectiveLowerCont";
private _collHigh  = inputAction "HeliCollectiveRaiseCont";
private _collVal   = _collHigh - _collLow;
private _collOut   = linearConversion [-1, 1, _collVal, 0, 1];

_heli setVariable ["fza_ah64d_collectiveOutput", _collOut];

