/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotor

Description:
	Simple rotor provides a simple, grounded in reality simulation of a
    helicopters rotor. Translational Lift, Ground Effect and Vortex Ring State
    are all simulated.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime", "_altitude", "_temperature", "_dryAirDensity"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _rtrPos              = [0.0, 2.06, 0.70];
private _rtrHeightAGL        = 3.606;   //m
private _rtrDesignRPM        = 289.0;
private _rtrRPMTrimVal       = 1.01;
private _rtrGearRatio        = 72.29;
private _rtrNumBlades        = 4;

private _bladeRadius         = 7.315;   //m
private _bladeChord          = 0.533;   //m
private _bladeDragCoef_min   = 0.0066;
private _bladeDragCoef_max   = 0.0286;
private _bladePitch_min      = 1.0;     //deg
private _bladePitch_max      = 19.0;    //deg

private _rtrPowerScalar      = 1.770;
private _rtrGndEffModifier   = 0.235;
private _rtrThrustScalar_min = 0.120;
private _rtrThrustScalar_max = 1.232; //20,260lbs @ 5200ft and 80% collective

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
private _airspeedVelocityScalar    = (1 + (_velXY / 36.0111)) ^ (1 / 2.50);
//Induced flow handler
private _velZ                      = velocityModelSpace _heli # 2;
private _inducedVelocityScalar     = 1.0;
if (_velZ < -24.384 && _velXY < 12.35) then { 
    _inducedVelocityScalar = 0.0;
} else { 
    _inducedVelocityScalar = 1 - (_velZ / 24.384);
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar           = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust                 = _baseThrust * _rtrThrustScalar;

private _rtrOmega                  = (2.0 * PI) * ((_rtrDesignRPM * _inputRPM) / 60);
private _bladeTipVel               = _rtrOmega * _bladeRadius;
private _rtrArea                   = PI * _bladeRadius^2;
private _thrustCoef                = if (_rtrOmega == 0) then { 0.0; } else { _rtrThrust / (_dryAirDensity * _rtrArea * _rtrOmega^2 * _bladeRadius^2); };
_thrustCoef                        = if (_inducedVelocityScalar == 0.0) then { 0.0; } else { _thrustCoef / _inducedVelocityScalar; };

//Calculate the hover induced velocity
private _rtrInducedVelocity        = sqrt(_rtrThrust / (2 * _dryAirDensity * _rtrArea));
//Gather the velocities required to determine the actual induced flow velocity using the newton-raphson method
private _w = _rtrInducedVelocity;
private _u = if (_w == 0) then { 0.0; } else { _velXY / _rtrInducedVelocity; };
private _n = if (_w == 0) then { 0.0; } else { _velZ  / _rtrInducedVelocity; };
private _rtrCorrInducedVelocity    = if (_w == 0) then { 0.0; } else { [_w, _u, _n] call fza_sfmplus_fnc_simpleRotorNewtRaphSolver; };
_rtrCorrInducedVelocity            = _rtrCorrInducedVelocity * _rtrInducedVelocity;
//Calculate the required rotor power
private _rtrPowerReq               = (_rtrThrust * _velZ + _rtrThrust * _rtrCorrInducedVelocity) * _rtrPowerScalar;
//Calculate the required rotor torque
private _rtrTorque                 = if (_rtrOmega == 0) then { 0.0; } else { _rtrPowerReq / _rtrOmega; };
//Calcualte the required engine torque
private _reqEngTorque              = _rtrTorque / _rtrGearRatio;
_heli setVariable ["fza_sfmplus_reqEngTorque", _reqEngTorque];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

[_heli, _rtrPos, _rtrPos vectorAdd _axisX, _colorRed]   call DRAW_LINE;
[_heli, _rtrPos, _rtrPos vectorAdd _axisY, _colorGreen] call DRAW_LINE;
[_heli, _rtrPos, _rtrPos vectorAdd _axisZ, _colorBlue]  call DRAW_LINE;

//Ground Effect
private _heightAGL    = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam      = _bladeRadius * 2;
private _gndEffScalar = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffModifier;
_gndEffScalar = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust = _rtrThrust * _gndEffScalar;

systemChat format ["Collective = %1", fza_sfmplus_collectiveOutput];
systemChat format ["Height AGL = %1 -- Gnd Eff Scalar = %2", _heightAGL, _gndEffScalar];

private _thrustZ   = _axisZ vectorMultiply ((_rtrThrust + _gndEffThrust) * _deltaTime);

_heli addForce[_heli vectorModelToWorld _thrustZ, _rtrPos];

//Camera shake effect for ETL
if (_velXY > 8.23 && _velXY < 12.35) then {
    enableCamShake true;
    setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
    addCamShake       [2.5, 1, 5];
    enableCamShake false;
};

//Camera shake effect for vortex ring sate
if (_velXY < 12.35) then {  //must be less than ETL
    //2000 fpm to 2933fpm
    if (_velZ < -10.16 && _velZ > -14.89) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
        addCamShake       [2.5, 1, 5];
        enableCamShake false;
    };
    //2933 fpm to 3867 
    if (_velZ <= -14.89 && _velZ > -19.64) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.5, true];
        addCamShake       [3, 1, 5.5];
        enableCamShake false;
    };
    //3867fpm to 4800 fpm
    if (_velZ <= -19.64 && _velZ > -24.384) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.75, 0.0, 0.75, true];
        addCamShake       [3.5, 1, 6.0];
        enableCamShake false;
    };
    //> 4800fpm
    if (_velZ < -24.384) then {
        enableCamShake true;
        setCamShakeParams [0.0, 1.0, 0.0, 2.0, true];
        addCamShake       [4.0, 1, 6.5];
        enableCamShake false;
    };
};

/*
hintsilent format ["v0.7 testing
                    \nRotor Omega = %1
                    \nBlade Tip Vel = %2
                    \nRotor Power Req = %3 kW
                    \nRotor Torque = %4 Nm 
                    \nE1 Tq = %5 % E2 Tq = %6 %
                    \nVelZ = %7
                    \nInduced Vel Scalar = %8
                    \nGnd Eff Scalar = %9
                    \nStab = %10
                    \nPitch = %11", _rtrOmega, _bladeTipVel, _rtrPowerReq * 0.001, _reqEngTorque, (_reqEngTorque / 2) / 481, (_reqEngTorque / 2) / 481, _velZ, _inducedVelocityScalar, _gndEffScalar, fza_sfmplus_collectiveOutput, _heli call BIS_fnc_getPitchBank select 0];
                    */