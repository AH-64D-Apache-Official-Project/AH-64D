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

private _flightModel    = getText (configOf _heli >> "fza_flightModel");

private _rtrRPM = 0.0;
if (_flightModel == "SFMPlus") then {
    _rtrRPM = ((_heli animationPhase "mainRotorRPM") * 1.08) / 10;
} else {
    private _mainRtrDamage  = _heli getHitPointDamage "HitHRotor";
    if (_mainRtrDamage == 1.0) then {
        _rtrRPM = 0.0;
    } else {
        (_heli getVariable "fza_sfmplus_engPctNP") 
        params ["_e1Np", "_e2Np"];
        _rtrRPM = _e1Np max _e2Np;
    };
};

_rtrRPM;