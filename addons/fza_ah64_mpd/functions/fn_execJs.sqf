/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_execJs

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
    [_browserCtrl, "fzaFCRScope.update({})"] call fza_mpd_fnc_execJs
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_ctrl", controlNull], ["_js", ""]];
if (isNull _ctrl || { _js isEqualTo "" }) exitWith {};

if (isNil "fza_mpd_execJsCode") then {
    fza_mpd_execJsCode = compileFinal "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
};
[_ctrl, _js] call fza_mpd_execJsCode;
