


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

// Cap at 33 ms (30 fps minimum) so a single long frame can't over-apply spring impulse
// and lift the aircraft, which would produce a false high-velocity unsettle on the next frame.
private _deltaTime = (_heli getVariable "fza_sfmplus_deltaTime") min 0.033;
diag_log format ["Wheel %1 - DeltaTime: %2", _num, _deltaTime];

private _curSuspDist    = 0.0;
private _springVel      = 0.0;
private _springForce    = 0.0;
private _damperForce    = 0.0;
private _prevSuspDist   = _heli getVariable "fza_sfmplus_wheelPrevSuspDistance" select _num;

private _strut           = [0.0, 0.0, -_length];
_strut                   = [_strut, _vectorRight, _angle] call fza_sfmplus_fnc_quaternion;
private _wheelPos        = _pos vectorAdd _strut;
private _contactPointPos = _wheelPos vectorAdd [0.0, 0.0, -_radius];
private _strutHeight     = ((_pos select 2) - (_wheelPos select 2)) + _radius;

private _heightOfTerrain    = 0.0;
private _heightAboveTerrain = 0.0;
private _posASL             = _heli modelToWorldWorld _pos;
// Ray extended 0.2 m beyond max strut reach to avoid false no-contact when the aircraft
// is marginally above the wheel's extension limit during decompression.
private _rayCastArray = lineIntersectsSurfaces [_posASL, _posASL vectorAdd [0.0, 0.0, -(_strutHeight + 0.2)], _heli, objNull, true, 1, "GEOM"];

if (count _rayCastArray > 0) then {
    _heightOfTerrain    = (_rayCastArray select 0 select 0) select 2;
    _heightAboveTerrain = (_posASL select 2) - _heightOfTerrain;
    _curSuspDist = _strutHeight - _heightAboveTerrain;

    private _settled    = _heli getVariable "fza_sfmplus_wheelSettled"    select _num;
    private _settledK   = _heli getVariable "fza_sfmplus_wheelSettledK"   select _num;
    private _settleTime = _heli getVariable "fza_sfmplus_wheelSettleTime" select _num;

    // Compute velocity for both disturbance detection and (unsettled) spring-damper.
    _springVel = (_curSuspDist - _prevSuspDist) / _deltaTime;
    private _inSettledMode = _settled && (abs _springVel) < 1.5;

    if (_inSettledMode) then {
        // Locked-K spring, no damper.
        // Spring constant is frozen at settle time to eliminate per-frame getCenterOfMass
        // noise (±15% variation) that continuously perturbs the resting aircraft.
        // Live compression is kept so roll/pitch tilts still produce corrective spring forces.
        // Disturbance threshold is velocity-based (0.5 m/s) so only actual impacts unsettle
        // the wheel — not the slow roll drift that compression-based detection caused.
        _springForce = (_settledK * _curSuspDist) * _deltaTime;
        _heli addForce [[0, 0, _springForce max 0.0], _pos];
    } else {
        // Disturbance detected OR not yet settled — run full spring-damper.
        if (_settled) then {
            [_heli, "fza_sfmplus_wheelSettled",    _num, false, true] call fza_fnc_setArrayVariable;
            [_heli, "fza_sfmplus_wheelSettleTime", _num, 0.0,   true] call fza_fnc_setArrayVariable;
            _settled    = false;
            _settleTime = 0.0;
            diag_log format ["Wheel %1 - UNSETTLED | vel: %2", _num, _springVel toFixed 3];
        };

        _springVel = _springVel max -5 min 5;

        // --- Initial contact: smoothstep ramp over first 10 frames ---
        private _settleFrames = 10;
        if (!isNil { _frameCount } && { _frameCount < _settleFrames }) then {
            private _t = _frameCount / (_settleFrames - 1);
            _t = _t * _t * (3 - 2 * _t);
            _curSuspDist = _curSuspDist * _t;
            _springVel   = _springVel   * _t;
        };

        _springForce = (_springConstant * _curSuspDist) * _deltaTime;
        _damperForce = (_damperConstant * _springVel)   * _deltaTime;

        // Semi-implicit: damper can never pull down harder than spring pushes up.
        _damperForce = _damperForce max (-_springForce);
        private _totalForce = (_springForce + _damperForce) max 0.0;

        _heli addForce [[0, 0, _totalForce], _pos];

        diag_log format ["Wheel %1 - Dist: %2 | SpringF: %3 | DamperF: %4 | Vel: %5 | Frame: %6 | ST: %7",
            _num, _curSuspDist toFixed 3, _springForce toFixed 0, _damperForce toFixed 0,
            _springVel toFixed 3, _frameCount, _settleTime toFixed 2];

        // Accumulate settle time while spring velocity is small and wheel is loaded.
        // Threshold 0.05 m/s accommodates ~1 mm/frame PhysX position jitter.
        if (abs _springVel < 0.05 && _prevSuspDist > 0.0 && _curSuspDist > 0.05) then {
            _settleTime = _settleTime + _deltaTime;
            if (_settleTime >= 0.3) then {
                [_heli, "fza_sfmplus_wheelSettled",  _num, true,            true] call fza_fnc_setArrayVariable;
                [_heli, "fza_sfmplus_wheelSettledK", _num, _springConstant, true] call fza_fnc_setArrayVariable;
                diag_log format ["Wheel %1 - SETTLED | K: %2 Dist: %3", _num, _springConstant toFixed 1, _curSuspDist toFixed 4];
            };
        } else {
            _settleTime = 0.0;
        };
        [_heli, "fza_sfmplus_wheelSettleTime", _num, _settleTime, true] call fza_fnc_setArrayVariable;
    };

    // Suppress PhysX restitution during active spring-damper phase only.
    // Captured after addForce so the post-impulse upward velocity is visible.
    // Skipped in settled mode so rotor-generated lift is not blocked at takeoff.
    private _wVel = velocity _heli;
    if (!_inSettledMode && (_wVel select 2) > 0.05) then {
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
    // No ground contact — reset all per-wheel state.
    if (_heli getVariable "fza_sfmplus_wheelSettled" select _num) then {
        [_heli, "fza_sfmplus_wheelSettled",    _num, false, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_wheelSettleTime", _num, 0.0,   true] call fza_fnc_setArrayVariable;
    };
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
