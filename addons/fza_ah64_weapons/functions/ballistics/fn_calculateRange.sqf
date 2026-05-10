/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_calculateRange

Description:
    Simulates a 2-D (forward/vertical) ballistic trajectory using ArmA 3's
    physics model — linear drag (airFriction * v) plus gravity — and returns
    the horizontal ground range at impact.

    Using ArmA's own drag model (rather than the real aerodynamic formula)
    ensures the solver predicts where rounds actually land in-engine.

Parameters:
    _platformFwdSpeed  - Forward speed of launch platform (m/s). Positive = fwd.
    _platformAlt       - Launch altitude above terrain (m). Must be > 0.
    _elevAngle         - Absolute launch elevation (radians). Positive = up.
    _muzzleVelocity    - Muzzle velocity relative to platform (m/s).
    _airFriction       - ArmA airFriction from CfgAmmo (negative, e.g. -0.00036).

Returns:
    Horizontal range at ground impact (m).

Author:
    fza_ah64 ballistics system
---------------------------------------------------------------------------- */
params ["_platformFwdSpeed", "_platformAlt", "_elevAngle", "_muzzleVelocity", "_airFriction"];

private _elevDeg = deg _elevAngle;   // SQF sin/cos take degrees, not radians
private _vx   = _platformFwdSpeed + _muzzleVelocity * cos _elevDeg;
private _vy   = _muzzleVelocity * sin _elevDeg;
private _posX = 0;
private _posY = _platformAlt;
private _dt   = 0.05;
private _iter = 0;

while { _posY > 0 && _iter < 2000 } do {
    // ArmA's projectile physics: v = v + airFriction * v * dt  (linear drag)
    _vx   = _vx + _airFriction * _vx * _dt;
    _vy   = _vy + (_airFriction * _vy - 9.8066) * _dt;
    _posX = _posX + _vx * _dt;
    _posY = _posY + _vy * _dt;
    _iter = _iter + 1;
};

_posX
