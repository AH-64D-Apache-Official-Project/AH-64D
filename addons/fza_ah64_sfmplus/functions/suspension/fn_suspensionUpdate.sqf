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
/*
params ["_heli"];

//_heli enableSimulation false;

systemChat format ["v2.43"];
//heli----index----suspensionPos----wheelPosComp----wheelPosNonComp----wheelRadius
[_heli, 0, [ 0.75, 3.12,-1.22], [ 0.25, 0.00,-1.50], [0.25, 0.00,-1.72], 0.37] call fza_sfmplus_fnc_suspension;
[_heli, 1, [-0.75, 3.12,-1.22], [-0.25, 0.00,-1.50], [0.25, 0.00,-1.72], 0.37] call fza_sfmplus_fnc_suspension;
[_heli, 2, [ 0.00,-7.40,-2.45], [ 0.00, 0.00,-0.37], [0.00, 0.00,-0.52], 0.18] call fza_sfmplus_fnc_suspension;
*/

params ["_heli"];

// Aircraft parameters
private _mass      = getMass _heli;  // 8006 kg (17650 lbs)
private _cg        = getCenterOfMass _heli;  // Dynamic CG from helicopter
private _g         = 9.81;

// Wheel positions (model space coordinates)
private _wheelPositions = [
    [ 1.2,  4.24, -1.9],   // Wheel 0 (right front)
    [-1.2,  4.24, -1.9],   // Wheel 1 (left front)
    [ 0.0, -6.28, -2.4]    // Wheel 2 (tail)
];

// Calculate dynamic damper constants based on load distribution
// Using formula: c = ζ * 2 * sqrt(m * k)
// Where ζ is target damping ratio (0.45 = slightly underdamped for responsive settling)
private _dampingRatio = 1.5; // Overdamped to reduce differential spring excitation of roll mode

// Calculate moment arms and wheel loads
// Front wheel span (Y coordinate distance)
private _frontY = 4.24;
private _tailY = -6.28;
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
private _rightFrac = 0.5 - (_cgX / _frontTrack); // Fraction of front load on right wheel
private _leftFrac  = 0.5 + (_cgX / _frontTrack); // Fraction of front load on left wheel

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

// Target equilibrium compression: front struts ~0.46 m (~33% of 1.37 m travel).
// k = wheelLoad * g / x_eq — springs are load-proportional so all wheels sag equally.
private _x_eq = 0.46;
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

// Call wheels with frame count for settling logic
[_heli, 0, _wheelPositions select 0, 1.35, -38, 0.31, _springConstants select 0, _damperConstants select 0, _frameCount] call fza_sfmplus_fnc_suspensionWheel;
[_heli, 1, _wheelPositions select 1, 1.35, -38, 0.31, _springConstants select 1, _damperConstants select 1, _frameCount] call fza_sfmplus_fnc_suspensionWheel;
[_heli, 2, _wheelPositions select 2, 1.20, 300, 0.16, _springConstants select 2, _damperConstants select 2, _frameCount] call fza_sfmplus_fnc_suspensionWheel;

// Increment frame counter
_heli setVariable ["fza_sfmplus_suspensionFrameCount", _frameCount + 1, true];

// Ground angular damping — damp roll/pitch oscillation from differential spring forces.
// Roll (Y axis) and pitch (X axis) have no explicit damping in the friction system.
// I is estimated as mass × arm² which pairs each axis with its own wheel geometry arm.
// c = 2 × sqrt(I × k_ang) follows the same critical-damping formula as the linear suspension.
// No new config values: everything is derived from _mass, _wheelPositions, _springConstants.
if ((_heli getVariable "fza_sfmplus_wheelPrevSuspDistance") findIf {_x > 0.001} >= 0) then {
    private _dt   = (_heli getVariable "fza_sfmplus_deltaTime") min 0.033;
    private _px   = abs ((_wheelPositions select 0) select 0);   // 1.2  m  half-track
    private _py_f = abs ((_wheelPositions select 0) select 1);   // 4.24 m  front arm
    private _py_t = abs ((_wheelPositions select 2) select 1);   // 6.28 m  tail arm
    private _kRoll  = 2 * (_springConstants select 0) * _px  * _px;
    private _kPitch = (_springConstants select 0) * _py_f * _py_f
                    + (_springConstants select 2) * _py_t * _py_t;
    // Both axes use _px² as the inertia estimate (half-track ≈ fuselage radius of gyration).
    // Using _py_f² for pitch yields I_est >> I_actual → c*dt/I > 1 → per-frame sign-flip instability.
    private _iEst   = _mass * _px * _px;
    private _cRoll  = 6.0 * sqrt(_iEst * _kRoll);
    private _cPitch = 6.0 * sqrt(_iEst * _kPitch);
    private _angVelModel = _heli vectorWorldToModel (angularVelocity _heli);
    _heli addTorque (_heli vectorModelToWorld [
        (_angVelModel select 0) * -_cPitch * _dt,
        (_angVelModel select 1) * -_cRoll  * _dt,
        0
    ]);
    // Direct angular velocity decay while on the ground.
    // addTorque effectiveness depends on PhysX inertia (unknown), so this guarantees
    // convergence. Axis-specific: roll (Y) uses 12× to quickly kill spring-excited oscillation;
    // pitch (X) stays at 3× so the tail wheel can still pitch to its equilibrium.
    _heli setAngularVelocity (_heli vectorModelToWorld [
        (_angVelModel select 0) * (1.0 - (_dt * 3.0)),
        (_angVelModel select 1) * (1.0 - (_dt * 12.0)),
        (_angVelModel select 2) * (1.0 - (_dt * 3.0))
    ]);
    diag_log format ["AngDamp | RollRate: %1 PitchRate: %2 cRoll: %3 cPitch: %4",
        (_angVelModel select 1) toFixed 4, (_angVelModel select 0) toFixed 4,
        _cRoll toFixed 0, _cPitch toFixed 0];
};
