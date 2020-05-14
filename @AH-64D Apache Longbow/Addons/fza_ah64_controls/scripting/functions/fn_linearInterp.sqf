params ["_arr", "_key"];

private _upperIndex = this findIf {_x > _key}; //Find the index of the value above key

if (_upperIndex == 0) exitWith {_arr select 0;}; //If it is below the values that can be interpolated

if (_upperIndex == -1) exitWith {_arr select (count _arr - 1);}; //If it is below the values that can be interpolated



private _lowerIndex = _upperIndex - 1;

private _lowerRow = (_arr select _lowerIndex);
private _upperRow = (_arr select _upperIndex);

private _lerp = {
	params ["_lowKey", "_highKey", "_lowVal", "_highVal", "_intendedKey"];
	_lowVal + (_highVal - _lowVal)/(_highKey - _lowKey)*(_intendedKey - _lowKey);
};

_out = [];
{
	_out pushBack ([_lowerRow select 0, _upperRow select 0, _x, _upperRow select _forEachIndex, _key] call _lerp);
} forEach (_lowerRow);
_out;