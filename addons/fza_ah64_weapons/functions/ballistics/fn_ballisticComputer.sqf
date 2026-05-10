/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_ballisticComputer

Description:
    Computes the required body-relative elevation angle (degrees) to
    ballistically hit a target at the given position.  Accounts for:

      * Platform velocity projected along the bearing to target (not just
        forward speed — handles crabbing / pedal turns correctly).
      * Full target lead: predicts where the target will be after the round
        reaches it, using a first-order TOF estimate.
      * Altitude difference between helicopter and target (so trajectories
        into a hillside or across a valley are correct).
      * Weapon-specific muzzle velocity and linear drag (airFriction from
        CfgAmmo).  Default values are for the M230/fza_30x113.

    The function is cheap enough for draw3D: 16 bisection steps × ≤ 40 Euler
    steps ≈ 640 arithmetic operations per call.

Parameters:
    _heli            - The helicopter
    _tPos            - Target position (ASL)
    _muzzleVelocity  - Muzzle velocity relative to platform (m/s).
                       Default: 805 (M230 fza_30x113)
    _airFriction     - ArmA airFriction from CfgAmmo (negative = drag).
                       Default: -0.00036 (M230 fza_30x113)
    _targVel         - Target velocity vector (world-frame, m/s).
                       Default: [0,0,0] (stationary target, no lead)

Returns:
    Body-relative cannon/pylon elevation angle in degrees (positive = up).
    Returns the direct-LOS angle when target is within 10 m.

Notes:
    Aircraft movement: The platform velocity component along the bearing to the
    target is added to the round's initial horizontal velocity.  The
    helicopter's full velocity vector is also removed from the lead offset so
    that the rocket/round's inherited platform velocity is not double-counted.

Author:
    fza_ah64 ballistics system
---------------------------------------------------------------------------- */
params ["_heli", "_tPos", ["_muzzleVelocity", 805], ["_airFriction", -0.00036], ["_targVel", [0,0,0]]];

private _heliPosASL  = getPosASLVisual _heli;
private _heliVel     = velocity _heli;
private _horizRange  = _heliPosASL distance2D _tPos;

private _toTargetH  = [_tPos # 0 - _heliPosASL # 0, _tPos # 1 - _heliPosASL # 1, 0];
private _toTargetHN = vectorNormalized _toTargetH;
private _platformFwdSpd = _heliVel vectorDotProduct _toTargetHN;

private _tof1 = _horizRange / ((_muzzleVelocity + _platformFwdSpd) max 1);
private _predictedPos = _tPos vectorAdd (_targVel vectorMultiply _tof1);

private _predHorizRange = _heliPosASL distance2D _predictedPos;

private _platformAlt = (_heliPosASL # 2) - (_predictedPos # 2);

if (_platformAlt <= 0 || _predHorizRange < 10) exitWith {
    private _b   = _heli worldToModel (ASLToAGL _predictedPos);
    private _mag = vectorMagnitude _b;
    if (_mag < 0.001) exitWith { 0 };
    asin ((_b # 2) / _mag)
};

_platformAlt = _platformAlt max 1;


private _platformPitch = pitch _heli;
private _elevMinAbs    = rad (_platformPitch - 60);
private _elevMaxAbs    = rad (_platformPitch + 11);

private _absElev = [
    _platformFwdSpd,
    _platformAlt,
    _predHorizRange,
    _muzzleVelocity,
    _airFriction,
    _elevMinAbs,
    _elevMaxAbs
] call fza_weapons_fnc_calculateElevationAngle;

if (abs(_absElev - _elevMaxAbs) < 0.0001 || abs(_absElev - _elevMinAbs) < 0.0001) exitWith {
    private _b   = _heli worldToModel (ASLToAGL _predictedPos);
    private _mag = vectorMagnitude _b;
    if (_mag < 0.001) exitWith { 0 };
    asin ((_b # 2) / _mag)
};


deg _absElev - _platformPitch
