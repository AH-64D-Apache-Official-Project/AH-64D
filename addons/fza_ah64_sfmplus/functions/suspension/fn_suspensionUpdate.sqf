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

// Fixed spring constants (tuned for aircraft stiffness)
private _springConstants = [60000, 60000, 30000];

// Calculate dynamic damper constants based on load distribution
// Using formula: c = ζ * 2 * sqrt(m * k)
// Where ζ is target damping ratio (0.45 = slightly underdamped for responsive settling)
private _dampingRatio = 0.6; // Increased for more critical damping

// Calculate moment arms and wheel loads
// Front wheel span (Y coordinate distance)
private _frontY = 4.24;
private _tailY = -6.28;
private _wheelSpan = _frontY - _tailY;  // 10.52

// Longitudinal load distribution (moment balance)
// Tail moment arm (distance from tail wheel to front wheel CG projection)
private _tailMomentArm = _frontY - (_cg select 1);  // Distance from tail to CG
// Front moment arm (distance from front wheels to tail wheel CG projection)
private _frontMomentArm = (_cg select 1) - _tailY;  // Distance from CG to tail

// Total moment arm span for equilibrium
private _totalMomentArm = _frontMomentArm + _tailMomentArm;

// Lateral (left/right) load distribution based on CG X position
private _frontTrack = abs(((_wheelPositions select 0) select 0) - ((_wheelPositions select 1) select 0)); // X distance between front wheels
private _cgX = _cg select 0;
private _rightFrac = 0.5 - (_cgX / _frontTrack); // Fraction of front load on right wheel
private _leftFrac  = 0.5 + (_cgX / _frontTrack); // Fraction of front load on left wheel

// Clamp fractions between 0 and 1 for safety
_rightFrac = _rightFrac max 0 min 1;
_leftFrac  = _leftFrac max 0 min 1;

private _frontLoad = (_mass * _tailMomentArm) / _totalMomentArm;
private _tailLoad  = (_mass * _frontMomentArm) / _totalMomentArm;

private _wheelLoads = [];
_wheelLoads set [0, _frontLoad * _rightFrac]; // Right front
_wheelLoads set [1, _frontLoad * _leftFrac];  // Left front
_wheelLoads set [2, _tailLoad];               // Tail

// Debug output for CG and per-wheel loads
diag_log format ["CG: %1 | RightFrac: %2 | LeftFrac: %3 | Loads: RF=%4, LF=%5, Tail=%6", _cg, _rightFrac, _leftFrac, _wheelLoads select 0, _wheelLoads select 1, _wheelLoads select 2];

// Calculate damper constants for each wheel
// c = ζ * 2 * sqrt(m * k)
private _damperConstants = [];
for "_i" from 0 to 2 do {
    private _wheelMass = _wheelLoads select _i;
    private _springK = _springConstants select _i;
    private _naturalFreq = sqrt(_springK / _wheelMass);
    private _damperC = _dampingRatio * 2 * _wheelMass * _naturalFreq;
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
