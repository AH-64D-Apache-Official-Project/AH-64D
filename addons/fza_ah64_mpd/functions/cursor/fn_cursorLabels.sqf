/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorLabels

Description:
    Finds the labels of the VABs in the helicopter's MPD draw config, for the
    MPD cursor, and keeps them for the mission (fza_mpd_cursorLabels) by
    helicopter type. A label is anything with a bold copy (headers\cursor.h):
    its text and arrows, and the symbols some pages give a button. The copy's
    condition starts with the label's place and alignment, which give its VAB
    by the rules there, and its own text or line is where the cursor chooses
    it. Per MPD, a hash map of VAB number (1-6 L1-L6, 7-12 R1-R6, 13-18 T1-T6,
    19-24 B1-B6) to its parts, each with the code that tells from the MFD user
    values whether it is drawn (fza_mpd_fnc_cursorCompile) and either its text
    (place, alignment, size, and a string, a user text index, or -1 for a
    number) or its box. Reads every draw class, so is spawned once
    (fza_mpd_fnc_cursorUpdate).

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] spawn fza_mpd_fnc_cursorLabels
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli"];

private _splits = [0, 1, 2, 3, 4] apply {MPD_CURSOR_ROW_SPLIT + _x * MPD_CURSOR_ROW_PITCH};
private _expressions = createHashMap;
private _chains = createHashMap;

// The VAB of a label at startX, startY (the top of its text) with an alignment (0 right, 1 centre, 2 left)
private _vabOf = {
    params ["_startX", "_startY", "_align"];
    private _inRows = _startY > MPD_CURSOR_ROWS_TOP && {_startY < MPD_CURSOR_ROWS_BOTTOM};
    private _row = {_startY > _x} count _splits;
    if (_inRows && {_align == 0} && {_startX < MPD_CURSOR_L_MAX_X}) exitWith {1 + _row};
    if (_inRows && {_align == 2} && {_startX > MPD_CURSOR_R_MIN_X}) exitWith {7 + _row};
    private _tolerance = [MPD_CURSOR_COL_EDGE, MPD_CURSOR_COL_TOL] select (_align == 1);
    private _col = [0, 1, 2, 3, 4, 5] findIf {abs (_startX - (MPD_POS_BUTTON_TB_1_X + _x * MPD_CURSOR_COL_PITCH)) < _tolerance};
    if (_col < 0) exitWith {0};
    if (_startY < MPD_CURSOR_T_MAX_Y) exitWith {13 + _col};
    if ((_startY > MPD_CURSOR_B_MIN_Y && {_startY < MPD_CURSOR_B_MAX_Y}) || {_startY > MPD_CURSOR_B2_MIN_Y && {_startY < MPD_CURSOR_B2_MAX_Y}}) exitWith {19 + _col};
    0
};

