// A zone cut into strips by lines parallel to its first side (q1-q2), of equal width across it, numbered from that side.
// Each strip is the part of the zone between two of the lines, so none leaves a concave zone.
params ["_zone", "_n"];

private _p1 = +(_zone # 0);
_p1 set [2, 0];
private _dir = (_zone # 1) vectorDiff _p1;
_dir set [2, 0];
private _length = vectorMagnitude _dir;
if (_length == 0 || {_n < 2}) exitWith {[_zone]};

// The side's normal, towards the zone
private _normal = [-(_dir # 1) / _length, (_dir # 0) / _length, 0];
private _distance = {
    (_x # 0 - _p1 # 0) * (_normal # 0) + (_x # 1 - _p1 # 1) * (_normal # 1)
};
if (([[_zone] call fza_dms_fnc_zoneCentroid] apply _distance) # 0 < 0) then {
    _normal = _normal vectorMultiply -1;
};
private _ds = _zone apply _distance;
private _min = selectMin _ds;
private _max = selectMax _ds;

// The part of a polygon on one side of the line at distance _at: above it, or below it
private _clip = {
    params ["_poly", "_at", "_above"];
    private _sign = [-1, 1] select _above;
    private _out = [];
    private _count = count _poly;
    for "_i" from 0 to _count - 1 do {
        private _a = _poly # ((_i + _count - 1) mod _count);
        private _b = _poly # _i;
        private _da = _sign * (([_a] apply _distance) # 0 - _at);
        private _db = _sign * (([_b] apply _distance) # 0 - _at);
        if ((_da < 0) != (_db < 0)) then {
            private _t = _da / (_da - _db);
            _out pushBack [(_a # 0) + ((_b # 0) - (_a # 0)) * _t, (_a # 1) + ((_b # 1) - (_a # 1)) * _t, 0];
        };
        if (_db >= 0) then {_out pushBack [_b # 0, _b # 1, 0]};
    };
    // Without points that repeat
    private _clean = [];
    {
        if (_clean isEqualTo [] || {(_clean # (count _clean - 1)) distance2D _x > 0.01}) then {_clean pushBack _x};
    } forEach _out;
    if (count _clean > 1 && {(_clean # 0) distance2D (_clean # (count _clean - 1)) <= 0.01}) then {_clean deleteAt (count _clean - 1)};
    _clean
};

private _flat = _zone apply {[_x # 0, _x # 1, 0]};
private _strips = [];
for "_i" from 0 to _n - 1 do {
    private _strip = [_flat, _min + (_max - _min) * _i / _n, true] call _clip;
    _strip = [_strip, _min + (_max - _min) * (_i + 1) / _n, false] call _clip;
    if (count _strip >= 3) then {_strips pushBack _strip};
};
_strips
