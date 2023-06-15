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

private _rect1On  = _heli getVariable "fza_systems_rect1On";
private _rect2On  = _heli getVariable "fza_systems_rect2On";

private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";
if (_rect1On || _rect2On) then {
    _dcBusOn = true;
} else {
    _dcBusOn = false;
};
_heli setVariable ["fza_systems_dcBusOn", _dcBusOn, true];
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