/* ----------------------------------------------------------------------------
Function: fza_fnc_debugDrawCircle

Description:

Parameters:
  _heli - The apache helicopter to get information from [Unit].

Returns:

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params["_heli", "_numSides", "_pos", "_radius", "_axis", "_col"];

for "_i" from 1 to _numSides do {
  private _incr = 360 / _numSides;
  private _a = 0;
  private _b = 0;

  switch (_axis) do {
    //X-axis
    case 0: {
      _a = _pos vectorAdd [0.0, _radius * sin (_incr * _i), _radius * cos (_incr * _i)];
      _b = _pos vectorAdd [0.0, _radius * sin (_incr * (_i + 1)), _radius * cos (_incr * (_i + 1))];
      [_heli, _a, _b, _col] call fza_fnc_debugDrawLine;
    };
    //Yz-axis
    case 1: {
      _a = _pos vectorAdd [_radius * sin (_incr * _i), 0.0, _radius * cos (_incr * _i)];
      _b = _pos vectorAdd [_radius * sin (_incr * (_i + 1)), 0.0 , _radius * cos (_incr * (_i + 1))];
      [_heli, _a, _b, _col] call fza_fnc_debugDrawLine;
    };
    //Zy-axis
    case 2: {
      _a = _pos vectorAdd [_radius * cos (_incr * _i), _radius * sin (_incr * _i), 0.0];
      _b = _pos vectorAdd [_radius * cos (_incr * (_i + 1)), _radius * sin (_incr * (_i + 1)), 0.0];
      [_heli, _a, _b, _col] call fza_fnc_debugDrawLine;
    };
  };
};