#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli","_ctr", "_vecRight", "_vecFwd", "_vecUp", "_relWind", "_angVel", "_v1","_v2","_v3","_v4"];
//Coords
//	   	         +Z
//            |  /
//   c--------f-/------d
//   |        |/       |
// --|--------e--------|-- +Y
//   |        |        |
//   b--------g--------a
//	          |
//           +X

if (!local _heli) exitWith {};

private _cfg            = configOf _heli;
private _sfmPlusConfig  = _cfg >> "Fza_SfmPlus";

private _deltaTime      = _heli getVariable "fza_sfmplus_deltaTime";//fza_ah64_fixedTimeStep;
private _heliCom        = getCenterOfMass _heli;
private _rho            = _heli getVariable "fza_sfmplus_rho";
private _airfoilTable   = getArray (_sfmPlusConfig >> "airfoilTable02");
private _debugLineScale = 1.0 / 30.0;

private _a = _ctr vectorAdd (_vecRight vectorMultiply (_v1 select 0)) vectorAdd (_vecFwd vectorMultiply (_v1 select 1)) vectorAdd (_vecUp vectorMultiply (_v1 select 2));
private _b = _ctr vectorAdd (_vecRight vectorMultiply (_v2 select 0)) vectorAdd (_vecFwd vectorMultiply (_v2 select 1)) vectorAdd (_vecUp vectorMultiply (_v2 select 2));
private _c = _ctr vectorAdd (_vecRight vectorMultiply (_v3 select 0)) vectorAdd (_vecFwd vectorMultiply (_v3 select 1)) vectorAdd (_vecUp vectorMultiply (_v3 select 2));
private _d = _ctr vectorAdd (_vecRight vectorMultiply (_v4 select 0)) vectorAdd (_vecFwd vectorMultiply (_v4 select 1)) vectorAdd (_vecUp vectorMultiply (_v4 select 2));

private _f = _d vectorDiff ((_d vectorDiff _c) vectorMultiply 0.5);
private _g = _a vectorDiff ((_a vectorDiff _b) vectorMultiply 0.5);

private _e = _g vectorAdd ((_f vectorDiff _g) vectorMultiply 0.5);

private _chordLine = _vecFwd;
_chordLine         = vectorNormalized _chordLine;

#ifdef __A3_DEBUG__
[_heli, _e, _e vectorAdd _chordLine, "blue"] call fza_fnc_debugDrawLine;
#endif

_relWind = _relWind vectorMultiply -1.0;

private _deltaPos   = _e vectorDiff _heliCom;
private _locRelWind = (vectorNormalized _angVel) vectorCrossProduct (vectorNormalized _deltaPos);
_locRelWind         = _locRelWind vectorMultiply -((vectorMagnitude _angVel) * (vectorMagnitude _deltaPos));
_relWind            = _relWind vectorAdd _locRelWind;

private _relWindNormalized = vectorNormalized (_relWind vectorMultiply -1.0);

#ifdef __A3_DEBUG__
[_heli, _e vectorDiff (_relWindNormalized), _e, "green"] call fza_fnc_debugDrawLine;
#endif

private _up = _chordLine vectorCrossProduct (vectorNormalized (_f vectorDiff _g));
_up         = vectorNormalized _up;

#ifdef __A3_DEBUG__
[_heli, _e, _e vectorAdd _up, "white"] call fza_fnc_debugDrawLine;
#endif

private _aoa = _chordLine vectorDotProduct _relWindNormalized;
_aoa = [_aoa, -1.0, 1.0] call BIS_fnc_clamp;
_aoa = acos _aoa;

private _aoaCorrection = _vecRight vectorDotProduct _relWindNormalized;
if (_aoaCorrection > 0.0) then {
	_aoa = _aoa * -1.0;
};

//Lift coefficient
private _area        = [_a, _b, _c, _d] call fza_fnc_getArea;
private _CL          = [_airfoilTable, _aoa] call fza_fnc_linearInterp select 1;
private _v            = vectorMagnitude _relWind;
private _lift         = _CL * 0.5 * _rho * _area * (_v * _v);

systemChat format ["%1 - %2 - %3 - %4", _area, _CL, _v, _lift];

//Drag coefficient
private _CD          = [_airfoilTable, _aoa] call fza_fnc_linearInterp select 2;
private _drag         = _CD * 0.5 * _rho * _area * (_v * _v);

private _liftVector = _vecRight vectorCrossProduct _relWind;
_liftVector = vectorNormalized _liftVector;
_liftVector = _liftVector vectorMultiply (_lift * _deltaTime);

private _dragVector = _relWind;
_dragVector = (vectorNormalized _dragVector) vectorMultiply -1.0;
_dragVector = _dragVector vectorMultiply (_drag * _deltaTime);

#ifdef __A3_DEBUG__
[_heli, _e vectorAdd (_liftVector vectorMultiply _debugLineScale), _e, "green"] call fza_fnc_debugDrawLine;
[_heli, _e vectorAdd (_dragVector vectorMultiply _debugLineScale), _e, "red"]   call fza_fnc_debugDrawLine;
#endif

_heli addForce[_heli vectorModelToWorld _liftVector, _e];
_heli addForce[_heli vectorModelToWorld _dragVector, _e];

private _moment = _liftVector vectorCrossProduct _deltaPos;
private _torque = [0.0, 0.0, 0.0];
if (fza_ah64_sfmplusRealismSetting == REALISTIC) then {
	_torque = _moment;
} else {
	_torque = [0.0, 0.0, _moment select 2];
};

_heli addTorque (_heli vectorModelToWorld _torque);

/////////////////////////////////////////////////////////////////////////////////////////////
// Debug                /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
#ifdef __A3_DEBUG__
//Draw the wing
[_heli, _a, _b, "red"]   call fza_fnc_debugDrawLine;
[_heli, _b, _c, "white"] call fza_fnc_debugDrawLine;
[_heli, _c, _d, "red"] call fza_fnc_debugDrawLine;
[_heli, _d, _a, "white"] call fza_fnc_debugDrawLine;

#endif
