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
private _maxTotFuelMass = 0.0;

// Station presence — outer tanks need inner present (pressurised air path)
private _stn1HasTank = ["auxTank", _pylonMagazines select 0]  call BIS_fnc_inString;
private _stn2HasTank = ["auxTank", _pylonMagazines select 4]  call BIS_fnc_inString;
private _stn3HasTank = ["auxTank", _pylonMagazines select 8]  call BIS_fnc_inString;
private _stn4HasTank = ["auxTank", _pylonMagazines select 12] call BIS_fnc_inString;

private _stn1FuelMass = 0.0;
private _stn2FuelMass = 0.0;
private _stn3FuelMass = 0.0;
private _stn4FuelMass = 0.0;

private _numExtTanks    = [_stn1HasTank, _stn2HasTank, _stn3HasTank, _stn4HasTank] count {_x};
private _maxExtFuelMass = _numExtTanks * _maxTnkFuelMass;
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
// External tank initial fuel
if (_numExtTanks > 0) then {
    private _perTank = _extFuelMass / _numExtTanks;
    if (_stn1HasTank) then { _stn1FuelMass = _perTank; };
    if (_stn2HasTank) then { _stn2FuelMass = _perTank; };
    if (_stn3HasTank) then { _stn3FuelMass = _perTank; };
    if (_stn4HasTank) then { _stn4FuelMass = _perTank; };
};
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
