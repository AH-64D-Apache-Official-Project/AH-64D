/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_mergeTargets

Description:
    Merges a fresh scan snapshot with the previous target list.
    Tracked targets carry their previous relAzi/range as a hold position until
    the sweep bar passes them. Ghosts persist for one additional cycle (scanAge=1).

Parameters:
    _heli       - The helicopter
    _fcrTargets - Sorted fresh scan records from fza_fcr_fnc_buildScanSnapshot

Returns:
    Merged target array. scanAge at [8]; previous azi/range at [9]/[10] for tracked.

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_fcrTargets"];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";

// Tag each fresh target with scanAge. Tracked targets carry previous relAzi/range
// so the draw function holds the old screen position until the sweep bar passes.
{
    private _obj     = _x # 3;
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };

    if (_prevIdx != -1) then {
        // Tracked: carry previous relAzi and range
        private _prevRec = _prevTargets # _prevIdx;
        _fcrTargets set [_forEachIndex, _x + [0, _prevRec # 4, _prevRec # 6]];
    } else {
        // Fresh: hidden until bar sweeps past
        _fcrTargets set [_forEachIndex, _x + [0]];
    };
} forEach _fcrTargets;

// Ghost targets not re-found: keep for one more cycle then drop
{
    private _prevObj    = _x # 3;
    private _foundInNew = (_fcrTargets findIf { (_x # 3) isEqualTo _prevObj }) != -1;

    if (!_foundInNew) then {
        private _prevAge = if ((count _x) > 8) then { _x # 8 } else { 0 };
        if (_prevAge < 1) then {
            private _ghost = +_x;
            _ghost set [7, 0]; // revealOffset = 0: visible from cycle start
            _ghost set [8, 1]; // scanAge = 1 (ghost)
            _fcrTargets pushBack _ghost;
        };
        // scanAge >= 1: drop silently (already ghosted for one cycle)
    };
} forEach _prevTargets;

_fcrTargets
