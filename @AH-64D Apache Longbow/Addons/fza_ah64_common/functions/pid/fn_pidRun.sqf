params ["_pid", "_frameTime", "_desiredVal", "_actualVal"];

private _kp        = _pid get "kp";
private _ki        = _pid get "ki";
private _kd        = _pid get "kd";
private _prevError = _pid get "prevError";
private _integral  = _pid get "integral";

private _error      = _desiredVal - _actualVal;
_integral           = integral + (_error * _frameTime);
private _derivative = (_error - _prevError) / _frameTime;
private _output     = _kp * _error * _ki * _integral + _kd * _derivative;
_prevError          = _error;

_pid set ["prevError", _prevError];
_pid set ["integral",  _integral];

_output;