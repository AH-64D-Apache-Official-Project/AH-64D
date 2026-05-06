#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _displayTargets = _heli getVariable "fza_ah64_fcrTargets";
private _systemWas = _heli getVariable "fza_ah64_was";

//FCR wiper
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];
if (_fcrScanState != FCR_MODE_OFF) then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      (_fcrScanDeltaTime max 0) % 3.2];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

//FCR page draw
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

private _scale      = (0.08125 * 8 / 8000);
private _heliCtr    = [0.5, 0.87];
private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

[_heli, _displayTargets, _scanPos, _fcrScanState, _lastFullCycle,
 _ntsIndex, _antsIndex, _scale, _heliCtr, _systemWas,
 _heli getVariable "fza_dms_shotAt", _fcrAzBias, _gtmHalfFov
] call fza_mpd_fnc_buildFCRPoints
params ["_pointsArray", "_fcrTgtCount"];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];
[_heli, _pointsArray, _mpdIndex, _scale, _heliCtr, _dir, _scanPos] call fza_mpd_fnc_drawIcons;
