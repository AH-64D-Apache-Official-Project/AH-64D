params ["_pid", "_deltaTime", "_desiredVal", "_actualVal"];

private _kp        = _pid get "kp";
private _ki        = _pid get "ki";
private _kd        = _pid get "kd";
private _ki_clamp  = _pid get "ki_clamp";
private _prevError = _pid get "prevError";
private _integral  = _pid get "integral";

private _error      = _desiredVal - _actualVal;
_integral           = _integral + (_error * _deltaTime);
_integral           = [_integral, -_ki_clamp, _ki_clamp] call BIS_fnc_clamp;
private _rawDeriv    = if (_deltaTime == 0) then { 0.0; } else { (_error - _prevError) / _deltaTime; };

//Derivative LOW-PASS FILTER. Raw (error-prevError)/dt divides frame-to-frame error noise by a jittery
//dt, so when the error sits at the noise floor the derivative explodes and kd slams the output rail to
//rail (seen on attRoll: kd 0.06 with ~0 static error -> +-0.1 jitter every frame). Smoothing the
//derivative with a 1st-order low-pass kills that noise amplification while keeping the useful low-freq
//derivative action every existing loop relies on. dCoef in (0,1]: 1.0 = no filter (old behaviour),
//smaller = heavier smoothing. Default 0.3 (mild). Stored per-PID so a loop can override if needed.
private _dCoef      = _pid getOrDefault ["dCoef", 0.3];
private _derivative = (_pid getOrDefault ["derivFilt", _rawDeriv]) + _dCoef * (_rawDeriv - (_pid getOrDefault ["derivFilt", _rawDeriv]));
private _output     = _kp * _error + _ki * _integral + _kd * _derivative;
_prevError          = _error;

_pid set ["prevError",  _prevError];
_pid set ["integral",   _integral];
_pid set ["derivFilt",  _derivative];

_output;
