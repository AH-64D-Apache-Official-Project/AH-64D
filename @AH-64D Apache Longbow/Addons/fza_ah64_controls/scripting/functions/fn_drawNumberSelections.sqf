/* ----------------------------------------------------------------------------
Function: fza_fnc_drawNumberSelections

Description:
	Displays a number on a series of named selections in the given 'font'

Parameters:
	_obj - The object to draw the digits on.
	_num - The number to input.
	_font - The texture 'font' to use.
	_sels - The list of selections to display upon. The order should be the first index being the RIGHTMOST selection, and the last the LEFTMOST. For example, if the selections were ordered "abc", they must be inputted "cba"
	_min - (optional) the minimum value (default 0). Must be non-negative
	_max - (optional) the maximum value (default 0). Must be less than (10^n)-1 (n being the number of named selections)

Returns:
	Nothing

Examples:
    --- Code
	_selections = [SEL_MPD_PL_FLT_SPD1, SEL_MPD_PL_FLT_SPD2, SEL_MPD_PL_FLT_SPD3];
	[_heli, 1000, "\fza_ah64_us\tex\CHAR\G", _selections] call fza_fnc_drawNumberSelections;
	//Draws "999" on the display
    ---

	--- Code
	_result = [_heli, 1000, "\fza_ah64_us\tex\CHAR\G", _selections, 0, 130] call fza_fnc_drawNumberSelections;
	//Draws "130" on the display
    ---

	--- Code
	_result = [_heli, 0, "\fza_ah64_us\tex\CHAR\G", _selections, 10, 130] call fza_fnc_drawNumberSelections;
	//Draws "10" on the display
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"

params ["_obj", "_num", "_font", "_sels", "_min", "_max"];

private _min = if(isNil "_min" || {_min < 0}) then {0} else {_min};

private _max = if(isNil "_max" || {_max > (10^(count _sels))-1}) then {(10^(count _sels))-1} else {_max};

_num = [round _num, _min, _max] call BIS_fnc_clamp;

_digits = _num call BIS_fnc_numberDigits;
reverse _digits;

while {count _sels > count _digits} do {
	_digits pushBack 0;
};

{
	_obj setObjectTexture [_x, format ["%1%2_ca.paa", _font, _digits # _forEachIndex]];
} forEach _sels;