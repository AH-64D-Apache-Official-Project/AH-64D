params ["_heli", "_deltaTime", "_rho", "_rtrNum", "_rotorPos", "_rotorRot", "_controlInputs"];

_rotorRot
    params ["_mastPitch_deg", "_mastRoll_deg"];

//---Collect rotor parameters
private _rotorParams = [ _heli getVariable "bmk_helisim_rotor_a"
                       , _heli getVariable "bmk_helisim_type" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_b" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_h" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_R" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_c" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_theta1_deg" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_m" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_eR" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_e" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_gearRatio" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_thrustScalar" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_Ib" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_s" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_polarMOI" select _rtrNum
                       , _heli getVariable "bmk_helisim_inputMaps" select _rtrNum];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

//---Linear velocities
([_heli, _mastPitch_deg, _mastRoll_deg] call bmk_helisim_fnc_utilityGetLinearVelocities)
    params ["_u_s", "_v_s", "_w_s"];
//---Angular velocities
([_heli, _deltaTime, _rtrNum, _mastPitch_deg, _mastRoll_deg] call bmk_helisim_fnc_utilityGetAngularVelocities)
    params ["_p_s", "_q_s", "_r_s"];
//---Update rotor rotational velocities
([_heli, _rtrNum, _rho, _rotorParams] call bmk_helisim_fnc_rotorUpdate)
    params ["_omega", "_omegaR", "_gamma"];
//---Update control angles
([_heli, _rotorParams, _controlInputs] call bmk_helisim_fnc_rotorUpdateControlAngles)
    params ["_theta0_deg", "_AIC_deg", "_BIC_deg"];
//--Calculate ground effect
([_heli, _rotorParams] call bmk_helisim_fnc_aeroGroundEffect)
    params ["_gndEffScalar"];
