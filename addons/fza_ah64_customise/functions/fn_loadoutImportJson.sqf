/* ----------------------------------------------------------------------------
Function: fza_fnc_loadoutImportJson

Description:
    Import of website heicopter configuration and apply it to the helicopter.
    The mission planner's loadout export is the same JSON with cannonRds,
    msnEquip, zone counts (zoneACount...) and aux pylons; fuel is the total
    including aux tanks, and tailNum paints the tail unless the Tail Number
    attribute is set. fuelGal is only for the planner. A DTC exported from the mission planner is put
    in the aircraft instead, for DTU MASTER LOAD (fza_dms_fnc_dtcFromJson).

Parameters:
    _heli - The helicopter to get information from [Unit].
    _json - the Json string output from the website or the mission planner, or a mission planner DTC

Returns:

Examples:
    [vehicle player, Json Data] call fza_loadoutImportJson

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_json"];
if (_json == "") exitWith {};
if (_json == "true") exitWith {};

if (["""pfz""", """lines""", """wp"""] findIf {_json find _x != -1} != -1) exitWith {
    if (!isServer && !is3DEN) exitWith {};
    ([_heli, _json] call fza_dms_fnc_dtcFromJson) params ["_ok", "_why"];
    if (!_ok) then {["DTC not loaded: %1", _why] call BIS_fnc_error};
};

private _settings = [_json] call CBA_fnc_parseJSON;
if (isNil "_settings" || {!(_settings isEqualTypeAny [locationNull, objNull])}) exitWith {
    ["Loadout Config is not a loadout"] call BIS_fnc_error;
};
private _nameCheck = ["M151","M255A1","M257","M261","M278","AGM114FA","AGM114K","AGM114K2A","AGM114L","AGM114N"];
private _ammoName = {
    params ["_info", "_key"];
    private _name = _info getVariable [_key, ""];
    if !(_name isEqualType "") exitWith {""};
    _name = toUpper ([_name] call BIS_fnc_filterString);
    if (_name == "M255") then {_name = "M255A1"};
    ["", _name] select (_name in _nameCheck)
};

//System Settings
private _iafs = (_settings getVariable ["iafsInstalled", true]) isNotEqualTo false;
_heli animateSource ["fcr_enable", [0, 1] select ((_settings getVariable ["fcrInstalled", false]) isEqualTo true)];
[_heli, [1, 0] select _iafs] call fza_fnc_weaponSwapM230Mag;

private _cannonRds = _settings getVariable ["cannonRds", -1];
if (_cannonRds isEqualType 0 && {_cannonRds >= 0} && {local _heli}) then {
    _heli setAmmo ["fza_m230", round _cannonRds min ([1200, 300] select _iafs)];
};

//SFM Weight sim
[_heli] call bmkhs_fnc_coreConfig;

//Loadout settings, as the mission planner loads them (fza_mplanner_fnc_applyConfig)
private _magazineIndex = 16;
private _load = {
    params ["_magazine", ["_count", -1]];
    _heli setPylonLoadout [_magazineIndex, _magazine, true, [0]];
    if (_magazine != "" && {_count >= 0}) then {_heli setAmmoOnPylon [_magazineIndex, _count]};
    _magazineIndex = _magazineIndex - 1;
};
{
    private _pylonInfo = _settings getVariable [_x, objNull];
    private _pylonType = if (_pylonInfo isEqualTypeAny [locationNull, objNull] && {!isNull _pylonInfo}) then {_pylonInfo getVariable ["type", "none"]} else {"none"};
    if !(_pylonType isEqualType "") then {_pylonType = "none"};
    switch _pylonType do {
        case "rocket": {
            [""] call _load;
            {
                private _name = [_pylonInfo, _x] call _ammoName;
                if (_name == "") then {
                    [["", "fza_275_pod"] select (_x == "zoneA")] call _load;
                } else {
                    private _count = _pylonInfo getVariable [_x + "Count", -1];
                    if !(_count isEqualType 0) then {_count = -1};
                    [toLower format ["fza_275_%1_%2", _name, _x], round _count] call _load;
                };
            } forEach ["zoneE","zoneB","zoneA"];
        };
        case "hellfire": {
            {
                private _name = [_pylonInfo, _x] call _ammoName;
                if (_name == "") then {
                    [["", "fza_agm114_rail"] select (_x == "ul")] call _load;
                } else {
                    [toLower format ["fza_%1_%2", _name, _x]] call _load;
                };
            } forEach ["lr","ll","ur","ul"];
        };
        case "aux": {
            for "_i" from 0 to 2 do {[""] call _load};
            ["fza_230gal_auxTank"] call _load;
        };
        default {
            if (_pylonType != "none") then {["Unknown pylon type %1", _pylonType] call BIS_fnc_error};
            for "_i" from 0 to 3 do {[""] call _load};
        };
    };
} forEach ["pylon1","pylon2","pylon3","pylon4"];

// Internal tanks fill first, then the aux tanks just loaded
private _fuelKg = _settings getVariable ["fuel", -1];
if (_fuelKg isEqualType 0 && {_fuelKg >= 0}) then {
    private _tankCapacityKg = [_heli] call fza_ah64_helisim_fnc_fuelCapacity;
    if (_tankCapacityKg > 0) then {_heli setFuel ((_fuelKg / _tankCapacityKg) min 1)};
};
[_heli] call bmkhs_fnc_fuelSet;

// The Tail Number attribute wins when it is set
private _tailNum = _settings getVariable ["tailNum", ""];
if (_tailNum isEqualType "" && {_tailNum regexMatch "^[0-9 ]{1,5}$"} && {(_heli getVariable ["fza_customise_tailAttribute", ""]) isEqualTo ""}) then {
    [_heli, _tailNum] call fza_customise_fnc_setTailNumber;
    _heli setVariable ["fza_ah64_tailNumber", _tailNum, true];
};

private _msnEquip = _settings getVariable ["msnEquip", ""];
if (_msnEquip in ["US", "UK"]) then {
    _heli animateSource ["msn_equip_american", [0, 1] select (_msnEquip == "US"), true];
    _heli animateSource ["msn_equip_british", [0, 1] select (_msnEquip == "UK"), true];
};
