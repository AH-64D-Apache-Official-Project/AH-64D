#include "\fza_ah64_dms\headers\constants.h"
// Returns the quad, reordered if its edges crossed, or [] when it can't be used
params ["_pts"];

if (count _pts != 4) exitWith {[]};
private _flat = _pts apply {[_x # 0, _x # 1, 0]};

private _orient = {
    params ["_a", "_b", "_c"];
    ((_b # 0) - (_a # 0)) * ((_c # 1) - (_a # 1)) - ((_b # 1) - (_a # 1)) * ((_c # 0) - (_a # 0))
};
private _crosses = {
    params ["_p1", "_p2", "_p3", "_p4"];
    private _d1 = [_p3, _p4, _p1] call _orient;
    private _d2 = [_p3, _p4, _p2] call _orient;
    private _d3 = [_p1, _p2, _p3] call _orient;
    private _d4 = [_p1, _p2, _p4] call _orient;
    (_d1 * _d2 < 0) && {_d3 * _d4 < 0}
};
private _area = {
    params ["_q"];
    private _s = 0;
    {
        private _n = _q select ((_forEachIndex + 1) mod 4);
        _s = _s + (_x # 0) * (_n # 1) - (_n # 0) * (_x # 1);
    } forEach _q;
    abs _s / 2
};

private _result = [];
{
    private _q = _x apply {_flat # _x};
    _q params ["_a", "_b", "_c", "_d"];
    if (!([_a, _b, _c, _d] call _crosses) && {!([_b, _c, _d, _a] call _crosses)}) exitWith {
        if ([_q] call _area >= ZONE_MIN_AREA) then {_result = _q};
    };
} forEach [[0, 1, 2, 3], [0, 1, 3, 2], [0, 2, 1, 3]];
_result
