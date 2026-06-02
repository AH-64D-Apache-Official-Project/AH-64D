/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_suspensionUpdate

Description:
    Updates the suspension system for the helicopter.
    
Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

// Time-acceleration freeze: override PhysX position every frame so gravity and terrain
// collision can't cause spring oscillation at large dt. exitWith skips all spring math.
if (accTime > 1.1) exitWith {
    if (!(_heli getVariable ["fza_sfmplus_simFrozen", false])) then {
        // Entering time accel — capture current pose and zero velocity.
        _heli setVelocity        [0.0, 0.0, 0.0];
        _heli setAngularVelocity [0.0, 0.0, 0.0];
        _heli setVariable ["fza_sfmplus_frozenPos", getPosASL _heli, true];
        _heli setVariable ["fza_sfmplus_frozenDir", vectorDir _heli, true];
        _heli setVariable ["fza_sfmplus_frozenUp",  vectorUp  _heli, true];
        _heli setVariable ["fza_sfmplus_simFrozen", true, true];
    } else {
        // Maintain freeze — override whatever PhysX did between SQF frames.
        _heli setPosASL         (_heli getVariable "fza_sfmplus_frozenPos");
        _heli setVectorDirAndUp [(_heli getVariable "fza_sfmplus_frozenDir"), (_heli getVariable "fza_sfmplus_frozenUp")];
        _heli setVelocity        [0.0, 0.0, 0.0];
        _heli setAngularVelocity [0.0, 0.0, 0.0];
    };
};

// Exiting time accel — restore exact frozen pose and zero velocity so the spring
// resumes from a clean, stationary state.
if (_heli getVariable ["fza_sfmplus_simFrozen", false]) then {
    _heli setPosASL         (_heli getVariable "fza_sfmplus_frozenPos");
    _heli setVectorDirAndUp [(_heli getVariable "fza_sfmplus_frozenDir"), (_heli getVariable "fza_sfmplus_frozenUp")];
    _heli setVelocity        [0.0, 0.0, 0.0];
    _heli setAngularVelocity [0.0, 0.0, 0.0];
    _heli setVariable ["fza_sfmplus_simFrozen", false, true];
};

