params ["_pos", ["_numDigits", 8]];

private _numDigitsPerAxis = _numDigits / 2;

private _converter = "0123456789";

(_pos call BIS_fnc_position) params ["_posx", "_posy"];

private _cfgGrid = configfile >> "CfgWorlds" >> worldname >> "Grid";
private _offsetX = getnumber (_cfgGrid >> "offsetX");
private _offsetY = getnumber (_cfgGrid >> "offsetY");
private _zoomMax = 1e99;
private _format = "";
private _formatX = "";
private _formatY = "";
private _stepX = 1e10;
private _stepY = 1e10;
{
	_zoom = getnumber (_x >> "zoomMax");
	if (_zoom < _zoomMax) then {
		_zoomMax = _zoom;
		_format = gettext (_x >> "format");
		_formatX = gettext (_x >> "formatX");
		_formatY = gettext (_x >> "formatY");
		_stepX = getnumber (_x >> "stepX");
		_stepY = getnumber (_x >> "stepY");
	};
} foreach configproperties [_cfgGrid,"isclass _x",false];
if (_stepY > 0) then {_offsetY = _offsetY + _stepY;};

private _convertAxis = {
    private _digitSize = 10000;
    private _ret = "";
    for "_i" from 0 to (_numDigitsPerAxis-1) do {
        private _index = floor ((_this % (_digitSize * 10)) / _digitSize);
        _ret = _ret + (_converter select [_index,1]);
        _digitSize = _digitSize / 10;
		systemChat format ["_this %1 _index %2 _i %3 _ret %4", _this, _index, _i, _ret];
    };
    _ret;
};

private _mapSize = worldName call BIS_fnc_mapSize;
private _gridX = _posx - _offsetX;
private _gridY = _offsetY + _posY - _mapSize;

systemChat format ["Grid X %1 Y %2", (_gridX call _convertAxis),  (_gridY call _convertAxis)];
(_gridX call _convertAxis) + (_gridY call _convertAxis)