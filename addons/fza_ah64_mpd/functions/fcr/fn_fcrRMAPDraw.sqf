/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrRMAPDraw

Description:
    Draws the FCR RMAP page: native MFD symbology plus the B-scope terrain
    video and target symbols, which are pushed to the page's HTML canvas.
    Terrain is sampled by fza_fcr_fnc_rmapSample, once per frame for the
    columns the scan bar has crossed, and shared by both MPDs. ZOOM shows the
    zoom box's area, picture and symbols, in a square about the MPD's centre.

Parameters:
    _heli         - The helicopter
    _mpdIndex     - 0 left MPD, 1 right MPD
    _state        - Page state: the display zoom and the cursor's targets
    _persistState - Page persistent state (unused)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _fcrOn   = _heli animationPhase "fcr_enable" != 0;

if (!_fcrOn || _fcrMode != FCR_DISP_MODE_RMAP) exitWith {
    [_heli, _mpdIndex, ["fcr", "fcrtpm"] select (_fcrOn && _fcrMode == FCR_DISP_MODE_TPM)] call fza_mpd_fnc_setCurrentPage;
};

private _cScope  = _heli getVariable "fza_ah64_fcrcscope";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), FCR_DISP_MODE_RMAP];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_SIZE), _heli getVariable ["fza_ah64_fcrScanSize", 0]];
// The MPD cursor: over the radar picture, where it chooses targets (fza_mpd_fnc_cursorInArea); on a target, below
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ZOOM), _state getOrDefault ["zoom", 0]];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CURSOR_TARGET), 0];
private _cursorOn = _heli getVariable ["fza_mpd_cursor", []];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CURSOR_AREA), BOOLTONUM(_cursorOn param [0, -1] == _mpdIndex && {[_heli, _mpdIndex, _cursorOn # 1, _cursorOn # 2] call fza_mpd_fnc_cursorInArea})];
[_heli, _mpdIndex, _state] call fza_mpd_fnc_fcrTgtDraw;
[_heli, _mpdIndex] call fza_mpd_fnc_cursorToNts;
_state set ["cursorTargets", []];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _gtmHalfFov       = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
private _barTime          = (_gtmHalfFov * 2) / FCR_SCAN_RATE_DEGS;
// Wiper hidden while the dish cues to the sector edge — the bar only ever appears at the sweep start
private _cueingRmap = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_cueingRmap) then {
    // Bars ride the fixed +-45 display axis — remap wiper bearing into the bone's 0..3.2 range.
    // Display is centerline-referenced: the sector stays centered, so the wiper ignores azimuth bias
    private _t  = (_fcrScanDeltaTime max 0) % (_barTime * 2);
    private _az = [-_gtmHalfFov + (_t / _barTime) * (_gtmHalfFov * 2), _gtmHalfFov - ((_t - _barTime) / _barTime) * (_gtmHalfFov * 2)] select (_t > _barTime);
    private _anim = [0.8 * (1 + _az / 45), 2.4 - 0.8 * _az / 45] select (_t > _barTime);
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _anim];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

[_heli, _mpdIndex] call fza_mpd_fnc_fcrStatusDraw;

// ---- Terrain sampling ----

[_heli] call fza_fcr_fnc_resolveDisplay;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
// RMAP re-select toggles the video underlay; sampling continues while hidden so it returns current
private _rmapVideo = _heli getVariable ["fza_ah64_fcrRmapVideo", true];
private _maxRange  = 8000;
[_heli] call fza_fcr_fnc_rmapSample;

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];

// ---- Video columns, FCR targets and shot-at markers → HTML canvas ----

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};

private _displayTargets = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _nts       = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = if (!isNull _nts) then { _displayTargets findIf {_x # 3 == _nts} } else { -1 };
private _antsIndex = [_displayTargets, _ntsIndex] call fza_fcr_fnc_antsIndex;

// "a" normalised to -1..1 over the fixed +-45 B-scope x axis
([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _heli getVariable "fza_ah64_was",
    _gtmHalfFov, _maxRange, _dir, 45, false
] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson", "_symbols"];

// Display zoom (ZOOM): the area about zoomCtr shown zoomRatio:1 in a square about the MPD's centre
private _zoomed    = _state getOrDefault ["zoom", 0] == 2;
private _zoomCtr   = _state getOrDefault ["zoomCtr", [0.5, 0.5]];
private _zoomRatio = _state getOrDefault ["zoomRatio", 6];
private _zoomJson  = ["null", format ["[%1,%2,%3,%4]", _zoomCtr # 0, _zoomCtr # 1, _zoomRatio, MPD_CURSOR_ZOOM_VIEW_HALF]] select _zoomed;

// Where fcr_rmap_view.js draws each symbol in the radar picture, for the MPD cursor (fza_mpd_fnc_cursorEnter); the
// browser covers 0.025 to 0.975 of the MPD
private _cursorTargets = [];
{
    _x params ["_a", "_r", "_target", "_pos"];
    if (_a < -1 || {_a > 1} || {_r < 0} || {_r > 1}) then {continue};
    private _sx = 0.025 + 0.95 * (0.1632 + (_a * 0.5 + 0.5) * (0.8368 - 0.1632));
    private _sy = 0.025 + 0.95 * (0.1316 + (0.8947 - 0.1316) * (1 - _r));
    if (_zoomed) then {
        _sx = 0.5 + (_sx - _zoomCtr # 0) * _zoomRatio;
        _sy = 0.5 + (_sy - _zoomCtr # 1) * _zoomRatio;
        if (abs (_sx - 0.5) > MPD_CURSOR_ZOOM_VIEW_HALF || {abs (_sy - 0.5) > MPD_CURSOR_ZOOM_VIEW_HALF}) then {continue};
    };
    _cursorTargets pushBack [_sx, _sy, _target, _pos, _forEachIndex];
} forEach _symbols;
_state set ["cursorTargets", _cursorTargets];
private _hover = [_heli, _mpdIndex, _state, _cursorTargets] call fza_mpd_fnc_fcrCursorHover;

private _json = format [
    '{%1,"video":%2,"hover":%3,"targets":[%4],"shots":[%5],"zoom":%6}',
    [_heli, _ctrl, "fza_ah64_fcrRMAPStore"] call fza_fcr_fnc_videoSync,
    ["false","true"] select _rmapVideo,
    _hover,
    _tgtJson,
    _shotJson,
    _zoomJson
];

[_ctrl, "fzaFCRRmap.update", _json] call fza_mpd_fnc_htmlPush;
