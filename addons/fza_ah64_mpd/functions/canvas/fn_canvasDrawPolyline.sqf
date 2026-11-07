// _pts in MPD units; _dash is [on, off, phase] in MPD units, or [] for solid
params ["_canvas", "_pts", "_closed", "_color", ["_width", 0.004], ["_clip", []], ["_dash", []]];
_canvas params ["_ctrl", "", "_vect"];

if (count _pts < 2) exitWith {};
private _fill = [_color] call fza_mpd_fnc_canvasLineTexture;
private _halfW = (_width / 2) * abs (_vect # 0);

private _seg = {
    params ["_a", "_b"];
    private _dx = (_b # 0) - (_a # 0);
    private _dy = (_b # 1) - (_a # 1);
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
    if (_t1 <= _t0) exitWith {};
    private _len = sqrt (_dx ^ 2 + _dy ^ 2) * (_t1 - _t0);
    if (_len <= 0) exitWith {};
    private _tm = (_t0 + _t1) / 2;
    private _mid = [_canvas, [(_a # 0) + _dx * _tm, (_a # 1) + _dy * _tm]] call fza_mpd_fnc_canvasAdjust;
    _ctrl drawRectangle [_mid, _halfW, (_len / 2) * abs (_vect # 1), _dx atan2 (-_dy), [1, 1, 1, 1], _fill];
};

private _count = count _pts;
private _last = [_count - 1, _count] select _closed;
if (_dash isEqualTo []) exitWith {
    for "_i" from 1 to _last do {[_pts # (_i - 1), _pts # (_i mod _count)] call _seg};
};

_dash params ["_on", "_off", ["_phase", 0]];
private _period = _on + _off;
if (_period <= 0) exitWith {};
private _s = (_phase mod _period + _period) mod _period;
private _budget = 400;
for "_i" from 1 to _last do {
    private _a = _pts # (_i - 1);
    private _b = _pts # (_i mod _count);
    private _len = _a distance2D _b;
    private _p = 0;
    while {_p < _len && {_budget > 0}} do {
        private _inOn = _s < _on;
        private _step = ([_period - _s, _on - _s] select _inOn) min (_len - _p);
        if (_inOn) then {
            private _d = _b vectorDiff _a;
            [_a vectorAdd (_d vectorMultiply (_p / _len)), _a vectorAdd (_d vectorMultiply ((_p + _step) / _len))] call _seg;
        };
        _p = _p + _step;
        _s = (_s + _step) mod _period;
        _budget = _budget - 1;
    };
};
