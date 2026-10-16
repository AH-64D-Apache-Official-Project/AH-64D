/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_mergeTargets

Description:
    Merges a fresh scan snapshot with the previous target list. Until fresh
    data is revealed a symbol holds the position it was last revealed at.
    Fresh data is revealed per frame when the wiper next crosses the target
    (fza_fcr_fnc_resolveDisplay). Targets that drop out of the scan become
    ghosts until the wiper re-covers them.

Parameters:
    _heli       - The helicopter
    _fcrTargets - Sorted fresh scan records from fza_fcr_fnc_buildScanSnapshot

Returns:
    Merged target array.

Record format (15 elements):
    [pos, type, moving, obj, aziAngle, elevAngle, range, revealOffset,
     0    1     2       3    4         5          6      7
     isGhost, dispAzi, dispRange, dispPos, mergeTime, ghostRemoveTime, revealTime]
     8        9        10         11       12         13               14
    Fields 9-11 hold the last revealed picture ([] pos until the first reveal).

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrTargets"];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";
private _now = CBA_missionTime;

_heli getVariable "fza_ah64_fcrState" params ["", "_fcrScanStartTime"];
([_heli] call fza_fcr_fnc_getScanTiming) params ["", "_cycleLen"];
private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _isAtm   = _fcrMode == FCR_DISP_MODE_ATM;
// ATM sectors are swept on both passes; GTM/RMAP bars split by range and ATM wide rotates, so once per cycle
private _bothPasses = _isAtm && { (_heli getVariable ["fza_ah64_fcrAtmHalfFov", 168]) < 168 };

// The next time at or after now that the wiper crosses a target with this reveal offset
private _revealTimeOf = {
    params ["_offset"];
    private _t = _fcrScanStartTime + _offset + _cycleLen * ((ceil ((_now - _fcrScanStartTime - _offset) / _cycleLen)) max 0);
    if (_bothPasses) then {
        private _back = _cycleLen - _offset;
        _t = _t min (_fcrScanStartTime + _back + _cycleLen * ((ceil ((_now - _fcrScanStartTime - _back) / _cycleLen)) max 0));
    };
    _t
};

// The picture a previous record is showing now: its fresh data once revealed, else what it carried
private _shownOf = {
    params ["_rec"];
    if ((_rec param [8, 0]) == 0 && { (_rec param [14, 1e9]) <= _now }) exitWith { [_rec # 4, _rec # 6, _rec # 0] };
    [_rec param [9, 0], _rec param [10, 0], _rec param [11, []]]
};

{
    _x params ["", "", "", "_obj", "", "", "", "_revealOffset"];
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };
    private _shown   = [0, 0, []];
    if (_prevIdx != -1) then { _shown = [_prevTargets # _prevIdx] call _shownOf; };
    _fcrTargets set [_forEachIndex, _x + [0] + _shown + [_now, 0, [_revealOffset] call _revealTimeOf]];
} forEach _fcrTargets;

// ATM purges priority target data at the start of each scan — no ghost persistence
if (_isAtm) exitWith { _fcrTargets };

// A non-redetected symbol lives until the wiper next re-covers its azimuth
{
    private _prev = _x;
    private _obj  = _prev # 3;
    if ((_fcrTargets findIf { (_x # 3) isEqualTo _obj }) == -1) then {
        private _offset     = _prev param [7, 0];
        private _removeTime = _prev param [13, 0];
        if ((_prev param [8, 0]) == 0) then {
            _removeTime = [_offset] call _revealTimeOf;
        };
        private _shown = [_prev] call _shownOf;
        if (_now < _removeTime && { (_shown # 2) isNotEqualTo [] }) then {
            private _ghost = +_prev;
            _ghost set [8, 1];
            _ghost set [9, _shown # 0];
            _ghost set [10, _shown # 1];
            _ghost set [11, _shown # 2];
            _ghost set [13, _removeTime];
            _fcrTargets pushBack _ghost;
        };
    };
} forEach _prevTargets;

_fcrTargets
