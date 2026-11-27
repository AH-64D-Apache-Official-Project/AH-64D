/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_sources

Description:
    The ammunition and fuel sources within the planner's source distance of the
    aircraft, nearest first (fza_mplanner_fnc_supply decides what is a source).
    The planner list and the apply both use this, so a source the planner shows
    is one the apply uses.

Parameters:
    _heli - The aircraft
    _ammo - Look for ammunition sources (default true)
    _fuel - Look for fuel sources (default true)

Returns:
    [ammo, fuel]
    ammo - [source, distance, supply points (-1 when points aren't used)]
    fuel - [source, distance, litres (-1 for unlimited)]

Examples:
    ([_heli] call fza_mplanner_fnc_sources) params ["_ammo", "_fuel"];

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_wantAmmo", true], ["_wantFuel", true]];

private _range = missionNamespace getVariable ["fza_mplanner_sourceDistance", 25];
if !(_range isEqualType 0) then {_range = 25};

private _ammo = [];
private _fuel = [];
{
    if (_x isEqualTo _heli || {!alive _x}) then {continue};
    private _dist = _heli distance _x;
    if (_wantAmmo && {["isAmmo", [_x]] call fza_mplanner_fnc_supply}) then {
        _ammo pushBack [_x, _dist, ["points", [_x]] call fza_mplanner_fnc_supply];
    };
    if (_wantFuel) then {
        private _litres = ["fuel", [_x]] call fza_mplanner_fnc_supply;
        if (_litres != 0) then {_fuel pushBack [_x, _dist, _litres]};
    };
} forEach (nearestObjects [_heli, ["AllVehicles", "House", "Strategic", "ThingX"], _range]);

[_ammo, _fuel]
