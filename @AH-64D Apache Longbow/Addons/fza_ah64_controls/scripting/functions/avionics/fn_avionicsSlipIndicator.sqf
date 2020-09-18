/* ----------------------------------------------------------------------------
Function: fza_fnc_avionicsSlipIndicator

Description:
    Updates *fza_ah64_dps* and *fza_ah64_slip* to be the degrees per second and slip for the respective helicopter.

    The first reading after switching helicopter / taking a reading for a while will always be inaccurate as these are both calculated as the difference between two readings of *direction*

Parameters:
	_heli - The apache helicopter to check.

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_avionicsSlipIndicator
    // fza_ah64_dps => 5
    // fza_ah64_slip => 3
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (!(player in _heli)) exitwith {};

_helipb = _heli call fza_fnc_getPitchBank;
_pitch = _helipb select 0;
_bank = _helipb select 1;

fza_ah64_dps = (fza_ah64_lastdir - direction _heli) * 11;

fza_ah64_slip = ((fza_ah64_dps * cos(abs _bank)) * sin(abs _pitch)) * 0.11;

fza_ah64_lastdir = direction _heli;