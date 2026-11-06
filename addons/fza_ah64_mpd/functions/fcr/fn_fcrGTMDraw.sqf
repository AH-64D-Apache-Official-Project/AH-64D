#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli", "_mpdIndex", "_state"];

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _displayTargets = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _systemWas = _heli getVariable "fza_ah64_was";

//FCR wiper
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
// Wiper hidden while the dish cues to the sector edge — the bar only ever appears at the sweep start
private _cueing = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_cueing) then {
    // Wiper bones map ANIM 0..3.2 linearly across +-45 — remap so sector scans sweep only their wedge.
    // Display is centerline-referenced: the wedge stays centered, so the wiper ignores azimuth bias
    private _h   = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
    private _bar = (_h * 2) / FCR_SCAN_RATE_DEGS;
    private _t   = (_fcrScanDeltaTime max 0) % (_bar * 2);
    private _az  = [-_h + (_t / _bar) * (_h * 2), _h - ((_t - _bar) / _bar) * (_h * 2)] select (_t > _bar);
    private _anim = [0.8 * (1 + _az / 45), 2.4 - 0.8 * _az / 45] select (_t > _bar);
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _anim];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

//FCR page draw — symbols on the scope HTML canvas (browser occludes native siblings), rest stays native MFD
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = [_displayTargets, _ntsIndex] call fza_fcr_fnc_antsIndex;

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (!isNull _ctrl) then {
    // "a" in degrees (divisor 1) — the polar wedge trig happens in scope.js
    ([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _systemWas,
        _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45], 8000, _dir, 1, false
    ] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson", "_symbols"];

    // Display zoom (ZOOM): the area about zoomCtr shown 6:1 in a square about the MPD's centre
    private _zoomed = _state getOrDefault ["zoom", 0] == 2;
    private _zoomCtr = _state getOrDefault ["zoomCtr", [0.5, 0.5]];
    private _zoomRatio = _state getOrDefault ["zoomRatio", 6];
    private _zoomJson = ["null", format ["[%1,%2,%3,%4]", _zoomCtr # 0, _zoomCtr # 1, _zoomRatio, MPD_CURSOR_ZOOM_VIEW_HALF]] select _zoomed;

    // Where scope.js draws each symbol, for the MPD cursor (fza_mpd_fnc_cursorEnter)
    private _cursorTargets = [];
    {
        _x params ["_a", "_r", "_target", "_pos"];
        private _sx = 0.5 + sin _a * _r * 0.65;
        private _sy = 0.87 - cos _a * _r * 0.65;
        if (_zoomed) then {
            _sx = 0.5 + (_sx - _zoomCtr # 0) * _zoomRatio;
            _sy = 0.5 + (_sy - _zoomCtr # 1) * _zoomRatio;
            if (abs (_sx - 0.5) > MPD_CURSOR_ZOOM_VIEW_HALF || {abs (_sy - 0.5) > MPD_CURSOR_ZOOM_VIEW_HALF}) then {continue};
        };
        _cursorTargets pushBack [_sx, _sy, _target, _pos, _forEachIndex];
    } forEach _symbols;
    _state set ["cursorTargets", _cursorTargets];
    private _hover = [_heli, _mpdIndex, _state, _cursorTargets] call fza_mpd_fnc_fcrCursorHover;

    private _zonesJson = [_heli, _scanPos, _dir, 0.65 / 8000, [0.5, 0.87]] call fza_mpd_fnc_fcrZonesJson;
    [_ctrl, "fzaFCRScope.update", format ['{"mode":1,"zoom":%3,"hover":%4,"targets":[%1],"shots":[%2],"zones":%5}', _tgtJson, _shotJson, _zoomJson, _hover, _zonesJson]] call fza_mpd_fnc_htmlPush;
};

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];
