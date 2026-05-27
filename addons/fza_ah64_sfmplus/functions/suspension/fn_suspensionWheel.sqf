


/*
params ["_heli", "_wheelPos", "_wheelRadius", "_axis"];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

#ifdef __A3_DEBUG__
[_heli, _wheelPos, _wheelPos vectorAdd _axisX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _wheelPos, _wheelPos vectorAdd _axisY, "green"] call fza_fnc_debugDrawLine;
[_heli, _wheelPos, _wheelPos vectorAdd _axisZ, "blue"]  call fza_fnc_debugDrawLine;
[_heli, 24, _wheelPos, _wheelRadius, _axis, "white"]    call fza_fnc_debugDrawCircle;
#endif
*/

params ["_heli", "_num", "_pos", "_length", "_angle", "_radius", "_springConstant", "_damperConstant", "_frameCount"];

if (_heli getVariable ["fza_sfmplus_suspensionDisabled", false]) exitWith {};

// Debug timestep
private _deltaTime = _heli getVariable "fza_sfmplus_deltaTime";
diag_log format ["Wheel %1 - DeltaTime: %2", _num, _deltaTime];

private _curSuspDist    = 0.0;
private _springVel      = 0.0;
private _springForce    = 0.0;
private _damperForce    = 0.0;
private _prevSuspDist   = _heli getVariable "fza_sfmplus_wheelPrevSuspDistance" select _num;

private _strut          = [0.0, 0.0, -_length];
_strut                  = [_strut, _vectorRight, _angle] call fza_sfmplus_fnc_quaternion;
private _wheelPos       = _pos vectorAdd _strut;
private _contactPointPos = _wheelPos vectorAdd [0.0, 0.0, -_radius];
private _strutHeight    = ((_pos select 2) - (_wheelPos select 2)) + _radius;

private _heightOfTerrain    = 0.0;
private _heightAboveTerrain = 0.0;
private _posASL             = _heli modelToWorldWorld _pos;
private _rayCastArray       = lineIntersectsSurfaces [_posASL, _posASL vectorAdd [0.0, 0.0, -_strutHeight], _heli, objNull, true, 1, "GEOM"];