// Ground freeze — once all wheels have settled, lock position/attitude until collective > 0.20.
// Uses the same setPosASL override pattern as time-accel freeze so PhysX can't perturb the aircraft.
private _groundFrozen = _heli getVariable ["fza_sfmplus_groundFrozen", false];
if (_groundFrozen) then {
    private _collective    = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];
    private _parkingBrake  = _heli getVariable ["fza_ah64_toggleParkingBrake", true];
    if (_collective >= 0.20 || !_parkingBrake) then {
        // Release: pilot raising collective OR parking brake released for taxi.
        _heli setPosASL         (_heli getVariable "fza_sfmplus_groundFrozenPos");
        _heli setVectorDirAndUp [(_heli getVariable "fza_sfmplus_groundFrozenDir"), (_heli getVariable "fza_sfmplus_groundFrozenUp")];
        _heli setVelocity        [0.0, 0.0, 0.0];
        _heli setAngularVelocity [0.0, 0.0, 0.0];
        _heli setVariable ["fza_sfmplus_groundFrozen", false, true];
        // Settled flags preserved — spring resumes immediately in settled mode (locked K/C).
        // Reset prevSuspDist to equilibrium so the first resumed frame sees springVel ≈ 0
        // and the damper is silent (stale pre-freeze dist ≈ 0.20 m would otherwise spike it).
        _heli setVariable ["fza_sfmplus_wheelPrevSuspDistance", [0.0, 0.0, 0.0], false];
        diag_log format ["GroundFreeze RELEASED | collective: %1", _collective toFixed 3];
        // Fall through — normal physics resumes this frame.
    } else {
        // Maintain lock: override PhysX and skip all spring/damper math.
        _heli setPosASL         (_heli getVariable "fza_sfmplus_groundFrozenPos");
        _heli setVectorDirAndUp [(_heli getVariable "fza_sfmplus_groundFrozenDir"), (_heli getVariable "fza_sfmplus_groundFrozenUp")];
        _heli setVelocity        [0.0, 0.0, 0.0];
        _heli setAngularVelocity [0.0, 0.0, 0.0];
    };
} else {
    // Not frozen yet — check if front wheels have settled AND collective is at idle.
    // Tail wheel (2) excluded: its 7.4 m lever arm makes it slave to pitch oscillation;
    // front-wheel settle is sufficient to eliminate getCenterOfMass noise forcing.
    private _settled      = _heli getVariable "fza_sfmplus_wheelSettled";
    private _collective   = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];
    private _parkingBrake = _heli getVariable ["fza_ah64_toggleParkingBrake", true];
    if ((_settled select 0) && (_settled select 1) && (_collective < 0.10) && _parkingBrake) then {
        // Compute terrain contact point under each wheel.
        // prevSuspDistance[i] = compression (positive = underground). Adding it to the
        // current contact-point world Z gives the terrain Z at that wheel.
        // max 0.0: if wheel is above terrain, treat terrain as being at contact level.
        private _dists = _heli getVariable "fza_sfmplus_wheelPrevSuspDistance";
        // Contact points in model space = wheel centre + [0,0,-radius]
        private _t0 = (_heli modelToWorldWorld [1.09, 3.13, -3.01]) vectorAdd [0, 0, ((_dists select 0) max 0.0)];
        private _t1 = (_heli modelToWorldWorld [-1.09, 3.13, -3.01]) vectorAdd [0, 0, ((_dists select 1) max 0.0)];
        private _t2 = (_heli modelToWorldWorld [0.00, -7.39, -3.00]) vectorAdd [0, 0, ((_dists select 2) max 0.0)];
        private _tPts = [_t0, _t1, _t2];

        // Fit a plane to the three terrain contact points for the correct resting attitude.
        private _n = vectorNormalized (((_tPts select 1) vectorDiff (_tPts select 0)) vectorCrossProduct ((_tPts select 2) vectorDiff (_tPts select 0)));
        if ((_n select 2) < 0) then { _n = [0,0,0] vectorDiff _n; };

        // Align aircraft: up = terrain normal, forward = heading projected onto terrain plane.
        private _dir    = vectorDir _heli;
        private _newDir = vectorNormalized (_dir vectorDiff (_n vectorMultiply (_dir vectorDotProduct _n)));
        _heli setVectorDirAndUp [_newDir, _n];

        // Translate so the average wheel contact point lands on the average terrain surface.
        // _avgC is the model-space average of the three wheel contact points (pos + [0,0,-radius]).
        private _avgC = [0.00, -0.377, -3.007];
        private _avgT = ((_tPts select 0) vectorAdd (_tPts select 1) vectorAdd (_tPts select 2)) vectorMultiply (1.0/3.0);
        private _dZ   = (_avgT select 2) - ((_heli modelToWorldWorld _avgC) select 2);
        private _p    = getPosASL _heli;
        _heli setPosASL [_p select 0, _p select 1, (_p select 2) + _dZ];

        _heli setVelocity        [0.0, 0.0, 0.0];
        _heli setAngularVelocity [0.0, 0.0, 0.0];
        _heli setVariable ["fza_sfmplus_groundFrozenPos", getPosASL _heli, true];
        _heli setVariable ["fza_sfmplus_groundFrozenDir", vectorDir _heli, true];
        _heli setVariable ["fza_sfmplus_groundFrozenUp",  vectorUp  _heli, true];
        _heli setVariable ["fza_sfmplus_groundFrozen",    true,            true];
        diag_log format ["GroundFreeze ACTIVATED | dZ: %1 m | terrainNormal: %2", _dZ toFixed 3, _n];
    };
};

// Skip spring-damper calls and angular damping while the ground freeze is active.
if (_heli getVariable ["fza_sfmplus_groundFrozen", false]) exitWith {};

