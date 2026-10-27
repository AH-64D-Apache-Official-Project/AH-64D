/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoState

Description:
    The video settings of one MPD, the VIDEO page's: changed in place. Each MPD
    has its own. [underlay, view, sharp, color, symb, g/s, VID knob, VSEL]
    (MPD_VIDEO_* indices)

Parameters:
    _heli - The helicopter
    _side - The MPD, 0 left or 1 right

Returns:
    The settings

Examples:
    --- Code
    ([_heli, 0] call fza_mpd_fnc_videoState) set [MPD_VIDEO_VIEW, MPD_VIDEO_VIEW_WIDE]
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_side"];

private _all = _heli getVariable "fza_mpd_video";
if (isNil "_all") then {
    _all = [0, 1] apply {[MPD_VIDEO_SRC_NONE, MPD_VIDEO_VIEW_NORM, 0, 0, 0, false, 0, true]};
    _heli setVariable ["fza_mpd_video", _all];
};
_all # _side
