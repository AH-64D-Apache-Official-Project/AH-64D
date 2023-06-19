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

private _cfg         = configOf _heli;
private _flightModel = getText (_cfg >> "fza_flightModel");

private _rtrRPM = 0.0;
if (_flightModel == "SFMPlus") then {
    (_heli getVariable "fza_sfmplus_engPctNP")
        params ["_e1Np", "_e2Np"];
    _rtrRPM = ((_heli animationPhase "mainRotorRPM") * 1.08) / 10;
    _rtrRPM = [_rtrRPM, 0.0, _e1Np max _e2Np] call BIS_fnc_clamp;
} else {
    //(_heli getVariable "fza_sfmplus_engPctNP")
    //    params ["_e1Np", "_e2Np"];
    _rtrRPM = _heli getVariable "fza_sfmplus_xmsnOutputRPM_pct";//_e1Np max _e2Np;
};

_rtrRPM;