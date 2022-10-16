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
private _collectiveMin  =  0.0;
private _collectiveMax  =  10.0;

private _cyclicPitchMin = -10.0;
private _cyclicPitchMax =  10.0;

private _cyclicRollMin  = -10.0;
private _cyclicRollMax  =  10.0;

//--Update
private _update = [_heli] call bmk_helisim_fnc_mainRotor_Update;
private _omega  = _update # 0;
private _omegaR = _update # 1;
private _RPM    = _heli getVariable "bmk_helisim_mainRotorRPM";

//--Update control angles
private _controlAngles  = [_heli, _collectiveMin, _collectiveMax, _cyclicPitchMin, _cyclicPitchMax, _cyclicRollMin, _cyclicRollMax] call bmk_helisim_fnc_mainRotor_UpdateControlAngles;
private _theta0_deg     = _controlAngles # 0;
private _AIC_deg        = _controlAngles # 1;
private _BIC_deg        = _controlAngles # 2;
//--Calculate beta and control axis velocities
private _controlAxes    = [_heli, 0.0, 0.0, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_mainRotor_HubToControlAxes;
private _beta_deg       = _controlAxes # 0;
private _u_w            = _controlAxes # 1;
private _v_w            = _controlAxes # 2;
private _w_w            = _controlAxes # 3;
//--Calculate thrust
private _thrust         = [_heli, _u_w, _omegaR, 0.97] call bmk_helisim_fnc_mainRotor_CalculateThrust;

hintsilent format ["Theta0: %8
                    \nAIC: %9
                    \nBIC: %10
                    \nVel X (FWD): %1
                    \nVelY (SIDE): %2
                    \nVelZ (UP): %3
                    \nDens Alt: %4
                    \nDry Air Dens: %5
                    \nTip Velocity: %6
                    \nBeta: %7",
                    _u_w toFixed 2, 
                    _v_w toFixed 2 , 
                    _w_w toFixed 2, 
                    _densityAltitude, 
                    _dryAirDensity, 
                    _bladeTipVelocity, 
                    _beta_deg toFixed 2,
                    _theta0_deg toFixed 2,
                    _AIC_deg toFixed 2,
                    _BIC_deg toFixed 2];