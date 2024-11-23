#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli", "_deltaTime", "_altitude", "_temperature", "_rho"];

if (!local _heli) exitWith {};

private _configVehicles     = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel        = getText (_configVehicles >> "fza_flightModel");

private _aerodynamicCenter  = _heli getVariable "fza_sfmplus_aerodynamicCenter"; //m
private _heliCOM            = getCenterOfMass _heli;

private _fuselageAreaFront  = _heli getVariable "fza_sfmplus_fuselageAreaFront";
//private _fuselageAreaSide   = _heli getVariable "fza_sfmplus_fuselageAreaSide";
//private _fuselageAreaBottom = _heli getVariable "fza_sfmplus_fuselageAreaBottom";

//private _fuselageDragCoefX    = 1.5;
//private _fuselageDragCoefZ    = 0.5;

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

private _vectorRight            = [1.0, 0.0, 0.0];
private _vectorForward          = [0.0, 1.0, 0.0];
private _vectorUp               = [0.0, 0.0, 1.0];

private _relativeWind           = _velModelSpace vectorMultiply -1.0;//_velWorldSpace vectorMultiply -1.0;

private _relativeWindCorrection = _vectorRight;
private _dotProduct             = _relativeWindCorrection vectorDotProduct _relativeWind;
_relativeWindCorrection         = _relativeWindCorrection vectorMultiply _dotProduct;
_relativeWind                   = _relativeWind vectorDiff _relativeWindCorrection;
/////////////////////////////////////////////////////////////////////////////////////////////
// Fuselage Drag        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _interpDragCoefTableY = [];

private _fuselageTorque       = [];

if (_flightModel == "SFMPlus") then {
    //                                  PA   -40     0    40
    private _sfmPlusdragCoefTableY = [[   0, 0.54, 0.60, 0.60]   //ft 
                                     ,[2000, 0.80, 0.70, 0.55]   //ft
                                     ,[4000, 1.02, 0.92, 0.85]   //ft
                                     ,[6000, 1.20, 1.00, 1.06]   //ft
                                     ,[8000, 1.65, 1.25, 1.70]]; //ft

    _interpDragCoefTableY         = [_sfmPlusdragCoefTableY, _altitude] call fza_fnc_linearInterp;
    private _dragCoefTableY       = [[-40, _interpDragCoefTableY # 1]
                                    ,[  0, _interpDragCoefTableY # 2]
                                    ,[ 40, _interpDragCoefTableY # 3]];
    _interpDragCoefTableY         = [_dragCoefTableY, _temperature] call fza_fnc_linearInterp;
} else {
    //-------------------------------PA   -40   -20     0    20    40
    private _heliSimDragTableY = [
                                  [    0,0.0220,0.0170,0.0145,0.0125,0.0100]  
                                 ,[ 2000,0.0255,0.0210,0.0185,0.0145,0.0140]  
                                 ,[ 4000,0.0260,0.0250,0.0185,0.0185,0.0185]  
                                 ,[ 6000,0.0260,0.0225,0.0205,0.0205,0.0240]  
                                 ,[ 8000,0.0235,0.0200,0.0250,0.0230,0.0310] 
                                 ];
    /*
    DRAG_TABLE =[ 
    [     0,0.00,0.00,0.00,0.01,0.00]  
    ,[ 2000,0.00,0.00,0.00,0.01,0.00]  
    ,[ 4000,0.00,0.00,0.00,0.01,0.00]  
    ,[ 6000,0.00,0.00,0.00,0.01,0.00]  
    ,[ 8000,0.00,0.00,0.00,0.01,0.00]
    ];
    */
    _interpDragCoefTableY      = [_heliSimDragTableY, _altitude] call fza_fnc_linearInterp; //_heliSimDragTableY
    private _dragCoefTableY    = [[-40, _interpDragCoefTableY # 1]
                                 ,[-20, _interpDragCoefTableY # 2]
                                 ,[  0, _interpDragCoefTableY # 3]
                                 ,[ 20, _interpDragCoefTableY # 4]
                                 ,[ 40, _interpDragCoefTableY # 5]];
    _interpDragCoefTableY      = [_dragCoefTableY, _temperature] call fza_fnc_linearInterp;

    private _CD         = _interpDragCoefTableY # 1;

    private _v          = vectorMagnitude _relativeWind;
    private _drag       = _CD * 0.5 * _rho * _fuselageAreaFront * (_v * _v);

    private _dragVector = _relativeWind;
    _dragVector         = vectorNormalized _dragVector;
    _dragVector         = _dragVector vectorMultiply _drag;

    _heli addForce[_heli vectorModelToWorld _dragVector, _heliCOM];
/////////////////////////////////////////////////////////////////////////////////////////////
// Fuselage Torque      /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    private _alpha    = _heli getVariable "fza_sfmplus_aero_alpha";
    private _beta_deg = _heli getVariable "fza_sfmplus_aero_beta_deg";
    private _beta_g   = _heli getVariable "fza_sfmplus_aero_beta_g";
    private _gamma    = _heli getVariable "fza_sfmplus_aero_gamma";

    private _vScalar  = linearConversion [0.0, VEL_VBE, _v, 0.0, 1.0];
    _vScalar          = [_vScalar, 0.0, 1.0] call BIS_fnc_clamp;

    private _sideslipTable     = [[-90, -0.100]
                                 ,[-20, -0.050]
                                 ,[  3,  0.000]
                                 ,[ 20,  0.050]
                                 ,[ 90,  0.100]];
    _interpSidelsipTable       = [_sideslipTable, _beta_deg] call fza_fnc_linearInterp;
    _interpSideslipVal         = _interpSidelsipTable select 1;

    private _fuselageYawTorque = [0.0, 0.0, 1.0] vectorMultiply ((_interpSideslipVal * 25000) * _vScalar);

    private _gammaTable       = [[-180, -0.100]
                                ,[ -90, -0.075]
                                ,[ -20, -0.050]
                                ,[   0,  0.000]
                                ,[  20,  0.050]
                                ,[  90,  0.075]
                                ,[ 180,  0.100]];

    _interpGammaTable           = [_gammaTable, _gamma] call fza_fnc_linearInterp;
    _interpGammaVal             = _interpGammaTable select 1;

   private _fuselagePitchTorque = [1.0, 0.0, 0.0] vectorMultiply ((_interpGammaVal * 25000) * _vScalar);


    //systemChat format ["_gamma = %1 -- _beta_deg = %2 -- _vScalar = %3", _gamma, _beta_deg, _vScalar];
    //systemChat format ["_interpBetaTable = %1 -- _interpBetaVal %2", _interpBetaTable select 1 toFixed 3, _interpBetaVal tofixed 3];
    //systemChat format ["_interpGammaTable = %1 -- _interpGammaVal %2", _interpGammaTable select 1 toFixed 3, _interpGammaVal tofixed 3];

    _fuselageTorque = _fuselagePitchTorque vectorAdd _fuselageYawTorque;

    _heli addTorque (_heli vectorModelToWorld _fuselageTorque);
};

#ifdef __A3_DEBUG__
private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

//Draw the force vector
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecY, "green"] call fza_fnc_debugDrawLine;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecZ, "blue"]  call fza_fnc_debugDrawLine;
#endif