//--Calculate beta and linear velocities in control axes
([_heli, _u_s, _v_s, _w_s, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorHubVelocityToControlAxes) 
    params ["_beta_deg", "_u_w", "_v_w", "_w_w"];
//--Calculate angular velocities in control axes
([_heli, _p_s, _q_s, _r_s, _beta_deg] call bmk_helisim_fnc_rotorBodyAngularVelocityToControlAxes)
    params ["_p_w", "_q_w", "_r_w"];  
_p_w = 0.0; _q_w = 0.0; _r_w = 0.0;  //<--until a more stable/reliable means of calculating angular velocity can be found, these values will be forced to zero
//--Calculate thrust
//Thrust scalar @ SL 15 dec C = 2.2, ground effect scalar min = 0.85
//Thrust scalar @ 4000ft 35 deg C = 2.3, ground effect scalar min = 0.85
([_heli, _deltaTime, _rtrNum, _rho, _u_w, _v_w, _w_w, _omegaR, _theta0_deg, _rotorParams, _gndEffScalar] call bmk_helisim_fnc_rotorCalculateThrust)
    params ["_mu", "_thrust", "_lambda", "_CT"];
//--Calculate coning angles
([_heli, _mu, _lambda, _theta0_deg, _rotorParams, _gamma] call bmk_helisim_fnc_rotorCalculateConingAngles)
    params ["_a0_deg"];
//--Calculate flapping angles
([_heli, _theta0_deg, _rotorParams, _mu, _lambda, _p_w, _q_w, _omega, _gamma, _a0_deg] call bmk_helisim_fnc_rotorCalculateFlappingAngles)
    params ["_a1_deg", "_b1_deg", "_theta75_deg"];
//--Calculate drag and side forces
([_heli, _mu, _lambda, _theta75_deg, _q_w, _gamma, _omega, _omegaR, _CT, _rotorParams, _thrust, _rho, _a0_deg, _a1_deg, _b1_deg] call bmk_helisim_fnc_rotorCalculateDragAndSideForces)
    params ["_dragH", "_sideJ"];
//--Calculate torque
([_heli, _rtrNum, _CT, _rotorParams, _rho, _omegaR, _mu, _thrust, _lambda, _dragH] call bmk_helisim_fnc_rotorCalculateTorque)
    params ["_torque"];
//--Calculate body forces
([_heli, _dragH, _beta_deg, _sideJ, _thrust, _AIC_deg, _BIC_deg] call bmk_helisim_fnc_rotorCalculateBodyForces)
    params ["_x_s", "_y_s", "_z_s"];
//--Calculate body moments
([_heli, _a1_deg, _beta_deg, _b1_deg, _AIC_deg, _BIC_deg, _omega, _rotorParams, _torque] call bmk_helisim_fnc_rotorCalculateBodyMoments)
    params ["_l_s", "_m_s", "_n_s"];
([_rotorRot, _x_s, _y_s, _z_s, _l_s, _m_s, _n_s] call bmk_helisim_fnc_utilityModelToArma)
    params ["_out_x", "_out_y", "_out_z", "_out_l", "_out_m", "_out_n"];

//systemchat format ["Rotor %7 --- Us %1 Vs %2 Ws %3 --- Ps %4 Qs %5 Rs %6 --- Gnd Eff Scalar %8", _u_s toFixed 1, _v_s toFixed 1, _w_s toFixed 1, _p_s toFixed 1, _q_s toFixed 1, _r_s toFixed 1, _rtrNum, _gndEffScalar toFixed 2];
//systemchat format ["Rotor %7 --- Uw %1 Vw %2 Ww %3 --- Pw %4 Qw %5 Rw %6 --- beta_deg %8", _u_w toFixed 1, _v_w toFixed 1, _w_w toFixed 1, _p_w toFixed 1, _q_w toFixed 1, _r_w toFixed 1, _rtrNum, _beta_deg toFixed 2];
//systemChat format ["Rotor %1 -- mu %2 -- thrust %3 -- lambda %4 -- ct %5", _rtrNum, _mu toFixed 2, _thrust toFixed 2, _lambda toFixed 2, _ct toFixed 2];
//systemChat format ["Rotor %1 -- X %2 Y %3 Z %4 -- L %5 M %6 N %7", _rtrNum, _out_x toFixed 0, _out_y toFixed 0, _out_z toFixed 0, _out_l toFixed 0, _out_m toFixed 0, _out_n toFixed 0];
//systemChat format ["Rotor %1 torque: %2", _rtrNum, (((_torque / 72.29) / 481.0) * 100) toFixed 2];

private _forceX = _axisX vectorMultiply (_out_x * _deltaTime);
private _forceY = _axisY vectorMultiply (_out_y * _deltaTime);
private _forceZ = _axisZ vectorMultiply (_out_z * _deltaTime);

_heli addForce[_heli vectorModelToWorld _forceX, _rotorPos];
_heli addForce[_heli vectorModelToWorld _forceY, _rotorPos];
_heli addForce[_heli vectorModelToWorld _forceZ, _rotorPos];

private _torqueX = _out_l * _deltaTime;
private _torqueY = _out_m * _deltaTime;
private _torqueZ = _out_n * _deltaTime;

_heli addTorque (_heli vectorModelToWorld[_torqueX, _torqueY, -_torqueZ]); //<-- this needs to be controlled by a direction variable to allow for clockwise rotating rotors

#ifdef __A3_DEBUG__

private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

_axisX = [[_axisX # 0], [_axisX # 1], [_axisX # 2]];
_axisX = _bodyToShaftMatrix matrixMultiply _axisX;
_axisX = _armaToModelMatrix matrixMultiply _axisX;
_axisX = [_axisX # 0 # 0, _axisX # 1 # 0, _axisX # 2 # 0];

_axisY = [[_axisY # 0], [_axisY # 1], [_axisY # 2]];
_axisY = _bodyToShaftMatrix matrixMultiply _axisY;
_axisY = _armaToModelMatrix matrixMultiply _axisY;
_axisY = [_axisY # 0 # 0, _axisY # 1 # 0, _axisY # 2 # 0];

_axisZ = [[_axisZ # 0], [_axisZ # 1], [_axisZ # 2]];
_axisZ = _bodyToShaftMatrix matrixMultiply _axisZ;
_axisZ = _armaToModelMatrix matrixMultiply _axisZ;
_axisZ = [_axisZ # 0 # 0, _axisZ # 1 # 0, _axisZ # 2 # 0];

//Draw model axes
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

[_heli, _rotorPos, _rotorPos vectorAdd _axisX, _colorRed]   call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisY, _colorGreen] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisZ, _colorBlue]  call DRAW_LINE;
#endif