#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _displayTargets = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _systemWas = _heli getVariable "fza_ah64_was";

private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];
private _atmWide    = _atmHalfFov >= 168;
private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_SIZE), _heli getVariable ["fza_ah64_fcrScanSize", 0]];

// TM fig 4-46: the ATM wedge rotates on the PPI to the slewed bearing (unlike GTM/RMAP,
// whose wedge stays forward). Base orientation is set by the bone's +180; the direction is
// -bias so a right (+) slew rotates the wedge right.
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_SECTOR_ROT), (((-_fcrAzBias mod 360) + 360) mod 360) / 360 * 6.4];

//FCR wiper — Fcr_ATMBar maps ANIM 0..6.4 linearly to 0..360, so feed the wiper bearing scaled to that range
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
// Wiper hidden while the dish cues to the sector edge — the bar only ever appears at the sweep start
private _cueing = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_cueing) then {
    private _animDelta = _fcrScanDeltaTime max 0;
    private _barTime   = [(_atmHalfFov * 2) / FCR_SCAN_RATE_DEGS, 180 / FCR_SCAN_RATE_DEGS] select _atmWide;
    private _cycle     = _barTime * 2;
    private _cycleT    = _animDelta % _cycle;
    // Sector rotates with the slew, so the wiper carries the bias too (wide rotation is
    // unbiased). Bias enters as -bias to match the wedge; the wiper bone's zero is already
    // forward (unlike the wedge geometry), so no 180 offset here.
    private _wiperAz   = if (_atmWide) then {
        (_cycleT / _cycle) * 360
    } else {
        // bias negated to match the wedge
        -_fcrAzBias + ([
            -_atmHalfFov + (_cycleT / _barTime) * (_atmHalfFov * 2),
            _atmHalfFov - ((_cycleT - _barTime) / _barTime) * (_atmHalfFov * 2)
        ] select (_cycleT > _barTime))
    };
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      (((_wiperAz mod 360) + 360) mod 360) / 360 * 6.4];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), [0,1] select (_atmWide && _animDelta >= _cycle * 0.458)];
    // Tail blank window (+-13.5 deg around 180) — wiper hidden while the radar cannot see
    if (!_atmWide || _cycleT < _cycle * 0.4625 || _cycleT > _cycle * 0.5375) then {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
    } else {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
    };
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
    if (_fcrScanState == FCR_MODE_OFF) then {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), 0];
    };
};

//FCR page draw — symbols on the scope HTML canvas (browser occludes native siblings), rest stays native MFD
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

// "a" in degrees (divisor 1) — the polar circle trig happens in scope.js.
// The stored ATM bearing is already nose-relative (frozen at scan time), so no live
// bias offset — the symbol holds its screen position through a slew until re-scanned.
([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _systemWas,
    _atmHalfFov, 8000, _dir, 1, true, 0
] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson"];

private _json = format ['{"mode":2,"targets":[%1],"shots":[%2]}', _tgtJson, _shotJson];

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
