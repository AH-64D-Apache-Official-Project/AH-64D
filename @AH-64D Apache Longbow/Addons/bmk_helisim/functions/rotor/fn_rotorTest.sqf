params ["_heli", "_deltaTime", "_rho", "_rtrNum", "_rotorPos", "_mastPitch_deg", "_mastRoll_deg", "_controlInputs"];

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
                       , _heli getVariable "bmk_helisim_rotor_Ib" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_s" select _rtrNum
                       , _heli getVariable "bmk_helisim_rotor_polarMOI" select _rtrNum
                       , _heli getVariable "bmk_helisim_inputMaps" select _rtrNum];

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

//systemchat format ["Rotor %7 --- Us %1 Vs %2 Ws %3 --- Ps %4 Qs %5 Rs %6 --- Gnd Eff Scalar %8", _u_s toFixed 1, _v_s toFixed 1, _w_s toFixed 1, _p_s toFixed 1, _q_s toFixed 1, _r_s toFixed 1, _rtrNum, _gndEffScalar toFixed 2];


#ifdef __A3_DEBUG__
private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

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