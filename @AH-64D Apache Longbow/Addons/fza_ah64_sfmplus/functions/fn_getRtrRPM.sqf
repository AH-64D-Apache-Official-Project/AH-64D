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

private _rtrRPM = 0.0;

private _mainRtrDamage  = _heli getHitPointDamage "HitHRotor";
if (_mainRtrDamage == 1.0) then {
    _rtrRPM = 0.0;
} else {
    (_heli getVariable "fza_sfmplus_engNp") 
    params ["_e1Np", "_e2Np"];
    _rtrRPM = (_e1Np max _e2Np) * 0.01;
};

_rtrRPM;