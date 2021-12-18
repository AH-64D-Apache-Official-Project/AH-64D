/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_drawIcons

Description:
	Draws the points inputted on the right hand MPD, performing all necessary positioning

Parameters:
	_heli - The helicopter to draw this on (the player must be in it)
	_points - the points to draw on the screen. An array with arrays in it that fit the following schema
	    [_posMode, _pos, _tex, _color, _textMode, _text1, _text2]
		where:
		    _posMode is how to read the position, either MPD_POSMODE_WORLD or MPD_POSMODE_SCREEN
			_pos is 2d position of the point, in the aforementioned mode
			_tex is the texture to apply to the centre of the point
			_color is the color to apply (MPD_ICON_COLOR_GREEN .. MPD_ICON_COLOR_YELLOW)
			_textMode is the text mode (MPD_ICON_TYPE_A .. G)
			_text1 is the first part of text
			_text2 is the second part of text, where applicable
	_display - true if right, false if left
	_scale - (optional) Ratio to apply to scale from the world's size to the MPD size. Defaults to *fza_ah64_rangesetting x 0.75*
	_center - (optional) Where in the screen should be where the "helicopter" should be when converting from world. Defaults to [0.5, 0.25]

Returns:
	Nothing

Examples:

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_points", "_display", ["_scale", -1], ["_center", [0.5, 0.25]]];
#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_mpd\headers\points.hpp"

private _validChars = createHashmapFromArray [
	["0", "\fza_ah64_us\tex\char\Y0_ca.paa"],
	["1", "\fza_ah64_us\tex\char\Y1_ca.paa"],
	["2", "\fza_ah64_us\tex\char\Y2_ca.paa"],
	["3", "\fza_ah64_us\tex\char\Y3_ca.paa"],
	["4", "\fza_ah64_us\tex\char\Y4_ca.paa"],
	["5", "\fza_ah64_us\tex\char\Y5_ca.paa"],
	["6", "\fza_ah64_us\tex\char\Y6_ca.paa"],
	["7", "\fza_ah64_us\tex\char\Y7_ca.paa"],
	["0", "\fza_ah64_us\tex\char\Y0_ca.paa"],
	["9", "\fza_ah64_us\tex\char\Y9_ca.paa"]
];

if (_scale == -1) then {
	_scale = (_heli getVariable "fza_ah64_rangesetting") * 0.75;
};

#define MPD_X_MIN 0.1
#define MPD_X_MAX 0.9
#define MPD_Y_MIN 0.1
#define MPD_Y_MAX 0.9

private _pointsWithPos = _points apply {
	private _theta = (_heli getDir _pos) - (direction _heli);

	private _pos = _x # 1;
	if (_x # 0) then {
		private _targxpos = (sin _theta) * ((_heli distance2D _pos) * _scale) + _center # 0;
		private _targypos = (cos _theta) * ((_heli distance2D _pos) * _scale) + _center # 1;
		_pos = [_targxpos, _targypos];
	};

	[_pos, _x];
};

private _filter = {
	(_x # 0) params ["_tx", "_ty"];
	(MPD_X_MIN < _tx && _tx < MPD_X_MAX && MPD_Y_MIN < _ty && _ty < MPD_Y_MAX);
};

systemChat format ["Presort: %1", _pointsWithPos];

_pointsWithPos = [_pointsWithPos, [_heli], {_heli distance2D _x # 0}, "ASCEND", _filter] call BIS_fnc_sortBy;

systemChat format ["Postsort: %1", _pointsWithPos];

#define SETTEXTURE(_ind, _tex) _heli setObjectTexture [_ind, _tex]
#define SETICONTEXTURE(_ind, _tex) SETTEXTURE(_ind + _offset, _tex)

private _prefix = [["pl", "pr"] select _display, ["cl", "cr"] select _display] select (gunner _heli == player);

private _writeText = {
	params ["_heli", "_offset", "_inds", "_text", "_rightJustified"];
	private _textLen = count _text;
	if (_rightJustified) then {
		_text = reverse _text;
		reverse _inds;
	};

	systemChat format ["WriteText %1", _inds];
	{
		systemChat format ["WriteText1 %1", _this];
		if (_forEachIndex >= _textLen) then {
			SETICONTEXTURE(_x, "");
			continue;
		};
		private _char = _text select [_forEachIndex,1];
		systemChat format ["Writing string %1 i=%2 ind=%3 c=%4 tex=%5 o=%6",_text, _i, _x, _char, str(_validChars getOrDefault [_char, ""]), _offset];
		private _tex = _validChars getOrDefault [_char, ""];
		SETICONTEXTURE(_x, _tex);
	} forEach _inds;
};

private _displayOffset = [0, 512] select _display;

for "_i" from 0 to 31 do {
	private _offset = (_i * 16) + _displayOffset;
	if (_i >= count _pointsWithPos) then {
		//Wipe all textures
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_ICON, "");
		continue;
	};
	private _pos = _pointsWithPos # _i # 0;
	_pointsWithPos # _i # 1 params ["","", "_tex", "_color", "_textMode", "_text1", "_text2"];
	systemChat format ["Setting: %1", _pointsWithPos # _i];
	// Set point texture
	SETICONTEXTURE(SEL_MPD_OBJ1_ICON, _tex);

	systemChat format ["%1_mpdObj%2%3_x", _prefix, ["", "0"] select (_i < 8), _i + 1];
	
	// Set point position
	_heli animate [format ["%1_mpdObj%2%3_x", _prefix, ["", "0"] select (_i < 8), _i + 1], _pos # 0];
	_heli animate [format ["%1_mpdObj%2%3_y", _prefix, ["", "0"] select (_i < 8), _i + 1], _pos # 1];

	switch (_textMode) do {
		case MPD_ICON_TYPE_A : {
			//[_heli, _offset, _inds, _text1, _rightJustified] call _writeText;
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT01, SEL_MPD_OBJ1_DIGIT02, SEL_MPD_OBJ1_DIGIT03], _text1, true] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_B : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT09, SEL_MPD_OBJ1_DIGIT10, SEL_MPD_OBJ1_DIGIT11], _text1, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_C : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT14, SEL_MPD_OBJ1_DIGIT15], _text1, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
		};
		case MPD_ICON_TYPE_D : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT01, SEL_MPD_OBJ1_DIGIT02, SEL_MPD_OBJ1_DIGIT03], _text1, true] call _writeText;
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT04, SEL_MPD_OBJ1_DIGIT05, SEL_MPD_OBJ1_DIGIT06], _text2, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_E : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT04, SEL_MPD_OBJ1_DIGIT05, SEL_MPD_OBJ1_DIGIT06], _text1, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_F : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT12, SEL_MPD_OBJ1_DIGIT13], _text1, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_G : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT07, SEL_MPD_OBJ1_DIGIT08], _text1, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		default {
			["Invalid text type %1", _textMode] call BIS_fnc_error;
		};
	};
};