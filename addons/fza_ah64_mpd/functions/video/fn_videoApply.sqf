/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoApply

Description:
    Shows an MPD's video underlay in a display's video group (FZA_MPD_VIDEO_GROUP),
    as its VIDEO page settings have it. The sensor's middle 4:3 is its image:
    NORM presents the centre 75% of it, WIDE 95% with black bars above and
    below, ZOOM 2:1 of WIDE. COLOR tints it green, SYMB
    BOOST darkens it, and the VID knob darkens it below its centre detent or
    lifts its dark areas above.

Parameters:
    _heli    - The helicopter
    _side    - The MPD, 0 left or 1 right
    _display - The display holding the video group
    _show    - False hides it

Returns:
    True when video is shown

Examples:
    --- Code
    [_heli, 0, _display, true] call fza_mpd_fnc_videoApply
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_side", "_display", ["_show", true]];

private _group = _display displayCtrl 380;
if (isNull _group) exitWith {false};

private _video = [_heli, _side] call fza_mpd_fnc_videoState;
_video params ["_underlay", "_view", "", "_color", "_symb", "", "_knob"];
private _target = "";
if (_show && {_heli getVariable ["bmkhs_acBusOn", false]}) then {
    _target = ([_heli, _underlay] call fza_mpd_fnc_videoSource) # 0;
};
if (_target == "") exitWith {
    if (ctrlShown _group) then {_group ctrlShow false};
    false
};

private _picture = _group controlsGroupCtrl 381;
private _lift    = _group controlsGroupCtrl 382;
private _texture = [_target] call fza_ihadss_fnc_r2tTexture;
private _gain = [1, 0.55] select (_symb == 1);
if (_knob < 0) then {_gain = _gain * (1 + 0.75 * _knob)};

private _key = [_texture, _view, _color, _gain, _knob];
if ((_group getVariable ["fza_mpd_videoKey", []]) isNotEqualTo _key) then {
    _group setVariable ["fza_mpd_videoKey", _key];
    _picture ctrlSetText _texture;
    private _aspect = missionNamespace getVariable ["fza_ihadss_screenAspect", 16 / 9];
    private _h      = [1 / (4 / 3 * 0.95), 1 / (4 / 3 * 0.75), 2 / (4 / 3 * 0.95)] select _view;
    private _w      = _h * _aspect;
    private _rect   = [(1 - _w) / 2, (1 - _h) / 2 - MPD_VIDEO_RAISE / 480, _w, _h];
    private _tint   = [[1, 1, 1], [0.35, 1, 0.35]] select _color;
    _picture ctrlSetPosition _rect;
    _picture ctrlSetTextColor ((_tint apply {_x * _gain}) + [1]);
    _picture ctrlCommit 0;
    _lift ctrlSetPosition _rect;
    _lift ctrlSetTextColor [1, 1, 1, 0.3 * (_knob max 0)];
    _lift ctrlCommit 0;
};
if !(ctrlShown _group) then {_group ctrlShow true};
true
