/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_debugDrawCircle

Description:

Parameters:
  _heli - The apache helicopter to get information from [Unit].

Returns:

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params["_heli", "_numSides", "_pos", "_radius", "_rot", "_col"];

for "_i" from 1 to _numSides do {
    private _incr = 360 / _numSides;
    private _a = 0;
    private _b = 0;

    _a = [[_radius * cos (_incr * _i), _radius * sin (_incr * _i), 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
    _a = _a vectorAdd _pos;

    _b = [[ _radius * cos (_incr * (_i + 1)), _radius * sin (_incr * (_i + 1)), 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
    _b = _b vectorAdd _pos;
    
    [_heli, _a, _b, _col] call fza_sfmplus_fnc_debugDrawLine;

};