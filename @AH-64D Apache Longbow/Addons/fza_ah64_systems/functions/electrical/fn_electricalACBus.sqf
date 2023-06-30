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

if !(Local _heli) exitwith {};

private _gen1On  = _heli getVariable "fza_systems_gen1On";
private _gen2On  = _heli getVariable "fza_systems_gen2On";

private _acBusOn = _heli getVariable "fza_systems_acBusOn";
if (_gen1On || _gen2On) then {
    _acBusOn = true;
} else {
    _acBusOn = false;
};
[_heli, "fza_systems_acBusOn", _acBusOn] call fza_fnc_updateNetworkGlobal;
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