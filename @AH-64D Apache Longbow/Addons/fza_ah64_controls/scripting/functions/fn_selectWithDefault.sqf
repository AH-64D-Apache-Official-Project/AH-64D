/* ----------------------------------------------------------------------------
Function: fza_fnc_selectWithDefault

Description:
    Allows for you to run a select operation while providing a default for if the index is out of range

Parameters:
    _arr - the array to search
    _index - the index to get an element from
    _default - the default if there isn't a valid element

Returns:
	Value at index of array, or the default

Examples:
    Valid and in index
	--- Code
    _ret = [[0,1,2,3], 0, -1] call fza_fnc_selectWithDefault
    //_ret => 0
    ---
    
    Below valid index
    --- Code
    _ret = [[0,1,2,3], -2, -1] call fza_fnc_selectWithDefault
    //_ret => -1
    ---

    Above valid index
    --- Code
    _ret = [[0,1,2,3], 4, -1] call fza_fnc_selectWithDefault
    //_ret => -1
    ---
Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_arr", "_index", "_default"];

if(_index < 0 || count _arr <= _index) then{
    _default
} else {
    _arr # _index
}