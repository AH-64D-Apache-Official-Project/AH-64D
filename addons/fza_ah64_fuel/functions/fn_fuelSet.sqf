/* ----------------------------------------------------------------------------
Function: fza_fuel_fnc_fuelSet

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

private _pylonMagazines = getPylonMagazines _heli;

private _percentFuel    = fuel _heli;
private _IAFSInstalled  = _heli getVariable "fza_ah64_IAFSInstalled";
private _maxFwdFuelMass = _heli getVariable ["fza_sfmplus_maxFwdFuelMass", 0];
private _maxCtrFuelMass = _heli getVariable ["fza_sfmplus_maxCtrFuelMass", 0];
private _maxAftFuelMass = _heli getVariable ["fza_sfmplus_maxAftFuelMass", 0];
private _maxTnkFuelMass = _heli getVariable ["fza_sfmplus_maxExtFuelMass", 0];

private _totFuelMass    = 0.0;
private _fwdFuelMass    = 0.0;
private _aftFuelMass    = 0.0;
private _ctrFuelMass    = 0.0;
private _extFuelMass    = 0.0;
private _maxIntFuelMass = 0.0;
private _maxExtFuelMass = 0.0;
private _maxTotFuelMass = 0.0;

/////////////////////////////////////////////////////////////////////////////////////////////
// Station 1 Fuel       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _stn1HasTank     = 0;
private _stn1FuelMass    = 0.0;
private _stn1MaxFuelMass = 0.0;
if (["auxTank", _pylonMagazines select 0] call BIS_fnc_inString) then {
    _stn1HasTank  = 1;
    _stn1MaxFuelMass = _maxTnkFuelMass;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Station 2 Fuel       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _stn2HasTank     = 0;
private _stn2FuelMass    = 0.0;
private _stn2MaxFuelMass = 0.0;
if (["auxTank", _pylonMagazines select 4] call BIS_fnc_inString) then {
    _stn2HasTank  = 1;
    _stn2MaxFuelMass = _maxTnkFuelMass;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Station 3 Fuel       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _stn3HasTank     = 0;
private _stn3FuelMass    = 0.0;
private _stn3MaxFuelMass = 0.0;
if (["auxTank", _pylonMagazines select 8] call BIS_fnc_inString) then {
    _stn3HasTank  = 1;
    _stn3MaxFuelMass = _maxTnkFuelMass;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Station 4 Fuel       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _stn4HasTank     = 0;
private _stn4FuelMass    = 0.0;
private _stn4MaxFuelMass = 0.0;
if (["auxTank", _pylonMagazines select 12] call BIS_fnc_inString) then {
    _stn4HasTank  = 1;
    _stn4MaxFuelMass = _maxTnkFuelMass;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Outer/inner tank dependency (pressurised air path)                                //////
// stn1 (outer L) can only transfer if stn2 (inner L) is also loaded.               //////
// stn4 (outer R) can only transfer if stn3 (inner R) is also loaded.               //////
// Tanks without a transfer path are excluded from initial fuel distribution.        //////
/////////////////////////////////////////////////////////////////////////////////////////////
if (_stn1HasTank == 1 && _stn2HasTank == 0) then {
    _stn1HasTank     = 0;
    _stn1MaxFuelMass = 0;
};
if (_stn4HasTank == 1 && _stn3HasTank == 0) then {
    _stn4HasTank     = 0;
    _stn4MaxFuelMass = 0;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// External Fuel        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
_numExtTanks        = _stn1HasTank  + _stn2HasTank  + _stn3HasTank  + _stn4HasTank;
_maxExtFuelMass     = _stn1MaxFuelMass + _stn2MaxFuelMass + _stn3MaxFuelMass + _stn4MaxFuelMass; 
/////////////////////////////////////////////////////////////////////////////////////////////
// Internal Fuel        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (isNil "_IAFSInstalled") exitWith {};

// Initial load — distribute fuel across cells based on capacity
if (_IAFSInstalled) then {
    _maxIntFuelMass = _maxFwdFuelMass + _maxCtrFuelMass + _maxAftFuelMass;
} else {
    _maxIntFuelMass = _maxFwdFuelMass + _maxAftFuelMass;
};
_maxTotFuelMass = _maxIntFuelMass + _maxExtFuelMass;

_totFuelMass    = _maxTotFuelMass * _percentFuel;
// Internal fills first; external gets whatever remains above internal capacity
private _intFuelMass = _totFuelMass min _maxIntFuelMass;
_extFuelMass    = 0 max (_totFuelMass - _intFuelMass) min _maxExtFuelMass;
_fwdFuelMass    = [_intFuelMass / 2,                             0, _maxFwdFuelMass] call BIS_fnc_clamp;
_aftFuelMass    = [_intFuelMass - _fwdFuelMass,                  0, _maxAftFuelMass] call BIS_fnc_clamp;
if (_IAFSInstalled) then {
    _ctrFuelMass = [_intFuelMass - (_fwdFuelMass + _aftFuelMass), 0, _maxCtrFuelMass] call BIS_fnc_clamp;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// External Tanks Final /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (_stn1HasTank == 1) then {
    _stn1FuelMass = _extFuelMass / _numExtTanks;
};
if (_stn2HasTank == 1) then {
    _stn2FuelMass = _extFuelMass / _numExtTanks;
};
if (_stn3HasTank == 1) then {
    _stn3FuelMass = _extFuelMass / _numExtTanks;
};
if (_stn4HasTank == 1) then {
    _stn4FuelMass = _extFuelMass / _numExtTanks;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Update Variables     /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
_heli setVariable ["fza_sfmplus_fwdFuelMass",    _fwdFuelMass];
_heli setVariable ["fza_sfmplus_ctrFuelMass",    _ctrFuelMass];
_heli setVariable ["fza_sfmplus_aftFuelMass",    _aftFuelMass];

_heli setVariable ["fza_sfmplus_stn1FuelMass",   _stn1FuelMass];
_heli setVariable ["fza_sfmplus_stn2FuelMass",   _stn2FuelMass];
_heli setVariable ["fza_sfmplus_stn3FuelMass",   _stn3FuelMass];
_heli setVariable ["fza_sfmplus_stn4FuelMass",   _stn4FuelMass];

private _actualTotFuelMass = _fwdFuelMass + _ctrFuelMass + _aftFuelMass
                           + _stn1FuelMass + _stn2FuelMass + _stn3FuelMass + _stn4FuelMass;
_heli setVariable ["fza_sfmplus_totFuelMass"   , _actualTotFuelMass];
_heli setVariable ["fza_sfmplus_maxTotFuelMass", _maxTotFuelMass];
