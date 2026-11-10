/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_bridge

Description:
    Handles a message from the setup page: a JSON object with a "cmd".

Parameters:
    _ctrl - The page's browser control <CONTROL>
    _json - The message <STRING>

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_ctrl", "_json"];

private _msg = fromJSON _json;
if !(_msg isEqualType createHashMap) exitWith {};
private _cmd = _msg getOrDefault ["cmd", ""];
private _display = ctrlParent _ctrl;

switch (_cmd) do {
    case "ready": {
        private _actions = (_msg getOrDefault ["actions", []]) select {_x isEqualType ""};
        private _settings = (_msg getOrDefault ["settings", []]) select {_x isEqualType ""};
        uiNamespace setVariable ["fza_setup_actions", _actions];
        uiNamespace setVariable ["fza_setup_settings", _settings];
        [_ctrl, true] call fza_setup_fnc_sendState;
    };
    case "refresh": {
        [_ctrl, false] call fza_setup_fnc_sendState;
    };
    case "save": {
        private _state = _msg getOrDefault ["state", ""];
        if !(_state isEqualType "") exitWith {};
        uiNamespace setVariable ["fza_setup_resume", _state];
        profileNamespace setVariable ["fza_ah64_setupState", _state];
        uiNamespace setVariable ["fza_setup_dirty", true];
    };
    case "apply": {
        private _values = _msg getOrDefault ["values", createHashMap];
        if !(_values isEqualType createHashMap) exitWith {};
        private _results = [_values] call fza_setup_fnc_applySettings;
        private _payload = createHashMapFromArray [["type", "applied"], ["results", _results]];
        [_ctrl, "window.fzaSetup && window.fzaSetup.receive(" + toJSON _payload + ");"] call fza_mpd_fnc_execJs;
        [_ctrl, false] call fza_setup_fnc_sendState;
    };
    case "bind": {
        private _action = _msg getOrDefault ["action", ""];
        if !(_action isEqualType "") exitWith {};
        ["controls", _action] call fza_setup_fnc_openMenu;
    };
    case "controls": {
        ["controls", ""] call fza_setup_fnc_openMenu;
    };
    case "addons": {
        ["addons"] call fza_setup_fnc_openMenu;
    };
    case "test": {
        uiNamespace setVariable ["fza_setup_reopen", true];
        _display closeDisplay 2;
        [{["start"] call fza_setup_fnc_test}] call CBA_fnc_execNextFrame;
    };
    case "docsButton": {
        (_display displayCtrl 101) ctrlShow ((_msg getOrDefault ["show", false]) isEqualTo true);
    };
    case "finish": {
        profileNamespace setVariable ["fza_ah64_setupDone", true];
        uiNamespace setVariable ["fza_setup_dirty", true];
        _display closeDisplay 1;
    };
    case "close": {
        _display closeDisplay 2;
    };
};
