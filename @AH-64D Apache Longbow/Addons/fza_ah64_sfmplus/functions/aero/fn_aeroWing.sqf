params ["_heli", "_deltaTime", "_dryAirDensity", "_wingType", "_wingPos", "_wingSweep", "_wingDim", "_wingRot"];

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

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
private _E = []; private _F = []; private _G = []; private _H = []; 
private _I = [];

private _liftLine = []; private _chordLine = []; private _liftVec = [];
private _stabLine = []; private _relWind   = [];

switch (_wingType) do {
    case 0: {   //Horizontal wing
        private _wingTipCtr  = _wingRootCtr vectorAdd [_width, _wingSweep, 0];

        _A = _wingRootCtr vectorAdd [ 0,  _halfLength * cos _wingRot, 0];
        _B = _wingTipCtr  vectorAdd [ 0,  _halfLength * cos _wingRot, 0];
        _C = _wingTipCtr  vectorAdd [ 0, -_halfLength * cos _wingRot, 0];
        _D = _wingRootCtr vectorAdd [ 0, -_halfLength * cos _wingRot, 0];

        private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
    };
    case 1: {   //Vertical wing
        private _wingTipCtr  = _wingRootCtr vectorAdd [0, _wingSweep, _width];

        _A = _wingRootCtr vectorAdd [  _halfLength * (sin _wingRot),  _halfLength * (cos _wingRot), 0];
        _B = _wingTipCtr  vectorAdd [  _halfLength * (sin _wingRot),  _halfLength * (cos _wingRot), 0];
        _C = _wingTipCtr  vectorAdd [ -_halfLength * (sin _wingRot), -_halfLength * (cos _wingRot), 0];
        _D = _wingRootCtr vectorAdd [ -_halfLength * (sin _wingRot), -_halfLength * (cos _wingRot), 0];

        _E = (_A vectorAdd _D) vectorMultiply 0.5;
        _F = (_B vectorAdd _C) vectorMultiply 0.5;
        _G = (_E vectorAdd _F) vectorMultiply 0.5;
        
        _H = (_A vectorAdd _B) vectorMultiply 0.5;
        _I = (_D vectorAdd _C) vectorMultiply 0.5;

        _liftLine  = _E vectorDiff _F;
        _chordLine = _H vectorDiff _I;
        
        _liftVec   = vectorNormalized (_liftLine vectorCrossProduct _chordLine);
        _liftVec   = _liftVec;

        _stabLine  = vectorNormalized _chordLine;
        _stabLine  = _stabLine;

        private _velXY = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];

        _relWind   = vectornormalized(velocityModelSpace _heli);
        _relWind   = _relWind;
        
        private _AoA = (_relWind # 0 atan2 _relWind # 1) + _wingRot;
        _AoA = [_AoA] call CBA_fnc_simplifyAngle180;

        private _intAirfoilTable = [getArray (_sfmPlusConfig >> "stabAirfoilTable"), _AoA] call fza_fnc_linearInterp;
        private _CL              = _intAirfoilTable select 1;
        
        private _area      = [_A, _B, _C, _D] call fza_fnc_getArea;
        private _liftForce = _CL * 0.5 * _dryAirDensity * _area * (_velXY * _velXY);

        private _lift = _liftVec vectorMultiply (_liftForce* _deltaTime);
        _heli addForce[_heli vectorModelToWorld _lift, _G];
    };
};

#ifdef __A3_DEBUG__
//Draw the wing
[_heli, _A, _B, "red"]   call fza_fnc_debugDrawLine;
[_heli, _B, _C, "white"] call fza_fnc_debugDrawLine;
[_heli, _C, _D, "white"] call fza_fnc_debugDrawLine;
[_heli, _D, _A, "white"] call fza_fnc_debugDrawLine;
//Draw the fwd chord line originating from the pivot
[_heli, _H, _H vectorAdd _stabLine, "white"] call fza_fnc_debugDrawLine;
//Draw the lift line
[_heli, _E, _F, "green"] call fza_fnc_debugDrawLine;
//Draw the lift vector
[_heli, _G, _G vectorAdd _liftVec, "blue"] call fza_fnc_debugDrawLine;
//Draw the velocity vector
[_heli, _H, _H vectorAdd _relWind, "red"] call fza_fnc_debugDrawLine;
#endif