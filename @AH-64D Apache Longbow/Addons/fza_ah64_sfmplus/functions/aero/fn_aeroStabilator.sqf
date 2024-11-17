/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_aeroStabilator

Description:
    Creates a stabilator object which automatically schedules as a function of
    collective position and airspeed.

Parameters:
    _heli      - The helicopter to get information from [Unit].
    _deltaTime - Passed delta time from core update.

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli", "_deltaTime", "_rho"];

private _stabDamage    = _heli getHitPointDamage "hit_stabilator";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";
private _flightModel   = getText (_cfg >> "fza_flightModel");

if (!local _heli) exitWith {};

private _heliCOM        = getCenterOfMass _heli;
private _numElements    = 5;
private _liftCurveSlope = 5.7;
private _baseDragCoef   = 0.025;
private _K              = 0.07;
private _stabPos        = [0.0, -6.45, -1.85];//_heli getVariable "fza_sfmplus_stabPos";
private _span           = _heli getVariable "fza_sfmplus_stabWidth";
private _chord          = _heli getVariable "fza_sfmplus_stabLength";
private _chordLinePos   = 0.25;

private _stabOutputTable = [[]];
private _theta           = 0.0;
if (_flightModel == "SFMPlus") then {
    private _intStabTable    = [getArray (_sfmPlusConfig >> "stabTable"), fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp;
    _stabOutputTable = [
                         [15.43, _intStabTable select 1]  //30kts
                        ,[36.01, _intStabTable select 2]  //70kts
                        ,[46.30, _intStabTable select 3]  //90kts
                        ,[56.59, _intStabTable select 4]  //110kts
                        ,[61.73, _intStabTable select 5]  //120kts
                        ,[77.17, _intStabTable select 6]  //150kts
                        ];
} else {
    private _intStabTable    = [getArray (_sfmPlusConfig >> "heliSimStabTable"), fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp;
    _stabOutputTable = [
                        [15.43, _intStabTable select 1]   //30kts
                       ,[20.58, _intStabTable select 2]   //40kts
                       ,[25.72, _intStabTable select 3]   //50kts
                       ,[30.87, _intStabTable select 4]   //60kts
                       ,[36.01, _intStabTable select 5]   //70kts
                       ,[41.16, _intStabTable select 6]   //80kts
                       ,[46.30, _intStabTable select 7]   //90kts
                       ,[51.44, _intStabTable select 8]   //100kts
                       ,[56.59, _intStabTable select 9]   //110kts
                       ,[61.73, _intStabTable select 10]  //120kts
                       ,[66.88, _intStabTable select 11]  //130kts
                       ,[72.02, _intStabTable select 12]  //140kts
                       ,[77.17, _intStabTable select 13]  //150kts
                       ,[82.31, _intStabTable select 14]  //160kts
                       ,[87.46, _intStabTable select 15]  //170kts
                       ,[92.60, _intStabTable select 16]  //180kts
                       ,[97.74, _intStabTable select 17]  //190kts
                       ,[102.9, _intStabTable select 18]  //200kts
                       ];
};

([_heli, fza_ah64_sfmplusEnableWind] call fza_sfmplus_fnc_getVelocities)
    params [ 
             "_gndSpeed"
           , "_vel2D"
           , "_vel3D"
           , "_vertVel"
           , "_velModelSpace"
           , "_angVelModelSpace"
           , "_velWorldSpace"
           , "_angVelWorldSpace"
           ];

if (_flightModel == "SFMPlus" && fza_ah64_sfmPlusKeyboardOnly) then {
    _theta = getNumber (_sfmPlusConfig >> "stabKeyTheta");
} else {
    _theta = [_stabOutputTable, _vel2D * KNOTS_TO_MPS] call fza_fnc_linearInterp select 1;
};

if (_stabDamage >= SYS_STAB_DMG_THRESH || !_dcBusOn) then {
    _theta = _heli getvariable "fza_ah64_stabilatorPosition";
} else {
    _heli setVariable ["fza_ah64_stabilatorPosition", _theta];
};

//Animate the Horizontal stabilizer
_heli animate ["Hstab", _theta];

private _vectorRight   = [1.0, 0.0, 0.0];
private _vectorForward = [0.0, 1.0, 0.0];
private _vectorUp      = [0.0, 0.0, 1.0];

//Wing coords
//  + A-------------+-------------B
//    |             |             |
//    F-------------E-------------G
//    |             |             |
//  - D-------------+-------------C

private _A_wingRootLeadingEdge   = [];
private _B_wingTipLeadingEdge    = [];
private _C_wingTipTrailingEdge   = [];
private _D_wingRootTrailingEdge  = [];
private _F_wingRootLiftPosition  = [];
private _G_wingTipLiftPosition   = [];

//First draw the wing
_A_wingRootLeadingEdge  = _stabPos vectorDiff (_vectorRight vectorMultiply (_span * 0.5));
_B_wingTipLeadingEdge   = _stabPos vectorAdd  (_vectorRight vectorMultiply (_span * 0.5));
_C_wingTipTrailingEdge  = _B_wingTipLeadingEdge  vectorDiff (_vectorForward vectorMultiply _chord);
_D_wingRootTrailingEdge = _A_wingRootLeadingEdge vectorDiff (_vectorForward vectorMultiply _chord);

_theta                  = _theta * -1.0;

private _stabRoot       = _A_wingRootLeadingEdge vectorDiff _D_wingRootTrailingEdge;
_stabRoot               = [_stabRoot, _vectorRight, _theta] call fza_sfmplus_fnc_quaternion;
_D_wingRootTrailingEdge = _A_wingRootLeadingEdge vectorDiff _stabRoot;

private _stabTip        = _B_wingTipLeadingEdge vectorDiff _C_wingTipTrailingEdge;
_stabTip                = [_stabTip, _vectorRight, _theta] call fza_sfmplus_fnc_quaternion;
_C_wingTipTrailingEdge  = _B_wingTipLeadingEdge vectorDiff _stabTip;

private _debugLineScale = 1.0 / 30.0;

for "_j" from 0 to (_numElements - 1) do {
    private _a = _A_wingRootLeadingEdge  vectorAdd ((_B_wingTipLeadingEdge  vectorDiff _A_wingRootLeadingEdge)  vectorMultiply (_j / _numElements));
    private _b = _A_wingRootLeadingEdge  vectorAdd ((_B_wingTipLeadingEdge  vectorDiff _A_wingRootLeadingEdge)  vectorMultiply ((_j + 1) / _numElements));
    private _c = _D_wingRootTrailingEdge vectorAdd ((_C_wingTipTrailingEdge vectorDiff _D_wingRootTrailingEdge) vectorMultiply ((_j + 1) / _numElements));
    private _d = _D_wingRootTrailingEdge vectorAdd ((_C_wingTipTrailingEdge vectorDiff _D_wingRootTrailingEdge) vectorMultiply (_j / _numElements));

    #ifdef __A3_DEBUG__
    [_heli, _b, _c,   "white"] call fza_fnc_debugDrawLine;
    [_heli, _d, _a,   "white"] call fza_fnc_debugDrawLine;
    #endif

    private _f = _d vectorAdd ((_a vectorDiff _d) vectorMultiply (1.0 - _chordLinePos));
    private _g = _c vectorAdd ((_b vectorDiff _c) vectorMultiply (1.0 - _chordLinePos));

    #ifdef __A3_DEBUG__
    [_heli, _f, _g,   "green"] call fza_fnc_debugDrawLine;
    #endif

    private _e = _f vectorAdd ((_g vectorDiff _f) vectorMultiply 0.5);

    private _chordLine   = (_a vectorAdd ((_b vectorDiff _a) vectorMultiply 0.5)) vectorDiff (_d vectorAdd ((_c vectorDiff _d) vectorMultiply 0.5));
    private _chordLength = vectorMagnitude _chordLine;
    _chordLine = vectorNormalized _chordLine;

    #ifdef __A3_DEBUG__
    [_heli, _e, _e vectorAdd _chordLine, "blue"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWind = _velModelSpace vectorMultiply -1.0;

    private _fromAeroCenterToCOM = _e vectorDiff _heliCOM;
    private _angularVel = _angVelWorldSpace;

    private _localRelWind = (vectorNormalized _angularVel) vectorCrossProduct (vectorNormalized _fromAeroCenterToCOM);
    _localRelWind         = _localRelWind vectorMultiply -((vectorMagnitude _angularVel) * (vectorMagnitude _fromAeroCenterToCOM));
    _relativeWind         = _relativeWind vectorAdd _localRelWind;

    #ifdef __A3_DEBUG__
    [_heli, _e vectorDiff (vectorNormalized _relativeWind), _e, "red"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWindCorrection = _vectorRight;
    private _dotProduct             = _relativeWindCorrection vectorDotProduct _relativeWind;
    _relativeWindCorrection         = _relativeWindCorrection vectorMultiply _dotProduct;
    _relativeWind                   = _relativeWind vectorDiff _relativeWindCorrection;
    
    #ifdef __A3_DEBUG__
    [_heli, _e vectorDiff (vectorNormalized _relativeWind), _e, "green"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWindNormalized = vectorNormalized _relativeWind;
    private _AoA = _chordLine vectorDotProduct (_relativeWindNormalized vectorMultiply -1.0);
    _AoA = [_AoA, -1.0, 1.0] call BIS_fnc_clamp;
    _AoA = acos _AoA;

    private _up = _chordLine vectorCrossProduct (vectorNormalized (_g vectorDiff _f));
    _up         = vectorNormalized _up;
    if (_span < 0.0) then {
        _up = _up vectorMultiply -1.0;
    };

    private _yAxisDotRelativeWind = _up vectorDotProduct _relativeWindNormalized;
    if (_yAxisDotRelativeWind < 0.0) then {
        _AoA = _AoA * -1.0;
    };

    //Lift coefficient
    private _span        = vectorMagnitude (_g vectorDiff _f);
    private _area        = [_a, _b, _c, _d] call fza_fnc_getArea;
    private _aspectRatio = (_span * _span) / _area;
    private _CL           = _liftCurveSlope * (_aspectRatio / (_aspectRatio + 2.0)) * (rad _AoA);
    private _v            = vectorMagnitude _relativeWind;
    private _lift         = _CL * 0.5 * _rho * _area * (_v * _v);

    //Drag coefficient
    private _CD           = _baseDragCoef + _K * (_CL * _CL);
    private _drag         = _CD * 0.5 * _rho * _area * (_v * _v);

    private _liftVector = _vectorRight vectorCrossProduct _relativeWind;
    _liftVector = vectorNormalized _liftVector;
    _liftVector = _liftVector vectorMultiply (_lift * _deltaTime);

    private _dragVector = _relativeWind;
    _dragVector = vectorNormalized _dragVector;
    _dragVector = _dragVector vectorMultiply (_drag * _deltaTime);

    #ifdef __A3_DEBUG__
    [_heli, _e vectorAdd (_liftVector vectorMultiply _debugLineScale), _e, "green"] call fza_fnc_debugDrawLine;
    [_heli, _e vectorAdd (_dragVector vectorMultiply _debugLineScale), _e, "red"]   call fza_fnc_debugDrawLine;
    #endif

    _heli addForce[_heli vectorModelToWorld _liftVector, _e];
    _heli addForce[_heli vectorModelToWorld _dragVector, _e];

    private _deltaPos  = _e vectorDiff (getCenterOfMass _heli);
    private _moment    = _liftVector vectorCrossProduct _deltaPos;

    _heli addTorque (_heli vectorModelToWorld _moment);
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Debug                /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
#ifdef __A3_DEBUG__
/*
hintsilent format ["Collective Out = %1
                   \nStab Pos = %2", fza_sfmplus_collectiveOutput, _theta];
*/
//Draw the wing
[_heli, _A_wingRootLeadingEdge,  _B_wingTipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
[_heli, _B_wingTipLeadingEdge,   _C_wingTipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
[_heli, _C_wingTipTrailingEdge,  _D_wingRootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
[_heli, _D_wingRootTrailingEdge, _A_wingRootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
#endif