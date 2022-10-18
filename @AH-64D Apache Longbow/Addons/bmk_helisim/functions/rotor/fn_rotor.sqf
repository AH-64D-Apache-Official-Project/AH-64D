params ["_heli", "_deltaTime"];
#include "\bmk_helisim\headers\core.hpp"

////////////////////////////////////////////////////////////////////////////////////////////////////
//Environment    ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _altitude          = 0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = 15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotor          ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _maxGrossWeight         = 2495;  //kg

private _numberOfBlades         = 4;
private _bladeRadius            = 7.315;
private _bladeChord             = 0.533;

private _bladeProfileDragMin    = 0.012;
private _bladeProfileDragMax    = 0.017;

private _designRPM              = 289;
private _desiredRPM             = 1.01;

private _bladeTipVelocity       = (2 * pi * (_designRPM * _desiredRPM)/60) * _bladeRadius;

//--Update control angles
private _cyclicPitchMin_deg     = -10.0;
private _cyclicPitchMax_deg     =  10.0;

private _cyclicRollMin_deg      = -10.0;
private _cyclicRollMax_deg      =  10.0;

private _collectivePitchMin_deg =  0.0;
private _collectivePitchMax_deg =  10.0;

//--Collect rotor params
private _rotorParams = [ _heli getVariable "bmk_helisim_a",
                         _heli getVariable "bmk_helisim_mainRotor_b",
                         _heli getVariable "bmk_helisim_mainRotor_R",
                         _heli getVariable "bmk_helisim_mainRotor_c",
                         _heli getVariable "bmk_helisim_mainRotor_theta1",
                         _heli getVariable "bmk_helisim_mainRotor_m",
                         _heli getVariable "bmk_helisim_mainRotor_eR",
                         _heli getVariable "bmk_helisim_mainRotor_e",
                         _heli getVariable "bmk_helisim_mainRotor_gearRatio",
                         _heli getVariable "bmk_helisim_mainRotor_s"];
//--Update
([_heli, _rotorParams] call bmk_helisim_fnc_rotorUpdate) 
    params ["_omega", "_omegaR"];
//--Get input
private _controlInputs       = [_heli] call bmk_helisim_fnc_utilityGetInput;
//--Collect pitch params
private _cyclicPitch_deg     = [_cyclicPitchMin_deg,     _cyclicPitchMax_deg];
private _cyclicRoll_deg      = [_cyclicRollMin_deg,      _cyclicRollMax_deg];
private _collectivePitch_deg = [_collectivePitchMin_deg, _collectivePitchMax_deg];
//--Update control angles
([_heli, _controlInputs, _cyclicPitch_deg, _cyclicRoll_deg, _collectivePitch_deg] call bmk_helisim_fnc_rotorUpdateControlAngles) 
    params ["_theta0_deg", "_AIC_deg", "_BIC_deg"];
//--Transform ARMA coordinate system to model
([_heli, 0.0, 0.0] call bmk_helisim_fnc_utilityArmaToModel)
    params ["_u_s", "_v_s", "_w_s"];
//--Calculate beta and control axis velocities
([_heli, _u_s, _v_s, _w_s, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorHubVelocityToControlAxes) 
    params ["_beta_deg", "_u_w", "_v_w", "_w_w"];
//--Calculate thrust
([_heli, _deltaTime, _dryAirDensity, _u_w, _v_w, _w_w, _omegaR, _theta0_deg, _rotorParams] call bmk_helisim_fnc_rotorCalculateThrust)
    params ["_mu", "_thrust"];

////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _objCtr    = _heli selectionPosition ["modelCenter", "Memory"];
private _rotorPos  = [0.0, 2.08, 0.83]; //m
private _forceVec  = [0.0, 0.0, 1.0];   //X, Z, Y
private _thrustVec = _forceVec vectorMultiply (_thrust * _deltaTime);

_heli addForce[_heli vectorModelToWorld _thrustVec, _rotorPos];

#ifdef __A3_DEBUG__
//Draw the force vector
[_heli, _rotorPos, _rotorPos vectorAdd _forceVec, _colorGreen] call DRAW_LINE;
#endif
////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

hintsilent format ["Theta0: %8
                    \nAIC: %9
                    \nBIC: %10
                    \nVel X (FWD): %1
                    \nVelY (SIDE): %2
                    \nVelZ (UP): %3
                    \nDens Alt: %4
                    \nDry Air Dens: %5
                    \nTip Velocity: %6
                    \nBeta: %7
                    \nMu: %11,
                    \nThrust: %12",
                    _u_w toFixed 2, 
                    _v_w toFixed 2 , 
                    _w_w toFixed 2, 
                    _densityAltitude, 
                    _dryAirDensity, 
                    _bladeTipVelocity, 
                    _beta_deg toFixed 2,
                    _theta0_deg toFixed 2,
                    _AIC_deg toFixed 2,
                    _BIC_deg toFixed 2,
                    _mu toFixed 2,
                    _thrust toFixed 0];