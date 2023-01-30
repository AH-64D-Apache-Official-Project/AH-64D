#include "\fza_ah64_dms\headers\constants.h"
params ["_ident"];

//Check local variable information first
if (_ident in fza_dms_pointIdents) exitWith {
    fza_dms_pointIdents get _ident;
};

//Returns nil for invalid identifier, or [texture, offset]
private _config = missionConfigFile >> "FzaIconTypes" >> _ident;

if (!isClass _config) then {
    _config = missionConfigFile >> "FzaIconTypes" >> "Icon" + _ident;
};

if (!isClass _config) then {
    _config = configFile >> "FzaIconTypes" >> _ident;
};

if (!isClass _config) then {
    _config = configFile >> "FzaIconTypes" >> "Icon" + _ident;
};

if (!isClass _config) exitWith {};

private _tex = "";
if (isText (_config >> "tex")) then {
    _tex = getText (_config >> "tex");
};

private _color = MPD_ICON_COLOR_GREEN;
if (isNumber (_config >> "color")) then {
    _color = getNumber (_config >> "color");
};

private _type = POINT_TYPE_WP;
if (isNumber (_config >> "type")) then {
    _type = getNumber (_config >> "type");
};

private _size = 0;
if (isNumber (_config >> "size")) then {
    _size = getNumber (_config >> "size");
};

private _parseText = {
    params ["_config", "_prefix"];
    private _ret = ["", [0,0], "center", "center"];
    if (isNumber (_config >> _prefix)) then {
        _ret set [0, getNumber (_config >> _prefix)];
    };
    if (isText (_config >> _prefix)) then {
        _ret set [0, getText (_config >> _prefix)];
    };

    private _offsetKey = _prefix + "offset";
    if (isArray (_config >> _offsetKey)) then {
        _ret set [1, getArray (_config >> _offsetKey)];
    };

    private _hAlignKey = _prefix + "Halign";
    if (isText (_config >> _hAlignKey)) then {
        _ret set [2, getText (_config >> _hAlignKey)];
    };
    private _vAlignKey = _prefix + "Valign";
    if (isText (_config >> _vAlignKey)) then {
        _ret set [3, getText (_config >> _vAlignKey)];
    };
    _ret
};

private _textA = [_config, "textA"] call _parseText;
private _textB = [_config, "textB"] call _parseText;

private _result = [_tex, _size, _color, _textA, _textB, _type];
fza_dms_pointIdents set [_ident, _result];
_result;