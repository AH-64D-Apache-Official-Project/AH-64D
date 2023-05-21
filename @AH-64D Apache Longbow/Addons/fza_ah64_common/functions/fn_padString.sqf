
/* ----------------------------------------------------------------------------
Function: fza_fnc_padString

Description:
    Pads a string to ensure that it is within a fixed size

    _to being string is slightly more performant

Parameters:
    _str - (String) The string to pad or trim
    _to - (String or Number) the expected output size as a number or a string of
            n characters to use as blank spaces
    _right - (Bool) (Optional) (Default: false) whether the spaces should be
            placed on the right

Returns:
    A padded string

Examples:
    --- Code
    ["test", 5] call fza_fnc_padString
    // " test"

    ["test", 5, true] call fza_fnc_padString
    // "test "

    ["test", 3] call fza_fnc_padString
    // "est"

    ["test", 3, true] call fza_fnc_padString
    // "tes"

    ["test", "     "] call fza_fnc_padString
    // " test"

    ["test", "     ", true] call fza_fnc_padString
    // "test "
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params
    [ "_str"
    , ["_to",0, ["", 0]]
    , ["_right", false]
    ];

private ["_add", "_length"];
if (_to isEqualType "") then {
    _add = _to;
    _length = count _to;
} else {
    _add = [];
    _add resize _to;
    _add = (_add apply {" "}) joinString "";
    _length = _to;
};

if (_right) exitWith {
    (_str + _add) select [0, _length];
};
(_add + _str) select [count _str, _length];
