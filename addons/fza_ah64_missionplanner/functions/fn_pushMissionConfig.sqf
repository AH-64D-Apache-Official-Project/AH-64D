params [
    ["_name", "", [""]],
    ["_stateJson", "", [""]]
];

["mission", _name, _stateJson] call fza_mplanner_fnc_saveConfig;
