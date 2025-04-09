private _wpnMass               = 10.1;      //kg
private _wpnDiameter           = 0.07;      //m
private _wpnDragCoef           = 0.757;
private _wpnMuzzleVelocity     = 700;       //m/s
private _wpnElevMin            = -15.0;     //deg
private _wpnElevMax            = 4.0;       //deg

private _platformVelocity      = 90;        //knots
private _platformAltitude      = 50;        //ft
private _platformPitchAngle    = 0.0;       //deg
private _platformRangeToTarget = 5000.0;    //m

private _elevation = [ _platformPitchAngle
                     , _platformVelocity
                     , _platformAltitude
                     , _platformRangeToTarget
                     , _wpnElevMin
                     , _wpnElevMax
                     , _wpnMuzzleVelocity
                     , _wpnDragCoef
                     , _wpnDiameter
                     , _wpnMass] call fza_weapons_fnc_calculateElevationAngle;

private _azimuth   = 0.0;

systemChat format ["_elevation = %1", _elevation];

[_elevation, _azimuth];