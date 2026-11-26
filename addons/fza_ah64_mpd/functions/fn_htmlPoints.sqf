/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlPoints

Description:
    Points for an HTML page's point layer (ui\shared\mpd_points.js), from points as fza_mpd_fnc_drawIcons takes them.
    The idents' definitions are kept on the page's browser control and sent with fza_mpd_fnc_htmlDefsJson.

Parameters:
    _ctrl   - The page's browser control (fza_mpd_fnc_htmlCtrl)
    _points - Points as fza_mpd_fnc_drawIcons takes them; a 7th element true draws the point bold
    _tune   - The page's threat symbol tuning, [size, text, inset, ...] (fza_mpd_fnc_threatSymbolTune)

Returns:
    [[ident, 1 world or 0 screen, x, y, text A, text B, ID type, ID number, bold 1 or 0], ...]

Examples:
    --- Code
    [_ctrl, _points, MPD_THREAT_TUNE_ASE] call fza_mpd_fnc_htmlPoints
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
disableSerialization;
params ["_ctrl", "_points", "_tune"];

// Ident definitions: [texture key, texture 2 key, size, colour, text A place, text B place, text A, text B]; a place is
// [x offset, y offset, horizontal, vertical], 0 without text; [] for an unknown ident. Built again when the threat
// symbols are tuned (fza_mpd_fnc_threatSymbolTune).
private _defs = _ctrl getVariable "fza_mpd_htmlDefs";
private _tuneVersion = missionNamespace getVariable ["fza_mpd_threatTuneVersion", 0];
if (isNil "_defs" || {(_ctrl getVariable ["fza_mpd_htmlDefsTune", -1]) != _tuneVersion}) then {
    _defs = createHashMap;
    _ctrl setVariable ["fza_mpd_htmlDefs", _defs];
    _ctrl setVariable ["fza_mpd_htmlDefsTune", _tuneVersion];
    _ctrl setVariable ["fza_mpd_htmlDefsGrew", true];
};
_tune params ["_tuneSize", "_tuneText", "_tuneIn"];

// A texture's key in the page's icon atlas: its file name without _ca, lower case
private _texKey = {
    if !(_this isEqualType "") exitWith {""};
    private _parts = (toLower _this) splitString "\/";
    if (_parts isEqualTo []) exitWith {""};
    private _name = _parts # (count _parts - 1);
    if (count _name > 4 && {_name select [count _name - 4, 4] == ".paa"}) then {_name = _name select [0, count _name - 4]};
    if (count _name > 3 && {_name select [count _name - 3, 3] == "_ca"}) then {_name = _name select [0, count _name - 3]};
    _name
};
private _place = {
    params ["_text"];
    _text params [["_tpl", ""], ["_offset", [0, 0]], ["_hAlign", "center"], ["_vAlign", "center"]];
    if (_tpl isEqualTo "") exitWith {0};
    [_offset param [0, 0], _offset param [1, 0], _hAlign, _vAlign]
};
// A position the page can take: two finite numbers. toJSON writes a NaN or an infinity as text JSON cannot parse,
// which would lose the whole payload
private _isXY = {
    _this isEqualType [] && {count _this >= 2} && {(_this # 0) isEqualType 0} && {(_this # 1) isEqualType 0}
        && {finite (_this # 0)} && {finite (_this # 1)}
};
private _defOf = {
    params ["_ident"];
    private _def = _defs get _ident;
    if (!isNil "_def") exitWith {_def};
    private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
    _def = [];
    if (!isNil "_details" && {_details isEqualType []} && {count _details >= 6}) then {
        _details params [["_tex", ""], ["_tex2", ""], ["_size", 0], ["_color", [1, 1, 1, 1]], ["_textA", []], ["_textB", []], ["_type", -1]];
        // An icon of no size or a colour that isn't four numbers is not drawn, as fza_mpd_fnc_uiDrawPoint
        if (_size isEqualType 0 && {finite _size} && {_size > 0} && {_color isEqualTypeArray [0, 0, 0, 0]}) then {
            private _placeA = [_textA] call _place;
            private _placeB = [_textB] call _place;
            // RLWR and RFI threat symbols as tuned: sized, the characters at their edges moved in, and the text's height,
            // which the page takes over the icon's size, by the size and text multipliers (ui\shared\mpd_points.js)
            if (_type in [POINT_TYPE_ASE, POINT_TYPE_RFI]) then {
                _size = _size * _tuneSize;
                private _tuned = {
                    if !(_this isEqualType []) exitWith {_this};
                    _this params ["_px", "_py", "_hAlign", "_vAlign"];
                    private _dx = [0, [-_tuneIn, _tuneIn] select (_px < 0.5)] select (abs (_px - 0.5) > 0.25);
                    [_px + _dx, _py, _hAlign, _vAlign, _tuneSize * _tuneSize * _tuneText]
                };
                _placeA = _placeA call _tuned;
                _placeB = _placeB call _tuned;
            };
            _def = [_tex call _texKey, _tex2 call _texKey, _size, _color, _placeA, _placeB, _textA param [0, ""], _textB param [0, ""]];
        };
    };
    _defs set [_ident, _def];
    _ctrl setVariable ["fza_mpd_htmlDefsGrew", true];
    _def
};

private _out = [];
{
    _x params [["_mode", true], ["_pos", []], "", ["_type", -1], ["_id", -1], ["_ident", ""], ["_bold", false]];
    if (!(_ident isEqualType "") || {!(_pos call _isXY)}) then {continue};
    private _def = [_ident] call _defOf;
    if (_def isEqualTo []) then {continue};
    private _textA = "";
    private _textB = "";
    if ((_def # 4) isNotEqualTo 0) then {_textA = [[_x, _def # 6] call fza_dms_fnc_pointFillIconText] param [0, ""]};
    if ((_def # 5) isNotEqualTo 0) then {_textB = [[_x, _def # 7] call fza_dms_fnc_pointFillIconText] param [0, ""]};
    if !(_textA isEqualType "") then {_textA = str _textA};
    if !(_textB isEqualType "") then {_textB = str _textB};
    private _idType = _type;
    private _idNum  = _id;
    if (_id isEqualType []) then {
        _idType = _id param [0, -1];
        _idNum  = _id param [1, -1];
    };
    _out pushBack [_ident, [0, 1] select (_mode isEqualTo true || {_mode isEqualTo 1}), _pos # 0, _pos # 1, _textA, _textB, _idType, _idNum, [0, 1] select (_bold isEqualTo true)];
} forEach _points;
_out
