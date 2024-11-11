params ["_heli", "_deltaTime", "_altitude", "_temperature", "_rho"];

private _configVehicles     = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel        = getText (_configVehicles >> "fza_flightModel");

private _aerodynamicCenter  = _heli getVariable "fza_sfmplus_aerodynamicCenter"; //m

private _fuselageAreaFront  = _heli getVariable "fza_sfmplus_fuselageAreaFront";
private _fuselageAreaSide   = _heli getVariable "fza_sfmplus_fuselageAreaSide";
private _fuselageAreaBottom = _heli getVariable "fza_sfmplus_fuselageAreaBottom";

private _fuselageDragCoefX    = 1.5;
private _fuselageDragCoefZ    = 0.5;

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
    private _heliSimDragTableY =[
                                 [    0, 0.83, 0.79, 0.74, 0.75, 0.78]
                                ,[ 2000, 1.19, 1.02, 1.00, 1.03, 0.88]
                                ,[ 4000, 1.48, 1.32, 1.25, 1.28, 1.46]
                                ,[ 6000, 2.02, 1.72, 1.65, 1.86, 2.00]
                                ,[ 8000, 2.24, 1.99, 1.97, 2.32, 2.57]
                                ];
/*
DRAG_TABLE =[ 
 [    0,0.83,0.79,0.74,0.75,0.78]  
,[ 2000,1.19,1.02,1.00,1.03,0.88]  
,[ 4000,1.48,1.32,1.25,1.28,1.46]  
,[ 6000,2.02,1.72,1.65,1.86,2.00]  
,[ 8000,2.24,1.99,1.97,2.32,2.57]
];
*/
    _interpDragCoefTableY      = [_heliSimDragTableY, _altitude] call fza_fnc_linearInterp;
    private _dragCoefTableY    = [[-40, _interpDragCoefTableY # 1]
                                 ,[-20, _interpDragCoefTableY # 2]
                                 ,[  0, _interpDragCoefTableY # 3]
                                 ,[ 20, _interpDragCoefTableY # 4]
                                 ,[ 40, _interpDragCoefTableY # 5]];
    _interpDragCoefTableY      = [_dragCoefTableY, _temperature] call fza_fnc_linearInterp;
 
    private _alpha = _heli getVariable "fza_sfmplus_aero_alpha";
    private _beta  = _heli getVariable "fza_sfmplus_aero_beta";
    private _gamma = _heli getVariable "fza_sfmplus_aero_gamma";

    private _betaTable         = [[-90, -0.100]
                                 ,[-20, -0.050]
                                 ,[  0,  0.000]
                                 ,[ 20,  0.050]
                                 ,[ 90,  0.100]];
    _interpBetaTable           = [_betaTable, _beta] call fza_fnc_linearInterp;
    _interpBetaVal             = _interpBetaTable select 1;

    private _fuselageYawTorque = [0.0, 0.0, 1.0] vectorMultiply ((_interpBetaVal * 25000) * _deltaTime);

    private _gammaTable       = [[-180, -0.100]
                                ,[ -90, -0.075]
                                ,[ -20, -0.050]
                                ,[   0,  0.000]
                                ,[  20,  0.050]
                                ,[  90,  0.075]
                                ,[ 180,  0.100]];

    _interpGammaTable           = [_gammaTable, _gamma] call fza_fnc_linearInterp;
    _interpGammaVal             = _interpGammaTable select 1;

   private _fuselagePitchTorque = [1.0, 0.0, 0.0] vectorMultiply ((_interpGammaVal * 25000) * _deltaTime);

    //systemChat format ["_interpBetaTable = %1 -- _interpBetaVal %2", _interpBetaTable select 1 toFixed 3, _interpBetaVal tofixed 3];
    //systemChat format ["_interpGammaTable = %1 -- _interpGammaVal %2", _interpGammaTable select 1 toFixed 3, _interpGammaVal tofixed 3];

    _fuselageTorque = _fuselagePitchTorque vectorAdd _fuselageYawTorque;
};
private _fuselageDragCoefY     = _interpDragCoefTableY # 1;

velocityModelSpace _heli
    params ["_locVelX", "_locVelY", "_locVelZ"];

private _drag = 
            [ _fuselageDragCoefX * _fuselageAreaSide   * (_locVelX * _locVelX)
            , _fuselageDragCoefY * _fuselageAreaFront  * (_locVelY * _locVelY)
            , _fuselageDragCoefZ * _fuselageAreaBottom * (_locVelZ * _locVelZ)
            ] vectorMultiply (-0.5 * _rho * _deltaTime);

_heli addForce[_heli vectorModelToWorld _drag, getCenterOfMass _heli];
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