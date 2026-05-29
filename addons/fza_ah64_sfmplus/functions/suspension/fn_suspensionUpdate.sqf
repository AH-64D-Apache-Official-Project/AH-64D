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
    [ 1.09,  3.39, -2.98],   // Wheel 0 (right front)
    [-1.09,  3.39, -2.98],   // Wheel 1 (left front)
    [ 0.00, -7.31, -2.95]    // Wheel 2 (tail)
];

// Calculate dynamic damper constants based on load distribution
// Using formula: c = ζ * 2 * sqrt(m * k)
// Where ζ is target damping ratio (0.45 = slightly underdamped for responsive settling)
private _dampingRatio = 1.5; // Overdamped to reduce differential spring excitation of roll mode

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
    _heli setAngularVelocity (_heli vectorModelToWorld [
        (_angVelModel select 0) * (1.0 - (_dt * 25.0)),
        (_angVelModel select 1) * (1.0 - (_dt * 25.0)),
        (_angVelModel select 2) * (1.0 - (_dt *  3.0))
    ]);
    private _pitch = asin  ((vectorDir _heli) select 2);          // +ve = nose up  (deg)
    private _bank  = asin (-((vectorUp  _heli) select 0));        // +ve = bank right (deg)
    diag_log format ["AngDamp | RollRate: %1 PitchRate: %2 | Pitch: %3 Bank: %4",
        (_angVelModel select 1) toFixed 4, (_angVelModel select 0) toFixed 4,
        _pitch toFixed 2, _bank toFixed 2];
};
