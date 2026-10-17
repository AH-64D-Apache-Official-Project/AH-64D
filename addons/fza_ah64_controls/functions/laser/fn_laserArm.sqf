/* ----------------------------------------------------------------------------
Function: fza_fnc_laserArm

Description:
    Arms the apache's LRFD, from either seat. Must be run in scheduled environment (involve sleep)

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Examples:
    --- Code
    [_heli] spawn fza_fnc_laserArm
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _acBusOn = _heli getVariable "bmkhs_acBusOn";

// The CPG lases with the TADS as the sight
if (player == gunner _heli && {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_TADS}) exitWith {};

if (isNull laserTarget _heli && _acBusOn) then {
    // The lasing crew station takes the laser as its range source
    private _seat = [_heli] call fza_fnc_getSeat;
    if (!isNil "_seat") then {_heli setVariable ["fza_ah64_laserSeat", _seat, true]};
    [_heli, "Laserdesignator_mounted", [0]] call BIS_fnc_fire;
}
