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

([_heli] call fza_fnc_calculateAlphaAndBeta)
    params ["_alpha", "_beta"];
//Since alpha and beta are in degrees, and since 1 full ball width is appx 3 deg
//30 degrees works as a scalar for the sideslip indication
fza_ah64_sideslip = _beta / 30.0;