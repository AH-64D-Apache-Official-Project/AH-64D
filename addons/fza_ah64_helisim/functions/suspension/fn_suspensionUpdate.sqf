/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionUpdate

Description:
    Runs the three wheels each frame. The wheels are forces only, and a crewed
    aircraft is never frozen: the brake and the tyres' grip hold it still.

    The pose is held in three cases only, none of them while the aircraft is free
    to move under its crew. For a moment after load-in, while the mission's long
    frames pass. On the ground under time acceleration, the frame time is too long
    for the springs. Left idle with nobody aboard, Core stops publishing the frame
    time they need.

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

if (_isHeld && {_timeAccel || _idle || _steady >= 0.0}) exitWith {
    _held params ["_posHeld", "_dirHeld", "_upHeld"];
    _heli setPosASL _posHeld;
    _heli setVectorDirAndUp [_dirHeld, _upHeld];
    _heli setVelocity [0.0, 0.0, 0.0];
    _heli setAngularVelocity [0.0, 0.0, 0.0];
};
if (_isHeld) then {
    _heli setVariable ["fza_suspension_heldPose", []];
    _heli setVariable ["fza_suspension_restTime", 0.0];
};

private _mainsDown = (_compressed select 0) >= 0.0 && {(_compressed select 1) >= 0.0};
private _atRest    = _idle && _mainsDown
    && {vectorMagnitude (velocity _heli) < SUSP_REST_SPEED}
    && {vectorMagnitude (angularVelocity _heli) < SUSP_REST_RATE};
private _restTime  = [0.0, (_heli getVariable "fza_suspension_restTime") + _deltaTime] select _atRest;
_heli setVariable ["fza_suspension_restTime", _restTime];

if (_restTime >= SUSP_REST_TIME || {_timeAccel && {_compressed findIf {_x >= 0.0} >= 0}}) exitWith {
    _heli setVelocity [0.0, 0.0, 0.0];
    _heli setAngularVelocity [0.0, 0.0, 0.0];
    _heli setVariable ["fza_suspension_heldPose", [getPosASL _heli, vectorDir _heli, vectorUp _heli]];
};

//Static load on each wheel, from the moment balance about the centre of mass.
private _mass      = getMass _heli;
private _cg        = getCenterOfMass _heli;
private _mainY     = SUSP_WHEEL_RIGHT select 1;
private _tailY     = SUSP_WHEEL_TAIL select 1;
private _mainShare = ((((_cg select 1) - _tailY) / (_mainY - _tailY)) max 0.5) min 0.95;
private _rightFrac = ((0.5 + ((_cg select 0) / (2.0 * (SUSP_WHEEL_RIGHT select 0)))) max 0.3) min 0.7;
private _brake     = _heli getVariable ["fza_ah64_toggleParkingBrake", true];
private _muLon     = [SUSP_MU_ROLL, SUSP_MU_BRAKE] select _brake;

([_heli, (_compressed select 2) >= 0.0, _deltaTime] call fza_suspension_fnc_suspensionCastor) params ["_castor", "_pinned"];

private _right = [_heli, 0, SUSP_WHEEL_RIGHT, SUSP_MAIN_RADIUS, SUSP_MAIN_SAG, _mass * _mainShare * _rightFrac,
                  SUSP_MU_MAIN_LAT, _muLon, 0.0, _deltaTime] call fza_suspension_fnc_suspensionWheel;
private _left  = [_heli, 1, SUSP_WHEEL_LEFT, SUSP_MAIN_RADIUS, SUSP_MAIN_SAG, _mass * _mainShare * (1.0 - _rightFrac),
                  SUSP_MU_MAIN_LAT, _muLon, 0.0, _deltaTime] call fza_suspension_fnc_suspensionWheel;
private _tail  = [_heli, 2, SUSP_WHEEL_TAIL, SUSP_TAIL_RADIUS, SUSP_TAIL_SAG, _mass * (1.0 - _mainShare),
                  [SUSP_MU_TAIL_SWIVEL, SUSP_MU_TAIL_LOCKED] select _pinned, SUSP_MU_ROLL, _castor, _deltaTime] call fza_suspension_fnc_suspensionWheel;

#ifdef SUSP_LOG
if ((_right select 0) >= 0.0 || {(_left select 0) >= 0.0} || {(_tail select 0) >= 0.0}) then {
    diag_log format ["SUSP,%1,%2,%3,%4,%5,%6,%7,%8,%9,%10,%11,%12,%13,%14,%15,%16",
        CBA_missionTime toFixed 2, _deltaTime toFixed 3,
        (_right select 0) toFixed 3, (_left select 0) toFixed 3, (_tail select 0) toFixed 3,
        (_right select 1) toFixed 0, (_left select 1) toFixed 0, (_tail select 1) toFixed 0,
        (_right select 2) toFixed 3, (_left select 2) toFixed 3, (_tail select 2) toFixed 3,
        (_right select 3) toFixed 3, (_left select 3) toFixed 3, _brake,
        _castor toFixed 1, _pinned];
};
#endif
