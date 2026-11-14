/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoFcr

Description:
    Shows the FCR imagery as an MPD's video underlay, drawn by the page in the
    display (fcr_video_layer.js): the RMAP or TPM picture, sampled whether or
    not an MPD shows the FCR page. Placed as the FCR page has it in NORM;
    VIEW, COLOR, SYMB and the VID knob as for sensor video
    (fza_mpd_fnc_videoApply).

Parameters:
    _heli    - The helicopter
    _browser - The display's browser control
    _imagery - "rmap", "tpm" or "" for none
    _view    - MPD_VIDEO_VIEW_*
    _tint    - The video's colour times its gain, [r, g, b]
    _lift    - The VID knob's white layer, 0 to 1

Returns:
    True when the imagery is shown: none, or the RMAP video toggled off, is not

Examples:
    --- Code
    [_heli, _browser, "rmap", MPD_VIDEO_VIEW_NORM, [1, 1, 1], 0] call fza_mpd_fnc_videoFcr
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_browser", "_imagery", "_view", "_tint", "_lift"];
if (isNull _browser) exitWith {false};
if !(_imagery in ["rmap", "tpm"]) then {_imagery = ""};

// None is sent for a moment after the imagery goes, in case a push is dropped; a page that loads starts with none
(_browser getVariable ["fza_mpd_fcrVideoMode", ["", -10]]) params ["_lastMode", "_lastTick"];
if (_imagery == "" && {_lastMode == ""} && {diag_tickTime - _lastTick > 2}) exitWith {false};
if (_imagery != _lastMode) then {_browser setVariable ["fza_mpd_fcrVideoMode", [_imagery, diag_tickTime]]};

private _data  = "{}";
private _shown = _imagery != "";
switch (_imagery) do {
    case "rmap": {
        [_heli] call fza_fcr_fnc_rmapSample;
        _shown = _heli getVariable ["fza_ah64_fcrRmapVideo", true];
        _data = format ['{%1,"video":%2}',
            [_heli, _browser, "fza_ah64_fcrRMAPStore"] call fza_fcr_fnc_videoSync,
            ["false", "true"] select _shown];
    };
    case "tpm": {
        [_heli] call fza_fcr_fnc_tpmSample;
        _data = "{" + ([_heli, _browser, "fza_ah64_fcrTPMStore"] call fza_fcr_fnc_videoSync) + "}";
    };
};

[_browser, "fzaFCRVideo.update", format ['{"mode":"%1","view":%2,"tint":%3,"lift":%4,"data":%5}', _imagery, _view, _tint, _lift, _data], "fcrVideo"] call fza_mpd_fnc_htmlPush;
_shown
