#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

params ["_heli","_wingPos","_pitch","_roll","_span","_chord","_sweep","_twist","_tipWidthScalar",["_isStab", false]];

if (!local _heli) exitWith {};

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _deltaTime      = _heli getVariable "fza_sfmplus_deltaTime";
private _rho            = _heli getVariable "fza_sfmplus_rho";
private _heliCOM        = getCenterOfMass _heli;
private _numElements    = 5;
private _chordLinePos   = 0.25;

private _debugLineScale = 1.0 / 30.0;

//Wing coords
//  + A-------------+-------------B
//    |             |             |
//    F-------------E-------------G
//    |             |             |
//  - D-------------+-------------C

private _A_wingRootLeadingEdge  = [];
private _B_wingTipLeadingEdge   = [];
private _C_wingTipTrailingEdge  = [];
private _D_wingRootTrailingEdge = [];
private _airfoilTable           = [];

if (_isStab) then {
    private _stabDamage = _heli getHitPointDamage "hit_stabilator";
    private _dcBusOn    = _heli getVariable "fza_systems_dcBusOn";

    private _stabOutputTable = [[]];
    private _desiredTheta    = 0.0;
    private _theta           = _heli getVariable "fza_ah64_stabilatorPosition";

    private _intStabTable = [getArray (_sfmPlusConfig >> "heliSimStabTable"), (_heli getVariable "fza_sfmplus_collectiveOutput")] call fza_fnc_linearInterp;
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

    if (_stabDamage < SYS_STAB_DMG_THRESH && _dcBusOn) then {
        _desiredTheta = [_stabOutputTable, (_heli getVariable "fza_sfmplus_vel2D") * KNOTS_TO_MPS] call fza_fnc_linearInterp select 1;
        _theta        = [_theta, _desiredTheta, (1.0 / 1.5) * _deltaTime] call BIS_fnc_lerp;
        _heli setVariable ["fza_ah64_stabilatorPosition", _theta];
    };

    _heli animate ["Hstab", _theta];

    private _vectorRight   = [1.0, 0.0, 0.0];
    private _vectorForward = [0.0, 1.0, 0.0];

    // Stab leading edge is _wingPos; trailing edges are built rearward then rotated about _wingPos
    _A_wingRootLeadingEdge  = _wingPos vectorDiff (_vectorRight vectorMultiply (_span * 0.5));
    _B_wingTipLeadingEdge   = _wingPos vectorAdd  (_vectorRight vectorMultiply (_span * 0.5));
    _C_wingTipTrailingEdge  = _B_wingTipLeadingEdge  vectorDiff (_vectorForward vectorMultiply _chord);
    _D_wingRootTrailingEdge = _A_wingRootLeadingEdge vectorDiff (_vectorForward vectorMultiply _chord);

    private _stabTheta  = _theta * -1.0;
    private _stabRoot   = _A_wingRootLeadingEdge vectorDiff _D_wingRootTrailingEdge;
    _stabRoot           = [_stabRoot, _vectorRight, _stabTheta] call fza_sfmplus_fnc_quaternion;
    _D_wingRootTrailingEdge = _A_wingRootLeadingEdge vectorDiff _stabRoot;

    private _stabTip    = _B_wingTipLeadingEdge vectorDiff _C_wingTipTrailingEdge;
    _stabTip            = [_stabTip, _vectorRight, _stabTheta] call fza_sfmplus_fnc_quaternion;
    _C_wingTipTrailingEdge = _B_wingTipLeadingEdge vectorDiff _stabTip;

    _airfoilTable = getArray (_sfmPlusConfig >> "airfoilTable01");
} else {
    private _vectorRight   = [[1.0, 0.0, 0.0], _pitch, _roll, 0.0] call fza_fnc_rotateVector;
    private _vectorForward = [[0.0, 1.0, 0.0], _pitch, _roll, 0.0] call fza_fnc_rotateVector;

    private _wingRootCenter = _wingPos       vectorDiff (_vectorRight   vectorMultiply (_span * 0.5));
    private _wingTipCenter  = _wingPos       vectorAdd  (_vectorRight   vectorMultiply (_span * 0.5));
    _wingTipCenter          = _wingTipCenter vectorAdd  (_vectorForward vectorMultiply _sweep);

    _A_wingRootLeadingEdge  = _wingRootCenter vectorAdd  (_vectorForward vectorMultiply  (_chord * 0.5));
    _B_wingTipLeadingEdge   = _wingTipCenter  vectorAdd  (_vectorForward vectorMultiply ((_chord * 0.5) * _tipWidthScalar));
    _C_wingTipTrailingEdge  = _wingTipCenter  vectorDiff (_vectorForward vectorMultiply ((_chord * 0.5) * _tipWidthScalar));
    _D_wingRootTrailingEdge = _wingRootCenter vectorDiff (_vectorForward vectorMultiply  (_chord * 0.5));

    private _wingTip       = _B_wingTipLeadingEdge vectorDiff _C_wingTipTrailingEdge;
    _wingTip               = [_wingTip, _vectorRight, _twist] call fza_sfmplus_fnc_quaternion;
    _B_wingTipLeadingEdge  = _wingTipCenter vectorAdd  (_wingTip vectorMultiply 0.5);
    _C_wingTipTrailingEdge = _wingTipCenter vectorDiff (_wingTip vectorMultiply 0.5);

    _airfoilTable = getArray (_sfmPlusConfig >> "airfoilTable02");
};

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
    private _angularVel          = (_heli getVariable "fza_sfmplus_angVelModelSpace");

    private _localRelWind = _angularVel vectorCrossProduct _fromAeroCenterToCOM;
    _localRelWind         = _localRelWind vectorMultiply -1.0;
    _relativeWind         = _relativeWind vectorAdd _localRelWind;

    #ifdef __A3_DEBUG__
    [_heli, _e vectorDiff (vectorNormalized _relativeWind), _e, "red"] call fza_fnc_debugDrawLine;
    #endif

    private _up = (vectorNormalized (_g vectorDiff _f)) vectorCrossProduct _chordLine;
    _up         = vectorNormalized _up;
    if (_span < 0.0) then {
        _up = _up vectorMultiply -1.0;
    };

    #ifdef __A3_DEBUG__
    [_heli, _e, _e vectorAdd _up, "white"] call fza_fnc_debugDrawLine;
    #endif

    private _relWindY = _chordLine vectorDotProduct _relativeWind;
    private _relWindZ = _up vectorDotProduct _relativeWind;
    _relativeWind     = (_chordLine vectorMultiply _relWindY) vectorAdd (_up vectorMultiply _relWindZ);

    #ifdef __A3_DEBUG__
    [_heli, _e vectorDiff (vectorNormalized _relativeWind), _e, "green"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWindNormalized = vectorNormalized _relativeWind;
    private _AoA                    = _chordLine vectorDotProduct (_relativeWindNormalized vectorMultiply -1.0);
    _AoA = [_AoA, -1.0, 1.0] call BIS_fnc_clamp;
    _AoA = acos _AoA;

    private _yAxisDotRelativeWind = _up vectorDotProduct _relativeWindNormalized;
    if (_yAxisDotRelativeWind < 0.0) then {
        _AoA = _AoA * -1.0;
    };

    //Lift coefficient
    private _area  = [_a, _b, _c, _d] call fza_fnc_getArea;
    private _CL    = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 1;
    private _v     = vectorMagnitude _relativeWind;
    private _lift  = _CL * 0.5 * _rho * _area * (_v * _v);

    //Drag coefficient
    private _CD    = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 2;
    private _drag  = _CD * 0.5 * _rho * _area * (_v * _v);

    private _liftVector = _relativeWindNormalized vectorCrossProduct _up;
    _liftVector = _liftVector vectorCrossProduct _relativeWindNormalized;
    _liftVector = vectorNormalized _liftVector;
    _liftVector = _liftVector vectorMultiply (_lift * _deltaTime);

    private _dragVector = _relativeWind;
    _dragVector = (vectorNormalized _dragVector) vectorMultiply -1.0;
    _dragVector = _dragVector vectorMultiply (_drag * _deltaTime);

    #ifdef __A3_DEBUG__
    [_heli, _e vectorAdd (_liftVector vectorMultiply _debugLineScale), _e, "green"] call fza_fnc_debugDrawLine;
    [_heli, _e vectorAdd (_dragVector vectorMultiply _debugLineScale), _e, "red"]   call fza_fnc_debugDrawLine;
    #endif

    _heli addForce [_heli vectorModelToWorld _liftVector, _e];
    _heli addForce [_heli vectorModelToWorld _dragVector, _e];

    private _deltaPos = _e vectorDiff _heliCOM;
    private _moment   = _deltaPos vectorCrossProduct _liftVector;

    _heli addTorque (_heli vectorModelToWorld _moment);
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Debug                /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
#ifdef __A3_DEBUG__
[_heli, _A_wingRootLeadingEdge,  _B_wingTipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
[_heli, _B_wingTipLeadingEdge,   _C_wingTipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
[_heli, _C_wingTipTrailingEdge,  _D_wingRootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
[_heli, _D_wingRootTrailingEdge, _A_wingRootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
#endif