// Aircraft parameters
private _mass      = getMass _heli;  // 8006 kg (17650 lbs)
private _cg        = getCenterOfMass _heli;  // Dynamic CG from helicopter
private _g         = 9.81;

// Wheel positions (model space coordinates)
private _wheelPositions = [
    [ 1.09,  3.13, -2.70],   // Wheel 0 (right front)
    [-1.09,  3.13, -2.70],   // Wheel 1 (left front)
    [ 0.00, -7.39, -2.84]    // Wheel 2 (tail)
];

// Calculate dynamic damper constants based on load distribution
// Using formula: c = ζ * 2 * sqrt(m * k)
// Where ζ is target damping ratio (0.45 = slightly underdamped for responsive settling)
// ζ=1.5: still overdamped (no oscillation) but damper C is 40% lower than ζ=2.5.
// ζ=2.5 made liftoff impossible at normal collective: the damper's downward impulse
// when rising from compressed contact exceeded what the rotor+spring could overcome.
private _dampingRatio = 1.5;

// Calculate moment arms and wheel loads
// Front wheel span (Y coordinate distance)
private _frontY = (_wheelPositions select 0) select 1;
private _tailY  = (_wheelPositions select 2) select 1;
private _wheelSpan = _frontY - _tailY;  // 10.52

// Longitudinal load distribution (moment balance)
// _armCGToFront: distance from CG back to front wheels (short arm — small tail load)
// _armCGToTail:  distance from CG forward to tail wheel  (long arm  — large front load)
private _armCGToFront = _frontY - (_cg select 1);
private _armCGToTail  = (_cg select 1) - _tailY;

// Total moment arm span for equilibrium
private _totalMomentArm = _armCGToFront + _armCGToTail;

// Lateral (left/right) load distribution based on CG X position
private _frontTrack = abs(((_wheelPositions select 0) select 0) - ((_wheelPositions select 1) select 0)); // X distance between front wheels
private _cgX = _cg select 0;
private _rightFrac = 0.5 + (_cgX / _frontTrack); // Fraction of front load on right wheel
private _leftFrac  = 0.5 - (_cgX / _frontTrack); // Fraction of front load on left wheel

// Clamp fractions between 0 and 1 for safety
_rightFrac = _rightFrac max 0 min 1;
_leftFrac  = _leftFrac max 0 min 1;

// Front wheels carry the larger share: CG is close to front, far from tail
private _frontLoad = (_mass * _armCGToTail)  / _totalMomentArm;
private _tailLoad  = (_mass * _armCGToFront) / _totalMomentArm;

private _wheelLoads = [];
_wheelLoads set [0, _frontLoad * _rightFrac]; // Right front
_wheelLoads set [1, _frontLoad * _leftFrac];  // Left front
_wheelLoads set [2, _tailLoad];               // Tail

// Preload offset: spring applies k*(curSuspDist + x_eq) force, giving full equilibrium force
// at first contact (curSuspDist = 0). Wheel centre positions represent the resting position —
// contact point sits exactly on terrain with no underground sinking.
// Larger x_eq → softer spring (lower K_angular) so 25× setAngVel damping achieves ζ > 1
// for the angular modes without exceeding the dt × multiplier < 1 sign-flip limit.
private _x_eq = 1.0;
private _springConstants = [
    (_wheelLoads select 0) * _g / _x_eq,
    (_wheelLoads select 1) * _g / _x_eq,
    (_wheelLoads select 2) * _g / _x_eq
];

// Debug output for CG and per-wheel loads
diag_log format ["CG: %1 | RightFrac: %2 | LeftFrac: %3 | Loads: RF=%4, LF=%5, Tail=%6", _cg, _rightFrac, _leftFrac, _wheelLoads select 0, _wheelLoads select 1, _wheelLoads select 2];

