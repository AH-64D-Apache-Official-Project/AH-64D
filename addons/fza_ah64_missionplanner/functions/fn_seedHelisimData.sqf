/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_seedHelisimData

Description:
    Reads the helicopter's HeliSim config (performance tables, masses, fuel
    capacities) and sends it to the browser, so the planner's weights and
    performance come from the same data the flight model uses.

Parameters:
    None

Returns:
    true / false

Author:
    FZA Missionplanner
---------------------------------------------------------------------------- */
disableSerialization;

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith { false };

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith { false };

private _heli = uiNamespace getVariable ["fza_mplanner_target", vehicle player];
if (isNull _heli || !(_heli isKindOf "Helicopter")) then {
    _heli = vehicle player;
};

private _cfg = configOf _heli >> "BMKHS_HeliSim";
if !(isClass _cfg) exitWith { false };

// One table per FAT bin: -40, -20, 0, 20, 40 deg C
(["perfTable", "hoverTable", "TASTable"] apply {
    private _name = _x;
    str ([0, 1, 2, 3, 4] apply { getArray (_cfg >> format ["%1%2", _name, _x]) })
}) params ["_perfJson", "_hoverJson", "_tasJson"];

private _fcrVariant = ("true" configClasses (_cfg >> "EmptyMassVariants")) select { getText (_x >> "animation") == "fcr_enable" } param [0, configNull];

private _crewMass = 0;
{ _crewMass = _crewMass + getNumber (_x >> "mass") } forEach ("true" configClasses (_cfg >> "Seats"));

// HeliSim picks a store by its "match" substring of the magazine class name
private _matchClass = {
    params ["_parent", "_magazine"];
    ("true" configClasses _parent) select { toLower getText (_x >> "match") in toLower _magazine } param [0, configNull]
};
private _hellfire = [_cfg >> "Stores", "fza_agm114k_ul"] call _matchClass;
private _rocket   = [_cfg >> "Stores", "fza_275_m151_zoneA"] call _matchClass;
private _auxTank  = [_cfg >> "Stores", "fza_230gal_auxTank"] call _matchClass;
private _cannon   = [_cfg >> "Magazines", "fza_m230_300"] call _matchClass;

private _massJson = format [
    '{"empty":%1,"emptyFcr":%2,"crew":%3,"m299":%4,"hellfire":%5,"m261":%6,"rocket":%7,"auxTank":%8,"cannonRd":%9}',
    getNumber (_cfg >> "emptyMass"),
    getNumber (_fcrVariant >> "mass"),
    _crewMass,
    getNumber (_hellfire >> "launcherMass"),
    getNumber (_hellfire >> "massPerRound"),
    getNumber (_rocket >> "launcherMass"),
    getNumber (_rocket >> "massPerRound"),
    getNumber (_auxTank >> "launcherMass"),
    getNumber (_cannon >> "massPerRound")
];

private _tankCapacity = createHashMap;
{ _tankCapacity set [getText (_x >> "variableName"), getNumber (_x >> "capacity")] } forEach ("true" configClasses (_cfg >> "FuelTanks"));

private _fuelJson = format [
    '{"fwd":%1,"aft":%2,"ctr":%3,"aux":%4}',
    _tankCapacity getOrDefault ["fwdTank", 0],
    _tankCapacity getOrDefault ["aftTank", 0],
    _tankCapacity getOrDefault ["ctrTank", 0],
    getNumber (("true" configClasses (_cfg >> "AuxTanks")) param [0, configNull] >> "capacity")
];

// Joined rather than formatted: format truncates its output at 8191 characters
private _payload = [
    '{"perf":',  _perfJson,
    ',"hover":', _hoverJson,
    ',"tas":',   _tasJson,
    ',"engFF":', str getArray (_cfg >> "engFFTable"),
    ',"mass":',  _massJson,
    ',"fuel":',  _fuelJson,
    '}'
] joinString "";

private _jsCode = "window.fza_mplanner_receiveHelisimData && window.fza_mplanner_receiveHelisimData('" + _payload + "');";
[_browser, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";

true
