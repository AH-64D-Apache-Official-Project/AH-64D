/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_cscopeProfileDraw

Description:
    onDraw handler of the C-scope profile canvas. Draws the TPM terrain profile
    lines conformally on the HMD while TPM and
    C-SCP are selected: line 1 solid white, lines 2-4 dashed in the IHADSS
    colour, as many lines as the TPM page LINES setting. Lines are clipped to
    the monocle, so nothing outside it is turned into draw calls.

Parameters:
    _ctrl - The canvas map control (covers the monocle rectangle)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_ctrl"];

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base") || { driver _heli != player && gunner _heli != player }) exitWith {};
if ((_heli getVariable ["fza_ah64_fcrMode", 0]) != FCR_DISP_MODE_TPM || { !(_heli getVariable ["fza_ah64_fcrcscope", false]) }) exitWith {};
// HMD only, not in the TADS sight
if (cameraView == "GUNNER") exitWith {};

private _lineCount = (_heli getVariable ["fza_ah64_fcrTpmLines", 4]) min 4;
private _profile   = _heli getVariable ["fza_ah64_fcrTPMProfile", []];
if (_lineCount < 1 || { count _profile < 3 }) exitWith {};
_profile params ["_leftBearing", "_colWidth", "_lines"];

// Screen -> map is linear; the canvas sits at the display root, so its position is in screen coordinates
private _cp = ctrlPosition _ctrl;
private _cx = (_cp # 0) + (_cp # 2) * 0.5;
private _cy = (_cp # 1) + (_cp # 3) * 0.5;
private _mc = _ctrl ctrlMapScreenToWorld [_cx, _cy];
private _mb = _ctrl ctrlMapScreenToWorld [(_cp # 0) + (_cp # 2), (_cp # 1) + (_cp # 3)];
private _kx = ((_mb # 0) - (_mc # 0)) / ((_cp # 2) * 0.5);
private _ky = ((_mb # 1) - (_mc # 1)) / ((_cp # 3) * 0.5);
private _unit = abs _kx;

// Monocle aperture, measured from monocle_solid.paa (canvas = monocle rectangle), in screen coordinates
private _ex = _cx;
private _ey = (_cp # 1) + (_cp # 3) * 0.492;
private _rx = (_cp # 2) * 0.469 * 0.97;
private _ry = (_cp # 3) * 0.421 * 0.97;

// Line width and dash patterns [on, off], in screen widths
private _halfWidth = 0.00125 * _unit;
private _patterns  = [[], [0.022, 0.014], [0.040, 0.007], [0.007, 0.009]] apply { _x apply { _x * _unit } };
private _green     = [0.1, 1, 0, 1];
private _colors    = [[1, 1, 1, 1], _green, _green, _green] apply { format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _x) };

private _toMap = { [(_mc # 0) + _kx * ((_this # 0) - _cx), (_mc # 1) + _ky * ((_this # 1) - _cy)] };

private _rect = {
    params ["_a", "_b", "_tex"];
    private _d = _b vectorDiff _a;
    _ctrl drawRectangle [(_a vectorAdd _b) vectorMultiply 0.5, (vectorMagnitude _d) / 2, _halfWidth, -((_d # 1) atan2 (_d # 0)), [1, 1, 1, 1], _tex];
};

// Part of screen segment a-b inside the aperture as [t0, t1], or [] if none
private _clip = {
    params ["_a", "_b"];
    private _ax = ((_a # 0) - _ex) / _rx;
    private _ay = ((_a # 1) - _ey) / _ry;
    private _dx = ((_b # 0) - (_a # 0)) / _rx;
    private _dy = ((_b # 1) - (_a # 1)) / _ry;
    private _qa = _dx * _dx + _dy * _dy;
    private _qb = 2 * (_ax * _dx + _ay * _dy);
    private _qc = _ax * _ax + _ay * _ay - 1;
    if (_qa < 1e-12) exitWith { [[], [0, 1]] select (_qc <= 0) };
    private _disc = _qb * _qb - 4 * _qa * _qc;
    if (_disc <= 0) exitWith { [] };
    private _sq = sqrt _disc;
    private _t0 = ((-_qb - _sq) / (2 * _qa)) max 0;
    private _t1 = ((-_qb + _sq) / (2 * _qa)) min 1;
    if (_t0 >= _t1) exitWith { [] };
    [_t0, _t1]
};

// About 3 deg between drawn points at either sector width
private _colCount = count (_lines # 0);
private _stride   = (round (3 / _colWidth)) max 1;

// Only the columns near the view can reach the monocle: +-35 deg around the camera bearing
private _camDir = getCameraViewDirection player;
private _camRel = ((((_camDir # 0) atan2 (_camDir # 1)) - _leftBearing) + 720) % 360;
if (_camRel > 270) then { _camRel = _camRel - 360; };
private _iFrom  = ((floor ((_camRel - 35) / _colWidth)) max 0);
private _iTo    = ((ceil ((_camRel + 35) / _colWidth)) min (_colCount - 1));
_iFrom = _iFrom - (_iFrom % _stride);

for "_li" from 0 to (_lineCount - 1) do {
    private _points = _lines # _li;
    private _tex    = _colors # _li;

    // Screen positions; a missing column or a point behind the eye breaks the line
    private _screen = [];
    for "_i" from _iFrom to _iTo step _stride do {
        private _p = _points # _i;
        _screen pushBack (if (_p isEqualTo []) then { [] } else { worldToScreen (ASLToAGL _p) });
    };

    // Runs of map points inside the aperture
    private _runs = [];
    private _run  = [];
    for "_j" from 1 to (count _screen - 1) do {
        private _a = _screen # (_j - 1);
        private _b = _screen # _j;
        private _span = if (_a isEqualTo [] || { _b isEqualTo [] }) then { [] } else { [_a, _b] call _clip };
        if (_span isEqualTo []) then {
            if (count _run > 1) then { _runs pushBack _run; };
            _run = [];
        } else {
            _span params ["_t0", "_t1"];
            private _d = _b vectorDiff _a;
            if (_t0 > 0 || { _run isEqualTo [] }) then {
                if (count _run > 1) then { _runs pushBack _run; };
                _run = [(_a vectorAdd (_d vectorMultiply _t0)) call _toMap];
            };
            _run pushBack ((_a vectorAdd (_d vectorMultiply _t1)) call _toMap);
            if (_t1 < 1) then {
                _runs pushBack _run;
                _run = [];
            };
        };
    };
    if (count _run > 1) then { _runs pushBack _run; };

    private _pattern = _patterns # _li;
    {
        private _pts = _x;
        if (_pattern isEqualTo []) then {
            for "_j" from 1 to (count _pts - 1) do { [_pts # (_j - 1), _pts # _j, _tex] call _rect; };
        } else {
            // One straight rectangle per dash, chorded across corners, so the count follows the dashes not the points
            _pattern params ["_on", "_off"];
            private _isOn      = true;
            private _left      = _on;
            private _dashStart = _pts # 0;
            for "_j" from 1 to (count _pts - 1) do {
                private _a   = _pts # (_j - 1);
                private _b   = _pts # _j;
                private _len = _a distance2D _b;
                private _pos = 0;
                while { _len - _pos >= _left } do {
                    _pos = _pos + _left;
                    private _q = _a vectorAdd ((_b vectorDiff _a) vectorMultiply (_pos / _len));
                    if (_isOn) then { [_dashStart, _q, _tex] call _rect; } else { _dashStart = _q; };
                    _isOn = !_isOn;
                    _left = [_off, _on] select _isOn;
                };
                _left = _left - (_len - _pos);
            };
            if (_isOn) then { [_dashStart, _pts # (count _pts - 1), _tex] call _rect; };
        };
    } forEach _runs;
};
