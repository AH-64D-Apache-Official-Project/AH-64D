/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingFilterType

Description:
    Filters the input array of targets based on the fza_ah64_tsdsort setting of the input apache 

Parameters:
    _heli - The helicopter to act on
    _targs - The helicopter to act on

Returns:
    Array of targets

Examples:
    --- Code
    _ret = [_heli, [targ1, targ2, targ3]] call fza_fnc_targetingFilterType
    //_ret => [targ1, targ2] //Targ3 
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli", "_targs"];

_targFilter = _heli getVariable "fza_ah64_tsdsort";

switch (_targFilter) do {
    case 0: {_targs}; //All
    case 1: {_targs select {_x isKindOf "tank"}}; //Tracked
    case 2: {_targs select {[_x] call fza_fnc_targetIsADA}}; //Air defence artillery
    case 3: {_targs select {_x isKindOf "car"}}; //Wheeled
    case 4;
    case 5;
    case 6;
    case 7;
    case 8;
    case 9;
    case 10;
    case 11 : {
        _targs arrayIntersect (_heli getVariable "fza_ah64_pfzs" select (_targFilter - 4));
    };
};