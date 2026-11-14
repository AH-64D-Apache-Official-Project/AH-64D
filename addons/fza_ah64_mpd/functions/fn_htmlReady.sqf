/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlReady

Description:
    Listens for an HTML MPD page's ready message, "fza:ready" (A3API.SendAlert),
    sent once its script has run. fza_mpd_fnc_htmlPush then sends the page its
    data again, as what was sent while it loaded was lost.

Parameters:
    _browser - The page's browser control, may be null

Returns:
    Nothing

Examples:
    --- Code
    [_display displayCtrl 369] call fza_mpd_fnc_htmlReady
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_browser", controlNull]];
if (isNull _browser) exitWith {};

// The only message these pages send
_browser ctrlAddEventHandler [["JS", "Dialog"] joinString "", {
    params ["_control", "_isConfirmDialog", "_message"];
    if (_isConfirmDialog || {_message isNotEqualTo "fza:ready"}) exitWith {false};
    _control setVariable ["fza_mpd_htmlReadyAt", diag_tickTime];
    true
}];
