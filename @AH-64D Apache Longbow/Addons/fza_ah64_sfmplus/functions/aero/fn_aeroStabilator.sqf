/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_aeroStabilator

Description:
    Creates a stabilator object which automatically schedules as a function of
    collective position and airspeed.

Parameters:
    _heli      - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

private _stabDamage    = _heli getHitPointDamage "hit_stabilator";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

if (!local _heli) exitWith {};

private _deltaTime       = fza_ah64_fixedTimeStep;
private _rho             = _heli getVariable "fza_sfmplus_rho";

private _heliCOM         = getCenterOfMass _heli;
private _numElements     = 5;
private _airfoilTable    = getArray (_sfmPlusConfig >> "airfoilTable01");
private _stabPos         = [0.0, -6.45, -1.85];//_heli getVariable "fza_sfmplus_stabPos";
private _span            = _heli getVariable "fza_sfmplus_stabWidth";
private _chord           = _heli getVariable "fza_sfmplus_stabLength";
private _chordLinePos    = 0.25;

private _stabOutputTable = [[]];
private _desiredTheta    = 0.0;
private _theta           = _heli getvariable "fza_ah64_stabilatorPosition";

private _intStabTable    = [getArray (_sfmPlusConfig >> "heliSimStabTable"), (_heli getVariable "fza_sfmplus_collectiveOutput")] call fza_fnc_linearInterp;
/*
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
*/
_stabOutputTable = [
                    [15.43, _intStabTable select 1]   //30kts
                   ,[20.58, _intStabTable select 2]   //40kts
                   ,[25.72, _intStabTable select 3]   //50kts
                   ,[29.58, _intStabTable select 4]   //57.5kts
                   ,[41.16, _intStabTable select 5]   //80kts
                   ,[42.44, _intStabTable select 6]   //82.5kts
                   ,[51.44, _intStabTable select 7]   //100kts
                   ,[59.16, _intStabTable select 8]   //115kts
                   ,[61.73, _intStabTable select 9]   //120kts
                   ,[72.02, _intStabTable select 10]  //140kts
                   ,[77.17, _intStabTable select 11]  //150kts
                   ,[82.31, _intStabTable select 12]  //160kts
                   ,[84.88, _intStabTable select 13]  //165kts
                   ,[92.60, _intStabTable select 14]  //180kts
                   ];
/*
_stabOutputTable = [
                    [15.43, -25.0]   //30kts
                   ,[20.58,   0.0]   //40kts
                   ,[36.01,  -2.5]   //70kts
                   ,[46.30,  -5.0]   //90kts
                   ,[61.73,  -7.8]   //120kts
                   ,[66.88, -10.0]  //130kts
                   ];
*/
                   
if (_stabDamage < SYS_STAB_DMG_THRESH && _dcBusOn) then {
    _desiredTheta = [_stabOutputTable, (_heli getVariable "fza_sfmplus_vel2D") * KNOTS_TO_MPS] call fza_fnc_linearInterp select 1;
    _theta        = [_theta, _desiredTheta, (1.0 / 1.5) * _deltaTime] call BIS_fnc_lerp;
    _heli setVariable ["fza_ah64_stabilatorPosition", _theta];
};

//_theta = THETA;
//systemChat format ["_theta = %1 -- _collectiveOutput = %2", _theta, (_heli getVariable "fza_sfmplus_collectiveOutput")];
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

//First draw the wing
private _A_wingRootLeadingEdge  = _stabPos vectorDiff (_vectorRight vectorMultiply (_span * 0.5));
private _B_wingTipLeadingEdge   = _stabPos vectorAdd  (_vectorRight vectorMultiply (_span * 0.5));
private _C_wingTipTrailingEdge  = _B_wingTipLeadingEdge  vectorDiff (_vectorForward vectorMultiply _chord);
private _D_wingRootTrailingEdge = _A_wingRootLeadingEdge vectorDiff (_vectorForward vectorMultiply _chord);

//_theta                  = THETA;
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
    _chordLine           = vectorNormalized _chordLine;

    #ifdef __A3_DEBUG__
    [_heli, _e, _e vectorAdd _chordLine, "blue"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWind = (_heli getVariable "fza_sfmplus_velModelSpace") vectorMultiply -1.0;

    private _fromAeroCenterToCOM = _e vectorDiff _heliCOM;
    private _angularVel   = (_heli getVariable "fza_sfmplus_angVelModelSpace");

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
    private _aoa                    = _chordLine vectorDotProduct (_relativeWindNormalized vectorMultiply -1.0);
    _aoa = [_aoa, -1.0, 1.0] call BIS_fnc_clamp;
    _aoa = acos _aoa;

    private _up = _chordLine vectorCrossProduct (vectorNormalized (_g vectorDiff _f));
    _up         = vectorNormalized _up;
    if (_span < 0.0) then {
        _up = _up vectorMultiply -1.0;
    };

    private _yAxisDotRelativeWind = _up vectorDotProduct _relativeWindNormalized;
    if (_yAxisDotRelativeWind < 0.0) then {
        _aoa = _aoa * -1.0;
    };

    //Lift coefficient
    private _area        = [_a, _b, _c, _d] call fza_fnc_getArea;
    private _CL          = [_airfoilTable, _aoa] call fza_fnc_linearInterp select 1;
    private _v           = vectorMagnitude _relativeWind;
    private _lift        = _CL * 0.5 * _rho * _area * (_v * _v);
    //Drag coefficient
    private _CD          = [_airfoilTable, _aoa] call fza_fnc_linearInterp select 2;
    private _drag        = _CD * 0.5 * _rho * _area * (_v * _v);

    private _liftVector  = _vectorRight vectorCrossProduct _relativeWind;
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
                   \nStab Pos = %2", (_heli getVariable "fza_sfmplus_collectiveOutput"), _theta];
*/
//Draw the wing
[_heli, _A_wingRootLeadingEdge,  _B_wingTipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
[_heli, _B_wingTipLeadingEdge,   _C_wingTipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
[_heli, _C_wingTipTrailingEdge,  _D_wingRootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
[_heli, _D_wingRootTrailingEdge, _A_wingRootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
#endif