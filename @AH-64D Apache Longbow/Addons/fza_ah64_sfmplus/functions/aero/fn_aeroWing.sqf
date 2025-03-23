params ["_heli", "_rho"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (!local _heli) exitWith {};

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _deltaTime      = fza_ah64_fixedTimeStep;
private _heliCOM        = getCenterOfMass _heli;
private _numElements    = 5;//getArray  (_heliSimCfg >> "wingElements")               select _wingNum;
private _airfoilTable   = getArray (_sfmPlusConfig >> "stabAirfoilTable");
private _wingPos        = [0.0, -6.3, -0.75];//getArray  (_heliSimCfg >> "wingPos")                    select _wingNum;    //POS
private _pitch          = 0.0;//getArray  (_heliSimCfg >> "wingPitch")                  select _wingNum;    //PCH
private _roll           = -90.0;//getArray  (_heliSimCfg >> "wingRoll")                   select _wingNum;    //RLL
private _span           = 2.25;//getArray  (_heliSimCfg >> "wingSpan")                   select _wingNum;    //SPN
private _chord          = 0.95;//getArray  (_heliSimCfg >> "wingChord")                  select _wingNum;    //CRD
private _sweep          = -1.2;//getArray  (_heliSimCfg >> "wingSweep")                  select _wingNum;    //SWP
private _twist          = 0.0;//getArray  (_heliSimCfg >> "wingTwist")                  select _wingNum;
private _tipWidthScalar = 1.0;//getArray  (_heliSimCfg >> "wingTipWidthScalar")         select _wingNum;    //TWS
private _chordLinePos   = 0.25;//getArray  (_heliSimCfg >> "wingChordLinePos")           select _wingNum;

private _vectorRight   = [[1.0, 0.0, 0.0], _pitch, _roll] call fza_fnc_rotateVector;
private _vectorForward = [[0.0, 1.0, 0.0], _pitch, _roll] call fza_fnc_rotateVector;
private _vectorUp      = [[0.0, 0.0, 1.0], _pitch, _roll] call fza_fnc_rotateVector;

//Wing coords
//  + A-------------+-------------B
//    |             |             |
//    F-------------E-------------G
//    |             |             |
//  - D-------------+-------------C

//First draw the wing
private _wingRootCenter = _wingPos       vectorDiff (_vectorRight   vectorMultiply (_span * 0.5));
private _wingTipCenter  = _wingPos       vectorAdd  (_vectorRight   vectorMultiply (_span * 0.5)); 
_wingTipCenter          = _wingTipCenter vectorAdd  (_vectorForward vectorMultiply _sweep);

private _A_wingRootLeadingEdge  = _wingRootCenter vectorAdd  (_vectorForward vectorMultiply  (_chord * 0.5));
private _B_wingTipLeadingEdge   = _wingTipCenter  vectorAdd  (_vectorForward vectorMultiply ((_chord * 0.5) * _tipWidthScalar));
private _C_wingTipTrailingEdge  = _wingTipCenter  vectorDiff (_vectorForward vectorMultiply ((_chord * 0.5) * _tipWidthScalar));
private _D_wingRootTrailingEdge = _wingRootCenter vectorDiff (_vectorForward vectorMultiply  (_chord * 0.5));

private _wingTip        = _B_wingTipLeadingEdge vectorDiff _C_wingTipTrailingEdge;
_wingTip                = [_wingTip, _vectorRight, _twist] call fza_sfmplus_fnc_quaternion;

_B_wingTipLeadingEdge   = _wingTipCenter vectorAdd  (_wingTip vectorMultiply 0.5);
_C_wingTipTrailingEdge  = _wingTipCenter vectorDiff (_wingTip vectorMultiply 0.5);

private _F_wingRootLiftPosition = _D_wingRootTrailingEdge vectorAdd ((_A_wingRootLeadingEdge vectorDiff _D_wingRootTrailingEdge) vectorMultiply (1.0 - _chordLinePos));
private _G_wingTipLiftPosition  = _C_wingTipTrailingEdge  vectorAdd ((_B_wingTipLeadingEdge  vectorDiff _C_wingTipTrailingEdge)  vectorMultiply (1.0 - _chordLinePos));

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

    //private _fromAeroCenterToCOM = _e vectorDiff _heliCOM;
    //private _angularVel          = (_heli getVariable "fza_sfmplus_angVelModelSpace");

    //private _localRelWind = (vectorNormalized _angularVel) vectorCrossProduct (vectorNormalized _fromAeroCenterToCOM);
    //_localRelWind         = _localRelWind vectorMultiply -((vectorMagnitude _angularVel) * (vectorMagnitude _fromAeroCenterToCOM));
    //_relativeWind         = _relativeWind vectorAdd _localRelWind;

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
    private _AoA                    = _chordLine vectorDotProduct (_relativeWindNormalized vectorMultiply -1.0);
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
    private _area        = [_a, _b, _c, _d] call fza_fnc_getArea;
    private _CL          = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 1;
    private _v            = vectorMagnitude _relativeWind;
    private _lift         = _CL * 0.5 * _rho * _area * (_v * _v);

    //Drag coefficient
    private _CD          = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 2;
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
//Draw the wing
[_heli, _A_wingRootLeadingEdge,  _B_wingTipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
[_heli, _B_wingTipLeadingEdge,   _C_wingTipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
[_heli, _C_wingTipTrailingEdge,  _D_wingRootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
[_heli, _D_wingRootTrailingEdge, _A_wingRootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
#endif