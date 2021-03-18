/* ----------------------------------------------------------------------------
Function: fza_fnc_tsdFilter

Description:

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_tsdFilter;

Author:
---------------------------------------------------------------------------- */
params ["_heli"];

_tsdSort = (_heli getVariable "fza_ah64_tsdsort") + 1;
if (_tsdSort == 12) then {
    _tsdSort = 0;
};
_heli setVariable ["fza_ah64_tsdsort", _tsdSort, true]; 