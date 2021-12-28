#include "\fza_ah64_dms\headers\constants.h"
params ["_ident"];

//Returns nil for invalid identifier, or [texture, offset]

private _config = configFile >> "FzaIconTypes" >> _ident;

if (!isClass _config) then {
    _config = configFile >> "FzaIconTypes" >> "Icon" + _ident;
};

if (!isClass _config) exitWith {};

private _tex = "";
if (isText (_config >> "tex")) then {
    _tex = getText (_config >> "tex");
};

private _offset = [0,0];
if (isArray (_config >> "offset")) then {
    _offset = getArray (_config >> "offset");
};

private _color = MPD_ICON_COLOR_GREEN;
if (isNumber (_config >> "color")) then {
    _color = getNumber (_config >> "color");
};

private _iconType = MPD_ICON_TYPE_A;
if (isNumber (_config >> "iconType")) then {
    _iconType = getNumber (_config >> "iconType");
};

private _type = POINT_TYPE_WP;
if (isNumber (_config >> "type")) then {
    _type = getNumber (_config >> "type");
};

private _textA = "";
if (isNumber (_config >> "textA")) then {
    _textA = getNumber (_config >> "textA");
};
if (isText (_config >> "textA")) then {
    _textA = getText (_config >> "textA");
};

private _textB = "";
if (isNumber (_config >> "textB")) then {
    _textB = getNumber (_config >> "textB");
};
if (isText (_config >> "textB")) then {
    _textB = getText (_config >> "textB");
};

[_tex, _offset, _color, _iconType, _textA, _textB, _type];