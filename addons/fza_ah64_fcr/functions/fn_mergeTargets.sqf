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
            _fcrTargets set [_forEachIndex, +_prev];
        };
    };
} forEach _fcrTargets;

private _ghostedCount = 0;
private _purgedCount  = 0;
{
    _x params ["_pos", "_type", "_moving", "_obj"];
    private _searchObj = _obj;
    if ((_fcrTargets findIf { (_x # 3) isEqualTo _searchObj }) == -1) then {
        private _lastSeen = if (count _x >= 13) then { _x # 12 } else { _now - 31 };
        if ((_now - _lastSeen) < 30) then {
            private _ghost = +_x;
            _ghost set [8, 1]; // mark as ghost
            _fcrTargets pushBack _ghost;
            _ghostedCount = _ghostedCount + 1;
        } else {
            _purgedCount = _purgedCount + 1;
        };
    };
} forEach _prevTargets;

_fcrTargets
