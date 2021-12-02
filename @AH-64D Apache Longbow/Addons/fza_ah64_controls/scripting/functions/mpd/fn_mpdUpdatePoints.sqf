/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdUpdatePoints

Description:
	Draws the points inputted on the right hand MPD, performing all necessary positioning

Parameters:
	_heli - The helicopter to draw this on (the player must be in it)
	_points - the points to draw on the screen. An array with arrays in it that fit the following schema
	    [_pos, _tex, _priority]
		where:
		    _pos is the position of the item as a 2d or 3d array, or an object (where the object's position will be used)
			_tex is the texture to use to represent the point
			_priority is (between 0 and 1) if two points overlap, the one with the larger number will be on top
	_clipToScreen - If a point goes off screen, should it be removed or drawn.
	_scale - (optional) Ratio to apply to scale from the world's size to the MPD size. Defaults to *fza_ah64_rangesetting x 0.75*
	_center - (optional) Where in the screen should be where the "helicopter" should be. Defaults to [0.5, 0.25]

Returns:
	Nothing

Examples:

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_points", "_clipToScreen", ["_scale", -1], ["_center", [0.5, 0.25]]];
#include "\fza_ah64_controls\headers\selections.h"

if (_scale == -1) then {
	_scale = (_heli getVariable "fza_ah64_rangesetting") * 0.75;
};

#define MPD_X_MIN 0.1
#define MPD_X_MAX 0.9
#define MPD_Y_MIN 0.1
#define MPD_Y_MAX 0.9

// Calculate the position of all points
_points = _points apply {
	_x params ["_pos", "_tex", "_priority"];
	if(typeName _pos == "OBJECT") then {
		_pos = getPos _pos;
	};
	private _theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (_pos select 0), (_pos select 1)] call fza_fnc_relativeDirection;
	if (_theta >= 180) then {
		_theta = _theta - 360;
	};

	private _targxpos = [(sin _theta) * ((_heli distance2D _pos) * _scale) + _center # 0, MPD_X_MIN, MPD_X_MAX] call BIS_fnc_clamp;
	private _targypos = [(cos _theta) * ((_heli distance2D _pos) * _scale) + _center # 1, MPD_Y_MIN, MPD_Y_MAX] call BIS_fnc_clamp;

	[[_targxpos, _targypos], _tex, _priority, _pos];
};

if !(_clipToScreen) then {
	_points = _points select {
		(_x # 0) params ["_tx", "_ty"];
		(MPD_X_MIN < _tx && _tx < MPD_X_MAX && MPD_Y_MIN < _ty && _ty < MPD_Y_MAX);
	};
};

// If there are more points to draw then selections available, render the closest ones to the helicopter.
if (count _points > 32) then {
	_points = [_points, [_heli], {_input0 distance2D (_x # 3)}, "ASCEND"] call BIS_fnc_sortBy;
	_points resize 32;
};


private _initial = if (player == driver _heli) then {SEL_MPD_PL_OBJ1} else {SEL_MPD_GR_OBJ1};

// Clear all unused selections
for "_i" from 0 to 31 do {
	_heli setObjectTexture [_i + _initial, ""];
};

// Draw all used selections
{
	_x params ["_pos", "_tex", "_priority"];

	_heli setObjectTexture [_forEachIndex + _initial, _tex];
	if (player == driver _heli) then {
		_heli animateSource[format ["mpd_pl_obj%1_h", _forEachIndex + 1], _pos # 0];
		_heli animateSource[format ["mpd_pl_obj%1_v", _forEachIndex + 1], _pos # 1];
		_heli animateSource[format ["mpd_pl_obj%1_z", _forEachIndex + 1], _priority];
	};
	if (player == gunner _heli) then {
		_heli animateSource[format ["mpd_gr_obj%1_h", _forEachIndex + 1], _pos # 0];
		_heli animateSource[format ["mpd_gr_obj%1_v", _forEachIndex + 1], _pos # 1];
		_heli animateSource[format ["mpd_gr_obj%1_z", _forEachIndex + 1], _priority];
	};
} forEach (_points);
