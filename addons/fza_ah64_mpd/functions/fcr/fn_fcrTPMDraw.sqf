/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTPMDraw

Description:
    Draws the FCR TPM page: native MFD symbology plus the terrain profile
    video and obstacle symbols, which are pushed to the page's HTML canvas.
    Terrain sampling, the sector width and the obstacle picture are owned by
    the FCR addon (fza_fcr_fnc_tpmSample, fza_fcr_fnc_stateControl,
    fza_fcr_fnc_updateTPMObstacles).

Parameters:
    _heli         - The helicopter
    _mpdIndex     - 0 left MPD, 1 right MPD
    _state        - Page state (unused)
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
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _fcrOn   = _heli animationPhase "fcr_enable" != 0;

if (!_fcrOn || _fcrMode != FCR_DISP_MODE_TPM) exitWith {
    [_heli, _mpdIndex, ["fcr", "fcrrmap"] select (_fcrOn && _fcrMode == FCR_DISP_MODE_RMAP)] call fza_mpd_fnc_setCurrentPage;
};

private _cScope = _heli getVariable "fza_ah64_fcrcscope";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), FCR_DISP_MODE_TPM];

[_heli, _mpdIndex, true] call fza_mpd_fnc_fcrStatusDraw;

private _clearanceFt = _heli getVariable ["fza_ah64_fcrTpmClearance", 1];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_PROF),  ["GEOM", "ARITH", "TEST"] select (_heli getVariable ["fza_ah64_fcrTpmProfMode", 0])];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_LINES), str (_heli getVariable ["fza_ah64_fcrTpmLines", 4])];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_CLR),   ["20","50","100","200"] select _clearanceFt];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_ELEV),  ["FAR", "NEAR"] select (_heli getVariable ["fza_ah64_fcrTpmElev", 0])];

// Wide below 45 kts, narrow above 55 kts — selected by fza_fcr_fnc_stateControl
private _halfFov = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TPM_WIDE), parseNumber (_halfFov > 45)];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;

// One sweep covers the sector width at the TPM antenna rate; cycle = there and back
private _halfSweepDuration = (_halfFov * 2) / FCR_TPM_SCAN_RATE_DEGS;
private _cycleDuration = _halfSweepDuration * 2;
private _tpmCueing = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_tpmCueing) then {
    // Wiper bones are calibrated in the legacy time-base (wide 0..6.4, narrow 0..3.2) —
    // normalize the real phase into bone-time so bars and dish stay in sync at any scan rate
    private _boneCycle = [3.2, 6.4] select (_halfFov >= 90);
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      ((_fcrScanDeltaTime max 0) % _cycleDuration) / _cycleDuration * _boneCycle];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

// OBS window appears only when obstacles are detected (value drives text + box condition)
private _tpmObsCount = count (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_OBS), ["", str _tpmObsCount] select (_tpmObsCount > 0)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TPM_OBS_SHOW), parseNumber (_tpmObsCount > 0)];

// ---- Terrain sampling (shared with the IHADSS profile lines) ----

private _aziSteps   = [60, 120] select (_halfFov >= 90);
private _rangeSteps = 150;
private _clearEpoch = _heli getVariable ["fza_ah64_fcrTPMClearEpoch", 0];
private _colJson    = [_heli] call fza_fcr_fnc_tpmSample;

// ---- Video columns and obstacles → HTML canvas ----

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};

// Each display clears once per commanded clear, including one that loads afterwards
private _dispClear = _clearEpoch != (_ctrl getVariable ["fza_fcrClearEpoch", -1]);
if (_dispClear) then { _ctrl setVariable ["fza_fcrClearEpoch", _clearEpoch]; };

// Obstacle picture: sent when it changes, and once a second in case the browser dropped a push
private _obsStamp = _heli getVariable ["fza_ah64_fcrTPMObsStamp", 0];
(_ctrl getVariable ["fza_fcrTpmObs", [-1, -10]]) params ["_seenStamp", "_seenTick"];
private _obsPart = "";
if (_obsStamp != _seenStamp || { diag_tickTime - _seenTick > 1 }) then {
    _ctrl setVariable ["fza_fcrTpmObs", [_obsStamp, diag_tickTime]];
    _obsPart = ',"obstacles":' + (_heli getVariable ["fza_ah64_fcrTPMObsJson", "[]"]);
};

private _json = format [
    '{"halfFov":%1,"aziSteps":%2,"rangeSteps":%3,"hardClear":%4%5%6}',
    _halfFov,
    _aziSteps,
    _rangeSteps,
    ["false","true"] select _dispClear,
    ["", ',"columns":' + _colJson] select (_colJson != ""),
    _obsPart
];

[_ctrl, "fzaFCRTpm.update", _json] call fza_mpd_fnc_htmlPush;
