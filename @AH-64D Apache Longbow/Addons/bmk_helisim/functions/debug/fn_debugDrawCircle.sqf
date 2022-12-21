/* ----------------------------------------------------------------------------
Function: bmk_debugDrawCircle

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params["_heli", "_numSides", "_rtrPos", "_radius", "_axis", "_color"];

for "_i" from 1 to _numSides do {
	private _incr = 360 / _numSides;
	private _a = 0;
	private _b = 0;

  switch (_axis) do {
    //X-axis
    case 0: {
      _a = _rtrPos vectorAdd [0.0, _radius * sin (_incr * _i), _radius * cos (_incr * _i)];
      _b = _rtrPos vectorAdd [0.0, _radius * sin (_incr * (_i + 1)), _radius * cos (_incr * (_i + 1))];
      [_heli, _a, _b, _color] call bmk_helisim_fnc_debugDrawLine;
    };
    //Yz-axis
    case 1: {
      _a = _rtrPos vectorAdd [_radius * sin (_incr * _i), 0.0, _radius * cos (_incr * _i)];
		  _b = _rtrPos vectorAdd [_radius * sin (_incr * (_i + 1)), 0.0 , _radius * cos (_incr * (_i + 1))];
      [_heli, _a, _b, _color] call bmk_helisim_fnc_debugDrawLine;
    };
    //Zy-axis
    case 2: {
      _a = _rtrPos vectorAdd [_radius * cos (_incr * _i), _radius * sin (_incr * _i), 0.0];
      _b = _rtrPos vectorAdd [_radius * cos (_incr * (_i + 1)), _radius * sin (_incr * (_i + 1)), 0.0];
      [_heli, _a, _b, _color] call bmk_helisim_fnc_debugDrawLine;
    };
  };
};