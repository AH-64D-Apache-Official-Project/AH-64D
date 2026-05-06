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
params ["_heli", "_fcrTargets", ["_isFullCycle", true]];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";

{
    _x params ["_pos", "_type", "_moving", "_obj"];
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };

    if (_prevIdx == -1) then {
        _fcrTargets set [_forEachIndex, _x + [0]];
    } else {
        private _prev = _prevTargets # _prevIdx;
        if (_isFullCycle) then {
            _fcrTargets set [_forEachIndex, _x + [0, _prev # 4, _prev # 6, _prev # 0]]; // promote tracked, freeze at prev revealed pos
        } else {
            _fcrTargets set [_forEachIndex, +_prev];
        };
    };
} forEach _fcrTargets;

// Age lost targets into ghosts
{
    _x params ["_pos", "_type", "_moving", "_obj"];
    if ((_fcrTargets findIf { (_x # 3) isEqualTo _obj }) == -1) then {
        private _age = if (count _x > 8) then { _x # 8 } else { 0 };
        if (_age < 4) then {
            private _ghost = +_x;
            _ghost set [8, _age + 1];
            _fcrTargets pushBack _ghost;
        };
    };
} forEach _prevTargets;

_fcrTargets
