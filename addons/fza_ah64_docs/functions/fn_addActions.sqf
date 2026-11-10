/* ----------------------------------------------------------------------------
Function: fza_docs_fnc_addActions

Description:
    Adds the manual to the AH-64 Misc category (fza_ah64_setup) of the AH-64D's
    ACE interaction and self-interaction menus: a Manual entry, a child for
    each section and a grandchild for each page.

Parameters:
    None

Returns:
    Nothing

Examples:
    --- Code
    call fza_docs_fnc_addActions
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!hasInterface || {isNil "ace_interact_menu_fnc_createAction"}) exitWith {};

private _open = {[_this select 2] call fza_docs_fnc_open};
private _nav = call fza_docs_fnc_nav;

{
    _x params ["_type", "_parent"];

    private _root = ["fza_docs", "Manual", "", _open, {true}, {}, "/"] call ace_interact_menu_fnc_createAction;
    private _rootPath = ["fza_ah64base", _type, _parent, _root, true] call ace_interact_menu_fnc_addActionToClass;

    {
        _x params ["_sectionTitle", "_pages"];
        if (_pages isEqualTo []) then {continue};

        private _section = [
            format ["fza_docs_s%1", _forEachIndex], _sectionTitle, "", _open, {true}, {}, (_pages select 0) select 1
        ] call ace_interact_menu_fnc_createAction;
        private _sectionPath = ["fza_ah64base", _type, _rootPath, _section, true] call ace_interact_menu_fnc_addActionToClass;

        {
            _x params ["_title", "_path"];
            private _page = [format ["fza_docs_p%1", _forEachIndex], _title, "", _open, {true}, {}, _path] call ace_interact_menu_fnc_createAction;
            ["fza_ah64base", _type, _sectionPath, _page, true] call ace_interact_menu_fnc_addActionToClass;
        } forEach _pages;
    } forEach _nav;
} forEach [[0, ["ACE_MainActions", "fza_misc"]], [1, ["ACE_SelfActions", "fza_misc"]]];
