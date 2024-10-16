/* ----------------------------------------------------------------------------
Function: fza_fnc_updateNetworkGlobal

Description:
    helps to reduce the network impact of using Public Variables
    by checking if there already of equal value and only sending
    the difference

Parameters:
    ...

Returns:
    ...

Examples:
    [_heli, "FUNCTION", 1] call fza_fnc_updateNetworkGlobal;
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_function", "_value"];

private _functionValue = _heli getvariable _function;

if (_functionValue isNotEqualTo _value) then {
    _heli setVariable [_function, _value, true];
};