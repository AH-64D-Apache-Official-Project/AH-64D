/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorUpdate

Description:
    Each frame, the crew station's MPD cursor. The cursor direction actions move
    it, faster the further they are pushed and the longer they are held. Held
    against the inner edge of an MPD, let go and pushed over it again, it goes
    to the other MPD. Three minutes after it was last used it is stowed in the
    lower left corner, unless it rests on a VAB label or point of the TSD or an
    FCR page. The labels of the VAB it is on (fza_mpd_fnc_cursorPick) are drawn
    bold; a TSD point it is on (fza_mpd_fnc_cursorPoint), over a black circle.

    Local to the crew station's client, as the cursors of the two crew stations
    are independent of each other. The MPDs draw it from MFD_IND_CURSOR_X and
    MFD_IND_CURSOR_Y, and the bold labels from MFD_IND_CURSOR_VAB.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_cursorUpdate
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli"];

// The VAB labels, found once per helicopter type
private _labels = missionNamespace getVariable "fza_mpd_cursorLabels";
if (isNil "_labels") then {
    _labels = createHashMap;
    missionNamespace setVariable ["fza_mpd_cursorLabels", _labels];
};
if !(typeOf _heli in _labels) then {
    _labels set [typeOf _heli, []];
    [_heli] spawn fza_mpd_fnc_cursorLabels;
};

private _deltaTime = (["fza_mpd_cursor"] call BIS_fnc_deltaTime) min 0.1;
private _cursor = _heli getVariable "fza_mpd_cursor";
if (isNil "_cursor") then {
    // [MPD, X, Y, last used, input held for, double bump armed, VAB it is on, looked for at, TSD point it is on]
    _cursor = [0, MPD_CURSOR_STOW_X, MPD_CURSOR_STOW_Y, time, 0, false, 0, -1, []];
    _heli setVariable ["fza_mpd_cursor", _cursor];
};
_cursor params ["_side", "_posX", "_posY", "_usedAt", "_heldFor", "_bumpArmed", ["_hover", 0, [0]], ["_pickedAt", -1], ["_point", [], [[]]]];

private _pages = [toLower ([_heli, 0] call fza_mpd_fnc_currentPage), toLower ([_heli, 1] call fza_mpd_fnc_currentPage)];
private _live = _pages # _side != "off";

private _inX = inputAction "fza_ah64_mpdCursorRight" - inputAction "fza_ah64_mpdCursorLeft";
private _inY = inputAction "fza_ah64_mpdCursorDown" - inputAction "fza_ah64_mpdCursorUp";
if !(finite _inX && {finite _inY} && {_live}) then {_inX = 0; _inY = 0};
_inX = (_inX max -1) min 1;
_inY = (_inY max -1) min 1;
private _pushed = sqrt (_inX * _inX + _inY * _inY) > MPD_CURSOR_DEADZONE;

if (_pushed) then {
    _heldFor = _heldFor + _deltaTime;
    _usedAt = time;
    private _rate = MPD_CURSOR_RATE_MIN + (MPD_CURSOR_RATE_MAX - MPD_CURSOR_RATE_MIN) * ((_heldFor / MPD_CURSOR_RAMP) min 1);
    _posX = ((_posX + _inX * _rate * _deltaTime) max 0) min 1;
    _posY = ((_posY + _inY * _rate * _deltaTime) max 0) min 1;
} else {
    _heldFor = 0;
};

// The left MPD's right edge faces the right MPD's left edge
private _atEdge = [_posX >= 1, _posX <= 0] select _side;
private _outward = [_inX, -_inX] select _side;
if (!_atEdge) then {_bumpArmed = false};
if (_atEdge && {!_pushed}) then {_bumpArmed = true};
if (_bumpArmed && {_outward > 0.5} && {_pages # (1 - _side) != "off"}) then {
    _side = 1 - _side;
    _posX = [1, 0] select _side;
    _bumpArmed = false;
    _live = true;
    _pickedAt = -1;
};

if (time - _usedAt > MPD_CURSOR_STOW_TIME && {_posX != MPD_CURSOR_STOW_X || {_posY != MPD_CURSOR_STOW_Y}}
    && {!((_pages # _side) in ["tsd", "fcr", "fcrrmap", "fcrtpm"] && {_hover > 0 || {_point isNotEqualTo []} || {[_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorInArea}})}) then {
    _posX = MPD_CURSOR_STOW_X;
    _posY = MPD_CURSOR_STOW_Y;
    _pickedAt = -1;
};

// Looked for while it moves, and now and then while it is still, as the page can change under it
// A label first, then a point on the TSD pages that take one
if (!_live) then {
    _hover = 0;
    _point = [];
} else {
    if (_pushed || {diag_tickTime - _pickedAt > MPD_CURSOR_PICK_EVERY}) then {
        _hover = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPick;
        _point = [];
        if (_hover == 0) then {_point = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPoint};
        _pickedAt = diag_tickTime;
    };
};

_heli setVariable ["fza_mpd_cursor", [_side, _posX, _posY, _usedAt, _heldFor, _bumpArmed, _hover, _pickedAt, _point]];

_heli setUserMFDValue [MFD_IND_CURSOR_X, [0, 1 + 2 * _side + _posX] select _live];
_heli setUserMFDValue [MFD_IND_CURSOR_Y, _posY];

{
    _heli setUserMFDValue [_x + MFD_IND_CURSOR_VAB, [0, 100 + _hover] select (_forEachIndex == _side && {_hover > 0})];
} forEach [MFD_OFFSET_L, MFD_OFFSET_R];