if (count _rayCastArray > 0) then {
    _heightOfTerrain    = (_rayCastArray select 0 select 0) select 2;
    _heightAboveTerrain = (_posASL select 2) - _heightOfTerrain;
    _curSuspDist = _strutHeight - _heightAboveTerrain;
    _springVel   = (_curSuspDist - _prevSuspDist) / _deltaTime;

    // Clamp spring velocity to prevent runaway oscillations
    _springVel = _springVel max -5 min 5;


    // --- Settling period: smoothstep interpolation for first 10 frames ---
    private _settleFrames = 10;
    if (!isNil { _frameCount } && { _frameCount < _settleFrames }) then {
        private _t = _frameCount / (_settleFrames - 1);
        // Smoothstep: t = t*t*(3-2*t)
        _t = _t * _t * (3 - 2 * _t);
        _curSuspDist = _curSuspDist * _t;
        _springVel = _springVel * _t;
    };


    _springForce = (_springConstant * _curSuspDist) * _deltaTime;
    _damperForce = (_damperConstant * _springVel)   * _deltaTime;

    // Semi-implicit: damper can never pull down harder than spring pushes up.
    // Prevents energy injection during rebound (damperForce overwhelming springForce).
    _damperForce = _damperForce max (-_springForce);
    private _totalForce = (_springForce + _damperForce) max 0.0;

    // Debug output to Arma 3 log file
    diag_log format ["Wheel %1 - Dist: %2 | SpringF: %3 | DamperF: %4 | Vel: %5 | Frame: %6", 
        _num, 
        _curSuspDist toFixed 3, 
        _springForce toFixed 0, 
        _damperForce toFixed 0, 
        _springVel toFixed 3,
        _frameCount
    ];

    // Apply spring force in world-up direction — prevents lateral force when aircraft is tilted
    _heli addForce [[0, 0, _totalForce], _pos];

    // Get current velocity once for both suppression and friction
    private _wVel = velocity _heli;

    // Suppress PhysX restitution: zero world-space upward velocity while a wheel is loaded
    if ((_wVel select 2) > 0.05) then {
        _heli setVelocity [_wVel select 0, _wVel select 1, 0];
    };

    // Friction: resist translation and yaw rotation using only in-plane wheel positions.
    // Only ωz contributes via px/py — using ωx/ωy with pz creates spurious roll/pitch torques
    // that fight the spring system. Note: Arma3 angularVelocity sign is inverted vs right-hand rule.
    private _velLocal    = _heli vectorWorldToModel _wVel;
    private _oz = (_heli vectorWorldToModel (angularVelocity _heli)) select 2;
    private _px = _pos select 0;
    private _py = _pos select 1;
    private _contactVelX = (_velLocal select 0) + (_oz * _py);
    private _contactVelY = (_velLocal select 1) - (_oz * _px);
    private _horizVel = [_contactVelX, _contactVelY, 0.0];
    private _velMag   = vectorMagnitude _horizVel;

    if (_velMag > 0.01) then {
        private _mass          = getMass _heli;
        private _normalForce   = _springForce;
        private _frictionForce = _normalForce * 0.8;
        // Clamp so a single wheel can't contribute more than 1/3 of the impulse
        // needed to stop the CG — prevents per-frame velocity reversal and oscillation.
        _frictionForce = _frictionForce min (_mass * _velMag / 3.0);
        private _frictionVector = _horizVel vectorMultiply (-_frictionForce / _velMag);
        _heli addForce [_heli vectorModelToWorld _frictionVector, _pos];
    };

    [_heli, "fza_sfmplus_wheelPrevSuspDistance", _num, _curSuspDist, true] call fza_fnc_setArrayVariable;
} else {
    [_heli, "fza_sfmplus_wheelPrevSuspDistance", _num, 0.0, true] call fza_fnc_setArrayVariable;
};

#ifdef __A3_DEBUG__
//Wheel
[_heli, _pos, _wheelPos, "white"] call fza_fnc_debugDrawLine;
[_heli, 24, _wheelPos, _radius, 0, "white"]   call fza_fnc_debugDrawCircle;
[_heli, _wheelPos vectorDiff [0.00, _radius, 0.00], _wheelPos vectorAdd [0.00, _radius, 0.00], "green"] call fza_fnc_debugDrawLine;
[_heli, _wheelPos vectorDiff [0.00, 0.00, _radius], _wheelPos vectorAdd [0.00, 0.00, _radius], "blue"] call fza_fnc_debugDrawLine;

//Contact Point
[_heli, 24, _contactPointPos, 0.05, 0, "white"]   call fza_fnc_debugDrawCircle;
[_heli, 24, _contactPointPos, 0.05, 1, "white"]   call fza_fnc_debugDrawCircle;
[_heli, 24, _contactPointPos, 0.05, 2, "white"]   call fza_fnc_debugDrawCircle;
[_heli, _contactPointPos vectorDiff [0.05, 0.00, 0.00], _contactPointPos vectorAdd [0.05, 0.00, 0.00], "red"] call fza_fnc_debugDrawLine;
[_heli, _contactPointPos vectorDiff [0.00, 0.05, 0.00], _contactPointPos vectorAdd [0.00, 0.05, 0.00], "green"] call fza_fnc_debugDrawLine;
[_heli, _contactPointPos vectorDiff [0.00, 0.00, 0.05], _contactPointPos vectorAdd [0.00, 0.00, 0.05], "blue"] call fza_fnc_debugDrawLine;

//Ray
[_heli, _pos, _pos vectorAdd [0.0,0.0, -_strutHeight], "red"] call fza_fnc_debugDrawLine;
#endif