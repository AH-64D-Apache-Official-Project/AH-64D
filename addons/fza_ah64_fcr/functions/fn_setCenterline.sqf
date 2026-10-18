/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_setCenterline

Description:
    Sets the FCR centerline azimuth bias, heading stabilised off centre, updates
    the centerline carets and re-cues a running scan.

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

// Current/last centerline carets update immediately; keep the update stamp and scan-time nose heading intact
private _clDir = (direction _heli + _newBias + 360) mod 360;
_heli getVariable "fza_ah64_fcrLastScan" params ["_oldDir", "_scanPos", "_time", "", ["_noseDir", direction _heli]];
[_heli, "fza_ah64_fcrLastScan", [_clDir, _scanPos, _time, _oldDir, _noseDir]] call fza_fnc_updateNetworkGlobal;

// The RMAP picture stays until the next scan starts (fza_fcr_fnc_armScanStart)
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState"];
if (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    [_heli, _fcrScanState, true] call fza_fcr_fnc_armScanStart;
};
