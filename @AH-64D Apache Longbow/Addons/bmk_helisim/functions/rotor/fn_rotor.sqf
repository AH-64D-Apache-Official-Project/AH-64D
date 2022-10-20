params ["_heli", "_deltaTime"];
#include "\bmk_helisim\headers\core.hpp"

////////////////////////////////////////////////////////////////////////////////////////////////////
//Environment    ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _altitude          = _heli getVariable "fza_sfmplus_PA"; //0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = _heli getVariable "fza_sfmplus_FAT"; //15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotor          ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
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
                         _heli getVariable "bmk_helisim_mainRotor_theta1_deg",
                         _heli getVariable "bmk_helisim_mainRotor_m",
                         _heli getVariable "bmk_helisim_mainRotor_eR",
                         _heli getVariable "bmk_helisim_mainRotor_e",
                         _heli getVariable "bmk_helisim_mainRotor_gearRatio",
                         _heli getVariable "bmk_helisim_mainRotor_Ib",
                         _heli getVariable "bmk_helisim_mainRotor_s"];
//--Update
([_heli, _dryAirDensity, _rotorParams] call bmk_helisim_fnc_rotorUpdate) 
    params ["_omega", "_omegaR", "_gamma"];
//--Get input
private _controlInputs       = [_heli, _deltaTime] call bmk_helisim_fnc_utilityGetInput;
//--Collect pitch params
private _cyclicPitch_deg     = [_cyclicPitchMin_deg,     _cyclicPitchMax_deg];
private _cyclicRoll_deg      = [_cyclicRollMin_deg,      _cyclicRollMax_deg];
private _collectivePitch_deg = [_collectivePitchMin_deg, _collectivePitchMax_deg];
//--Update control angles
([_heli, _controlInputs, _cyclicPitch_deg, _cyclicRoll_deg, _collectivePitch_deg] call bmk_helisim_fnc_rotorUpdateControlAngles) 
    params ["_theta0_deg", "_AIC_deg", "_BIC_deg"];
//--Transform ARMA coordinate system to model
([_heli, _deltaTime, 0.0, 0.0] call bmk_helisim_fnc_utilityArmaToModel)
    params ["_u_s", "_v_s", "_w_s", "_p_s", "_q_s", "_r_s"];
//--Calculate beta and linear velocities in control axes
([_heli, _u_s, _v_s, _w_s, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorHubVelocityToControlAxes) 
    params ["_beta_deg", "_u_w", "_v_w", "_w_w"];
//--Calculate angular velocities in control axes
([_heli, _p_s, _q_s, _r_s, _beta_deg] call bmk_helisim_fnc_rotorBodyAngularVelocityToControlAxes)
    params ["_p_w", "_q_w", "_r_w"];
//--Calculate thrust
([_heli, _deltaTime, _dryAirDensity, _u_w, _v_w, _w_w, _omegaR, _theta0_deg, _rotorParams] call bmk_helisim_fnc_rotorCalculateThrust)
    params ["_mu", "_thrust", "_lambda"];
//--Calculate coning angles
([_heli, _mu, _lambda, _theta0_deg, _rotorParams, _gamma] call bmk_helisim_fnc_rotorCalculateConingAngles)
    params ["_a0_deg"];
//--Calculate flapping angles
([_heli, _theta0_deg, _rotorParams, _mu, _lambda, _p_w, _q_w, _omega, _gamma, _a0_deg] call bmk_helisim_fnc_rotorCalculateFlappingAngles)
    params ["_a1_deg", "_b1_deg"];

////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _objCtr    = _heli selectionPosition ["modelCenter", "Memory"];
private _rotorPos  = [0.0, 2.06, 0.83]; //m
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
                    \nA0_deg: %13
                    \n-------------------------
                    \na1_deg: %20
                    \nb1_deg: %21
                    \n-------------------------
                    \nVel X (FWD): %1
                    \nVelY (SIDE): %2
                    \nVelZ (UP): %3
                    \n-------------------------
                    \nAng VelX (Roll): %14
                    \nAng VelY (Pitch): %15
                    \nAng VelZ (Yaw): %16
                    \n-------------------------
                    \nAng VelX: %17
                    \nAng VelY: %18
                    \nAng VelZ: %19
                    \n-------------------------
                    \nDens Alt: %4
                    \nDry Air Dens: %5
                    \nBeta: %7
                    \nMu: %11,
                    \nThrust: %12",
                    _u_w toFixed 2,         //1
                    _v_w toFixed 2 ,        //2
                    _w_w toFixed 2,         //3
                    _densityAltitude,       //4
                    _dryAirDensity,         //5
                    _bladeTipVelocity,      //6
                    _beta_deg toFixed 2,    //7
                    _theta0_deg toFixed 2,  //8
                    _AIC_deg toFixed 2,     //9
                    _BIC_deg toFixed 2,     //10
                    _mu toFixed 2,          //11
                    _thrust toFixed 0,      //12
                    _a0_deg toFixed 2,      //13
                    _p_w toFixed 2,         //14
                    _q_w toFixed 2,         //15
                    _r_w toFixed 2,         //16
                    _p_s toFixed 2,         //17
                    _q_s toFixed 2,         //18
                    _r_s toFixed 2,         //19
                    _a1_deg toFixed 2,      //20
                    _b1_deg toFixed 2];     //21