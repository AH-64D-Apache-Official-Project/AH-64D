/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionWheel

Description:
    One wheel: a spring and damper on its compression, and friction from the load
    that puts on the ground. Forces only. Rotor lift takes load off a wheel by
    unloading the spring, so nothing here needs to know about the rotor.

Parameters:
    _heli      - The helicopter [Object]
    _index     - Wheel index [Number]
    _pos       - Axle at static load, model space [Array]
    _radius    - Wheel radius, m [Number]
    _sag       - Compression at static load, m [Number]
    _load      - Static load on this wheel, kg [Number]
    _muSide    - Friction coefficient across the wheel [Number]
    _muRoll    - Friction coefficient along the wheel [Number]
    _angle     - Wheel heading from the aircraft's long axis, deg clockwise [Number]
    _deltaTime - Frame time, s [Number]

Returns:
    [compression (-1 when off the ground), normal force N, across m/s, along m/s]

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_helisim\functions\suspension\suspension.hpp"

params ["_heli", "_index", "_pos", "_radius", "_sag", "_load", "_muSide", "_muRoll", "_angle", "_deltaTime"];

private _bottom = _heli modelToWorldWorld (_pos vectorAdd [0.0, 0.0, -_radius]);
private _hits   = lineIntersectsSurfaces [
    _bottom vectorAdd [0.0, 0.0, SUSP_RAY_ABOVE],
    _bottom vectorAdd [0.0, 0.0, -_sag],
    _heli, objNull, true, 1, "GEOM"
];

private _bends = _heli getVariable "fza_suspension_gripBend";

if (_hits isEqualTo []) exitWith {
    [_heli, "fza_suspension_prevCompression", _index, -1.0] call fza_fnc_setArrayVariable;
    _bends set [_index, [0.0, 0.0]];
    [-1.0, 0.0, 0.0, 0.0]
};

//Zero with the wheel at full extension, _sag with it sitting where the model draws it.
private _compression = _sag - ((_bottom select 2) - ((_hits select 0 select 0) select 2));

//-1 when it was off the ground last frame, so there is no rate to read on first contact.
private _prev = (_heli getVariable "fza_suspension_prevCompression") select _index;
private _rate = 0.0;
if (_prev >= 0.0) then {
    _rate = (((_compression - _prev) / _deltaTime) max -SUSP_MAX_RATE) min SUSP_MAX_RATE;
};
[_heli, "fza_suspension_prevCompression", _index, _compression] call fza_fnc_setArrayVariable;

//A gas strut: it carries the static load at _sag, is soft near full extension and stiffens as it
//compresses. Per unit of the wheel's load. Never pulls on the ground.
private _omegaSq = SUSP_SPRING_EXP * SUSP_GRAVITY / _sag;
private _spring  = SUSP_GRAVITY * ((_compression / _sag) ^ SUSP_SPRING_EXP);
//At a low frame rate only the part above the static load is eased back. Easing all of it takes
//away the support holding the aircraft up, which dropped it on a long frame at load-in.
if (_spring > SUSP_GRAVITY) then {
    _spring = SUSP_GRAVITY + ((_spring - SUSP_GRAVITY) * ((SUSP_SPRING_DT_LIMIT / (_omegaSq * _deltaTime * _deltaTime)) min 1.0));
};
private _zeta    = [SUSP_ZETA_REBOUND, SUSP_ZETA_COMPRESS] select (_rate > 0.0);
private _damping = (2.0 * _zeta * (sqrt _omegaSq)) min (SUSP_DAMP_DT_LIMIT / _deltaTime);
private _normal  = _load * (_spring + (_damping * _rate));
_normal          = (_normal max 0.0) min (_load * SUSP_GRAVITY * SUSP_MAX_LOAD);

_heli addForce [[0.0, 0.0, _normal * _deltaTime], _pos];

//Velocity of the contact point. Arma's angular velocity is the inverse of the right hand rule,
//so positive yaw is clockwise from above.
private _velModel = _heli vectorWorldToModel (velocity _heli);
private _yawRate  = (_heli vectorWorldToModel (angularVelocity _heli)) select 2;
private _velX     = (_velModel select 0) + (_yawRate * (_pos select 1));
private _velY     = (_velModel select 1) - (_yawRate * (_pos select 0));

//Along and across the way the wheel is pointing.
private _sin      = sin _angle;
private _cos      = cos _angle;
private _velRoll  = (_velX * _sin) + (_velY * _cos);
private _velSide  = (_velX * _cos) - (_velY * _sin);

//Grip: the tyre bends like a stiff spring until it reaches the friction limit, then slips. The
//bend is what lets it hold a steady force at zero speed. Friction worked out from speed alone can
//only slow a wheel down, so a steady push would creep it along with the brake on.
private _gripStiff = (SUSP_GRIP_OMEGA * SUSP_GRIP_OMEGA) min (SUSP_SPRING_DT_LIMIT / (_deltaTime * _deltaTime));
private _gripDamp  = (2.0 * SUSP_GRIP_ZETA * SUSP_GRIP_OMEGA) min (SUSP_DAMP_DT_LIMIT / _deltaTime);
private _fnc_grip  = {
    params ["_bend", "_vel", "_mu"];
    private _limit = _mu * _normal;
    private _reach = _limit / (_load * _gripStiff);
    _bend = ((_bend + (_vel * _deltaTime)) max -_reach) min _reach;
    [_bend, ((-_load * ((_gripStiff * _bend) + (_gripDamp * _vel))) max -_limit) min _limit]
};
(_bends select _index) params ["_bendSide", "_bendRoll"];
([_bendSide, _velSide, _muSide] call _fnc_grip) params ["_newSide", "_forceSide"];
([_bendRoll, _velRoll, _muRoll] call _fnc_grip) params ["_newRoll", "_forceRoll"];
_bends set [_index, [_newSide, _newRoll]];

//Applied close to the height of the centre of mass. At the wheel, the grip works on a 1.8 m lever
//and cancels the strut's restoring moment, so the aircraft tips over its own feet.
private _cgZ     = (getCenterOfMass _heli) select 2;
private _gripPos = [_pos select 0, _pos select 1, _cgZ + (SUSP_ROLL_INFLUENCE * ((_pos select 2) - _cgZ))];
_heli addForce [
    _heli vectorModelToWorld [
        ((_forceRoll * _sin) + (_forceSide * _cos)) * _deltaTime,
        ((_forceRoll * _cos) - (_forceSide * _sin)) * _deltaTime,
        0.0
    ],
    _gripPos
];

[_compression, _normal, _velSide, _velRoll]
