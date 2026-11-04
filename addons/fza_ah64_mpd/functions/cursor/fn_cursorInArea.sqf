/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorInArea

Description:
    Whether an MPD cursor position is over the area its page chooses symbols
    from: the TSD's map, inside its border, or the FCR's target area, the GTM
    scan sector out to 8 km (the zoomed area while zoomed), the ATM circle or
    the RMAP radar picture.

Parameters:
    _heli - The helicopter
    _side - 0 left MPD, 1 right
    _posX - Cursor X, 0 left to 1 right
    _posY - Cursor Y, 0 top to 1 bottom

Returns:
    True if it is

Examples:
    --- Code
    [_heli, 1, 0.5, 0.5] call fza_mpd_fnc_cursorInArea
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli", "_side", "_posX", "_posY"];

((_heli getVariable "fza_mpd_mpdState") # _side) params ["_page", "", "", "", "_state"];
switch (toLower _page) do {
    case "tsd": {
        _posX > 0.095 && {_posX < 0.905} && {_posY > 0.095} && {_posY < 0.905}
    };
    case "fcr": {
        if ((_heli getVariable ["fza_ah64_fcrMode", FCR_DISP_MODE_OFF]) == FCR_DISP_MODE_ATM) exitWith {
            [_posX, _posY] distanceSqr [0.5, 0.5] < 0.325 ^ 2
        };
        if (_state getOrDefault ["zoom", 0] == 2) exitWith {
            abs (_posX - 0.5) < MPD_CURSOR_ZOOM_VIEW_HALF && {abs (_posY - 0.5) < MPD_CURSOR_ZOOM_VIEW_HALF}
        };
        private _dx = _posX - 0.5;
        private _dy = 0.87 - _posY;
        _dy > abs _dx && {_dx ^ 2 + _dy ^ 2 < 0.65 ^ 2}
    };
    // The RMAP radar picture, in the browser at 0.025 to 0.975 (rmap.js)
    case "fcrrmap": {
        _posX > 0.18 && {_posX < 0.82} && {_posY > 0.15} && {_posY < 0.875}
    };
    default {false};
};
