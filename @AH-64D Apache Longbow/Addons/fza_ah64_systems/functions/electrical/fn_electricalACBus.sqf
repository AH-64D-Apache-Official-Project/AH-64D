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

private _gen1State  = _heli getVariable "fza_systems_gen1State";
private _gen2State  = _heli getVariable "fza_systems_gen2State";

private _ACBusState = _heli getVariable "fza_systems_ACBusState";
if (_gen1State == "ON" || _gen2State == "ON") then {
    _ACBusState = "ON";
} else {
    _ACBusState = "OFF";
};
_heli setVariable ["fza_systems_ACBusState", _ACBusState];
//AC Bus powers the following
//--(1) FCR
//--(5) 30mm motor
//--(5) Anti-collision/formation lights
//--(5) Laser electronics unit
//--(5) PLT left hand MPD
//--(5) IHADSS SEU
//--(5) CPG right hand MPD
//--(5) TADS power supply
//--(6) IHADSS DEU
//--(6) ORT
//--(6) CPG left hand MPD
//--(6) PLT right hand MPD
//--(6) Battery charger