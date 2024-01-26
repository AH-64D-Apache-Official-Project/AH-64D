/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_massUpdate

Description:
    Updates the mass and moment of a wing station

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

private _armCPG         = [ 0.00, 4.31];
private _armPilot       = [ 0.00, 2.76];
private _armFwdFuelCell = [ 0.00, 2.89];
private _armAmmoBay     = [ 0.00, 1.08];
private _armAftFuelCell = [ 0.00,-0.39];

private _armStation01   = [-2.16, 1.68];
private _armStation02   = [-1.50, 1.68];
private _armStation03   = [ 1.50, 1.68];
private _armStation04   = [ 2.16, 1.68];

private _emptyMass = 0;
private _emptyMom  = 0;
if (_heli animationPhase "fcr_enable" == 1) then {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassFCR";
    _emptyMom  = _heli getVariable "fza_sfmplus_emptyMomFCR";
} else {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassNonFCR";
    _emptyMom  = _heli getVariable "fza_sfmplus_emptyMomNonFCR";
};
_heli setVariable["fza_sfmplus_emptyMass", _emptyMass];
_heli setVariable["fza_sfmplus_emptyMom",  _emptyMom];