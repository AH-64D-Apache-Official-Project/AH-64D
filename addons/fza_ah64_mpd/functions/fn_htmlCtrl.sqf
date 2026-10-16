/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlCtrl

Description:
    Returns the browser control of the HTML display behind an MPD's current page.

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left MPD, 1 right MPD

Returns:
    The browser control, controlNull when the page has no loaded HTML display

Examples:
    --- Code
    private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params ["_heli", "_mpdIndex"];

private _uniqueId = ((_heli getVariable ["fza_mpd_mpdState", []]) param [_mpdIndex, []]) param [9, ""];
if (_uniqueId == "") exitWith { controlNull };

private _display = (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
if (isNull _display) exitWith { controlNull };

_display displayCtrl 369
