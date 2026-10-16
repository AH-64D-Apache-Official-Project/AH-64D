/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduPnvsMask

Description:
    Shows the full screen PNVS picture only inside the HDU lens. A picture can
    only be clipped to rectangles, so the lens is built from thin horizontal
    controls groups, each clipping its own copy of the same render target;
    the monocle rim covers their stepped edge.

Parameters:
    _display - The fza_ah64_nvsoverlay display
    _rect    - Screen rectangle [x, y, w, h] of the 640x480 format
    _texture - The PNVS render target texture
    _colour  - Picture colour

Returns:
    Nothing

Examples:
    --- Code
    [_display, _rect, _texture, [0.1, 1, 0, 0.7]] call fza_ihadss_fnc_hduPnvsMask
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ihadss\headers\hdu.h"
disableSerialization;
params ["_display", "_rect", "_texture", "_colour"];
_rect params ["_rectX", "_rectY", "_rectW", "_rectH"];

// Live tunes in the debug console: fza_ihadss_pnvsScale scales the picture about the LOS,
// fza_ihadss_pnvsOffset = [right, up] moves it in degrees (16 format units each)
private _scale = missionNamespace getVariable ["fza_ihadss_pnvsScale", 1];
if !(_scale isEqualType 0 && {_scale > 0}) then {_scale = 1};
private _offset = missionNamespace getVariable ["fza_ihadss_pnvsOffset", [0, 0]];
if !(_offset isEqualTypeArray [0, 0]) then {_offset = [0, 0]};
private _pictureW = safeZoneW * _scale;
private _pictureH = safeZoneH * _scale;
private _pictureX = safeZoneX + (safeZoneW - _pictureW) / 2 + (_offset # 0) * 16 * _rectW / 640;
private _pictureY = safeZoneY + (safeZoneH - _pictureH) / 2 - (_offset # 1) * 16 * _rectH / 480;

// Whole-pixel strips so neighbours butt exactly; an overlap is drawn twice at the picture's alpha and shows as a line
if ((_display getVariable ["fza_ihadss_stripRect", []]) isNotEqualTo [_rect, _scale, _offset]) then {
    _display setVariable ["fza_ihadss_stripRect", [_rect, _scale, +_offset]];
    private _unitX   = _rectW / 640;
    private _unitY   = _rectH / 480;
    private _centreX = _rectX + 320 * _unitX;
    private _centreY = _rectY + 240 * _unitY;
    // Rotated ellipse: each strip spans the two roots of the ellipse at its mid height
    private _cos     = cos HDU_MASK_ROT;
    private _sin     = sin HDU_MASK_ROT;
    private _invA    = 1 / HDU_MASK_A ^ 2;
    private _invB    = 1 / HDU_MASK_B ^ 2;
    private _quadP   = _cos ^ 2 * _invA + _sin ^ 2 * _invB;
    private _extent  = sqrt (HDU_MASK_A ^ 2 * _sin ^ 2 + HDU_MASK_B ^ 2 * _cos ^ 2);
    private _firstPx = round ((_centreY - safeZoneY) / pixelH - _extent * _unitY / pixelH);
    private _lastPx  = round ((_centreY - safeZoneY) / pixelH + _extent * _unitY / pixelH);
    private _stripPx = HDU_STRIP_PX max ceil ((_lastPx - _firstPx) / HDU_STRIPS_MAX);
    private _count   = ceil ((_lastPx - _firstPx) / _stripPx);

    private _strips = _display getVariable ["fza_ihadss_strips", []];
    if (count _strips != _count) then {
        {ctrlDelete (_x # 0)} forEach _strips;
        _strips = [];
        for "_i" from 1 to _count do {
            private _group   = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
            private _picture = _display ctrlCreate ["RscPicture", -1, _group];
            _strips pushBack [_group, _picture];
        };
        _display setVariable ["fza_ihadss_strips", _strips];
        _display setVariable ["fza_ihadss_stripLook", []];
    };

    {
        _x params ["_group", "_picture"];
        private _topPx    = _firstPx + _forEachIndex * _stripPx;
        private _bottomPx = (_topPx + _stripPx) min _lastPx;
        private _mid      = ((safeZoneY + (_topPx + _bottomPx) / 2 * pixelH) - _centreY) / _unitY;
        private _quadQ    = 2 * _mid * _cos * _sin * (_invA - _invB);
        private _quadR    = _mid ^ 2 * (_sin ^ 2 * _invA + _cos ^ 2 * _invB) - 1;
        private _root     = sqrt ((_quadQ ^ 2 - 4 * _quadP * _quadR) max 0);
        private _left      = (-_quadQ - _root) / (2 * _quadP);
        private _right     = (-_quadQ + _root) / (2 * _quadP);
        private _leftPx    = round ((_centreX + _left * _unitX - safeZoneX) / pixelW);
        private _rightPx   = round ((_centreX + _right * _unitX - safeZoneX) / pixelW) max _leftPx;
        private _groupX    = safeZoneX + _leftPx * pixelW;
        private _groupY    = safeZoneY + _topPx * pixelH;
        _group ctrlSetPosition [_groupX, _groupY, (_rightPx - _leftPx) * pixelW, (_bottomPx - _topPx) * pixelH];
        _group ctrlCommit 0;
        _picture ctrlSetPosition [_pictureX - _groupX, _pictureY - _groupY, _pictureW, _pictureH];
        _picture ctrlCommit 0;
    } forEach _strips;
};
private _strips = _display getVariable ["fza_ihadss_strips", []];

if ((_display getVariable ["fza_ihadss_stripLook", []]) isNotEqualTo [_texture, _colour]) then {
    _display setVariable ["fza_ihadss_stripLook", [_texture, _colour]];
    {
        (_x # 1) ctrlSetText _texture;
        (_x # 1) ctrlSetTextColor _colour;
    } forEach _strips;
};
