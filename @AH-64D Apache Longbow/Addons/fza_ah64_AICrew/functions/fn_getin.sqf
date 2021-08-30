/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_getin


Description:
	handles what the ai does when he GETS IN

Parameters:
    vehicle: Object - Vehicle the event handler is assigned to
    role: String - Can be either "driver", "gunner" or "cargo"
    unit: Object - Unit that entered the vehicle
    Arma 3 logo black.png
1.36
 turret: Array - turret path

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_getin
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_role", "_unit", "_turret"];

if (_unit == driver _heli) then {
    sleep 1.2;
    _heli animateSource ["pdoor", 0];
};

if (_unit == gunner _heli) then {
    sleep 1.2;
    _heli animateSource ["gdoor", 0];
};