private _worldVel = velocity _heli;
private _angVel   = angularVelocity _heli;
diag_log format ["Vel WS[X=%1, Y=%2, Z=%3] Speed=%4 | AngVel[X=%5, Y=%6, Z=%7] AngSpeed=%8",
    (_worldVel select 0) toFixed 3,
    (_worldVel select 1) toFixed 3,
    (_worldVel select 2) toFixed 3,
    (vectorMagnitude _worldVel) toFixed 3,
    (_angVel select 0) toFixed 3,
    (_angVel select 1) toFixed 3,
    (_angVel select 2) toFixed 3,
    (vectorMagnitude _angVel) toFixed 3
];

// Calculate damper constants for each wheel
// c = ζ * 2 * sqrt(m * k)
private _damperConstants = [];
for "_i" from 0 to 2 do {
    private _wheelMass = _wheelLoads select _i;
    private _springK = _springConstants select _i;
    // c = 2 * ζ * sqrt(m * k)
    private _damperC = _dampingRatio * 2 * sqrt(_wheelMass * _springK);
    _damperConstants set [_i, _damperC];
};

// --- Suspension settling period (first 10 frames) ---
private _frameCount = _heli getVariable "fza_sfmplus_suspensionFrameCount";

// Call wheels — pos is wheel centre; radius drives the ray geometry and strutHeight.
[_heli, 0, _wheelPositions select 0, 0.31, _springConstants select 0, _damperConstants select 0, _x_eq, _frameCount] call fza_sfmplus_fnc_suspensionWheel;
[_heli, 1, _wheelPositions select 1, 0.31, _springConstants select 1, _damperConstants select 1, _x_eq, _frameCount] call fza_sfmplus_fnc_suspensionWheel;
[_heli, 2, _wheelPositions select 2, 0.16, _springConstants select 2, _damperConstants select 2, _x_eq, _frameCount] call fza_sfmplus_fnc_suspensionWheel;

// Increment frame counter
_heli setVariable ["fza_sfmplus_suspensionFrameCount", _frameCount + 1, true];

// Ground angular damping — 12× decay on roll/pitch kills spring-excited oscillation.
// addTorque is intentionally omitted: unknown PhysX inertia means addTorque + setAngularVelocity
// combined can exceed a damping factor of 1.0/frame, causing sign-flip instability.
if ((_heli getVariable "fza_sfmplus_wheelPrevSuspDistance") findIf {_x > -0.5} >= 0) then {
    private _dt          = (_heli getVariable "fza_sfmplus_deltaTime") min 0.033;
    private _angVelModel = _heli vectorWorldToModel (angularVelocity _heli);
    private _pitch = asin  ((vectorDir _heli) select 2);          // +ve = nose up  (deg)
    private _bank  = asin (-((vectorUp  _heli) select 0));        // +ve = bank left (deg)
    // Casual mode: remove the pitch attitude correction entirely.  The correction peak is
    // ~0.22 rad/s at -2.5° — large enough to prevent the pilot from holding -5° nose-down
    // for rolling takeoff regardless of scaling attempts.  The 25× angular velocity decay
    // (multiplier = 0.10 per frame) already damps PhysX-injected pitch noise on its own.
    // Bank correction is kept: roll stability is still desirable in casual mode.
    private _pitchCorr = if (fza_ah64_sfmplusRealismSetting != REALISTIC) then {0.0} else {(_pitch * 0.01745) * 10.0};
    _heli setAngularVelocity (_heli vectorModelToWorld [
        (_angVelModel select 0) * (1.0 - (_dt * 25.0)) + _pitchCorr,
        (_angVelModel select 1) * (1.0 - (_dt * 25.0)) - (_bank  * 0.01745) * 10.0,
        (_angVelModel select 2) * (1.0 - (_dt *  3.0))
    ]);
    diag_log format ["AngDamp | RollRate: %1 PitchRate: %2 | Pitch: %3 Bank: %4",
        (_angVelModel select 1) toFixed 4, (_angVelModel select 0) toFixed 4,
        _pitch toFixed 2, _bank toFixed 2];
};
