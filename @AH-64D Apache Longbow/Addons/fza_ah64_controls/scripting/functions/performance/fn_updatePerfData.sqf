/* ----------------------------------------------------------------------------
Function: fza_fnc_setMass

Description:
	Sets the initial mass of the helicopter.

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli] call fza_fnc_perfConfig;
[_heli] call fza_fnc_setMass;

private _deltaTime = ["deltaTime"] call BIS_fnc_deltaTime;

//Torque
private _GWT_kg = _heli getVariable "fza_ah64d_rampMass";

//Only issue here is TQ doesn't update with reduction in GWT...current GWT needs
//to be passed into getTorque to ensure accurate numbers...would it be better to
//just pass the _heli into getTorque and then use getMass in getTorque itself?
private _TQ = [_heli, _GWT_kg] call fza_fnc_getTorque;
private _FF = [_heli, _TQ] call fza_fnc_getFuelFlow;
_FF = _FF;

//This obviously causes the fuel to constantly be reset...not optimal
private _fwdFuelMass    = _heli getVariable "fza_ah64d_initFwdFuelMass";
private _curFwdFuelMass = _fwdFuelMass;
_curFwdFuelMass = _curFwdFuelMass - _FF;

//This obviously causes the fuel to constantly be reset...not optimal
private _aftFuelMass    = _heli getVariable "fza_ah64d_initAftFuelMass";
private _curAftFuelMass = _aftFuelMass;
_curAftFuelMass = _curAftFuelMass - _FF;

private _curMass = _GWT_kg + _curFwdFuelMass + _curAftFuelMass;

hintSilent format ["Torque = %1
					\nFuel Flow = %2 pph
					\nFwd Fuel = %3
					\nAft Fuel = %4", _TQ, (_FF * 2.204 * 3600), _curFwdFuelMass, _curAftFuelMass];

_heli setMass _curMass;

[_TQ, _FF, _curFwdFuelMass, _curAftFuelMass];


/***
[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		vehicle player call fza_fnc_perfConfig;
		vehicle player call fza_fnc_setMass;

		_GWT_kg = vehicle player getVariable "fza_ah64d_rampMass";

		_TQ = [vehicle player, _GWT_kg] call fza_fnc_getTorque;
		
		hintSilent format ["Torque = %1", _TQ];
		sleep 0.03;
	}
};






vehicle player call fza_fnc_perfConfig;

_emptyMass = 0;

if (typeOf vehicle player == "fza_ah64d_b2e") then { 
	_emptyMass = vehicle player getVariable "fza_ah64d_emptyMassFCR";
} else { 
	_emptyMass = vehicle player getVariable "fza_ah64d_emptyMassNonFCR";
};

_fuelMass = [vehicle player] call fza_fnc_setFuel;
_fwdFuelMass = _fuelMass select 0;
_aftFuelMass = _fuelMass select 1;

_rampMass = _emptyMass + _fwdFuelMass + _aftFuelMass;

vehicle player setMass _rampMass;

hintSilent format ["Empty Mass = %1", _rampMass];

***/