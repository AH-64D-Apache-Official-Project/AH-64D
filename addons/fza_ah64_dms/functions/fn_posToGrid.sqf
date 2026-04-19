params ["_pos", ["_numDigits", 8]];

private _numDigitsPerAxis = _numDigits / 2;

private _converter = "0123456789";

(_pos call BIS_fnc_position) params ["_posx", "_posy"];

private _cfgGrid = configFile >> "CfgWorlds" >> worldName >> "Grid";
private _offsetX = getNumber (_cfgGrid >> "offsetX");
private _offsetY = getNumber (_cfgGrid >> "offsetY");
private _zoomMax = 1e99;
private _format = "";
private _formatX = "";
private _formatY = "";
private _stepX = 1e10;
private _stepY = 1e10;
{
	_zoom = getNumber (_x >> "zoomMax");
	if (_zoom < _zoomMax) then {
		_zoomMax = _zoom;
		_format = getText (_x >> "format");
		_formatX = getText (_x >> "formatX");
		_formatY = getText (_x >> "formatY");
		_stepX = getNumber (_x >> "stepX");
		_stepY = getNumber (_x >> "stepY");
	};
} forEach configProperties [_cfgGrid,"isclass _x",false];
if (_stepY > 0) then {_offsetY = _offsetY + _stepY;};

private _convertAxis = {
    private _digitSize = 10000;
    private _ret = "";
    for "_i" from 0 to (_numDigitsPerAxis-1) do {
        private _index = floor ((_this % (_digitSize * 10)) / _digitSize);
        _ret = _ret + (_converter select [_index,1]);
        _digitSize = _digitSize / 10;
    };
    _ret;
};

private _mapSize = worldName call BIS_fnc_mapSize;
private _gridX = _posx - _offsetX;
private _gridY = _offsetY + _posY - _mapSize;

(_gridX call _convertAxis) + (_gridY call _convertAxis)
