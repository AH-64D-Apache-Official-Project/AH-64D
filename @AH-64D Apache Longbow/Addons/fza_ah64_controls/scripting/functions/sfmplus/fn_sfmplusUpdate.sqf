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
params ["_heli"];

private _deltaTime = ["fza_ah64d_deltaTime"] call BIS_fnc_deltaTime;

[_heli] call fza_fnc_sfmplusGetInput;

private _emptyMass      = _heli getVariable "fza_ah64d_emptyMass";
private _maxTotFuelMass = _heli getVariable "fza_ah64d_maxTotFuelMass";

private _fwdFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 0;
private _aftFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 1;

private _eng1State = ((_heli getVariable "fza_ah64_engineStates") select 0) select 0;
private _eng2State = ((_heli getVariable "fza_ah64_engineStates") select 0) select 0;

private _curFuelFlow = 0;
if (_eng1State != "OFF" && _eng1State != "OFF") then {
	_curFuelFlow = [_heli] call fza_fnc_sfmplusGetData select 2;
} else {
	if (_eng1State != "OFF" || _eng2State != "OFF") then {
		_curFuelFlow = ([_heli] call fza_fnc_sfmplusGetData select 2) / 2;
	} else {
		_curFuelFlow = 0;
	};
};
_curFuelFlow = _curFuelFlow * _deltaTime;

private _totFuelMass  = _fwdFuelMass + _aftFuelMass;
_totFuelMass = _totFuelMass - _curFuelFlow;
private _armaFuelFrac = _totFuelMass / _maxTotFuelMass;

_heli setFuel _armaFuelFrac;

private _pylonMass = 0;
{
	_x params ["_magName","", "_magAmmo"];
	private _magConfig    = configFile >> "cfgMagazines" >> _magName;
	private _magMaxWeight = getNumber (_magConfig >> "weight");
	private _magMaxAmmo   = getNumber (_magConfig >> "count");
	_pylonMass = _pylonMass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
} foreach magazinesAllTurrets _heli;

private _curMass = _emptyMass + _totFuelMass + _pylonMass;
_heli setMass _curMass;

[_heli, _deltaTime] call fza_fnc_sfmplusStabilator;