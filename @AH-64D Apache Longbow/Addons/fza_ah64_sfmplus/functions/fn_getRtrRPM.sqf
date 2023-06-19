/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getRtrRPM

Description:
    Returns the rotor RPM depending on the simulation being used

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    Rotor rpm

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel    = getText (_configVehicles >> "fza_flightModel");

private _rtrRPM = 0.0;
if (_flightModel == "SFMPlus") then {
    _rtrRPM = ((_heli animationPhase "mainRotorRPM") * 1.08) / 10;
} else {
    (_heli getVariable "fza_sfmplus_engPctNP") 
        params ["_e1Np", "_e2Np"];
    _rtrRPM = _e1Np max _e2Np;
};

_rtrRPM;