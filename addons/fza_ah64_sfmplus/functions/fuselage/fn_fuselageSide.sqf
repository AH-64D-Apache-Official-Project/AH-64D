#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

private _cfg            = configOf _heli;
private _sfmPlusConfig  = _cfg >> "Fza_SfmPlus";

private _deltaTime      = _heli getVariable "fza_sfmplus_deltaTime";//fza_ah64_fixedTimeStep;
private _heliCom        = getCenterOfMass _heli;
private _rho            = _heli getVariable "fza_sfmplus_rho";
private _debugLineScale = 1.0 / 30.0;

private _position       = _heli getVariable "fza_sfmplus_fuselagePosition";
private _rotation       = _heli getVariable "fza_sfmplus_fuselageSideRotation";
private _dragCoefTable  = _heli getVariable "fza_sfmplus_fuselageSideDragCoefTable";
private _airfoilTable   = getArray (_sfmPlusConfig >> "airfoilTable01");
private _count          = _heli getVariable "fza_sfmplus_fuselageSideCount";
private _coords         = _heli getVariable "fza_sfmplus_fuselageSide";

private _pitch          = _rotation select 0;
private _roll           = _rotation select 1;
private _yaw            = _rotation select 2;

private _vecRight = [[1.0, 0.0, 0.0], _pitch, _roll, _yaw] call fza_fnc_rotateVector;
private _vecFwd   = [[0.0, 1.0, 0.0], _pitch, _roll, _yaw] call fza_fnc_rotateVector;
private _vecUp    = [[0.0, 0.0, 1.0], _pitch, _roll, _yaw] call fza_fnc_rotateVector;

for "_i" from 0 to (_count - 1) do {
    private _verts = _coords select _i;
    private _v1    = _verts select 0;
    private _v2    = _verts select 1;
    private _v3    = _verts select 2;
    private _v4    = _verts select 3;

    private _a = _position vectorAdd (_vecRight vectorMultiply (_v1 select 0)) vectorAdd (_vecFwd vectorMultiply (_v1 select 1)) vectorAdd (_vecUp vectorMultiply (_v1 select 2));
    private _b = _position vectorAdd (_vecRight vectorMultiply (_v2 select 0)) vectorAdd (_vecFwd vectorMultiply (_v2 select 1)) vectorAdd (_vecUp vectorMultiply (_v2 select 2));
    private _c = _position vectorAdd (_vecRight vectorMultiply (_v3 select 0)) vectorAdd (_vecFwd vectorMultiply (_v3 select 1)) vectorAdd (_vecUp vectorMultiply (_v3 select 2));
    private _d = _position vectorAdd (_vecRight vectorMultiply (_v4 select 0)) vectorAdd (_vecFwd vectorMultiply (_v4 select 1)) vectorAdd (_vecUp vectorMultiply (_v4 select 2));

    private _f = _d vectorDiff ((_d vectorDiff _c) vectorMultiply 0.5);
    private _g = _a vectorDiff ((_a vectorDiff _b) vectorMultiply 0.5);

    private _e = _g vectorAdd ((_f vectorDiff _g) vectorMultiply 0.5);

	private _chordLine = _vecFwd;
	_chordLine         = vectorNormalized _chordLine;

    private _up 	   = _vecRight;
    _up         	   = vectorNormalized _up;

	private _right	   = _vecUp vectorMultiply -1.0;
    _right         	   = vectorNormalized _right;

    #ifdef __A3_DEBUG__
    [_heli, _e, _e vectorAdd _chordLine, "white"] call fza_fnc_debugDrawLine;
	[_heli, _e, _e vectorAdd _up,	 	 "white"] call fza_fnc_debugDrawLine;
	[_heli, _e, _e vectorAdd _right,     "white"] call fza_fnc_debugDrawline;
    #endif

    private _velModelSpace    = (_heli getVariable "fza_sfmplus_velModelSpace")    vectorMultiply -1.0;
    private _angVelModelSpace = (_heli getVariable "fza_sfmplus_angVelModelSpace") vectorMultiply -1.0;
    private _deltaPos    	  = _e vectorDiff _heliCom;

	private _relWindX    	  = _velModelSpace select 0;
	private _relWindY    	  = _velModelSpace select 1;
	private _locRelWindX      = (_angVelModelSpace select 2) * (vectorMagnitude _deltaPos);

	private _relWind		  = [_relWindX + _locRelWindX, _relWindY, 0.0];

    #ifdef __A3_DEBUG__
    [_heli, _e vectorDiff (vectorNormalized _relWind), _e, "red"] call fza_fnc_debugDrawLine;
    #endif

    private _relWindNormalized = vectorNormalized _relWind;

	private _aoa = (_relWindNormalized select 0) atan2 (_chordLine select 1);

    //Lift coefficient
    private _area        = [_a, _b, _c, _d] call fza_fnc_getArea;
    private _CL          = [_airfoilTable, _aoa] call fza_fnc_linearInterp select 1;
    private _v            = vectorMagnitude _relWind;
    private _lift         = _CL * 0.5 * _rho * _area * (_v * _v);

    //Drag coefficient
    private _CD          =  [_dragCoefTable, _pa] call fza_fnc_linearInterp select 1;
    private _drag         = _CD * 0.5 * _rho * _area * (_relWindX * _relWindX);

    private _liftVector = _up vectorMultiply (_lift * _deltaTime);

    private _dragVector = _relWind;
    _dragVector = (vectorNormalized _dragVector) vectorMultiply -1.0;
    _dragVector = _dragVector vectorMultiply (_drag * _deltaTime);

    #ifdef __A3_DEBUG__
    [_heli, _e vectorAdd (_liftVector vectorMultiply _debugLineScale), _e, "green"] call fza_fnc_debugDrawLine;
    [_heli, _e vectorAdd (_dragVector vectorMultiply _debugLineScale), _e, "red"]   call fza_fnc_debugDrawLine;
    #endif

    //_heli addForce[_heli vectorModelToWorld _liftVector, _e];
    _heli addForce[_heli vectorModelToWorld _dragVector, _e];

    private _moment = _liftVector vectorCrossProduct _deltaPos;

    //private _torque = [0.0, 0.0, 0.0];
    //if (fza_ah64_sfmplusRealismSetting == REALISTIC) then {
    //    _torque = _moment;
    //};

    _heli addTorque (_heli vectorModelToWorld _moment);//_torque);
	
    #ifdef __A3_DEBUG__
    //Draw the wing
    [_heli, _a, _b, "red"]   call fza_fnc_debugDrawLine;
    [_heli, _b, _c, "white"] call fza_fnc_debugDrawLine;
    [_heli, _c, _d, "red"]   call fza_fnc_debugDrawLine;
    [_heli, _d, _a, "white"] call fza_fnc_debugDrawLine;
    #endif
};
