params ["_heli", "_deltaTime", "_altitude", "_temperature", "_dryAirDensity"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _rtrPos              = [0.0, 2.06, 0.70];
private _rtrDesignRPM        = 289.0;
private _rtrRPMTrimVal       = 1.01;
private _rtrGearRatio        = 72.29;
private _rtrNumBlades        = 4;

private _bladeRadius         = 7.315;   //m
private _bladeChord          = 0.533;   //m
private _bladeDragCoef       = 0.018;
private _bladePitch_min      = 1.0;     //deg
private _bladePitch_max      = 19.0;    //deg

private _rtrThrustScalar_min = 0.120;
private _rtrThrustScalar_max = 1.279; //20,260lbs @ 5200ft and 80% collective

private _altitude_max        = 30000;   //ft
private _baseThrust          = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced 
private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * fza_sfmplus_collectiveOutput;
private _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _bladePitch_cur;
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
private _rtrRPMInducedThrustScalar = (_inputRPM / _rtrRPMTrimVal) * _rtrThrustScalar_max;
//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = 1 - ((1 / _altitude_max) * _altitude);
//Additional thrust gained from increasing forward airspeed
private _velXY                      = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _airspeedVelocityScalar    = (1 + (_velXY / 36.0111)) ^ (1 / 2.65);
//Induced flow handler
private _velZ                      = velocityModelSpace _heli # 2;
private _inducedVelocityScalar     = 1.0;
if (_velZ < -24.384 && _velXY < 12.35) then { 
    _inducedVelocityScalar = 0.0;
    systemChat format ["VRS!"]; 
} else { 
    _inducedVelocityScalar = 1 - (_velZ / 24.384);
    //if (_inducedVelocityScalar >= 1.25) then {
    //    _inducedVelocityScalar = 1.25;
    //};
    systemChat format ["Normal!"];
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar           = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;

//private _thrustX                       = 0;
//private _thrustY                       = 0;
private _rtrThrust                 = _baseThrust * _rtrThrustScalar;

private _rtrOmega                  = (2.0 * PI) * ((_rtrDesignRPM * _inputRPM) / 60);
private _bladeTipVel               = _rtrOmega * _bladeRadius;
private _rtrArea                   = PI * _bladeRadius^2;
private _thrustCoef                = if (_rtrOmega == 0) then { 0.0; } else { _rtrThrust / (_dryAirDensity * _rtrArea * _rtrOmega^2 * _bladeRadius^2); };
//Induced power is the power required to overcome the drag developed during the creation of thrust
private _inducedPowerScalarTable   =  [[ 0.00, 1.000]     //0 ktas
                                      ,[15.43, 0.793]     //30 ktas
                                      ,[30.87, 0.620]     //60 ktas
                                      ,[38.58, 0.575]     //75 ktas
                                      ,[46.30, 0.568]     //90 ktas
                                      ,[51.44, 0.561]     //100 ktas
                                      ,[61.73, 0.554]     //120 ktas
                                      ,[72.02, 0.547]     //140 ktas
                                      ,[77.17, 0.540]];   //150 ktas
private _inducedPowerScalar        = [_inducedPowerScalarTable, _velXY] call fza_fnc_linearInterp; 
private _inducedPowerCoef          = (_inducedPowerScalar # 1) * ((1.15 * _thrustCoef^(3/2)) / (SQRT 2));
//Profile power is the power required to matiain a given rotor RPM when the collective is at it's minimum setting and to overcome the drag produced by ancillary equipment
private _rtrSolidity               = (_rtrNumBlades * _bladeChord) / (PI * _bladeRadius);
private _profilePowerCoef          = (_rtrSolidity * _bladeDragCoef) / 8;
private _powerCoef                 = _inducedPowerCoef + _profilePowerCoef;
private _rtrPowerReq               = if (_rtrOmega == 0) then { 0.0; } else { (_powerCoef * _dryAirDensity * _rtrArea * _rtrOmega^3 * _bladeRadius^3) * 1.115; };
private _rtrTorque                 = if (_rtrOmega == 0) then { 0.0; } else { _rtrPowerReq / _rtrOmega; };
private _engTorque                 = _rtrTorque / _rtrGearRatio;

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

[_heli, _rtrPos, _rtrPos vectorAdd _axisX, _colorRed]   call DRAW_LINE;
[_heli, _rtrPos, _rtrPos vectorAdd _axisY, _colorGreen] call DRAW_LINE;
[_heli, _rtrPos, _rtrPos vectorAdd _axisZ, _colorBlue]  call DRAW_LINE;

//private _thrustX = _axisX vectorMultiply (_thrustX * _deltaTime);
//private _thrustY = _axisY vectorMultiply (_thrustY * _deltaTime);
private _thrustZ = _axisZ vectorMultiply (_rtrThrust * _deltaTime);

_heli addForce[_heli vectorModelToWorld _thrustZ, _rtrPos];

hintsilent format ["Rotor Omega = %1
                    \nBlade Tip Vel = %2
                    \nRotor Power Req = %3 W
                    \nEngine Torque = %4 Nm 
                    \nE1 = %5 % E2 = %6 %
                    \nVelZ = %7
                    \nInduced Vel Scalar = %8", _rtrOmega, _bladeTipVel, _rtrPowerReq * 0.001, _engTorque, (_engTorque / 2) / 481, (_engTorque / 2) / 481, _velZ, _inducedVelocityScalar];