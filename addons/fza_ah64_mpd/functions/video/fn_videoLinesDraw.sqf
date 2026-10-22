/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoLinesDraw

Description:
    onDraw handler of the VIDEO page's line canvas: the TPM terrain profile
    lines fza_mpd_fnc_videoSymbolsShow left on the display, line 1 solid, lines
    2-4 dashed, as on the HDU (fza_ihadss_fnc_cscopeProfileDraw).

Parameters:
    _ctrl - The canvas map control (covers the display)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_ctrl"];

// Kept far off the map, so it draws none of it
_ctrl ctrlMapAnimAdd [0, 0.001, [-99999, -99999]];
ctrlMapAnimCommit _ctrl;

private _lines = (ctrlParent _ctrl) getVariable ["fza_mpd_videoLines", []];
if (_lines isEqualTo []) exitWith {};

// Display to map is linear; format units to the display are 480 to its height, centred and raised
private _mc = _ctrl ctrlMapScreenToWorld [0.5, 0.5];
private _mb = _ctrl ctrlMapScreenToWorld [1, 1];
private _kx = ((_mb # 0) - (_mc # 0)) / 0.5 / 480;
private _ky = ((_mb # 1) - (_mc # 1)) / 0.5 / 480;
private _toMap = {[(_mc # 0) + _kx * ((_this # 0) - 320), (_mc # 1) + _ky * ((_this # 1) - 240 - MPD_VIDEO_RAISE)]};

// Line half width and dash patterns [on, off], in format units
private _unit      = abs _kx;
// A canvas not yet sized has no scale, and zero length dashes would never end
if (_unit < 1e-9 || {abs _ky < 1e-9}) exitWith {};
private _halfWidth = 0.8 * _unit;
private _patterns  = [[], [13, 9], [24, 4], [4, 6]] apply {_x apply {_x * _unit}};
private _tex       = "\fza_ah64_mpd\tex\canvas\line_green_ca.paa";

private _rect = {
    params ["_a", "_b"];
    private _d = _b vectorDiff _a;
    _ctrl drawRectangle [(_a vectorAdd _b) vectorMultiply 0.5, (vectorMagnitude _d) / 2, _halfWidth, -((_d # 1) atan2 (_d # 0)), [1, 1, 1, 1], _tex];
};

{
    _x params ["_li", "_flat"];
    private _pts = [];
    for "_i" from 0 to (count _flat - 2) step 2 do {_pts pushBack ([_flat # _i, _flat # (_i + 1)] call _toMap)};
    private _pattern = _patterns param [_li, []];
    if (_pattern isEqualTo []) then {
        for "_j" from 1 to (count _pts - 1) do {[_pts # (_j - 1), _pts # _j] call _rect};
    } else {
        // One straight rectangle per dash, chorded across corners
        _pattern params ["_on", "_off"];
        private _isOn      = true;
        private _left      = _on;
        private _dashStart = _pts # 0;
        for "_j" from 1 to (count _pts - 1) do {
            private _a   = _pts # (_j - 1);
            private _b   = _pts # _j;
            private _len = _a distance2D _b;
            private _pos = 0;
            while {_len - _pos >= _left} do {
                _pos = _pos + _left;
                private _q = _a vectorAdd ((_b vectorDiff _a) vectorMultiply (_pos / _len));
                if (_isOn) then {[_dashStart, _q] call _rect} else {_dashStart = _q};
                _isOn = !_isOn;
                _left = [_off, _on] select _isOn;
            };
            _left = _left - (_len - _pos);
        };
        if (_isOn) then {[_dashStart, _pts # (count _pts - 1)] call _rect};
    };
} forEach _lines;
