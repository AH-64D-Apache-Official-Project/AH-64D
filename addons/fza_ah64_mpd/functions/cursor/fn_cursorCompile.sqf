/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorCompile

Description:
    Turns an MPD draw class condition into an SQF expression of its value,
    reading the MFD user values from _u. The MPD's conditions are made of
    numbers, userN, + - * / < >, brackets and "x factor [lo, hi]"; a
    comparison gives 1 or 0, as in the MFD. Any other name (heading,
    horizonBank) is not supported.

Parameters:
    _condition - The condition, as the config gives it

Returns:
    The SQF expression, or "" when the condition can't be turned into one

Examples:
    --- Code
    ["(((user1)>((5) - 1))*((user1)<((5) + 1)))"] call fza_mpd_fnc_cursorCompile
    // => "(([0, 1] select (((_u select 1)) > (((5) - 1)))) * ...)"
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_condition"];

private _chars = toArray _condition;
private _count = count _chars;
private _tokens = [];
private _i = 0;
private _isDigit = {(_this >= 48 && _this <= 57) || _this == 46};
private _isLetter = {(_this >= 65 && _this <= 90) || (_this >= 97 && _this <= 122) || _this == 95};
while {_i < _count} do {
    private _c = _chars # _i;
    private _start = _i;
    switch (true) do {
        case (_c <= 32): {
            _i = _i + 1;
        };
        case (_c call _isDigit): {
            while {_i < _count && {(_chars # _i) call _isDigit}} do {_i = _i + 1};
            if (_i < _count && {(_chars # _i) in [69, 101]}) then {
                _i = _i + 1;
                if (_i < _count && {(_chars # _i) in [43, 45]}) then {_i = _i + 1};
                while {_i < _count && {(_chars # _i) call _isDigit}} do {_i = _i + 1};
            };
            _tokens pushBack toString (_chars select [_start, _i - _start]);
        };
        case (_c call _isLetter): {
            while {_i < _count && {((_chars # _i) call _isLetter) || {(_chars # _i) call _isDigit}}} do {_i = _i + 1};
            _tokens pushBack toLower toString (_chars select [_start, _i - _start]);
        };
        default {
            _i = _i + 1;
            _tokens pushBack toString [_c];
        };
    };
};

// Recursive descent, from the loosest: comparison, factor, sum, product, then a number, userN, a bracket or a negation
private _at = 0;
private _bad = false;
private _peek = {_tokens param [_at, ""]};
private _expect = {
    if ((call _peek) != _this) then {_bad = true};
    _at = _at + 1;
};
private _comparison = {};
private _primary = {
    private _token = call _peek;
    _at = _at + 1;
    if (_token == "(") exitWith {
        private _inner = call _comparison;
        ")" call _expect;
        "(" + _inner + ")"
    };
    if (_token == "-") exitWith {"(-" + (call _primary) + ")"};
    if (_token select [0, 4] == "user" && {count _token > 4}) exitWith {format ["(_u select %1)", parseNumber (_token select [4])]};
    if ((toArray _token param [0, 0]) call _isDigit) exitWith {_token};
    _bad = true;
    "0"
};
private _product = {
    private _left = call _primary;
    while {(call _peek) in ["*", "/"]} do {
        private _op = call _peek;
        _at = _at + 1;
        _left = format ["(%1 %2 %3)", _left, _op, call _primary];
    };
    _left
};
private _sum = {
    private _left = call _product;
    while {(call _peek) in ["+", "-"]} do {
        private _op = call _peek;
        _at = _at + 1;
        _left = format ["(%1 %2 %3)", _left, _op, call _product];
    };
    _left
};
private _factor = {
    private _left = call _sum;
    while {(call _peek) == "factor"} do {
        _at = _at + 1;
        "[" call _expect;
        private _lo = call _comparison;
        "," call _expect;
        private _hi = call _comparison;
        "]" call _expect;
        _left = format ["(((((%1) - (%2)) / (((%3) - (%2)) max 1e-9)) max 0) min 1)", _left, _lo, _hi];
    };
    _left
};
_comparison = {
    private _left = call _factor;
    while {(call _peek) in ["<", ">"]} do {
        private _op = call _peek;
        _at = _at + 1;
        _left = format ["([0, 1] select (%1 %2 %3))", _left, _op, call _factor];
    };
    _left
};

private _expression = call _comparison;
if (_bad || {_at != count _tokens}) exitWith {""};
_expression
