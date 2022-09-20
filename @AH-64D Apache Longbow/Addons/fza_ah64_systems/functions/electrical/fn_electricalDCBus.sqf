/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricaACBus

Description:
	Updates all of the modules core functions.
	
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

private _rect1State  = _heli getVariable "fza_systems_rect1State";
private _rect2State  = _heli getVariable "fza_systems_rect2State";

private _DCBusState = _heli getVariable "fza_systems_DCBusState";
if (_rect1State == "ON" || _rect2State == "ON") then {
    _DCBusState = "ON";
} else {
    _DCBusState = "OFF";
};
_heli setVariable ["fza_systems_DCBusState", _DCBusState];
//DC Bus powers the following
//--(1) PSP/LPRF (FCR)
//--(3) Radar warning receiver
//--(3) CHAFF arm
//--(5) CPG primary lighting
//--(5) PLT primary lighting
//--(4) IHADSS DEU power
//--(4) IHADSS SEU power
//--(4) Radar altimeter power
//--(4) 30mm arm (power)
//--(6) Navigation lights/anti-collision
//--(6) Stabilator control