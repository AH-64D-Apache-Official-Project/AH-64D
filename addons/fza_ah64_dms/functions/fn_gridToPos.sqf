private _grid = _this;
// Check grid is a valid format
if !(_grid regexMatch "^(\d{2})+$") exitWith {-1};

// Get world information
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

private _converter = "0123456789";

private _convertAxis = {
    private _digitSize = 10000;
    private _pos = 0;
    for "_i" from 0 to (count _this-1) do {
        private _char = _this select [_i,1];
        private _digit = _converter find _char;
        _pos = _pos + _digitSize * _digit;
        _digitSize = _digitSize / 10;
    };
    _pos;
};

private _gridDigits = count _grid;
private _axisDigits = _gridDigits / 2;
private _gridX = (_grid select [0, _axisDigits]) call _convertAxis;
private _gridY = (_grid select [_axisDigits, _axisDigits]) call _convertAxis;

private _mapSize = worldName call BIS_fnc_mapSize;
private _posX = _gridX + _offsetX;
private _posY = _mapSize - _offsetY + _gridY;

[_posX, _posY]
