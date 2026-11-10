/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_openMenu

Description:
    Swaps the setup for Arma's Controls menu or CBA's Addon Options, and
    brings the setup back on the same page when that menu closes.

    The engine only fills in the Controls menu when the pause menu's Controls
    button opens it, and only on a pause menu made with createDisplay (as the
    respawn menu does) or by Esc. Failing the first, the player is asked to
    press Esc and the button is pressed for them.

Parameters:
    _menu   - "controls" or "addons" <STRING>
    _action - Controls: the action to show, its category selected and its row picked where the menu allows <STRING>

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_menu", ["_action", ""]];

uiNamespace setVariable ["fza_setup_reopen", true];
private _setup = uiNamespace getVariable ["fza_setup_display", displayNull];
if (!isNull _setup) then {_setup closeDisplay 2};

if (_menu == "addons") exitWith {
    [{
        private _main = findDisplay 46;
        if (isNull _main) exitWith {};
        private _before = allDisplays;
        [_main] call CBA_settings_fnc_openSettingsMenu;
        private _opened = (allDisplays - _before) param [0, displayNull];
        if (isNull _opened) exitWith {[true] call fza_setup_fnc_open};
        _opened displayAddEventHandler ["Unload", {[{[true] call fza_setup_fnc_open}] call CBA_fnc_execNextFrame}];
    }] call CBA_fnc_execNextFrame;
};

private _name = "";
if (_action != "") then {
    private _cfg = configFile >> "CfgUserActions" >> _action;
    _name = if (isClass _cfg) then {getText (_cfg >> "displayName")} else {actionName _action};
    if ((_name select [0, 4]) == "$STR") then {_name = localize (_name select [1])};
};
private _group = if (_action == "") then {[]} else {(call fza_setup_fnc_actionGroups) getOrDefault [toLower _action, []]};

[_name, _group] spawn {
    disableSerialization;
    params ["_name", "_group"];

    // Presses the pause menu's Controls button; the menu, once the engine has filled it in
    private _openControls = {
        params ["_pause"];
        private _button = _pause displayCtrl 303;
        _button ctrlShow true;
        _button ctrlEnable true;
        ctrlActivate _button;
        private _found = displayNull;
        private _t0 = diag_tickTime;
        waitUntil {
            uiSleep 0.05;
            _found = (allDisplays select {!isNull (_x displayCtrl 108) && {!isNull (_x displayCtrl 2300)}}) param [0, displayNull];
            (!isNull _found && {lbSize (_found displayCtrl 108) > 0}) || {diag_tickTime - _t0 > 1} || {isNull _pause}
        };
        if (!isNull _found && {lbSize (_found displayCtrl 108) == 0}) then {
            _found closeDisplay 2;
            _found = displayNull;
        };
        _found
    };

    uiSleep 0.1;
    private _pause = (findDisplay 46) createDisplay (["RscDisplayInterrupt", "RscDisplayMPInterrupt"] select isMultiplayer);
    private _menu = if (isNull _pause) then {displayNull} else {[_pause] call _openControls};

    if (isNull _menu) then {
        if (!isNull _pause) then {_pause closeDisplay 2};
        uiSleep 0.1;
        private _layer = "fza_setup_hint" call BIS_fnc_rscLayer;
        private _hint = "<t size='1.6' color='#d8ffd8' font='RobotoCondensedBold'>Press Esc to open the Controls menu</t>";
        if (_name != "") then {_hint = _hint + format ["<br/><t size='1.2' color='#9ad79a'>It opens at %1</t>", _name]};
        _layer cutText [_hint, "PLAIN", -1, true, true];
        private _t0 = diag_tickTime;
        waitUntil {uiSleep 0.05; !isNull findDisplay 49 || {diag_tickTime - _t0 > 60}};
        _layer cutText ["", "PLAIN"];
        _pause = findDisplay 49;
        if (!isNull _pause) then {_menu = [_pause] call _openControls};
    };

    if (isNull _menu) exitWith {
        waitUntil {uiSleep 0.1; isNull findDisplay 49};
        [true] call fza_setup_fnc_open;
    };

    // Back out of the pause menu too, to the setup
    _menu displayAddEventHandler ["Unload", {
        [] spawn {
            disableSerialization;
            uiSleep 0.05;
            (findDisplay 49) closeDisplay 2;
            {_x closeDisplay 2} forEach (allDisplays select {!isNull (_x displayCtrl 303) && {!isNull (_x displayCtrl 101)} && {ctrlIDD _x != 46}});
            uiSleep 0.05;
            [true] call fza_setup_fnc_open;
        };
    }];

    private _title = _menu displayCtrl 1000;
    if (!isNull _title && {_name != ""}) then {_title ctrlSetText format ["AH-64D SETUP - FIND: %1", toUpper _name]};
    if (_group isEqualTo []) exitWith {};

    private _combo = _menu displayCtrl 108;
    private _index = -1;
    for "_i" from 0 to (lbSize _combo - 1) do {
        if ((_combo lbText _i) == (_group # 1)) exitWith {_index = _i};
    };
    if (_index < 0) exitWith {};
    // The menu's own onLoad spawns a reset of the category to this saved one
    profileNamespace setVariable ["RscDisplayConfigure_cursel", _index];
    _combo lbSetCurSel _index;

    uiSleep 0.2;
    if (isNull _menu) exitWith {};
    if (lbCurSel _combo != _index) then {
        _combo lbSetCurSel _index;
        uiSleep 0.05;
    };
    private _list = _menu displayCtrl 102;
    private _wanted = toLower _name;
    private _row = -1;
    for "_i" from 0 to (lbSize _list - 1) do {
        if (toLower (_list lbText _i) == _wanted) exitWith {_row = _i};
    };
    if (_row < 0) then {
        for "_i" from 0 to (lbSize _list - 1) do {
            if ((toLower (_list lbText _i)) find _wanted >= 0) exitWith {_row = _i};
        };
    };
    if (_row >= 0) then {
        _list lbSetCurSel _row;
        ctrlSetFocus _list;
    };
};
