/* ----------------------------------------------------------------------------
Function: fza_fnc_avionicsSlipIndicator

Description:
    Updates *fza_ah64_dps* and *fza_ah64_sideslip* to be the degrees per second and slip for the respective helicopter.

    The first reading after switching helicopter / taking a reading for a while will always be inaccurate as these are both calculated as the difference between two readings of *direction*

Parameters:
    _heli - The apache helicopter to check.

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_avionicsSlipIndicator
    // fza_ah64_dps => 5
    // fza_ah64_sideslip => 3
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (!(player in _heli)) exitwith {};

private _beta     = _heli getVariable "fza_sfmplus_aero_beta";

fza_ah64_sideslip = [_beta / 0.15, -1.0, 1.0] call BIS_fnc_clamp;