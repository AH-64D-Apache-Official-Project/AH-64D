/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdUpdatePoints

Description:
	Draws the points inputted on the right hand MPD, performing all necessary positioning

Parameters:
	_heli - The helicopter to draw this on (the player must be in it)
	_points - the points to draw on the screen. An array with arrays in it that fit the following schema
	    [_pos, _tex, _priority]
		where:
		    _pos - the position of the item as a 2d or 3d array, or an object (where the object's position will be used)
			_tex - the texture to use to represent the point
			_priority - (between 0 and 1) if two points overlap, the one with the larger number will be on top
	_clipToScreen - If a point goes off screen, should it be removed or drawn.

Returns:
	Nothing

Examples:

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_points", "_clipToScreen"];
#include "\fza_ah64_controls\headers\selections.h"

#define MPD_X_MIN 0.1
#define MPD_X_MAX 0.9
#define MPD_Y_MIN 0.1
#define MPD_Y_MAX 0.9

#define ANIMATION_OBJECT(_num, _dim) (format ["mpd_%1_obj%2_%3", _seat, _num, _dim])

private _seat = if (player == driver _heli) then {"pr"} else {"gr"};

// Calculate the position of all points
_points = _points apply {
	_x params ["_pos", "_tex", "_priority"];
	if(typeName _pos == "OBJECT") then {
		_pos = getPos _pos;
	};
	private _theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (_pos select 0), (_pos select 1)] call fza_ah64_reldir;
	if (_theta >= 180) then {
		_theta = _theta - 360;
	};

	private _targxpos = [((sin _theta) * (((_heli distance2D _pos) * fza_ah64_rangesetting) * 0.75)) + 0.5, MPD_X_MIN, MPD_X_MAX] call BIS_fnc_clamp;
	private _targypos = [((cos _theta) * (((_heli distance2D _pos) * fza_ah64_rangesetting) * 0.75)) + 0.25, MPD_Y_MIN, MPD_Y_MAX] call BIS_fnc_clamp;

	[[_targxpos, _targypos], _tex, _priority, _pos];
};

if !(_clipToScreen) then {
	_points = _points select {
		(_x # 0) params ["_tx", "_ty"];
		(MPD_X_MIN < _tx && _tx < MPD_X_MAX && MPD_Y_MIN < _ty && ty < MPD_Y_MAX);
	};
};

// If there are more points to draw then selections available, render the closest ones to the helicopter.
if (count _points > 31) then {
	_points = [_points, [_heli], {_input0 distance2D (_x # 3)}, "ASCEND"] call BIS_fnc_sortBy;
	_points resize 31;
};

// Draw the helicopter's range
_heli setobjecttexture [SEL_MPD_PL_OBJ1, "\fza_ah64_US\tex\mpd\ownship_ca.paa"];
_heli setobjecttexture [SEL_MPD_GR_OBJ1, "\fza_ah64_US\tex\mpd\ownship_ca.paa"];

_heli animate[ANIMATION_OBJECT(1,"v"),0.25];
_heli animate[ANIMATION_OBJECT(1,"h"),0.5];
_heli animate[ANIMATION_OBJECT(1,"z"),0.005];

private _initial = if (player == driver _heli) then {SEL_MPD_PL_OBJ2} else {SEL_MPD_GR_OBJ2};

// Draw all used selections
{
	_x params ["_pos", "_tex", "_priority"];
	_heli setObjectTexture [_forEachIndex + _initial, _tex];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"v"),pos # 0];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"h"),pos # 1];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"z"),_priority];
} forEach (_points);


// Clear all unused selections
for "_i" from (count _points) to 30 do {
	_heli setObjectTexture [_i + _initial, ""];
};