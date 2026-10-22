/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_pageVIDHandleControl

Description:
    VIDEO page buttons. With VSEL (decluttered) only VSEL, VIEW and the menu
    button work. VCR, IMAGE and SHARP are not available.

Parameters:
    _heli     - The helicopter
    _mpdIndex - The MPD, 0 left or 1 right
    _control  - The button

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_control"];

private _video = [_heli, _mpdIndex] call fza_mpd_fnc_videoState;
private _vsel  = _video # MPD_VIDEO_VSEL;

if (_vsel && {!(_control in ["b1", "t6", "l1", "l2", "l3"])}) exitWith {};

switch (_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t6": {
        _video set [MPD_VIDEO_VSEL, !_vsel];
    };
    case "l1": {_video set [MPD_VIDEO_VIEW, MPD_VIDEO_VIEW_WIDE]};
    case "l2": {_video set [MPD_VIDEO_VIEW, MPD_VIDEO_VIEW_NORM]};
    case "l3": {_video set [MPD_VIDEO_VIEW, MPD_VIDEO_VIEW_ZOOM]};
    case "l6": {_video set [MPD_VIDEO_COLOR, 1 - (_video # MPD_VIDEO_COLOR)]};
    case "r1";
    case "r2";
    case "r3";
    case "r4";
    case "r5";
    case "r6": {
        _video set [MPD_VIDEO_UNDERLAY, ["r1", "r2", "r3", "r4", "r5", "r6"] find _control];
    };
    case "b2": {_video set [MPD_VIDEO_SYMB, 1 - (_video # MPD_VIDEO_SYMB)]};
    // VIEW and COLOR back to NORM and WHITE
    case "b3": {
        _video set [MPD_VIDEO_VIEW, MPD_VIDEO_VIEW_NORM];
        _video set [MPD_VIDEO_COLOR, 0];
    };
    case "b6": {_video set [MPD_VIDEO_GS, !(_video # MPD_VIDEO_GS)]};
};
