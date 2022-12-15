params ["_heli", "_deltaTime", "_rtrNum", "_mastPitch_deg", "_mastRoll_deg"];

// ARMA               Model 
//
// +Z  +Y                +X
//  +  +                 +
//  | /                 /
//  |/                 / 
//  +-----+ +X        +-----+ +Y
//                    |
//                    |
//                    +
//                   +Z

private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

private _pitchPrev = _heli getVariable "bmk_helisim_pitchPrev" select _rtrNum;
private _rollPrev  = _heli getVariable "bmk_helisim_rollPrev"  select _rtrNum;
private _yawPrev   = _heli getVariable "bmk_helisim_yawPrev"   select _rtrNum;

(_heli call bis_fnc_getPitchBank)
    params ["_pitch", "_roll"];
private _yaw = getDir _heli;
//--Convert from degrees to radians
_pitch = rad _pitch; _roll = rad _roll; _yaw = rad _yaw;
//--Calculate angular velocities
private _angVelX = if (_deltaTime == 0) then { 0.0; } else { (_pitchPrev - _pitch) / _deltaTime; };
private _angVelY = if (_deltaTime == 0) then { 0.0; } else { (_rollPrev  - _roll)  / _deltaTime; };
private _angVelZ = if (_deltaTime == 0) then { 0.0; } else { (_yawPrev   - _yaw)   / _deltaTime; };

[_heli, "bmk_helisim_pitchPrev", _rtrNum, _pitch] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rollPrev",  _rtrNum, _roll] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_yawPrev",   _rtrNum, _yaw] call fza_sfmplus_fnc_setArrayVariable;

private _angVel = [[_angVelX], [_angVelY], [_angVelZ]];
_angVel         = _armaToModelMatrix matrixMultiply _angVel;
_angVel         = _bodyToShaftMatrix matrixMultiply _angVel;
_angVel         = [_angVel # 0 # 0, _angVel # 1 # 0, _angVel # 2 # 0];

private _p_s = _angVel # 0;
private _q_s = _angVel # 1;
private _r_s = _angVel # 2;

[_p_s, _q_s, _r_s];