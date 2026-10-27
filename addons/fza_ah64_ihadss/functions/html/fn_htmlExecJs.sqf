/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlExecJs

Description:
    Runs JavaScript in a CT_WEBBROWSER control. The command is compiled from a
    string once, because HEMTT cannot parse ctrlWebBrowserAction directly.

Parameters:
    _ctrl - Browser control
    _js   - JavaScript source

Returns:
    Nothing

Examples:
    --- Code
    [_ctrl, "fzaIhadss.clear()"] call fza_ihadss_fnc_htmlExecJs
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_ctrl", controlNull], ["_js", ""]];
if (isNull _ctrl || {_js isEqualTo ""}) exitWith {};
if (isNil "fza_ihadss_execJsCode") then {
    fza_ihadss_execJsCode = compileFinal "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
};
[_ctrl, _js] call fza_ihadss_execJsCode;
