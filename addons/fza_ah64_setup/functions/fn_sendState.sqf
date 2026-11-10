/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_sendState

Description:
    Sends the setup page the bindings of the actions and the values of the
    settings it asked for, and where the player is.

Parameters:
    _ctrl       - The page's browser control <CONTROL>
    _withResume - Also send the page state to resume from <BOOL>

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_ctrl", ["_withResume", false]];

private _groups = call fza_setup_fnc_actionGroups;

private _bindings = createHashMap;
{
    private _action = _x;
    private _cfg = configFile >> "CfgUserActions" >> _action;
    private _group = _groups getOrDefault [toLower _action, []];
    // An action no group lists and no addon declares is not in this game, and the key commands would reject it
    if (isClass _cfg || {_group isNotEqualTo []}) then {
        private _name = if (isClass _cfg) then {getText (_cfg >> "displayName")} else {actionName _action};
        if ((_name select [0, 4]) == "$STR") then {_name = localize (_name select [1])};
        private _codes = actionKeys _action;
        _bindings set [_action, createHashMapFromArray [
            ["name", _name],
            ["group", _group param [1, ""]],
            ["codes", _codes],
            ["keys", _codes apply {keyName _x}],
            ["devices", (actionKeysEx _action) apply {(_x param [0, []]) param [1, ""]}]
        ]];
    };
} forEach (uiNamespace getVariable ["fza_setup_actions", []]);

private _settings = createHashMap;
{
    private _default = [_x, "default"] call CBA_settings_fnc_get;
    if (!isNil "_default") then {
        _settings set [_x, createHashMapFromArray [
            ["value", missionNamespace getVariable [_x, _default]],
            ["default", _default],
            ["source", _x call CBA_settings_fnc_priority]
        ]];
    };
} forEach (uiNamespace getVariable ["fza_setup_settings", []]);

private _veh = vehicle player;
private _inApache = _veh isKindOf "fza_ah64base";
private _seat = if (_inApache) then {[_veh] call fza_fnc_getSeat} else {""};
if (isNil "_seat") then {_seat = ""};

private _payload = createHashMapFromArray [
    ["type", "state"],
    ["bindings", _bindings],
    ["settings", _settings],
    ["context", createHashMapFromArray [
        ["inApache", _inApache],
        ["seat", _seat],
        ["engineOn", _inApache && {isEngineOn _veh}],
        ["multiplayer", isMultiplayer],
        ["done", profileNamespace getVariable ["fza_ah64_setupDone", false]]
    ]]
];
if (_withResume) then {
    _payload set ["resume", uiNamespace getVariable ["fza_setup_resume", ""]];
    _payload set ["saved", profileNamespace getVariable ["fza_ah64_setupState", ""]];
};

[_ctrl, "window.fzaSetup && window.fzaSetup.receive(" + toJSON _payload + ");"] call fza_mpd_fnc_execJs;
