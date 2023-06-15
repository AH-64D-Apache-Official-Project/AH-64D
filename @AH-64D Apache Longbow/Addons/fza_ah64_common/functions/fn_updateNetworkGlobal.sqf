/* ----------------------------------------------------------------------------
Function: fza_fnc_updateNetworkGlobal

Description:
    helps to reduce the network impact of using Public Variables
    by checking if there already of equal value and only pushing 
    those not different

Parameters:
    ...

Returns:
    ...

Examples:
    [_heli, "FUNCTION", 1] call fza_fnc_updateNetworkGlobal;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_function", "_value"];

private _functionValue = _heli getvariable _function;

if (_functionValue isNotEqualTo _value) then {
    _heli setVariable [_function, _value, true];
};