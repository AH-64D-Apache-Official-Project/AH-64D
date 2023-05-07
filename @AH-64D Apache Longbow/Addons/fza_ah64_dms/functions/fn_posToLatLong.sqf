convert={params ["_pos", ["_world", worldName]];

private _mapLatLong = getArray (configfile >> "CfgWorlds" >> "Altis" >> "mapArea");

private _config = configFile >> "CfgWorlds" >> _world;

if (isArray (_config >> "mapArea")) then {
    _mapLatLong = getArray (_config >> "mapArea");
};

_mapLatLong params ["_startLat", "_startLong", "_endLat", "_endLong"];

private _mapSize = worldName call BIS_fnc_mapSize;
private _start = _mapLatLong select [0,2];
private _end = _mapLatLong select [2,2];

[linearConversion [0, _mapSize, _pos # 0, _start # 0, _end # 0]
    ,linearConversion [0, _mapSize, _pos # 1, _start # 1, _end # 1]]};

[getPos player] call convert;