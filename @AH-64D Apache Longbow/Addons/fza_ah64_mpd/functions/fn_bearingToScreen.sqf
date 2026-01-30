params ["_ctrX", "_ctrY", "_minX", "_maxX", "_minY", "_maxY", "_bearing"];

private _dirVecX = sin _bearing;
private _maxDstX = 0.0;
private _maxMagX = 0.0;
if (_dirVecX == 0) then { 
    _maxDstX = 1000;
    _maxMagX = 1000;
} else {
    if (_dirVecX < 0) then {
        _maxDstX = _minX - _ctrX;
    } else {
        _maxDstX = _maxX - _ctrX;
    };
    _maxMagX = _maxDstX / _dirVecX;
};

private _dirVecY = -cos _bearing;
private _maxDstY = 0.0;
private _maxMagY = 0.0;
if (_dirVecY == 0) then { 
    _maxDstY = 1000;
    _maxMagY = 1000;
} else {
    if (_dirVecY < 0) then {
        _maxDstY = _minY - _ctrY;
    } else {
        _maxDstY = _maxY - _ctrY;
    };
    _maxMagY = _maxDstY / _dirVecY;
};

private _magnitude = _maxMagX min _maxMagY;
private _screenX   = _ctrX + sin _bearing * _magnitude;
private _screenY   = _ctrY - cos _bearing * _magnitude;

[_screenX, _screenY];