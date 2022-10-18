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
private _cyclicPitchMin     = -10.0;
private _cyclicPitchMax     =  10.0;

private _cyclicRollMin      = -10.0;
private _cyclicRollMax      =  10.0;

private _collectivePitchMin =  0.0;
private _collectivePitchMax =  10.0;

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
([_heli, _rotorParams] call bmk_helisim_fnc_mainRotor_update) 
    params ["_omega", "_omegaR"];
//--Get input
private _controlInputs   = [_heli] call bmk_helisim_fnc_utility_getInput;
//--Collect pitch params
private _cyclicPitch     = [_cyclicPitchMin, _cyclicPitchMax];
private _cyclicRoll      = [_cyclicRollMin, _cyclicRollMax];
private _collectivePitch = [_collectivePitchMin, _collectivePitchMax];
//--Update control angles
([_heli, _controlInputs, _cyclicPitch, _cyclicRoll, _collectivePitch] call bmk_helisim_fnc_mainRotor_updateControlAngles) 
    params ["_theta0", "_AIC_deg", "_BIC_deg"];
//--Calculate beta and control axis velocities
([_heli, 0.0, 0.0, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_mainRotor_hubToControlAxes) 
    params ["_beta_deg", "_controlAxisVelocities"];
//--Calculate thrust
([_heli, _deltaTime, _dryAirDensity, _controlAxisVelocities, _omegaR, _theta0, _rotorParams] call bmk_helisim_fnc_mainRotor_calculateThrust)
    params ["_mu", "_thrust"];


_controlAxisVelocities params ["_u_w", "_v_w", "_w_w"];

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
                    (deg _theta0) toFixed 2,
                    _AIC_deg toFixed 2,
                    _BIC_deg toFixed 2,
                    _mu toFixed 2,
                    _thrust toFixed 0];