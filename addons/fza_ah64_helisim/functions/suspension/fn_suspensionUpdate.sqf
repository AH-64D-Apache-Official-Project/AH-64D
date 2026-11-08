/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionUpdate

Description:
    Runs the three wheels each frame. The wheels are forces only, and the pose is
    held only when the aircraft is not free to move. For a moment after load-in,
    while the mission's long frames pass. On the ground under time acceleration,
    the frame time is too long for the springs. Left idle with nobody aboard, Core
    stops publishing the frame time they need. And asleep: crewed, at rest on all
    three wheels with the brake on and the collective down, which is where the
    frame-late forces would otherwise leave a small wobble that never dies. It
    wakes when the collective comes up, the brake comes off, its mass changes or
    something moves it.

    Never read and write angular velocity here while the aircraft is free to move:
    doing so once a frame throws away the moments from every addForce, which left
    the tail rotor with its side force and no yaw.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_helisim\functions\suspension\suspension.hpp"

params ["_heli"];

//Core's pause guard only returns from coreUpdate, so the pack has to repeat it here.
if (isGamePaused || CBA_missionTime < 0.1) exitWith {};

//Core's idle gate returns before it publishes bmkhs_deltaTime, so an aircraft nobody has
//boarded still reads the initial 0.0.
private _deltaTime = _heli getVariable ["bmkhs_deltaTime", 0.0];
if (_deltaTime <= 0.0) exitWith {};

if !(_heli getVariable "fza_suspension_placed") then {
    _heli setVariable ["fza_suspension_placed", true];
    [_heli] call fza_suspension_fnc_suspensionPlace;
};

//Read after placing, which may have just set it.
private _held       = _heli getVariable "fza_suspension_heldPose";
private _isHeld     = _held isNotEqualTo [];
private _compressed = _heli getVariable "fza_suspension_prevCompression";
private _timeAccel  = accTime > 1.1;
//The main conditions of Core's idle gate: nobody aboard and nothing turning.
private _idle       = ((crew _heli) findIf {isPlayer _x}) < 0
    && {((_heli getVariable ["bmkhs_engState", []]) findIf {_x != "OFF"}) < 0}
    && {(_heli getVariable ["bmkhs_rtrRpm", 0.0]) <= 0.01};
private _mass       = getMass _heli;
private _brake      = _heli getVariable ["fza_ah64_toggleParkingBrake", true];
private _collDown   = (_heli getVariable "bmkhs_collectiveOutput") <= SUSP_SLEEP_COLLECTIVE;
//Read before the hold zeroes it: a collision shows up here. Less the frame of free fall the
//engine gives a held aircraft before the hold puts it back.
private _vel        = velocity _heli;
private _moved      = vectorMagnitude [_vel select 0, _vel select 1, (_vel select 2) + (SUSP_GRAVITY * _deltaTime)] > SUSP_WAKE_SPEED
    || {abs (_mass - (_heli getVariable "fza_suspension_sleepMass")) > SUSP_WAKE_MASS_FRAC * _mass};

//Loading: placed, and waiting out the long frames of a mission starting up. A long frame on the
//ground drops the aircraft, because gravity acts for the whole of it.
private _steady = _heli getVariable "fza_suspension_loadSteady";
if (_steady >= 0.0) then {
    _steady = [0.0, _steady + _deltaTime] select (_deltaTime < SUSP_LOAD_LONG_FRAME);
    if (_steady >= SUSP_LOAD_STEADY_TIME || {CBA_missionTime > (_heli getVariable "fza_suspension_loadUntil")}) then {
        _steady = -1.0;
    };
    _heli setVariable ["fza_suspension_loadSteady", _steady];
};

if (_isHeld && {_timeAccel || _idle || _steady >= 0.0 || {_brake && _collDown && !_moved}}) exitWith {
    if (SUSP_LOG && {CBA_missionTime - (_heli getVariable ["fza_suspension_heldLogged", -10.0]) >= 1.0}) then {
        _heli setVariable ["fza_suspension_heldLogged", CBA_missionTime];
        diag_log format ["SUSP,HELD,%1,coll=%2,brake=%3,idle=%4,steady=%5,accel=%6,moved=%7",
            CBA_missionTime toFixed 2, (_heli getVariable "bmkhs_collectiveOutput") toFixed 3,
            _brake, _idle, _steady toFixed 2, _timeAccel, _moved];
    };
    _held params ["_posHeld", "_dirHeld", "_upHeld"];
    _heli setPosASL _posHeld;
    _heli setVectorDirAndUp [_dirHeld, _upHeld];
    _heli setVelocity [0.0, 0.0, 0.0];
    _heli setAngularVelocity [0.0, 0.0, 0.0];
};
//Waking: no compression to difference against, so the wheels take their first-contact rate.
if (_isHeld) then {
    _heli setVariable ["fza_suspension_heldPose", []];
    _heli setVariable ["fza_suspension_restTime", 0.0];
    _heli setVariable ["fza_suspension_prevCompression", [-1.0, -1.0, -1.0]];
    _compressed = [-1.0, -1.0, -1.0];
};

