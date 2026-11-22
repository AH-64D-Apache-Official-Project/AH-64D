/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_spreadBearings

Description:
    Spreads apart the bearings of icons drawn round the ownship that are closer than a gap, keeping them in bearing
    order: each group of icons too close together is laid out a gap apart, centred on the mean of their bearings, and
    groups that then touch are joined.

Parameters:
    _bearings - bearings, deg
    _gap      - least bearing between two icons, deg

Returns:
    The bearings to draw at, -180 to 180, in the order given

Examples:
    [[10, 12, 40], 12] call fza_mpd_fnc_spreadBearings // [5, 17, 40]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_bearings", "_gap"];

private _count = count _bearings;
if (_count < 2) exitWith {_bearings apply {[_x] call CBA_fnc_simplifyAngle180}};

private _items = [];
{_items pushBack [[_x] call CBA_fnc_simplifyAngle180, _forEachIndex];} forEach _bearings;
_items sort true;
// Laid out from the widest gap round the circle, so icons either side of 180 are spread as neighbours
private _widest = -1;
private _start  = 0;
{
    private _next = if (_forEachIndex == _count - 1) then {((_items # 0) # 0) + 360} else {(_items # (_forEachIndex + 1)) # 0};
    if (_next - (_x # 0) > _widest) then {
        _widest = _next - (_x # 0);
        _start  = (_forEachIndex + 1) % _count;
    };
} forEach _items;
_items = (_items select [_start, _count]) + ((_items select [0, _start]) apply {[(_x # 0) + 360, _x # 1]});

// [sum of bearings, count]: a group's icons are a gap apart about their mean
private _groups = _items apply {[_x # 0, 1]};
private _joined = true;
while {_joined} do {
    _joined = false;
    for "_i" from 0 to (count _groups - 2) do {
        (_groups # _i) params ["_sumA", "_nA"];
        (_groups # (_i + 1)) params ["_sumB", "_nB"];
        if ((_sumB / _nB - (_nB - 1) / 2 * _gap) - (_sumA / _nA + (_nA - 1) / 2 * _gap) < _gap) exitWith {
            _groups set [_i, [_sumA + _sumB, _nA + _nB]];
            _groups deleteAt (_i + 1);
            _joined = true;
        };
    };
};

private _drawn = [];
{
    _x params ["_sum", "_n"];
    private _first = _sum / _n - (_n - 1) / 2 * _gap;
    for "_k" from 0 to (_n - 1) do {_drawn pushBack (_first + _k * _gap);};
} forEach _groups;

private _out = [];
_out resize _count;
{_out set [_x # 1, [_drawn # _forEachIndex] call CBA_fnc_simplifyAngle180];} forEach _items;
_out
