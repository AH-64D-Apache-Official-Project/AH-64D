#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";//fza_ah64_fixedTimeStep;;
private _altitude           = _heli getVariable "fza_sfmplus_PA";
private _temperature        = _heli getVariable "fza_sfmplus_FAT";
private _rho                = _heli getVariable "fza_sfmplus_rho";

//systemChat format ["_altitude = %1 -- _temperature -- %2 -- _rho = %3", _altitude toFixed 0, _temperature toFixed 0, _rho toFixed 3];

private _configVehicles     = configFile >> "CfgVehicles" >> typeof _heli;
private _aerodynamicCenter  = _heli getVariable "fza_sfmplus_aerodynamicCenter"; //m
private _heliCOM            = getCenterOfMass _heli;

private _fuselageAreaFront  = _heli getVariable "fza_sfmplus_fuselageAreaFront";
//private _fuselageAreaSide   = _heli getVariable "fza_sfmplus_fuselageAreaSide";
//private _fuselageAreaBottom = _heli getVariable "fza_sfmplus_fuselageAreaBottom";

//private _fuselageDragCoefX    = 1.5;
//private _fuselageDragCoefZ    = 0.5;

private _vectorRight            = [1.0, 0.0, 0.0];
private _vectorForward          = [0.0, 1.0, 0.0];
private _vectorUp               = [0.0, 0.0, 1.0];

private _relativeWind           = (_heli getVariable "fza_sfmplus_velModelSpace") vectorMultiply -1.0;//(_heli getVariable "fza_sfmplus_velWorldSpace") vectorMultiply -1.0;

private _relativeWindCorrection = _vectorRight;
private _dotProduct             = _relativeWindCorrection vectorDotProduct _relativeWind;
_relativeWindCorrection         = _relativeWindCorrection vectorMultiply _dotProduct;
_relativeWind                   = _relativeWind vectorDiff _relativeWindCorrection;
/////////////////////////////////////////////////////////////////////////////////////////////
// Fuselage Drag        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _interpDragCoefTableY = [];

private _fuselageTorque       = [];

//-------------------------------PA   -40   -20     0    20    40
private _heliSimDragTableY = [
                              [    0,0.90,0.75,0.60,0.55,0.50]   
                             ,[ 2000,1.10,0.95,0.75,0.70,0.60]   
                             ,[ 4000,1.15,1.00,0.85,0.70,0.75]   
                             ,[ 6000,1.20,1.05,1.00,0.95,0.95]   
                             ,[ 8000,1.15,0.95,0.90,1.10,1.10] 
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

private _dragCoefVelScalarTable =
[
 [  0.0, 0.40]  //0kts
,[20.58, 0.40]  //40kts
,[36.01, 0.44]  //70kts
,[46.30, 0.52]  //90kts
,[54.02, 0.61]  //105kts
,[61.73, 0.75]  //120kts
,[72.02, 1.00]  //140kts
];

private _dragCoefVelScalar = ([_dragCoefVelScalarTable, (_heli getVariable "fza_sfmplus_vel2D")] call fza_fnc_linearInterp) select 1;

private _CD         = (_interpDragCoefTableY # 1) * _dragCoefVelScalar;

private _v          = vectorMagnitude _relativeWind;
private _drag       = _CD * 0.5 * _rho * _fuselageAreaFront * (_v * _v);

private _dragVector = _relativeWind;
_dragVector         = vectorNormalized _dragVector;
_dragVector         = _dragVector vectorMultiply (_drag * _deltaTime);

_heli addForce[_heli vectorModelToWorld _dragVector, _heliCOM];
/////////////////////////////////////////////////////////////////////////////////////////////
// Fuselage Torque      /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _alpha    = _heli getVariable "fza_sfmplus_aero_alpha_deg";
private _beta_deg = _heli getVariable "fza_sfmplus_aero_beta_deg";
private _beta_g   = _heli getVariable "fza_sfmplus_aero_beta_g";
private _gamma    = _heli getVariable "fza_sfmplus_aero_gamma";

private _vScalar  = linearConversion [0.0, VEL_VBE, _v, 0.0, 1.0];
_vScalar          = [_vScalar, 0.0, 1.0] call BIS_fnc_clamp;

private _sideslipTable     = [[-90, -0.100]
                             ,[-60, -0.010]
                             ,[-20, -0.005]
                             ,[  3,  0.000]
                             ,[ 20,  0.005]
                             ,[ 60,  0.010]
                             ,[ 90,  0.100]];
_interpSidelsipTable       = [_sideslipTable, _beta_deg] call fza_fnc_linearInterp;
_interpSideslipVal         = _interpSidelsipTable select 1;

private _fuselageYawTorque = [0.0, 0.0, 1.0] vectorMultiply ((_interpSideslipVal * 5000) * _vScalar);

private _alphaTable       = [[-180.000,  0.100]
                            ,[ -90.000,  0.010]
                            ,[ -20.000,  0.005]
                            ,[  -5.365,  0.000]
                            ,[   0.000, -0.005]
                            ,[  90.000, -0.010]
                            ,[ 180.000, -0.100]];

_interpAlphaTable           = [_alphaTable, _alpha] call fza_fnc_linearInterp;
_interpAlphaVal             = _interpAlphaTable select 1;

private _fuselagePitchTorque  = [1.0, 0.0, 0.0] vectorMultiply ((_interpAlphaVal * 25000) * _vScalar);
//systemChat format ["_alpha = %1", _alpha];
//systemChat format ["_pitchTorque = %1 -- _vScalar = %2", _fuselagePitchTorque, _vScalar];
//systemChat format ["_gamma = %1 -- _beta_deg = %2 -- _vScalar = %3", _gamma, _beta_deg, _vScalar];
//systemChat format ["_interpBetaTable = %1 -- _interpBetaVal %2", _interpBetaTable select 1 toFixed 3, _interpBetaVal tofixed 3];
//systemChat format ["_interpGammaTable = %1 -- _interpGammaVal %2", _interpGammaTable select 1 toFixed 3, _interpGammaVal tofixed 3];
_fuselageTorque = _fuselagePitchTorque vectorAdd _fuselageYawTorque;

_heli addTorque (_heli vectorModelToWorld _fuselageTorque);

#ifdef __A3_DEBUG__
private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

//Draw the force vector
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecY, "green"] call fza_fnc_debugDrawLine;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecZ, "blue"]  call fza_fnc_debugDrawLine;
#endif