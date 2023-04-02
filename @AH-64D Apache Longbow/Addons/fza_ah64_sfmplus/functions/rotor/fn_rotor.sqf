params ["_heli", "_deltaTime", "_altitude", "_temperature"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _rotorPos            = [0.0, 2.06, 0.70];

private _bladePitch_min      = 1.0;     //deg
private _bladePitch_max      = 19.0;    //deg

private _rtrRPM_max          = 1.01;
private _rtrThrustScalar_min = 0.12;
private _rtrThrustScalar_max = 1.45;

private _altitude_max        = 30000;   //ft
private _baseThrust          = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * fza_sfmplus_collectiveOutput;
private _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _bladePitch_cur;
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _rtrRPM                        = _eng1PctNP max _eng2PctNp;
private _rtrRPMInducedThrustScalar     = (_rtrRPM / _rtrRPM_max) * _rtrThrustScalar_max;
private _airDensityThrustScalar        = 1 - ((1 / _altitude_max) * _altitude);

private _rtrThrustScalar               = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar;

private _thrustX = 0;
private _thrustY = 0;
private _thrustZ                       = _baseThrust * _rtrThrustScalar;

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

[_heli, _rotorPos, _rotorPos vectorAdd _axisX, _colorRed]   call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisY, _colorGreen] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisZ, _colorBlue]  call DRAW_LINE;

_thrustX = _axisX vectorMultiply (_thrustX * _deltaTime);
_thrustY = _axisY vectorMultiply (_thrustY * _deltaTime);
_thrustZ = _axisZ vectorMultiply (_thrustZ * _deltaTime);

_heli addForce[_heli vectorModelToWorld _thrustZ, _rotorPos];

systemChat format ["v0.1 Rotor Thrust Scalar = %1", _rtrThrustScalar];