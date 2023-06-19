params ["_val", "_target", "_accel", "_decel"];

private _v = _val;

if (_v > _target) then {
    _v = (_v - _target) * EXP (-fza_ah64_deltaTime / _decel) + _target;
};

if (_v < _target) then {
    _v = (_target - _v) * (1.0 - EXP (-fza_ah64_deltaTime / _accel)) + _v;
};

_v;