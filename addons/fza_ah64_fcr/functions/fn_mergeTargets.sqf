/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_mergeTargets

Description:
    Merges a fresh GTM scan snapshot with the previous scan's target list,
    implementing target persistence and aging across scan cycles:

    - Tracked targets (seen in both scans): scanAge=0. The heading-corrected
      previous azimuth and range are stored at indices [9] and [10] so the
      draw function can hold the old screen position until the sweep bar
      passes that azimuth, then snap to the updated position.

    - Fresh detections (not in previous scan): scanAge=0, no prev position.
      Normal sweep reveal applies.

    - Ghosted targets (in previous scan but not re-found): kept for one
      further scan cycle with scanAge=1 and revealOffset=0 so they remain
      visible from the start of the next cycle. Dropped when scanAge >= 1.

Parameters:
    _heli       - the helicopter
    _fcrTargets - sorted fresh scan records from fza_fcr_fnc_buildScanSnapshot

Returns:
    Merged target array with scanAge at index [8], and optionally
    previous azimuth/range at indices [9] and [10] for tracked targets.

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_fcrTargets"];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";

// Tag each fresh target with scanAge.
// Tracked targets carry the raw previous azimuth/range so the draw function
// can hold the exact previous screen position until the sweep bar passes,
// then snap to the new detected position.  No heading correction is applied:
// the FCR is a frozen-scope display — targets stay put on the MFD until the
// scan line rescans them, regardless of aircraft rotation between cycles.
{
    private _obj     = _x # 3;
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };

    if (_prevIdx != -1) then {
        // Tracked target: carry previous relAzi and range as hold position
        private _prevRec = _prevTargets # _prevIdx;
        _fcrTargets set [_forEachIndex, _x + [0, _prevRec # 4, _prevRec # 6]];
    } else {
        // Fresh detection: hidden until bar sweeps past
        _fcrTargets set [_forEachIndex, _x + [0]];
    };
} forEach _fcrTargets;

// For each previous target not re-found, ghost it for one further scan cycle.
// Ghost retains its original relAzi (frozen at last-detected screen position).
{
    private _prevObj    = _x # 3;
    private _foundInNew = (_fcrTargets findIf { (_x # 3) isEqualTo _prevObj }) != -1;

    if (!_foundInNew) then {
        private _prevAge = if ((count _x) > 8) then { _x # 8 } else { 0 };
        if (_prevAge < 1) then {
            private _ghost = +_x;
            _ghost set [7, 0]; // revealOffset = 0: visible from start of new cycle
            _ghost set [8, 1]; // scanAge = 1 (ghost)
            _fcrTargets pushBack _ghost;
        };
        // scanAge >= 1: drop silently (already ghosted for one cycle)
    };
} forEach _prevTargets;

_fcrTargets
