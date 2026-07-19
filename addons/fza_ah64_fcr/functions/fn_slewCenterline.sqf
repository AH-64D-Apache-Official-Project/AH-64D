/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_slewCenterline

Description:
    Steps the FCR azimuth scan centerline one full scan width left or right
    (TM 4.35.6d / 4.35.13: coverage adjacent to the previously selected area).
    The new position is stored as a world bearing so the centerline remains
    heading stabilized until commanded again. Only acts when the FCR is the
    crewmember's selected sight.

Parameters:
    _heli    - The helicopter
    _dirSign - -1 = left arrow, 1 = right arrow

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_dirSign"];

if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) exitWith {};

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {};

private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _newBias = _azBias;

// Use the SELECTED size, not the latched half-FOV — the latch happens at the next scan
// start, so reading fcrAtmHalfFov here would give the previous size's step right after a change.
private _size    = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _halfFov = if (_fcrMode == FCR_DISP_MODE_ATM) then {
    [168, 90, 45, 22.5] select _size
} else {
    [45, 22.5, 15, 7.5] select _size
};
// Wide (ATM 360 rotation) has no centerline to offset
if (_halfFov >= 168) exitWith {};

// One position either side, offset half the scan azimuth (= the half-FOV) — the slewed
// sector's inner edge sits on the helicopter centerline. GTM wide +-45/med +-22.5/
// nrw +-15/zoom +-7.5; ATM med +-90/nrw +-45/zoom +-22.5. Clamped (no wrap-around).
private _stepped = _azBias + _dirSign * _halfFov;
if (abs _stepped <= _halfFov + 0.001) then { _newBias = _stepped; };

if (_newBias == _azBias) exitWith {};

_heli setVariable ["fza_ah64_fcrAzBias", _newBias, true];

// Returning to centre (0 bias) is NOT heading-stabilized — the scan tracks the nose again,
// so clear the stored world centerline; otherwise stabilization would drift it off centre.
if (_newBias == 0) then {
    _heli setVariable ["fza_ah64_fcrCenterlineWorld", -1, true];
} else {
    // SQF mod keeps sign — +360 first so a left slew at low headings can't store a negative bearing
    _heli setVariable ["fza_ah64_fcrCenterlineWorld", (direction _heli + _newBias + 360) mod 360, true];
};

// Current/last centerline carets update immediately (TM 4.14); keep the update stamp intact
private _clDir = (direction _heli + _newBias + 360) mod 360;
_heli getVariable "fza_ah64_fcrLastScan" params ["_oldDir", "_scanPos", "_time"];
[_heli, "fza_ah64_fcrLastScan", [_clDir, _scanPos, _time, _oldDir]] call fza_fnc_updateNetworkGlobal;

// B-scope columns map to the new sector — restart the video
_heli setVariable ["fza_ah64_fcrRMAPHardClear", true];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState"];
if (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    [_heli, _fcrScanState, true] call fza_fcr_fnc_armScanStart;
};
