params ["_heli", "_deltaTime", "_dryAirDensity", "_wingType", "_wingPos", "_wingSweep", "_wingDim", "_wingRot"];

_wingDim
    params ["_width", "_length"];

//Wing coords
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C
private _wingRootCtr = _wingPos;
private _halfLength  = _length / 2.0;

private _A = []; private _B = []; private _C = []; private _D = [];

switch (_wingType) do {
    case 0: {   //Horizontal wing
        private _wingTipCtr  = _wingRootCtr vectorAdd [_width, _wingSweep, 0];

        _A = _wingRootCtr vectorAdd [ 0,  _halfLength * cos _wingRot, 0];
        _B = _wingTipCtr  vectorAdd [ 0,  _halfLength * cos _wingRot, 0];
        _C = _wingTipCtr  vectorAdd [ 0, -_halfLength * cos _wingRot, 0];
        _D = _wingRootCtr vectorAdd [ 0, -_halfLength * cos _wingRot, 0];

        private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];

        systemChat format ["4 Vel YZ = %1", _velYZ * 1.94384];
    };
    case 1: {   //Vertical wing
        private _wingTipCtr  = _wingRootCtr vectorAdd [0, _wingSweep, _width];

        _A = _wingRootCtr vectorAdd [  _halfLength * (sin _wingRot),  _halfLength * (cos _wingRot), 0];
        _B = _wingTipCtr  vectorAdd [  _halfLength * (sin _wingRot),  _halfLength * (cos _wingRot), 0];
        _C = _wingTipCtr  vectorAdd [ -_halfLength * (sin _wingRot), -_halfLength * (cos _wingRot), 0];
        _D = _wingRootCtr vectorAdd [ -_halfLength * (sin _wingRot), -_halfLength * (cos _wingRot), 0];

        private _velXY = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];

        private _relWind = vectornormalized(velocityModelSpace _heli);
        _relWind         = _relWind;
        
        private _AoA = (_relWind # 0 atan2 _relWind # 1) + _wingRot;
        _AoA = [_AoA] call CBA_fnc_simplifyAngle180;


        
        systemChat format ["4 Vel YZ = %1 -- AoA = %2", _velXY * 1.94384, _AoA toFixed 2];
    };
};

/*
private _normLocVel = vectorNormalized(velocityModelSpace _heli);
([_normLocVel, _wingRot] call fza_fnc_rotateVector)
    params ["_locVel"];
private _locVelX = _locVel select 0;
private _locVelY = _locVel select 1;
private _locVelZ = _locVel select 2;

private _AoA = _locVelY atan2 _locVelZ;
_AoA = [_AoA, -180, 180] call BIS_fnc_clamp;

//Wing coords
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C

private _wingCtr    = _wingPos;
private _halfLength = _length / 2.0;

([[0,  _halfLength, 0],      _wingRot] call fza_fnc_rotateVector) params ["_A"];
_A = _wingCtr vectorAdd _A;
([[0,  _halfLength, _width], _wingRot] call fza_fnc_rotateVector) params ["_B"];
_B = _wingCtr vectorAdd _B;
([[0, -_halfLength, _width], _wingRot] call fza_fnc_rotateVector) params ["_C"];
_C = _wingCtr vectorAdd _C;
([[0, -_halfLength, 0],      _wingRot] call fza_fnc_rotateVector) params ["_D"];
_D = _wingCtr vectorAdd _D;
//systemChat format ["Wing velocities %1 -- %2 -- %3 -- AoA %4", _locVelX toFixed 2, _locVelY toFixed 2, _locVelZ tofixed 2, _AoA];
*/
#ifdef __A3_DEBUG__
//Draw the wing
[_heli, _A, _B, "red"]   call fza_fnc_debugDrawLine;
[_heli, _B, _C, "white"] call fza_fnc_debugDrawLine;
[_heli, _C, _D, "white"] call fza_fnc_debugDrawLine;
[_heli, _D, _A, "white"] call fza_fnc_debugDrawLine;
//Draw the fwd chord line originating from the pivot
//[_heli, _H, _H vectorAdd _wingLine, bmk_global_colorWhite] call bmk_fnc_debugDrawLine;
//Draw the lift line
//[_heli, _E, _F, bmk_global_colorGreen] call bmk_fnc_debugDrawLine;
//Draw the lift vector
//[_heli, _G, _G vectorAdd _liftVec, bmk_global_colorBlue] call bmk_fnc_debugDrawLine;
//Draw the velocity vector
//[_heli, _H, _H vectorAdd _relWind, bmk_global_colorRed] call bmk_fnc_debugDrawLine;
#endif