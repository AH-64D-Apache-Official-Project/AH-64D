/* ----------------------------------------------------------------------------
Function: fza_fnc_setMultiArrayVariable

Description:
  Sets a value in a 2D (nested) array variable stored on an object.

Parameters:
  _heli          - The object [Unit]
  _variableName  - Variable name [String]
  _index0        - Outer array index [Number]
  _index1        - Inner array index [Number]
  _value         - Value to set [Any]
  _public        - Broadcast to network (optional, default false) [Bool]

Returns:
  Nothing

Examples:
  [_heli, "fza_sfmplus_rotorBladeAzimuth", 0, 2, 45.0] call fza_fnc_setMultiArrayVariable;

Author:
  BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_variableName", "_index0", "_index1", "_value", ["_public", false]];

private _temp = +(_heli getVariable _variableName);
(_temp select _index0) set [_index1, _value];

if _public then {
    [_heli, _variableName, _temp] call fza_fnc_updateNetworkGlobal;
};
_heli setVariable [_variableName, _temp];
