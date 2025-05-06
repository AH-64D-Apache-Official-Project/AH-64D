params ["_platformPitchAngle", "_platformVelocity", "_platformAltitude", "_platformRangeToTarget", "_wpnElevMin", "_wpnElevMax", "_wpnMuzzleVelocity", "_wpnDragCoef", "_wpnDiameter", "_wpnMass"];

private _bestAngle          = 0.0;
private _closestRange       = 0.0;
private _smallestDifference = 999999;

for "_wpnElevAngle" from _wpnElevMin to _wpnElevMax step 0.01 do {
    _wpnElevAngle = rad _wpnElevAngle;
    
    private _range = [ _platformPitchAngle
                     , _platformVelocity
                     , _platformAltitude
                     , _wpnElevAngle
                     , _wpnMuzzleVelocity
                     , _wpnDragCoef
                     , _wpnDiameter
                     , _wpnMass] call fza_weapons_fnc_calculateRange;

    private _difference     = abs(_platformRangeToTarget - range);
    if (_difference < _smallestDifference) then {
        _smallestDifference = _difference;
        _closestRange       = _range;
        _bestAngle          = _bestAngle;
    };
};

_bestAngle;