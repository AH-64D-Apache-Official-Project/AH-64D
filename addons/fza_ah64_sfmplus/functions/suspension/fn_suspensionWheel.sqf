


params ["_heli", "_num", "_pos", "_radius", "_springConstant", "_damperConstant", "_x_eq", "_frameCount"];

if (_heli getVariable ["fza_sfmplus_suspensionDisabled", false]) exitWith {};

// getDeltaTime already multiplies by accTime and caps at 0.10 s.
// Angular damping in fn_suspensionUpdate uses a tighter 0.033 s cap (25× multiplier limit).
private _deltaTime = (_heli getVariable "fza_sfmplus_deltaTime") min 0.10;
diag_log format ["Wheel %1 - DeltaTime: %2", _num, _deltaTime];

private _curSuspDist    = 0.0;
private _springForce    = 0.0;
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
// Ghost zone extended to 0.50 m so the spring tapers over 0.50 m of rise rather
// than disappearing abruptly at 0.25 m, which caused a hard vertical bob on liftoff.
private _rayCastArray = lineIntersectsSurfaces [_posASL, _posASL vectorAdd [0.0, 0.0, -(_strutHeight + 0.50)], _heli, objNull, true, 1, "GEOM"];

if (count _rayCastArray > 0) then {
    _heightOfTerrain    = (_rayCastArray select 0 select 0) select 2;
    _heightAboveTerrain = (_posASL select 2) - _heightOfTerrain;
    _curSuspDist = _strutHeight - _heightAboveTerrain;
    // Cap at physical strut travel: the wheel cannot compress beyond its own diameter.
    // Prevents runaway spring force when terrain geometry pushes the contact point
    // deeper than the strut can physically reach (e.g. one wheel on a steep slope).
    _curSuspDist = _curSuspDist min _strutHeight;
    // effectiveDist = curSuspDist (allowed to be negative in the ghost zone).
    // At curSuspDist < 0: spring = K×(neg+x_eq) < gravity → net downward → aircraft descends to 0.
    // At curSuspDist > 0: spring = K×(pos+x_eq) > gravity → net upward → aircraft rises to 0.
    // Both sides push toward curSuspDist = 0, making the equilibrium fully stable.
    private _effectiveDist = _curSuspDist;

    // Scale spring and damper forces by the wheel's residual load fraction.
    // At hover power the rotor carries most of the aircraft weight; full spring force on top of
    // rotor lift causes violent overshoot on any terrain contact (spring + rotor >> gravity).
    // (1 - collective) ≈ the fraction of weight still on the wheels, so the spring only supplies
    // the residual support not already provided by the rotor.  At engines-off (collective = 0)
    // loadScale = 1.0 and the spring behaves exactly as before.
    private _collective = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];
    private _loadScale  = (1.0 - _collective) max 0.0;

    private _springVel  = 0.0;
    private _damperForce = 0.0;

        private _settled    = _heli getVariable "fza_sfmplus_wheelSettled"    select _num;
        private _settledK   = _heli getVariable "fza_sfmplus_wheelSettledK"   select _num;
        private _settledC   = _heli getVariable "fza_sfmplus_wheelSettledC"   select _num;
        private _settleTime = _heli getVariable "fza_sfmplus_wheelSettleTime" select _num;

        // Compute velocity for both disturbance detection and spring-damper.
        _springVel = (_curSuspDist - _prevSuspDist) / _deltaTime;
        // Clamp spring velocity: stable at ±3 m/s up to dt=0.10 (damperC×3×0.10 < wheelLoad).
        // Lower clamp reduces per-frame impulse on hard landings, preventing overshoot bounce.
        _springVel = _springVel max -3.0 min 3.0;
        private _inSettledMode = _settled && (abs _springVel) < 1.5;

        if (_inSettledMode) then {
            // Locked-K spring + locked-C damper.  Both constants are frozen at settle time to
            // eliminate per-frame getCenterOfMass noise (±15% spikes) that otherwise continuously
            // perturbs forces and prevents the settle timer from holding.  Live compression is kept
            // so roll/pitch tilts still produce corrective spring forces.
            _springForce = (_settledK * (_effectiveDist + _x_eq)) * _deltaTime * _loadScale;
            _damperForce = (_settledC * _springVel)               * _deltaTime * _loadScale;
            private _totalForce = _springForce + _damperForce;
            if (_effectiveDist <= 0.0) then {
                // Ghost zone: spring only, tapered linearly to 0 at the -0.50 m boundary.
                // Without the taper the spring still carries ~50% of equilibrium force at the
                // boundary edge; when the raycast loses contact, that force vanishes instantly
                // causing the vertical bob on liftoff.
                private _gzTaper = (1.0 + _effectiveDist / 0.50) max 0.0;
                _totalForce = (_springForce * _gzTaper) max 0.0;
            };
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

            _springForce = (_springConstant * (_effectiveDist + _x_eq)) * _deltaTime * _loadScale;
            _damperForce = (_damperConstant * _springVel)              * _deltaTime * _loadScale;

            // Suppress the damper whenever prevSuspDist is not a trustworthy reading.
            if (_frameCount == 0 || _prevSuspDist < -0.5) then { _damperForce = 0.0; };

            // Ghost zone (effectiveDist ≤ 0): apply spring force only, exclude the damper.
            // Spring force in the ghost zone is always < gravity (by design), so it can never
            // launch the aircraft upward on its own — the net vertical force stays ≤ 0 aside from
            // rotor lift, which is the correct physics.  Including the damper here allows it to
            // add its full impulse on top of rotor lift and exceed gravity, causing the bounce.
            private _totalForce = _springForce + _damperForce;
            if (_effectiveDist <= 0.0) then {
                private _gzTaper = (1.0 + _effectiveDist / 0.50) max 0.0;
                _totalForce = (_springForce * _gzTaper) max 0.0;
            };

            _heli addForce [[0, 0, _totalForce], _pos];

            diag_log format ["Wheel %1 - Dist: %2 | SpringF: %3 | DamperF: %4 | Vel: %5 | Frame: %6 | ST: %7",
                _num, _curSuspDist toFixed 3, _springForce toFixed 0, _damperForce toFixed 0,
                _springVel toFixed 3, _frameCount, _settleTime toFixed 2];

            // Accumulate settle time while spring velocity is low.
            // 0.50 m/s is loose enough to accumulate across the pitch oscillation that
            // getCenterOfMass noise drives; once K/C locks the excitation ends naturally.
            // 0.10 s at typical frame rates requires only 2–3 consecutive quiet frames.
            if (abs _springVel < 0.50) then {
                _settleTime = _settleTime + _deltaTime;
                if (_settleTime >= 0.10) then {
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
    private _contactVelX = (_velLocal select 0) + (_oz * _py);  // lateral
    private _contactVelY = (_velLocal select 1) - (_oz * _px);  // longitudinal

    // Lateral and longitudinal friction applied independently so each axis can carry a different μ.
    //
    // Lateral (μ=0.4): prevents sideways sliding. Kept below the theoretical 0.8 because full 0.8
    //   creates large roll torques (force × wheel-height-below-CG) that excite roll oscillation
    //   during forward motion faster than the angular damper can suppress.
    //
    // Longitudinal:
    //   Wheel 2 (tail) is a castering wheel — it swivels freely with heading changes.
    //   Applying longitudinal friction here causes tail drag on pedal turns, so it is always zero.
    //   Front wheels: parking brake ON → full braking (μ=0.8) for landing roll-out;
    //                 parking brake OFF → rolling resistance (μ=0.05) so the aircraft decelerates
    //                 naturally after touchdown while still allowing taxi under rotor thrust.
    //   Note: _normalForce = _springForce, which already reflects reduced wheel load when the rotor
    //   is generating lift, so rolling resistance automatically drops during taxi power settings.
    //
    // Per-axis clamp at 1/3 of stopping impulse — 3 wheels together stop the CG in one frame
    // without sign-flip overshoot.
    private _parkingBrake = _heli getVariable ["fza_ah64_toggleParkingBrake", true];
    private _mass         = getMass _heli;
    private _normalForce  = _springForce;
    // µ=0.01 (not 0.05) when taxiing: the wheel X-offset from the yaw axis means
    // longitudinal friction produces a yaw-opposing torque during in-place pedal turns.
    // 0.01 provides minimal rolling resistance while not significantly impeding yaw.
    private _longMu = if (_num == 2) then {0.0} else {if (_parkingBrake) then {0.8} else {0.01}};
    // Tail: castering wheel, zero lateral resistance.
    // Front parked: µ=0.4 prevents sideways drift.
    // Front taxi (parking brake off): µ=0 — in-place pedal turns require the front wheels
    // to slide freely laterally.  Forward path is still controlled by _longMu rolling friction.
    private _latMu  = if (_num == 2) then {0.0} else {if (_parkingBrake) then {0.4} else {0.0}};

    if (_latMu > 0.0 && abs _contactVelX > 0.01) then {
        private _latForce = (_normalForce * _latMu) min (_mass * (abs _contactVelX) / 3.0);
        _heli addForce [_heli vectorModelToWorld [(if (_contactVelX > 0) then {-_latForce} else {_latForce}), 0.0, 0.0], _pos];
    };
    if (abs _contactVelY > 0.01) then {
        private _longForce = (_normalForce * _longMu) min (_mass * (abs _contactVelY) / 3.0);
        _heli addForce [_heli vectorModelToWorld [0.0, (if (_contactVelY > 0) then {-_longForce} else {_longForce}), 0.0], _pos];
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
