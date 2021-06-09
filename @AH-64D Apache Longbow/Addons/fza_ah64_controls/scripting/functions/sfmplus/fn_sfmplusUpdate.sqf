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

private _deltaTime = ["sfmplusUpdate_deltaTime"] call BIS_fnc_deltaTime;

[_heli] call fza_fnc_sfmplusGetInput;

private _emptyMass      = _heli getVariable "fza_ah64_emptyMass";
private _maxTotFuelMass = _heli getVariable "fza_ah64_maxTotFuelMass";

private _fwdFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 0;
private _aftFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 1;

private _eng1State = ((_heli getVariable "fza_ah64_engineStates") select 0) select 0;
private _eng2State = ((_heli getVariable "fza_ah64_engineStates") select 1) select 0;

//NEW ENGINE 
[_heli, 0, _deltaTime] call fza_fnc_sfmplusEngine;
[_heli, 1, _deltaTime] call fza_fnc_sfmplusEngine;

hintsilent format ["Engine 1 Ng = %1
					\nEngine 1 TQ = %2
					\nEngine 1 TGT = %3
					\n------------------
					\nEngine 2 Ng = %4
					\nEngine 2 TQ = %5
					\nEngine 2 TGT = %6", _heli getVariable "fza_ah64_engPctNG" select 0, 
										  _heli getVariable "fza_ah64_engPctTQ" select 0, 
										  _heli getVariable "fza_ah64_engTGT" select 0,
										  _heli getVariable "fza_ah64_engPctNG" select 1, 
										  _heli getVariable "fza_ah64_engPctTQ" select 1, 
										  _heli getVariable "fza_ah64_engTGT" select 1];
//NEW ENGINE

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

if(fza_ah64_sfmPlusStabilatorEnabled) then {
	[_heli, _deltaTime] call fza_fnc_sfmplusStabilator;
};