params ["_platformPitchAngle", "_platformVelocity", "_platformAltitude", "_wpnElevationAngle", "_wpnMuzzleVelocity", "_wpnDragCoef", "_wpnDiameter", "_wpnMass"];

private _radius   = _wpnDiameter / 2.0;
private _area     = PI * (_radius * _radius);

private _effLaunchAngle = _platformPitchAngle + _wpnElevationAngle;

private _velX     = _platformVelocity + (_wpnMuzzleVelocity * (cos _effLaunchAngle));
private _velY     = _wpnMuzzleVelocity * (sin _effLaunchAngle);

private _posY  = _platformAltitude; 
private _posX  = 0.0;

private _timeStep = 0.01;//<--make this a define in config...

while { _posY >= 0.0 } do {
    private _velMagnitude = sqrt (_velX * _velX + _velY * _velY);

    private _drag   = [_velMagnitude, _wpnDragCoef, _area] call fza_weapons_fnc_calculateDrag;

    private _accelX = - _drag * _velX / (_wpnMass * _velMagnitude);
    private _accelY = -g - (_drag * _velY / (_wpnMass * _velMagnitude));

    _velX = _velX + _accelX * _timeStep;
    _velY = _velY + _accelY * _timeStep;

    _posX = _posX + _velX * _timeStep;
    _posY = _posY + _velY * _timeStep;
};

_posX;