// A point at a fixed place, {x, y} or {"Null", {x, y}, 1}, whose numbers can be expressions; [] if a bone moves it
private _point = {
    params ["_p"];
    private _xy = [];
    if ((_p param [0, 0]) isEqualType []) then {_xy = _p # 0};
    if (count _p == 3 && {(_p # 0) isEqualType ""} && {(_p # 0) == "Null"} && {(_p # 1) isEqualType []}) then {_xy = _p # 1};
    if (count _xy != 2) exitWith {[]};
    _xy = _xy apply {if (_x isEqualType "") then {call compile _x} else {_x}};
    if !(_xy isEqualTypeAll 0) exitWith {[]};
    _xy
};

private _addPart = {
    params ["_cfg", "_chain", "_vab"];

    // The code telling whether it is drawn, [] if a condition can't be read
    private _key = _chain joinString "|";
    private _code = _chains getOrDefault [_key, false];
    if (_code isEqualTo false) then {
        private _parts = _chain apply {
            private _sqf = _expressions get _x;
            if (isNil "_sqf") then {
                _sqf = [_x] call fza_mpd_fnc_cursorCompile;
                _expressions set [_x, _sqf];
            };
            _sqf
        };
        _code = [];
        if !("" in _parts) then {
            private _body = "true";
            if (_parts isNotEqualTo []) then {
                _body = format ["(%1) > 0", _parts # 0];
                for "_k" from 1 to (count _parts - 1) do {_body = _body + format [" && {(%1) > 0}", _parts # _k]};
            };
            _code = compile ("params ['_u']; " + _body);
        };
        _chains set [_key, _code];
    };
    if (_code isEqualTo []) exitWith {};

    private _part = [];
    switch (toLower getText (_cfg >> "type")) do {
        case "text": {
            private _pos = [getArray (_cfg >> "pos")] call _point;
            private _right = [getArray (_cfg >> "right")] call _point;
            private _down = [getArray (_cfg >> "down")] call _point;
            if (_pos isEqualTo [] || {_right isEqualTo []} || {_down isEqualTo []}) exitWith {};
            private _align = ["right", "center", "left"] find toLower getText (_cfg >> "align");
            if (_align < 0) then {_align = 2};
            private _text = switch (toLower getText (_cfg >> "source")) do {
                case "static": {getText (_cfg >> "text")};
                case "usertext": {getNumber (_cfg >> "sourceIndex")};
                default {-1};
            };
            // The copy is drawn a little to the right of its label
            _part = [_code, 0, (_pos # 0) - MPD_CURSOR_BOLD, _pos # 1, _align, (_pos distance2D _right) * MPD_TEXT_WIDTH / MPD_TEXT_WIDTH_VEC, _pos distance2D _down, _text];
        };
        case "line";
        case "polygon": {
            private _points = getArray (_cfg >> "points");
            if (toLower getText (_cfg >> "type") == "polygon") then {
                private _polygons = _points;
                _points = [];
                {_points append _x} forEach _polygons;
            };
            private _xys = (_points apply {[_x] call _point}) select {_x isNotEqualTo []};
            if (_xys isEqualTo []) exitWith {};
            private _xs = _xys apply {_x # 0};
            private _ys = _xys apply {_x # 1};
            _part = [_code, 1, selectMin _xs, selectMin _ys, selectMax _xs, selectMax _ys];
        };
    };
    if (_part isEqualTo []) exitWith {};

    private _list = _labels getOrDefault [_vab, []];
    _list pushBack _part;
    _labels set [_vab, _list];
};

private _walk = {
    params ["_cfg", "_chain"];
    if ((configName _cfg) select [0, 8] == "Mpd_Bold") exitWith {
        // Its label's place and alignment start its condition: (0*(startX)*(startY)*(alignment))+...
        private _params = (getText (_cfg >> "condition")) splitString "()*+";
        private _vab = [parseNumber (_params param [1, ""]), parseNumber (_params param [2, ""]), parseNumber (_params param [3, ""])] call _vabOf;
        if (_vab == 0) exitWith {};
        {
            [_x, _chain, _vab] call _addPart;
        } forEach ("true" configClasses _cfg);
    };
    // A copy, as the parent's chain is its other children's too
    _chain = +_chain;
    private _condition = _cfg >> "condition";
    if (isText _condition) then {_chain pushBack getText _condition};
    if (isNumber _condition) then {_chain pushBack str getNumber _condition};
    {
        [_x, _chain] call _walk;
    } forEach ("true" configClasses _cfg);
};

private _mfd = configOf _heli >> "MFD";
private _sides = ["MPD_L", "MPD_R"] apply {
    private _labels = createHashMap;
    {
        // Not the cursor's own classes
        if ((configName _x) select [0, 6] != "Cursor") then {[_x, []] call _walk};
    } forEach ("true" configClasses (_mfd >> _x >> "Draw"));
    _labels
};

(missionNamespace getVariable "fza_mpd_cursorLabels") set [typeOf _heli, _sides];
