// A zone from its cursor entries, a box from two: [] if it can't be used
params ["_entries", "_heading"];

if (count _entries == 2) exitWith {
    [[_entries # 0, _entries # 1, _heading] call fza_dms_fnc_zoneBox] call fza_dms_fnc_zoneValidate
};
[_entries] call fza_dms_fnc_zoneValidate
