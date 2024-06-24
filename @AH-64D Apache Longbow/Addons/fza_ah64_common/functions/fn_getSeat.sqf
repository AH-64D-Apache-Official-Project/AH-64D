/* ----------------------------------------------------------------------------
Function: fza_fnc_getSeat

Description:
  Gets the seat of a current player
  Allows for swapping seat position

Parameters:
  _heli - The helicopter for which the variable is set
  _seat - The seat of the helicopter to set the variable to (default: player seat) 
      can also be "plt" or "cpg"
  _swap - Swap the seat returned

Returns:
  ...

Examples:
  [_heli, player, true] call fza_fnc_getSeatVariable

  [_heli, "plt", false] call fza_fnc_getSeatVariable
  => "plt"

  [_heli, "plt", false] call fza_fnc_getSeatVariable
  => "cpg"

Author:
  mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", ["_seat", player], ["_swap", false]];

if (typeName _seat == "OBJECT") then {
    switch _seat do {
        case (driver _heli) : {_seat = "plt";};
        case (gunner _heli) : {_seat = "cpg";};
    };
};

if (typeName _seat != "STRING") exitWith {};

if (_swap) then {
    switch _seat do {
        case "plt" : {_seat = "cpg";};
        case "cpg" : {_seat = "plt";};
    };
};
_seat;