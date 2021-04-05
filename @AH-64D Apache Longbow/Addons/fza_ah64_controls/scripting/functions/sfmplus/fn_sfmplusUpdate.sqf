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

/***
PYLON WEIGHT AND MAGAZINE WEIGHT HERE
*/
/*
hintSilent format ["_armaFuelFrac = %1
					\nFwd Fuel = %2
					\nAft Fuel  = %3
					\nTot Fuel = %4
					\nHeli Mass = %5
					\nMax Fuel = %6
					\nCur FF = %7
					\nDelta Time = %8", _armaFuelFrac, _fwdFuelMass, _aftFuelMass, _totFuelMass, getMass _heli, _maxTotFuelMass, _curFuelFlow, _deltaTime];
*/
private _curMass = _emptyMass + _totFuelMass;

[_heli] call fza_fnc_sfmplusStabilator;

_heli setMass _curMass;