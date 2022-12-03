params ["_heli", "_deltaTime", "_rho", "_rotorPos", "_rotorRot", "_controlInputs"];
#include "\bmk_helisim\headers\core.hpp"

////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotor          ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _isTailRotor = true;

private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

//--Update control angles, MOVE TO CONFIG
private _pedalPitchMap_deg = [[-1.0,  27.0],
                              [ 0.0,   0.0],
                              [ 1.0, -15.0]];

//--Collect rotor params
private _rotorParams = [ _heli getVariable "bmk_helisim_a",
                         _heli getVariable "bmk_helisim_tailRotor_b",
                         _heli getVariable "bmk_helisim_tailRotor_R",
                         _heli getVariable "bmk_helisim_tailRotor_c",
                         _heli getVariable "bmk_helisim_tailRotor_theta1_deg",
                         _heli getVariable "bmk_helisim_tailRotor_m",
                         _heli getVariable "bmk_helisim_tailRotor_eR",
                         _heli getVariable "bmk_helisim_tailRotor_e",
                         _heli getVariable "bmk_helisim_tailRotor_gearRatio",
                         _heli getVariable "bmk_helisim_tailRotor_Ib",
                         _heli getVariable "bmk_helisim_tailRotor_s"];

//--Update
([_heli, _rho, _isTailRotor, _rotorParams] call bmk_helisim_fnc_rotorUpdate) 
    params ["_omega", "_omegaR", "_gamma"];
//--Update control angles
([_heli, _controlInputs, nil, nil, nil, _pedalPitchMap_deg] call bmk_helisim_fnc_rotorUpdateControlAngles) 
    params ["_theta0_deg", "_AIC_deg", "_BIC_deg"];
//--Transform ARMA coordinate system to model
_rotorRot params ["_mastPitch_deg", "_mastRoll_deg"];
([_heli, _deltaTime, _mastPitch_deg, _mastRoll_deg] call bmk_helisim_fnc_utilityArmaToModel)
    params ["_u_s", "_v_s", "_w_s", "_p_s", "_q_s", "_r_s"];
//--Calculate beta and linear velocities in control axes
([_heli, _u_s, _v_s, _w_s, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorHubVelocityToControlAxes) 
    params ["_beta_deg", "_u_w", "_v_w", "_w_w"];
//--Calculate angular velocities in control axes
([_heli, _p_s, _q_s, _r_s, _beta_deg] call bmk_helisim_fnc_rotorBodyAngularVelocityToControlAxes)
    params ["_p_w", "_q_w", "_r_w"];
//--Calculate thrust
//Thrust scalar @ SL 15 dec C = 2.2, ground effect scalar min = 0.85
//Thrust scalar @ 4000ft 35 deg C = 2.3, ground effect scalar min = 0.85
([_heli, _deltaTime, _rho, _isTailRotor, _u_w, _v_w, _w_w, _omegaR, _theta0_deg, _rotorParams, 1.00, 1.00] call bmk_helisim_fnc_rotorCalculateThrust)
    params ["_mu", "_thrust", "_lambda", "_CT"];
//--Calculate coning angles
([_heli, _mu, _lambda, _theta0_deg, _rotorParams, _gamma] call bmk_helisim_fnc_rotorCalculateConingAngles)
    params ["_a0_deg"];
//--Calculate flapping angles
([_heli, _theta0_deg, _rotorParams, _mu, _lambda, _p_w, _q_w, _omega, _gamma, _a0_deg] call bmk_helisim_fnc_rotorCalculateFlappingAngles)
    params ["_a1_deg", "_b1_deg", "_theta75_deg"];
//--Calculate drag and side forces
([_heli, _mu, _lambda, _theta75_deg, _q_w, _gamma, _omega, _omegaR, _CT, _rotorParams, _thrust, _rho, _a0_deg, _a1_deg, _b1_deg] call bmk_helisim_fnc_rotorCalculateDragAndSideForces)
    params ["_H", "_J"];
//--Calculate torque
([_heli, _CT, _rotorParams, _rho, _omegaR, _mu, _thrust, _lambda, _H] call bmk_helisim_fnc_rotorCalculateTorque)
    params ["_torque", "_outputTorque"];
//--Calculate body forces
([_heli, _H, _beta_deg, _J, _thrust, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorCalculateBodyForces)
    params ["_x_s", "_y_s", "_z_s"];
//--Transform model coordinates back to ARMA coordinates
([_x_s, _y_s, _z_s, 0.0, 0.0, 0.0] call bmk_helisim_fnc_utilityModelToArma)
    params ["_out_x", "_out_y", "_out_z", "_out_l", "_out_m", "_out_n"];

////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _forceX = _vecX vectorMultiply (_out_z * _deltaTime);
private _forceY = _vecY vectorMultiply (_out_y * _deltaTime);
private _forceZ = _vecZ vectorMultiply (_out_x * _deltaTime);

_heli addForce[_heli vectorModelToWorld _forceX, _rotorPos];
_heli addForce[_heli vectorModelToWorld _forceY, _rotorPos];
_heli addForce[_heli vectorModelToWorld _forceZ, _rotorPos];

#ifdef __A3_DEBUG__
//Draw the force vector
[_heli, _rotorPos, _rotorPos vectorAdd _vecX, _colorRed] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _vecY, _colorGreen] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _vecZ, _colorBlue] call DRAW_LINE;
#endif
////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

hintsilent format ["-----TAIL ROTOR-----
                    \nTheta0: %8
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
                    \nThrust: %12
                    \n-------------------------
                    \nH: = %22
                    \nJ: = %23
                    \n-------------------------
                    \nTorque: %24 Nm
                    \nOutput Torque: %25 Nm
                    \nOutput Torque: %29 %
                    \n-------------------------
                    \nTorque X: %26
                    \nTorque Y: %27
                    \nTorque Z: %28",
                    _u_w toFixed 2,         //1
                    _v_w toFixed 2 ,        //2
                    _w_w toFixed 2,         //3
                    _densityAltitude,       //4
                    _rho,         //5
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
                    _b1_deg toFixed 2,      //21
                    _H,                     //22
                    _J,                     //23
                    _torque,                //24
                    _outputTorque,          //25
                    _torqueX toFixed 2,     //26
                    _torqueY toFixed 2,     //27
                    _torqueZ toFixed 2,     //28
                    _outputTorque / 481 * 100 toFixed 0];   //29

[_outputTorque, _out_x, _out_y, _out_z, _out_l, _out_m, _out_n];