/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoKnob

Description:
    Turns an MPD's VID knob one detent: clockwise brightens its video,
    counterclockwise darkens it; the centre detent leaves it unmodified.

Parameters:
    _heli - The helicopter
    _side - The MPD, 0 left or 1 right
    _dir  - 1 clockwise, -1 counterclockwise

Returns:
    Nothing

Examples:
    --- Code
    [_heli, 1, 1] call fza_mpd_fnc_videoKnob
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_side", "_dir"];

private _video = [_heli, _side] call fza_mpd_fnc_videoState;
_video set [MPD_VIDEO_KNOB, ((_video # MPD_VIDEO_KNOB) + _dir * MPD_VIDEO_KNOB_STEP) max -1 min 1];
