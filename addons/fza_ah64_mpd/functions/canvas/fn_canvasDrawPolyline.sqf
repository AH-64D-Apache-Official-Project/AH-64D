// _pts in MPD units; _dash is [on, off, phase] in MPD units, or [] for solid. Only what is inside _clip is dashed; past
// _budget dashes the line is drawn solid. Returns the rectangles drawn
params ["_canvas", "_pts", "_closed", "_color", ["_width", 0.004], ["_clip", []], ["_dash", []], ["_budget", 400]];
_canvas params ["_ctrl", "", "_vect"];

private _count = count _pts;
if (_count < 2) exitWith {0};
private _fill = [_color] call fza_mpd_fnc_canvasLineTexture;
private _halfW = (_width / 2) * abs (_vect # 0);

private _rect = {
    params ["_a", "_b"];
    private _dx = (_b # 0) - (_a # 0);
    private _dy = (_b # 1) - (_a # 1);
    private _len = sqrt (_dx ^ 2 + _dy ^ 2);
    if (_len <= 0) exitWith {};
    private _mid = [_canvas, [((_a # 0) + (_b # 0)) / 2, ((_a # 1) + (_b # 1)) / 2]] call fza_mpd_fnc_canvasAdjust;
    _ctrl drawRectangle [_mid, _halfW, (_len / 2) * abs (_vect # 1), _dx atan2 (-_dy), [1, 1, 1, 1], _fill];
};

// Each segment's part inside the clip: [start, direction, length, from, to, distance along the line to its start]
private _parts = [];
private _along = 0;
private _visible = 0;
for "_i" from 1 to ([_count - 1, _count] select _closed) do {
    private _a = _pts # (_i - 1);
    private _b = _pts # (_i mod _count);
    private _dx = (_b # 0) - (_a # 0);
    private _dy = (_b # 1) - (_a # 1);
    private _len = sqrt (_dx ^ 2 + _dy ^ 2);
    if (_len <= 0) then {continue};
    private _t0 = 0;
    private _t1 = 1;
    if (_clip isNotEqualTo []) then {
        _clip params ["_l", "_t", "_r", "_bt"];
        {
            _x params ["_p", "_q"];
            if (_p == 0) then {
                if (_q < 0) then {_t0 = 2};
            } else {
                private _k = _q / _p;
                if (_p < 0) then {_t0 = _t0 max _k} else {_t1 = _t1 min _k};
            };
        } forEach [[-_dx, (_a # 0) - _l], [_dx, _r - (_a # 0)], [-_dy, (_a # 1) - _t], [_dy, _bt - (_a # 1)]];
    };
    if (_t1 > _t0) then {
        _parts pushBack [_a, [_dx / _len, _dy / _len], _len, _t0 * _len, _t1 * _len, _along];
        _visible = _visible + (_t1 - _t0) * _len;
    };
    _along = _along + _len;
};
if (_parts isEqualTo []) exitWith {0};

private _at = {
    params ["_a", "_u", "_d"];
    [(_a # 0) + (_u # 0) * _d, (_a # 1) + (_u # 1) * _d]
};
_dash params [["_on", 0], ["_off", 0], ["_phase", 0]];
private _period = _on + _off;
if (_period <= 0 || {_on <= 0} || {ceil (_visible / _period) + count _parts > _budget}) exitWith {
    {
        _x params ["_a", "_u", "", "_from", "_to"];
        [[_a, _u, _from] call _at, [_a, _u, _to] call _at] call _rect;
    } forEach _parts;
    count _parts
};

private _drawn = 0;
private _steps = 2 * _budget;
{
    _x params ["_a", "_u", "", "_from", "_to", "_start"];
    // Where the pattern is at the visible part's start, from the line's start
    private _s = ((_start + _from + _phase) mod _period + _period) mod _period;
    private _p = _from;
    while {_p < _to && {_steps > 0}} do {
        _steps = _steps - 1;
        private _inOn = _s < _on;
        private _step = ([_period - _s, _on - _s] select _inOn) min (_to - _p);
        if (_inOn) then {
            [[_a, _u, _p] call _at, [_a, _u, _p + _step] call _at] call _rect;
            _drawn = _drawn + 1;
        };
        _p = _p + _step;
        _s = (_s + _step) mod _period;
    };
} forEach _parts;
_drawn
