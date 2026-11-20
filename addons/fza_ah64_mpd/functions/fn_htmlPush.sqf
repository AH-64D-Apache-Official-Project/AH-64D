/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlPush

Description:
    Pushes a JSON payload to an HTML MPD page. An identical payload is skipped,
    apart from a once-a-second resend that recovers a push the browser dropped
    while the page was still loading.

Parameters:
    _ctrl   - Browser control (see fza_mpd_fnc_htmlCtrl)
    _jsFunc - JS function to call, e.g. "fzaFCRScope.update"
    _json   - JSON text passed as the single argument
    _slot   - (optional) Name of the payload, for a page sent more than one, each compared with its own last

Returns:
    Nothing

Examples:
    --- Code
    [_ctrl, "fzaFCRScope.update", _json] call fza_mpd_fnc_htmlPush
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_ctrl", controlNull], "_jsFunc", "_json", ["_slot", ""]];
if (isNull _ctrl) exitWith {};

private _var = "fza_mpd_htmlLast" + _slot;
(_ctrl getVariable [_var, ["", -10]]) params ["_lastJson", "_lastTick"];
// A page that says it is ready (fza_fcr_fnc_displayUiInit) is sent everything again now, as what it was sent while
// loading was lost
if (_lastJson isNotEqualTo _json || { _lastTick < (_ctrl getVariable ["fza_mpd_htmlReadyAt", -1]) } || { diag_tickTime - _lastTick > 1 }) then {
    _ctrl setVariable [_var, [_json, diag_tickTime]];
    // Guarded on the page object, which does not exist until the page script has run
    private _jsObj = (_jsFunc splitString ".") # 0;
    [_ctrl, "if(window." + _jsObj + "){" + _jsFunc + "(" + _json + ")}"] call fza_mpd_fnc_execJs;
};
