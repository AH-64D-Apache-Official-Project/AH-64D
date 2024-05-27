/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_fuelUpdate

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
params ["_heli", "_deltaTime"];

private _percentFuel     = fuel _heli;
private _IAFSInstalled   = _heli getVariable "fza_ah64_IAFSInstalled";
private _maxFwdFuelMass  = _heli getVariable "fza_sfmplus_maxFwdFuelMass";
private _maxCtrFuelMass  = _heli getVariable "fza_sfmplus_maxCtrFuelMass";
private _maxAftFuelMass  = _heli getVariable "fza_sfmplus_maxAftFuelMass";
private _maxTnkFuelMass  = _heli getVariable "fza_sfmplus_maxExtFuelMass";
private _fwdFuelMass     = 0.0;
private _aftFuelMass     = 0.0;
private _ctrFuelMass     = 0.0;
private _extFuelMass     = 0.0;
private _stn1FuelMass    = 0.0;
private _stn2FuelMass    = 0.0;
private _stn3FuelMass    = 0.0;
private _stn4FuelMass    = 0.0;
private _totFuelMass     = 0.0;
private _maxTotFuelMass  = _heli getVariable "fza_sfmplus_maxTotFuelMass";
/////////////////////////////////////////////////////////////////////////////////////////////
// Fuel Flow            /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _apuFF_kgs       = _heli getVariable "fza_systems_apuFF_kgs";
private _eng1FF_kgs      = _heli getVariable "fza_sfmplus_engFF" select 0;
private _eng2FF_kgs      = _heli getVariable "fza_sfmplus_engFF" select 1;
private _curFuelFlow_kgs = 0;
_curFuelFlow_kgs         = (_apuFF_kgs + _eng1FF_kgs + _eng2FF_kgs) * _deltaTime;
_totFuelMass             = (_maxTotFuelMass * _percentFuel) - _curFuelFlow_kgs;
/////////////////////////////////////////////////////////////////////////////////////////////
// External Tanks       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _pylonMagazines  = getPylonMagazines _heli;
private _stn1HasTank     = 0;
if (["auxTank", _pylonMagazines select 0] call BIS_fnc_inString) then {
    _stn1HasTank  = 1;
};
private _stn2HasTank     = 0;
if (["auxTank", _pylonMagazines select 4] call BIS_fnc_inString) then {
    _stn2HasTank  = 1;
};
private _stn3HasTank     = 0;
if (["auxTank", _pylonMagazines select 8] call BIS_fnc_inString) then {
    _stn3HasTank  = 1;
};
private _stn4HasTank     = 0;
if (["auxTank", _pylonMagazines select 12] call BIS_fnc_inString) then {
    _stn4HasTank  = 1;
};
_numExtTanks      = _stn1HasTank  + _stn2HasTank  + _stn3HasTank  + _stn4HasTank;
/////////////////////////////////////////////////////////////////////////////////////////////
// Internal Tanks       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (_IAFSInstalled) then {
    _fwdFuelMass    = [_totFuelMass / 2,                             0, _maxFwdFuelMass] call BIS_fnc_clamp;
    _aftFuelMass    = [_totFuelMass - _fwdFuelMass,                  0, _maxAftFuelMass] call BIS_fnc_clamp;
    _ctrFuelMass    = [_totFuelMass - (_fwdFuelMass + _aftFuelMass), 0, _maxCtrFuelMass] call BIS_fnc_clamp;
    _extFuelMass    = _totFuelMass - (_fwdFuelMass + _ctrFuelMass + _aftFuelMass);
} else {
    _fwdFuelMass    = [_totFuelMass / 2,            0, _maxFwdFuelMass] call BIS_fnc_clamp;
    _aftFuelMass    = [_totFuelMass - _fwdFuelMass, 0, _maxAftFuelMass] call BIS_fnc_clamp;
    _extFuelMass    = _totFuelMass - (_fwdFuelMass + _aftFuelMass);
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
// Update Fuel          /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _armaFuelFrac    = _totFuelMass / _maxTotFuelMass;
if (local _heli) then {
    _heli setFuel _armaFuelFrac;
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

_heli setVariable ["fza_sfmplus_totFuelMass"   , _totFuelMass];


systemChat format ["ArmA Fuel Fraction = %1 -- ApuFF = %2 -- Eng1 FF = %3 -- Eng2 FF = %4", _armaFuelFrac, _apuFF_kgs, _eng1FF_kgs, _eng2FF_kgs];

hintsilent format ["Fwd Fuel Mass = %1
                    \nCtr Fuel Mass = %2
                    \nAft Fuel Mass = %3
                    \nStation 1 Fuel Mass = %4
                    \nStation 2 Fuel Mass = %5
                    \nStation 3 Fuel Mass = %6
                    \nStation 4 Fuel Mass = %7
                    \n------------------------------
                    \nTotal Fuel Mass = %8
                    \nMax Total Fuel Mass = %9
                    \n------------------------------
                    \nFuel Fraction = %10"
                    , _heli getVariable "fza_sfmplus_fwdFuelMass"
                    , _heli getVariable "fza_sfmplus_ctrFuelMass"
                    , _heli getVariable "fza_sfmplus_aftFuelMass"
                    , _heli getVariable "fza_sfmplus_stn1FuelMass"
                    , _heli getVariable "fza_sfmplus_stn2FuelMass"
                    , _heli getVariable "fza_sfmplus_stn3FuelMass"
                    , _heli getVariable "fza_sfmplus_stn4FuelMass"
                    , _heli getVariable "fza_sfmplus_totFuelMass"
                    , _heli getVariable "fza_sfmplus_maxTotFuelMass"
                    , (_heli getVariable "fza_sfmplus_totFuelMass") / (_heli getVariable "fza_sfmplus_maxTotFuelMass")];
