#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

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
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

// "a" in degrees (divisor 1) — the polar wedge trig happens in scope.js
([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _systemWas,
    _gtmHalfFov, 8000, _dir, 1, false
] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson"];

private _json = format ['{"mode":1,"targets":[%1],"shots":[%2]}', _tgtJson, _shotJson];

private _uniqueId = (_heli getVariable "fza_mpd_mpdState") # _mpdIndex # 9;
private _display  = (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
if (!isNull _display) then {
    // Skip push when unchanged; keyed on the control so the cache dies with the display
    private _browserCtrl = _display displayCtrl 369;
    if ((_browserCtrl getVariable ["fza_fcrScopeLastJson", ""]) != _json) then {
        _browserCtrl setVariable ["fza_fcrScopeLastJson", _json];
        [_browserCtrl, format ["fzaFCRScope.update(%1)", _json]] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
};

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];
