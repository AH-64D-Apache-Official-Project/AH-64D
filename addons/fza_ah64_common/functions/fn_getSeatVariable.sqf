/* ----------------------------------------------------------------------------
Function: fza_fnc_getSeatVariable

Description:
  Sets a public but seat-specific variable
  Defaults to the player's seat, but can be overriden by passing a specific seat name

Parameters:
  _heli - The helicopter for which the variable is set
  _key - The variable to be set
  _seat - The seat of the helicopter to set the variable to (default: player seat) 
      can also be "plt" or "cpg"

Returns:
  ...

Examples:
  [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable

Author:
  mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_key", "_seat", "_swap"];

_heli getVariable format["%1_%2", _key, [_heli, _seat, _swap] call fza_fnc_getSeat];
