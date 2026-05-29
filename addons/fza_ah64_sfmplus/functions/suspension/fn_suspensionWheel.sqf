


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

params ["_heli", "_num", "_pos", "_radius", "_springConstant", "_damperConstant", "_x_eq", "_frameCount"];

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

// _pos is the wheel centre; ray starts at the top of the wheel and the contact point
// is the bottom of the wheel, so strutHeight spans the full diameter.
private _contactPointPos = _pos vectorAdd [0.0, 0.0, -_radius];
private _strutHeight     = 2.0 * _radius;

private _heightOfTerrain    = 0.0;
private _heightAboveTerrain = 0.0;
private _posASL             = _heli modelToWorldWorld (_pos vectorAdd [0.0, 0.0, _radius]);
// Ghost zone of 0.25 m keeps wheels in the ray-hit branch during tiny bounces and covers the
// ~0.18 m natural tail clearance when front wheels sit at Dist=0 on flat ground.
// Without it, the tail exits the contact branch → -1.0 sentinel → large vel spike on re-entry.
private _rayCastArray = lineIntersectsSurfaces [_posASL, _posASL vectorAdd [0.0, 0.0, -(_strutHeight + 0.25)], _heli, objNull, true, 1, "GEOM"];

if (count _rayCastArray > 0) then {
    _heightOfTerrain    = (_rayCastArray select 0 select 0) select 2;
    _heightAboveTerrain = (_posASL select 2) - _heightOfTerrain;
    _curSuspDist = _strutHeight - _heightAboveTerrain;
    // Ghost zone yields negative curSuspDist. Spring uses max 0 so only preload fires there.
    private _effectiveDist = _curSuspDist max 0.0;

    private _settled    = _heli getVariable "fza_sfmplus_wheelSettled"    select _num;
    private _settledK   = _heli getVariable "fza_sfmplus_wheelSettledK"   select _num;
    private _settledC   = _heli getVariable "fza_sfmplus_wheelSettledC"   select _num;
    private _settleTime = _heli getVariable "fza_sfmplus_wheelSettleTime" select _num;

    // Compute velocity for both disturbance detection and (unsettled) spring-damper.
    _springVel = (_curSuspDist - _prevSuspDist) / _deltaTime;
    private _inSettledMode = _settled && (abs _springVel) < 1.5;

    if (_inSettledMode) then {
        // Locked-K spring + locked-C damper.  Both constants are frozen at settle time to
        // eliminate per-frame getCenterOfMass noise (±15% spikes) that otherwise continuously
        // perturbs forces and prevents the settle timer from holding.  Live compression is kept
        // so roll/pitch tilts still produce corrective spring forces.
        _springForce = (_settledK * (_effectiveDist + _x_eq)) * _deltaTime;
        _damperForce = (_settledC * _springVel)               * _deltaTime;
        private _totalForce = _springForce + _damperForce;
        if (_effectiveDist <= 0.0) then { _totalForce = _totalForce max 0.0; };
        _heli addForce [[0, 0, _totalForce], _pos];
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

        _springForce = (_springConstant * (_effectiveDist + _x_eq)) * _deltaTime;
        _damperForce = (_damperConstant * _springVel)              * _deltaTime;

        // Suppress the damper whenever prevSuspDist is not a real compression reading:
        //   frame 0  → init value 0.0 is meaningless
        //   re-contact after airborne → sentinel -1.0 makes vel = (dist+1)/dt ≈ 50 m/s
        // In both cases the velocity is garbage; only the spring fires this frame.
        // The damper picks up on the very next frame with a real prevSuspDist.
        if (_frameCount == 0 || _prevSuspDist < -0.5) then { _damperForce = 0.0; };

        // When compressed (effectiveDist > 0), allow the damper to resist rebound fully —
        // total force may go negative so the damper brakes the bounce on touchdown.
        // In the ghost zone (effectiveDist = 0), only the preload fires; no pull.
        private _totalForce = _springForce + _damperForce;
        if (_effectiveDist <= 0.0) then { _totalForce = _totalForce max 0.0; };

        _heli addForce [[0, 0, _totalForce], _pos];

        diag_log format ["Wheel %1 - Dist: %2 | SpringF: %3 | DamperF: %4 | Vel: %5 | Frame: %6 | ST: %7",
            _num, _curSuspDist toFixed 3, _springForce toFixed 0, _damperForce toFixed 0,
            _springVel toFixed 3, _frameCount, _settleTime toFixed 2];

        // Accumulate settle time while spring velocity is below 0.12 m/s.
        // 0.12 tolerates getCenterOfMass noise spikes (~0.07-0.10 m/s) without false resets.
        if (abs _springVel < 0.12) then {
            _settleTime = _settleTime + _deltaTime;
            if (_settleTime >= 0.3) then {
                [_heli, "fza_sfmplus_wheelSettled",  _num, true,            true] call fza_fnc_setArrayVariable;
                [_heli, "fza_sfmplus_wheelSettledK", _num, _springConstant, true] call fza_fnc_setArrayVariable;
                [_heli, "fza_sfmplus_wheelSettledC", _num, _damperConstant, true] call fza_fnc_setArrayVariable;
                diag_log format ["Wheel %1 - SETTLED | K: %2 C: %3 Dist: %4", _num, _springConstant toFixed 1, _damperConstant toFixed 1, _curSuspDist toFixed 4];
            };
        } else {
            _settleTime = 0.0;
        };
        [_heli, "fza_sfmplus_wheelSettleTime", _num, _settleTime, true] call fza_fnc_setArrayVariable;
    };

    // Friction: resist translation and yaw rotation using only in-plane wheel positions.
    // Only ωz contributes via px/py — using ωx/ωy with pz creates spurious roll/pitch torques
    // that fight the spring system. Note: Arma3 angularVelocity sign is inverted vs right-hand rule.
    private _wVel        = velocity _heli;
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
    [_heli, "fza_sfmplus_wheelPrevSuspDistance", _num, -1.0, true] call fza_fnc_setArrayVariable;
};

