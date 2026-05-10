/* ----------------------------------------------------------------------------
Function: fza_fnc_setSeatVariable

Description:
  Sets a public but seat-specific variable
  Defaults to the player's seat, but can be overriden by passing a specific seat name

Parameters:
  _heli - The helicopter for which the variable is set
  _key - The variable to be set
  _value - The value to set
  _seat - The seat of the helicopter to set the variable to (default: player seat) 
      can also be "plt" or "cpg"

Returns:
  ...

Examples:
  [_heli, "fza_ah64_sight", 0] call fza_fnc_setSeatVariable

Author:
  mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_key", "_value", "_seat", "_swap"];

_heli setVariable [format["%1_%2", _key, [_heli, _seat, _swap] call fza_fnc_getSeat], _value, true];
