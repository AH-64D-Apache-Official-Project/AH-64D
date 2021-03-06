/* ----------------------------------------------------------------------------
Function: fza_fnc_tsdRange

Description:
    cycles through the ranges for the TSD
    
Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_tsdRange;

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(driver _heli == player || gunner _heli == player)) exitwith {};

_range = (_heli getVariable "fza_ah64_rangesetting") * 2;
if (_range == 0.00008) then {
    _range = 0.0001;
};
if (_range == 0.0004) then {
    _range = 0.0005;
};
if (_range == 0.002) then {
    _range = 0.00002;
};
_heli setVariable ["fza_ah64_rangesetting", _range];