#ifdef __A3_DEBUG__
//Wheel (pos is wheel centre)
[_heli, 24, _pos, _radius, 0, "white"]   call fza_fnc_debugDrawCircle;
[_heli, _pos vectorDiff [0.00, _radius, 0.00], _pos vectorAdd [0.00, _radius, 0.00], "green"] call fza_fnc_debugDrawLine;
[_heli, _pos vectorDiff [0.00, 0.00, _radius], _pos vectorAdd [0.00, 0.00, _radius], "blue"] call fza_fnc_debugDrawLine;

//Contact Point (bottom of wheel)
[_heli, 24, _contactPointPos, 0.05, 0, "white"]   call fza_fnc_debugDrawCircle;
[_heli, 24, _contactPointPos, 0.05, 1, "white"]   call fza_fnc_debugDrawCircle;
[_heli, 24, _contactPointPos, 0.05, 2, "white"]   call fza_fnc_debugDrawCircle;
[_heli, _contactPointPos vectorDiff [0.05, 0.00, 0.00], _contactPointPos vectorAdd [0.05, 0.00, 0.00], "red"] call fza_fnc_debugDrawLine;
[_heli, _contactPointPos vectorDiff [0.00, 0.05, 0.00], _contactPointPos vectorAdd [0.00, 0.05, 0.00], "green"] call fza_fnc_debugDrawLine;
[_heli, _contactPointPos vectorDiff [0.00, 0.00, 0.05], _contactPointPos vectorAdd [0.00, 0.00, 0.05], "blue"] call fza_fnc_debugDrawLine;

//Ray (top of wheel to bottom)
[_heli, _pos vectorAdd [0.0,0.0,_radius], _contactPointPos, "red"] call fza_fnc_debugDrawLine;
#endif
