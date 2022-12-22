params ["_heli", "_deltaTime", "_dryAirDensity", "_wingPos", "_wingSweep", "_wingDim", "_wingRot"];

_wingDim
    params ["_width", "_length"];

private _normLocVel = vectorNormalized(velocityModelSpace _heli);
([_normLocVel, _wingRot] call bmk_helisim_fnc_utilityRotateVector)
    params ["_locVel"];
private _locVelX = _locVel select 0;
private _locVelY = _locVel select 1;
private _locVelZ = _locVel select 2;

private _AoA = _locVelY atan2 _locVelZ;
_AoA = [_AoA, -180, 180] call bis_fnc_clamp;

//Wing coords
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C

private _wingCtr    = _wingPos;
private _halfLength = _length / 2.0;

([[0,  _halfLength, 0],      _wingRot] call bmk_helisim_fnc_utilityRotateVector) params ["_A"];
_A = _wingCtr vectorAdd _A;
([[0,  _halfLength, _width], _wingRot] call bmk_helisim_fnc_utilityRotateVector) params ["_B"];
_B = _wingCtr vectorAdd _B;
([[0, -_halfLength, _width], _wingRot] call bmk_helisim_fnc_utilityRotateVector) params ["_C"];
_C = _wingCtr vectorAdd _C;
([[0, -_halfLength, 0],      _wingRot] call bmk_helisim_fnc_utilityRotateVector) params ["_D"];
_D = _wingCtr vectorAdd _D;
//systemChat format ["Wing velocities %1 -- %2 -- %3 -- AoA %4", _locVelX toFixed 2, _locVelY toFixed 2, _locVelZ tofixed 2, _AoA];

#ifdef __A3_DEBUG__
//Draw the wing
[_heli, _A, _B, bmk_global_colorRed]   call bmk_helisim_fnc_debugDrawLine;
[_heli, _B, _C, bmk_global_colorWhite] call bmk_helisim_fnc_debugDrawLine;
[_heli, _C, _D, bmk_global_colorWhite] call bmk_helisim_fnc_debugDrawLine;
[_heli, _D, _A, bmk_global_colorWhite] call bmk_helisim_fnc_debugDrawLine;
//Draw the fwd chord line originating from the pivot
//[_heli, _H, _H vectorAdd _wingLine, bmk_global_colorWhite] call bmk_fnc_debugDrawLine;
//Draw the lift line
//[_heli, _E, _F, bmk_global_colorGreen] call bmk_fnc_debugDrawLine;
//Draw the lift vector
//[_heli, _G, _G vectorAdd _liftVec, bmk_global_colorBlue] call bmk_fnc_debugDrawLine;
//Draw the velocity vector
//[_heli, _H, _H vectorAdd _relWind, bmk_global_colorRed] call bmk_fnc_debugDrawLine;
#endif