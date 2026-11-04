/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorPick

Description:
    The VAB whose label is under an MPD cursor position: of the labels drawn
    now (fza_mpd_fnc_cursorLabels), the nearest part, text or arrow, that the
    cursor is on or within a margin of.

Parameters:
    _heli - The helicopter
    _side - 0 left MPD, 1 right
    _posX - Cursor X, 0 left to 1 right
    _posY - Cursor Y, 0 top to 1 bottom

Returns:
    The VAB number (1-6 L1-L6, 7-12 R1-R6, 13-18 T1-T6, 19-24 B1-B6), 0 for none

Examples:
    --- Code
    [_heli, 0, 0.06, 0.22] call fza_mpd_fnc_cursorPick
    // => 1
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli", "_side", "_posX", "_posY"];

private _labels = ((missionNamespace getVariable ["fza_mpd_cursorLabels", createHashMap]) getOrDefault [typeOf _heli, []]) param [_side, createHashMap];
if (count _labels == 0) exitWith {0};

// The VABs whose labels can reach the cursor
private _vabs = [];
{
    if (abs (_posY - _x) < 0.15) then {_vabs pushBack (([1, 7] select (_posX > 0.5)) + _forEachIndex)};
} forEach [MPD_POS_BUTTON_LR_1_Y, MPD_POS_BUTTON_LR_2_Y, MPD_POS_BUTTON_LR_3_Y, MPD_POS_BUTTON_LR_4_Y, MPD_POS_BUTTON_LR_5_Y, MPD_POS_BUTTON_LR_6_Y];
if (_posY < 0.15 || {_posY > 0.85}) then {
    {
        if (abs (_posX - _x) < 0.15) then {_vabs pushBack (([13, 19] select (_posY > 0.5)) + _forEachIndex)};
    } forEach [MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_TB_6_X];
};

private _values = [];
private _texts = [];
private _best = 0;
private _bestDistance = 1e9;
{
    private _vab = _x;
    {
        private _part = _x;
        private _box = [];
        if (_part # 1 == 0) then {
            _part params ["", "", "_labelX", "_labelY", "_align", "_advance", "_height", "_text"];
            if (_text isEqualType 0 && {_text >= 0}) then {
                if (_texts isEqualTo []) then {_texts = getUserMFDText _heli};
                _text = _texts param [_text, ""];
            };
            private _length = if (_text isEqualType "") then {count _text} else {3};
            if (_length == 0) exitWith {};
            private _width = _advance * _length;
            private _left = _labelX - [0, _width / 2, _width] # _align;
            _box = [_left, _labelY, _left + _width, _labelY + _height];
        } else {
            _box = _part select [2, 4];
        };
        if (_box isEqualTo []) then {continue};
        _box params ["_x0", "_y0", "_x1", "_y1"];
        if (_posX < _x0 - MPD_CURSOR_PICK_PAD || {_posX > _x1 + MPD_CURSOR_PICK_PAD} || {_posY < _y0 - MPD_CURSOR_PICK_PAD} || {_posY > _y1 + MPD_CURSOR_PICK_PAD}) then {continue};
        if (_values isEqualTo []) then {_values = getUserMFDValue _heli};
        if !([_values] call (_part # 0)) then {continue};
        private _distance = (_posX - (_x0 + _x1) / 2) ^ 2 + (_posY - (_y0 + _y1) / 2) ^ 2;
        if (_distance < _bestDistance) then {
            _bestDistance = _distance;
            _best = _vab;
        };
    } forEach (_labels getOrDefault [_vab, []]);
} forEach _vabs;

// No label there: the button itself, at its place on the edge, for a button with nothing drawn by it (the COORD page's
// rows)
if (_best == 0) then {
    if (_posX < MPD_CURSOR_L_MAX_X || {_posX > MPD_CURSOR_R_MIN_X}) then {
        private _row = [MPD_POS_BUTTON_LR_1_Y, MPD_POS_BUTTON_LR_2_Y, MPD_POS_BUTTON_LR_3_Y, MPD_POS_BUTTON_LR_4_Y, MPD_POS_BUTTON_LR_5_Y, MPD_POS_BUTTON_LR_6_Y] findIf {abs (_posY - _x) < MPD_CURSOR_BUTTON_REACH};
        if (_row >= 0) then {_best = ([1, 7] select (_posX > 0.5)) + _row};
    };
    if (_posY < MPD_CURSOR_T_MAX_Y || {_posY > MPD_CURSOR_B_MIN_Y}) then {
        private _col = [MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_TB_4_X, MPD_POS_BUTTON_TB_5_X, MPD_POS_BUTTON_TB_6_X] findIf {abs (_posX - _x) < MPD_CURSOR_BUTTON_REACH};
        if (_col >= 0) then {_best = ([13, 19] select (_posY > 0.5)) + _col};
    };
};

_best
