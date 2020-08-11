params ["_heli", "_points", "_clipToScreen"];
#include "\fza_ah64_controls\headers\selections.h"

#define MPD_X_MIN 0.1
#define MPD_X_MAX 0.9
#define MPD_Y_MIN 0.1
#define MPD_Y_MAX 0.9

#define ANIMATION_OBJECT(_num, _dim) (format ["mpd_%1_obj%2_%3", _seat, _num, _dim])

private _seat = if (player == driver _heli) then {"pr"} else {"gr"};

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

	[[_targxpos, _targypos], _tex, _priority];
};

if !(_clipToScreen) then {
	_points = _points select {
		(_x # 0) params ["_tx", "_ty"];
		(MPD_X_MIN < _tx && _tx < MPD_X_MAX && MPD_Y_MIN < _ty && ty < MPD_Y_MAX);
	};
};

if (count _points > 31) then {
	_points = [_points, _heli, {_this distance2D (_x # 0)}, "ASCEND"] call BIS_fnc_sortBy;
	_points resize 31;
};

_heli setobjecttexture [SEL_MPD_PL_OBJ1, "\fza_ah64_US\tex\mpd\ownship_ca.paa"];
_heli setobjecttexture [SEL_MPD_GR_OBJ1, "\fza_ah64_US\tex\mpd\ownship_ca.paa"];

_heli animate[ANIMATION_OBJECT(1,"v"),0.25];
_heli animate[ANIMATION_OBJECT(1,"h"),0.5];
_heli animate[ANIMATION_OBJECT(1,"z"),0.005];

private _initial = if (player == driver _heli) then {SEL_MPD_PL_OBJ2} else {SEL_MPD_GR_OBJ2};

{
	_x params ["_pos", "_tex", "_priority"];
	_heli setObjectTexture [_forEachIndex + _initial, _tex];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"v"),pos # 0];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"h"),pos # 1];
	_heli animate[ANIMATION_OBJECT(_forEachIndex+2,"z"),_priority];
} forEach (_points);

for "_i" from (count _points + 1) to 32 do {
	_heli setObjectTexture [_i + _initial, ""];
};