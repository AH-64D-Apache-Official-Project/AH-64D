/* ----------------------------------------------------------------------------
Function: fza_fnc_laserDisarm

Description:
    Disarms the apache's LRFD, from either seat.

Parameters:
	_heli - The helicopter to act upon

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_laserDisarm
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
if (player == gunner _heli && fza_ah64_laserstate == 1) exitwith {
    fza_ah64_laserstate = 0;
    _heli vehiclechat "Laser OFF.";
};

_heli removemagazine "Laserbatteries";
_heli removeweapon "Laserdesignator_mounted";