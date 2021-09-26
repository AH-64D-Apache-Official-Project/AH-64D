params ["_system", "_control", "_pilotMempoint", "_gunnerMempoint", "_value"];

if (!_value) exitWith {};
if !(vehicle player isKindOf "fza_ah64base") exitWith {};

private _heli = vehicle player;

// Ensure that the player actually has one of the controls in their cockpit.
if !((player == driver _heli && _pilotMempoint != "") || (player == gunner _heli && _gunnerMempoint != "")) exitwith {};

[_heli, _system, _control] call fza_fnc_coreCockpitInteract;