/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_fuelCapacity

Description:
    The fuel the aircraft can hold as fitted, in kg: the internal tanks that are
    installed and the aux tanks on its pylons, counted as bmkhs_fnc_fuelSet
    counts them. setFuel takes a share of this.

Parameters:
    _heli - The helicopter

Returns:
    Capacity in kg

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _fuelTanks = _heli getVariable ["bmkhs_fuelTanks", []];
private _auxTanks = _heli getVariable ["bmkhs_auxTanks", []];
private _stations = _heli getVariable ["bmkhs_stations", []];
private _pylonMagazines = getPylonMagazines _heli;

private _capacity = 0;
{
    if (!(_x get "removable") || {_heli getVariable [(_x get "varName") + "Installed", false]}) then {
        _capacity = _capacity + (_x get "capacity");
    };
} forEach _fuelTanks;
{
    private _tank = _x;
    private _pylons = (_stations param [(_tank get "station") - 1, createHashMap]) getOrDefault ["pylons", []];
    if (_pylons findIf {["auxTank", _pylonMagazines param [_x - 1, ""]] call BIS_fnc_inString} > -1) then {
        _capacity = _capacity + (_tank get "capacity");
    };
} forEach _auxTanks;

if (_capacity <= 0) then {
    _capacity = (_heli getVariable ["bmkhs_fwdTankMax", 0]) + (_heli getVariable ["bmkhs_aftTankMax", 0])
        + ([0, _heli getVariable ["bmkhs_ctrTankMax", 0]] select (_heli getVariable ["bmkhs_ctrTankInstalled", false]));
};
_capacity
