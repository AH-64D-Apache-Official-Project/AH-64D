#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrTargets", ["_isFullCycle", true]];

private _prevTargets = _heli getVariable "fza_ah64_fcrTargets";
private _now = CBA_missionTime;

{
    _x params ["_pos", "_type", "_moving", "_obj"];
    private _prevIdx = _prevTargets findIf { (_x # 3) isEqualTo _obj };

    if (_prevIdx == -1) then {
        _fcrTargets set [_forEachIndex, _x + [0, 0, 0, [], _now]];
    } else {
        private _prev = _prevTargets # _prevIdx;
        if (_isFullCycle) then {
            _fcrTargets set [_forEachIndex, _x + [0, _prev # 4, _prev # 6, _prev # 0, _now]];
        } else {
            private _rec = +_prev;
            if ((_rec param [8, 0]) > 0) then { _rec set [8, 0]; }; // redetected ghost is live again
            _fcrTargets set [_forEachIndex, _rec];
        };
    };
} forEach _fcrTargets;

// TM 4.44.2/.3: a non-redetected symbol lives until the next reveal sweep re-covers its azimuth — stamp that removal time, resolveDisplay hides per frame
private _fullCycleLen  = ([_heli] call fza_fcr_fnc_getScanTiming) # 1;
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
