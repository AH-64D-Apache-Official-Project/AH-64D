#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrTargets", ["_isFullCycle", true]];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";
private _now = CBA_missionTime;

// Reveal model (fixes rebound position jumps): a target's DISPLAYED record (fields 9-11 =
// azi/range/pos) is the picture the crew sees. It is refreshed with freshly-scanned data only
// once the scan bar has swept past the target's azimuth in the current cycle — never before,
// so a moving symbol holds its spot until the bar reaches it instead of jumping mid-rebound.
// Phase is measured from the fixed scan origin the wiper uses, modulo the cycle, so the reveal
// point tracks the bar (the reveal offset is the bar's phase-into-cycle at that azimuth).
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
([_heli] call fza_fcr_fnc_getScanTiming) params ["_barTime", "_cycleLen"];
private _elapsed  = (_now - _fcrScanStartTime) max 0;
private _barsTotal = round (_elapsed / _barTime);   // whole bars the wiper has completed
if (_barsTotal < 1) then { _barsTotal = 1; };       // at least the first bar by the time we merge
// Swept phase = how far into the CURRENT cycle the wiper has reached at this merge. Two bars per
// cycle: an odd completed-bar count means the wiper is mid-cycle (one bar swept); an even count
// means it just finished a full cycle (both bars swept). This tracks the coarse merge cadence
// exactly and, unlike the raw modulo, never snaps back to 0 and skips the last bar's targets.
private _phaseNow = [_cycleLen, _barTime] select ((_barsTotal % 2) == 1);

{
    _x params ["_pos", "_type", "_moving", "_obj", "_aziAngle", "_elevAngle", "_range", "_revealOffset"];
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };

    // Has the wiper reached this target's azimuth in the cycle currently under the bar?
    // mergeTargets runs coarsely (bar edges), so we can't gate on "crossing == now"; instead
    // commit whenever the bar has already passed the target this cycle. Between scan start and
    // that phase the merge simply hasn't advanced the picture, so the symbol holds its old spot.
    private _swept = _phaseNow >= _revealOffset;

    if (_prevIdx == -1) then {
        // Brand-new contact: commit the moment the bar has swept it, else hide (empty pos).
        private _dispAzi = 0; private _dispRange = 0; private _dispPos = [];
        if (_swept) then { _dispAzi = _aziAngle; _dispRange = _range; _dispPos = _pos; };
        _fcrTargets set [_forEachIndex, _x + [0, _dispAzi, _dispRange, _dispPos, _now, 0, 0]];
    } else {
        private _prev = _prevTargets # _prevIdx;
        // Displayed record carried from last merge (fields 9-11)
        private _dispAzi   = _prev param [9, _aziAngle];
        private _dispRange = _prev param [10, _range];
        private _dispPos   = _prev param [11, []];

        // Refresh the displayed record with fresh scan data once the bar has swept the azimuth
        // this cycle; otherwise hold the old picture verbatim (stops the mid-rebound jump).
        if (_swept) then {
            _dispAzi = _aziAngle; _dispRange = _range; _dispPos = _pos;
        };

        _fcrTargets set [_forEachIndex, _x + [0, _dispAzi, _dispRange, _dispPos, _now, 0, 0]];
    };
} forEach _fcrTargets;

// TM 4.35.11: ATM purges priority target data at the start of each scan — no ghost
// persistence at all, so drop the carry-over entirely in ATM mode.
if ((_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_ATM) exitWith { _fcrTargets };

// TM 4.44.2/.3: a non-redetected symbol lives until the next reveal sweep re-covers its azimuth — stamp that removal time, resolveDisplay hides per frame
private _fullCycleLen  = _cycleLen;
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];

{
    _x params ["_pos", "_type", "_moving", "_obj"];
    private _searchObj = _obj;
    if ((_fcrTargets findIf { (_x # 3) isEqualTo _searchObj }) == -1) then {
        private _removeTime = if ((_x param [8, 0]) > 0) then {
            _x param [13, 0]   // already a ghost — keep its stamped removal time
        } else {
            _lastFullCycle + _fullCycleLen + (_x param [7, 0])
        };
        if (_now < _removeTime) then {
            private _ghost = +_x;
            _ghost set [8, 1];            // mark as ghost
            _ghost set [13, _removeTime]; // wiper re-covers its azimuth at this time
            _fcrTargets pushBack _ghost;
        };
    };
} forEach _prevTargets;

_fcrTargets
