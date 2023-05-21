params ["_pid", "_deltaTime", "_desiredVal", "_actualVal"];

private _kp        = _pid get "kp";
private _ki        = _pid get "ki";
private _kd        = _pid get "kd";
private _prevError = _pid get "prevError";
private _integral  = _pid get "integral";

private _error      = _desiredVal - _actualVal;
_integral           = _integral + (_error * _deltaTime);
private _derivative = if (_deltaTime == 0) then { 0.0; } else { (_error - _prevError) / _deltaTime; };
private _output     = _kp * _error + _ki * _integral + _kd * _derivative;
_prevError          = _error;

_pid set ["prevError", _prevError];
_pid set ["integral",  _integral];

_output;