/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_setArrayVariable

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
params ["_heli", "_variableName", "_index", "_value"];

private _temp = (_heli getVariable _variableName);
_temp set [_index, _value];
_heli setVariable[_variableName, _temp, true];