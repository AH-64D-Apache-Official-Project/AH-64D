/* ----------------------------------------------------------------------------
Function: fza_docs_fnc_open

Description:
    Opens the manual at a page. The manual is the copy of the online manual
    built into the mod (tools/docsSnapshot.js). With the manual already open,
    the page changes in place.

Parameters:
    _path - Site path of the page, e.g. "/displays/mpd/tsd/"; "" keeps the last page <STRING>

Returns:
    Nothing

Examples:
    --- Code
    ["/flying/startup/"] call fza_docs_fnc_open
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_path", "", [""]]];

if (!hasInterface) exitWith {};

if (_path isEqualTo "") then {_path = uiNamespace getVariable ["fza_docs_path", "/"]};
uiNamespace setVariable ["fza_docs_path", _path];

private _display = uiNamespace getVariable ["fza_docs_display", displayNull];
// A new manual asks for the page once it has loaded
if (isNull _display) exitWith {createDialog "RscFzaDocs"};

private _payload = createHashMapFromArray [["type", "go"], ["path", _path]];
[_display displayCtrl 100, "window.fzaDocs && window.fzaDocs.receive(" + toJSON _payload + ");"] call fza_mpd_fnc_execJs;
