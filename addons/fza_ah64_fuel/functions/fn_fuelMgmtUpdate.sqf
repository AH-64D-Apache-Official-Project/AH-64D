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

private _checkRunning = _heli getVariable ["fza_fuel_checkRunning", false];
if (!_checkRunning) exitWith {};

private _checkStartTime = _heli getVariable ["fza_fuel_checkStartTime", 0];
if (_checkStartTime <= 0) exitWith {};

private _totalFuelMass  = _heli getVariable ["fza_sfmplus_totFuelMass", 0];
private _elapsed        = CBA_missionTime - _checkStartTime;
private _startFuelMass  = _heli getVariable ["fza_fuel_checkStartFuel", _totalFuelMass];
private _burnedKg       = _startFuelMass - _totalFuelMass;
private _checkMinutes   = _heli getVariable ["fza_fuel_checkMinutes", 15];
private _targetSec      = (_checkMinutes max 0) * 60;
private _elapsedClamped = if (_targetSec > 0) then { _elapsed min _targetSec } else { _elapsed };

// Cumulative average burn rate over the full elapsed check time (lb/hr)
private _burnRate = if (_elapsedClamped > 0) then { (_burnedKg * KGTOLBS) / (_elapsedClamped / 3600) } else { 0 };

if (_targetSec > 0 && _elapsed >= _targetSec) then {
    private _totalLbs     = _totalFuelMass * KGTOLBS;
    private _burnoutHours = if (_burnRate > 0) then { _totalLbs / _burnRate } else { 0 };
    private _fnZulu = {
        params ["_dt"];
        private _h = floor (_dt % 24);
        format ["%1:%2Z", _h, [floor ((_dt % 24 - _h) * 60), 2] call CBA_fnc_formatNumber]
    };

    [_heli, "fza_fuel_checkRunning", false]     call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_fuel_checkDone",     true]      call fza_fnc_updateNetworkGlobal;
    
    private _fuelPageOpen = ("fuel" in ([_heli, 0] call fza_mpd_fnc_currentPage)) ||
                            ("fuel" in ([_heli, 1] call fza_mpd_fnc_currentPage));
    if (!_fuelPageOpen ||
        (!(_heli getVariable ["fza_fuel_checkActivePlt", false]) &&
         !(_heli getVariable ["fza_fuel_checkActiveCpg", false]))) then {
        [_heli, "fza_fuel_checkPendingAdvisory", true] call fza_fnc_updateNetworkGlobal;
    };
    [_heli, "fza_fuel_checkBurnRate", _burnRate] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_fuel_checkBurnoutZulu", [dayTime + _burnoutHours]        call _fnZulu] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_fuel_checkVFRZulu",    [dayTime + _burnoutHours - 20/60] call _fnZulu] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_fuel_checkIFRZulu",    [dayTime + _burnoutHours - 30/60] call _fnZulu] call fza_fnc_updateNetworkGlobal;
};