private _mainsDown = (_compressed select 0) >= 0.0 && {(_compressed select 1) >= 0.0};
private _settled   = _mainsDown && {_idle || {(_compressed select 2) >= 0.0 && _brake && _collDown}};
private _atRest    = _settled
    && {vectorMagnitude (velocity _heli) < SUSP_REST_SPEED}
    && {vectorMagnitude (angularVelocity _heli) < SUSP_REST_RATE};
private _restTime  = [0.0, (_heli getVariable "fza_suspension_restTime") + _deltaTime] select _atRest;
_heli setVariable ["fza_suspension_restTime", _restTime];

if (_restTime >= SUSP_REST_TIME || {_timeAccel && {_compressed findIf {_x >= 0.0} >= 0}}) exitWith {
    _heli setVelocity [0.0, 0.0, 0.0];
    _heli setAngularVelocity [0.0, 0.0, 0.0];
    _heli setVariable ["fza_suspension_heldPose", [getPosASL _heli, vectorDir _heli, vectorUp _heli]];
    _heli setVariable ["fza_suspension_sleepMass", _mass];
};

//Static load on each wheel, from the moment balance about the centre of mass.
private _cg        = getCenterOfMass _heli;
private _mainY     = SUSP_WHEEL_RIGHT select 1;
private _tailY     = SUSP_WHEEL_TAIL select 1;
private _mainShare = ((((_cg select 1) - _tailY) / (_mainY - _tailY)) max 0.5) min 0.95;
private _rightFrac = ((0.5 + ((_cg select 0) / (2.0 * (SUSP_WHEEL_RIGHT select 0)))) max 0.3) min 0.7;
private _muLon     = [SUSP_MU_ROLL, SUSP_MU_BRAKE] select _brake;

([_heli, (_compressed select 2) >= 0.0, _deltaTime] call fza_suspension_fnc_suspensionCastor) params ["_castor", "_pinned"];

private _right = [_heli, 0, SUSP_WHEEL_RIGHT, SUSP_MAIN_RADIUS, SUSP_MAIN_SAG, _mass * _mainShare * _rightFrac,
                  SUSP_MU_MAIN_LAT, _muLon, 0.0, _deltaTime] call fza_suspension_fnc_suspensionWheel;
private _left  = [_heli, 1, SUSP_WHEEL_LEFT, SUSP_MAIN_RADIUS, SUSP_MAIN_SAG, _mass * _mainShare * (1.0 - _rightFrac),
                  SUSP_MU_MAIN_LAT, _muLon, 0.0, _deltaTime] call fza_suspension_fnc_suspensionWheel;
private _tail  = [_heli, 2, SUSP_WHEEL_TAIL, SUSP_TAIL_RADIUS, SUSP_TAIL_SAG, _mass * (1.0 - _mainShare),
                  [SUSP_MU_TAIL_SWIVEL, SUSP_MU_TAIL_LOCKED] select _pinned, SUSP_MU_ROLL, _castor, _deltaTime] call fza_suspension_fnc_suspensionWheel;

if (SUSP_LOG && {(_right select 0) >= 0.0 || {(_left select 0) >= 0.0} || {(_tail select 0) >= 0.0}}) then {
    diag_log format ["SUSP,%1,%2,%3,%4,%5,%6,%7,%8,%9,%10,%11,%12,%13,%14,%15,%16",
        CBA_missionTime toFixed 2, _deltaTime toFixed 3,
        (_right select 0) toFixed 3, (_left select 0) toFixed 3, (_tail select 0) toFixed 3,
        (_right select 1) toFixed 0, (_left select 1) toFixed 0, (_tail select 1) toFixed 0,
        (_right select 2) toFixed 3, (_left select 2) toFixed 3, (_tail select 2) toFixed 3,
        (_right select 3) toFixed 3, (_left select 3) toFixed 3, _brake,
        _castor toFixed 1, _pinned];
};
