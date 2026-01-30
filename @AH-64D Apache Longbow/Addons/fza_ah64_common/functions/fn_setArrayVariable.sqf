/* ----------------------------------------------------------------------------
Function: fza_fnc_setArrayVariable

Description:
  Sets a multi-variable array.

Parameters:
  ...

Returns:
  ...

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_variableName", "_index", "_value", ["_public", false]];

private _temp = +(_heli getVariable _variableName);
_temp set [_index, _value];

if _public then {
    [_heli, _variableName, _temp] call fza_fnc_updateNetworkGlobal;
};
_heli setVariable[_variableName, _temp];