/* ----------------------------------------------------------------------------
Function: fza_fuel_fnc_fuelMgmtUpdate

Description:
    Updates fuel management state: CHECK sub-mode burn calculations.
    Called each tick from fza_sfmplus_fnc_coreUpdate after fuelUpdate.

Parameters:
    _heli - The helicopter to update [Unit].

Returns:
    None

Author:
    FZA Development Team
---------------------------------------------------------------------------- */
params ["_heli"];

#define KGTOLBS 2.20462

private _checkActive = _heli getVariable ["fza_fuel_checkActive", false];
if (!_checkActive) exitWith {};

private _checkStartTime = _heli getVariable ["fza_fuel_checkStartTime", 0];
private _totalFuelMass  = _heli getVariable ["fza_sfmplus_totFuelMass", 0];

// Record start values on first tick after activation
if (_checkStartTime <= 0) then {
    _heli setVariable ["fza_fuel_checkStartTime", CBA_missionTime];
    _heli setVariable ["fza_fuel_checkStartFuel", _totalFuelMass];
} else {
    private _elapsed = CBA_missionTime - _checkStartTime;
    private _checkStartFuel = _heli getVariable ["fza_fuel_checkStartFuel", _totalFuelMass];
    private _burnedKg       = _checkStartFuel - _totalFuelMass;

    // Burn rate in lb/hr
    private _burnRate = if (_elapsed > 0) then { (_burnedKg * KGTOLBS) / (_elapsed / 3600) } else { 0 };

    // Total fuel remaining in lb
    private _totalFuelLbs = _totalFuelMass * KGTOLBS;

    // Burnout time (minutes at current burn rate)
    private _burnoutMin = if (_burnRate > 0) then { (_totalFuelLbs / _burnRate) * 60 } else { 999 };

    // VFR / IFR reserves in lb (20 min and 30 min at current burn rate)
    private _vfrResLbs = (_burnRate / 60) * 20;
    private _ifrResLbs = (_burnRate / 60) * 30;

    _heli setVariable ["fza_fuel_checkElapsedSec", _elapsed];
    _heli setVariable ["fza_fuel_checkBurnRate",   _burnRate];
    _heli setVariable ["fza_fuel_checkBurnoutMin", _burnoutMin];
    _heli setVariable ["fza_fuel_checkVFRRes",     _vfrResLbs];
    _heli setVariable ["fza_fuel_checkIFRRes",     _ifrResLbs];
};
