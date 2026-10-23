/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_pageVIDDraw

Description:
    The VIDEO page: the underlay video, and with VSEL the symbology that goes
    with it, drawn by the page from the IHADSS formats. Opened with NO VIDEO,
    the pilot gets the pilot's HMD video, the CPG the CPG's sight video.

Parameters:
    _heli         - The helicopter
    _mpdIndex     - The MPD, 0 left or 1 right
    _state        - The page state
    _persistState - The page's persisted state

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _video = [_heli, _mpdIndex] call fza_mpd_fnc_videoState;
if ((_state getOrDefault ["opened", 0]) == 0) then {
    _state set ["opened", 1];
    if ((_video # MPD_VIDEO_UNDERLAY) == MPD_VIDEO_SRC_NONE) then {
        _video set [MPD_VIDEO_UNDERLAY, [MPD_VIDEO_SRC_CPG_SIGHT, MPD_VIDEO_SRC_PLT_HMD] select (player == driver _heli)];
    };
};
_video params ["_underlay", "_view", "_sharp", "_color", "_symb", "_gs"];
private _vsel = _video # MPD_VIDEO_VSEL;
([_heli, _underlay] call fza_mpd_fnc_videoSource) params ["_target", "_symbology"];

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_VSEL), BOOLTONUM _vsel];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_UNDERLAY), _underlay];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_VIEW), _view];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_SHARP), _sharp];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_COLOR), _color];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_SYMB), _symb];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_VID_GS), BOOLTONUM _gs];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_VID_VSEL), _symbology];

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};
private _shown = [_heli, _mpdIndex, ctrlParent _ctrl] call fza_mpd_fnc_videoApply;

// The FCR targeting symbology is not presented on the video
private _sym     = "null";
private _symbols = [];
if (_vsel && {_symbology in ["TADS", "C-FLT", "P-FLT"]}) then {
    _sym = switch (_symbology) do {
        case "TADS":  {[_heli, true, true, false, "cpg", true] call fza_ihadss_fnc_htmlModel};
        case "C-FLT": {[_heli, false, false, false, "cpg", true] call fza_ihadss_fnc_htmlModel};
        default       {[_heli, false, false, false, "plt", true] call fza_ihadss_fnc_htmlModel};
    };
    // With no video, placed as that symbology's sensor or head sees them
    _symbols = [_heli, ["", _target] select _shown, _view, _symbology] call fza_mpd_fnc_videoSymbols;
};
[ctrlParent _ctrl, _symbols] call fza_mpd_fnc_videoSymbolsShow;
[_ctrl, "fzaMpdVideo.update", format ['{"gs":%1,"video":%2,"sym":%3}', _gs, _shown, _sym]] call fza_mpd_fnc_htmlPush;
