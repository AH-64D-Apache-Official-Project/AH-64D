/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_setCenterline

Description:
    Sets the FCR centerline azimuth bias, heading stabilised off centre, and
    re-cues a running scan. The last scan's picture is a snapshot and stays as
    it was (fza_ah64_fcrLastScan, written only by fza_fcr_fnc_update); the
    centerline caret reads the bias live.

Parameters:
    _heli    - The helicopter
    _newBias - Centerline azimuth from the nose (deg, right positive)

Returns:
    Nothing

Examples:
    [_heli, 22.5] call fza_fcr_fnc_setCenterline

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_newBias"];

_heli setVariable ["fza_ah64_fcrAzBias", _newBias, true];

// Returning to centre (0 bias) is NOT heading-stabilized — the scan tracks the nose again,
// so clear the stored world centerline; otherwise stabilization would drift it off centre.
if (_newBias == 0) then {
    _heli setVariable ["fza_ah64_fcrCenterlineWorld", -1, true];
} else {
    // SQF mod keeps sign — +360 first so a left slew at low headings can't store a negative bearing
    _heli setVariable ["fza_ah64_fcrCenterlineWorld", (direction _heli + _newBias + 360) mod 360, true];
};

// The RMAP picture stays until the next scan starts (fza_fcr_fnc_armScanStart)
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState"];
if (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    [_heli, _fcrScanState, true] call fza_fcr_fnc_armScanStart;
};
