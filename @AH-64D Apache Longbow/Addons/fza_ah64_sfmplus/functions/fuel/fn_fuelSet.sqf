/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_fuelSet

Description:
    Sets the initial fuel state of the aircraft.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    The mass of the forward and aft fuel cells.

Examples:
    ...
    _fuelMass = [_heli] call fza_fnc_setFuel;
    _fwdFuelMass = _fuelMass select 0;
    _aftFuelMass = _fuelMass select 1;

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _percentFuel    = fuel _heli;
private _IAFSInstalled  = _heli getVariable "fza_ah64_IAFSInstalled";
private _maxFwdFuelMass = _heli getVariable "fza_sfmplus_maxFwdFuelMass";
private _maxCtrFuelMass = _heli getVariable "fza_sfmplus_maxCtrFuelMass";
private _maxAftFuelMass = _heli getVariable "fza_sfmplus_maxAftFuelMass";

private _totFuelMass    = 0.0;
private _fwdFuelMass    = 0.0;
private _aftFuelMass    = 0.0;
private _ctrFuelMass    = 0.0;
private _maxTotFuelMass = 0.0;

if (_IAFSInstalled) then {
    _maxTotFuelMass = _maxFwdFuelMass + _maxCtrFuelMass + _maxAftFuelMass;

    _totFuelMass    = _maxTotFuelMass * _percentFuel;
    _fwdFuelMass    = [_totFuelMass / 2, 0, _maxFwdFuelMass] call BIS_fnc_clamp;
    _aftFuelMass    = [_totFuelMass - _fwdFuelMass, 0, _maxAftFuelMass] call BIS_fnc_clamp;
    _ctrFuelMass    = _totFuelMass - (_fwdFuelMass + _aftFuelMass);
} else {
    _maxTotFuelMass = _maxFwdFuelMass + _maxAftFuelMass;

    _totFuelMass    = _maxTotFuelMass * _percentFuel;
    _fwdFuelMass    = [_totFuelMass / 2, 0, _maxFwdFuelMass] call BIS_fnc_clamp;
    _aftFuelMass    = _totFuelMass - _fwdFuelMass;
};

[_fwdFuelMass, _ctrFuelMass, _aftFuelMass];
