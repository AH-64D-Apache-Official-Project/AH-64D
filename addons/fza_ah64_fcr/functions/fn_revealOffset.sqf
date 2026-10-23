/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_revealOffset

Description:
    When in the scan cycle the wiper crosses a target: seconds from the start
    of the cycle. GTM/RMAP cross each target once a cycle, on the near bar
    (L→R) under 4 km and the far bar (R→L) beyond. ATM wide rotates from the
    nose counter-clockwise; ATM sectors are crossed on both passes, the first
    R→L (fza_fcr_fnc_mergeTargets takes the earlier).

Parameters:
    _heli   - The helicopter
    _relAzi - The target's azimuth from the scan centerline, degrees
    _range  - The target's range, metres

Returns:
    Seconds from the start of the cycle

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_relAzi", "_range"];

if ((_heli getVariable "fza_ah64_fcrMode") in [FCR_DISP_MODE_GTM, FCR_DISP_MODE_RMAP]) exitWith {
    private _half = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
    private _bar  = (_half * 2) / FCR_SCAN_RATE_DEGS;
    if (_range < 4000) then {
        ((_relAzi + _half) / (_half * 2)) * _bar
    } else {
        _bar + ((_half - _relAzi) / (_half * 2)) * _bar
    }
};

private _atmHalf = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];
if (_atmHalf >= 168) exitWith {
    // Wide rotation starts at the nose and sweeps counter-clockwise (matches the display wiper)
    ((-_relAzi + 360) mod 360) / FCR_SCAN_RATE_DEGS
};
// Display mirrors the bearing math, so the visible first pass runs R→L: the right edge (+halfFov) at t=0
((_atmHalf - _relAzi) / (_atmHalf * 2)) * ((_atmHalf * 2) / FCR_SCAN_RATE_DEGS)
