


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

private _curSuspDist    = 0.0;
private _springVel      = 0.0;
private _springForce    = 0.0;
private _damperForce    = 0.0;
private _deltaTime      = _heli getVariable "fza_sfmplus_deltaTime";
private _prevSuspDist   = _heli getVariable "fza_sfmplus_wheelPrevSuspDistance" select _num;
private _velModelSpace  = _heli getVariable "fza_sfmplus_velModelSpace";

private _vectorRight    = [1.0, 0.0, 0.0];
private _vectorUp       = [0.0, 0.0, 1.0];

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
    _curSuspDist = _strutHeight - (_heightAboveTerrain - _radius);
    _springVel   = (_curSuspDist - _prevSuspDist) / _deltaTime;


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

    // Debug output to Arma 3 log file
    diag_log format ["Wheel %1 - Dist: %2 | SpringF: %3 | DamperF: %4 | Vel: %5 | Frame: %6", 
        _num, 
        _curSuspDist toFixed 3, 
        _springForce toFixed 0, 
        _damperForce toFixed 0, 
        _springVel toFixed 3,
        _frameCount
    ];

    _heli addForce [_heli vectorModelToWorld (_vectorUp vectorMultiply (_springForce + _damperForce)), _pos];

    // Apply friction at center of mass to prevent sliding
    private _velocity = _velModelSpace;
    private _velMag   = vectorMagnitude _velocity;
    
    if (_velMag > 0.01) then {
        private _normalForce = _springForce;
        private _frictionForce = _normalForce * 2.5;
        private _frictionVector = _velocity vectorMultiply (-_frictionForce / _velMag);
        
        _heli addForce [_heli vectorModelToWorld _frictionVector, [0, 0, 0]];
    };

    [_heli, "fza_sfmplus_wheelPrevSuspDistance", _num, _curSuspDist, true] call fza_fnc_setArrayVariable;
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