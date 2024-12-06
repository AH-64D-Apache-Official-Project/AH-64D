params ["_config"];

private _map = createHashMap;

if (!isClass _config) exitWith {_map};

{
        if (isNumber _x) then {_map set [configName _x, getNumber _x]; continue;};
        if (isText _x) then {_map set [configName _x, getText _x]; continue;};
        if (isArray _x) then {_map set [configName _x, getArray _x]; continue;};
} forEach configProperties [_config, "true", true];
_map;