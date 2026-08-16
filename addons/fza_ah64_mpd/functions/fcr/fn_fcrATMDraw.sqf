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
if (_fcrScanState != FCR_MODE_OFF) then {
    private _animDelta = _fcrScanDeltaTime max 0;
    private _cycleT    = _animDelta % 6.4;
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _cycleT];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), [0,1] select ((CBA_missionTime - _fcrScanStartTime) >= 2.93)];
    if (_cycleT < 2.96 || _cycleT > 3.44) then {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
    } else {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
    };
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), 0];
};

//FCR page draw
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

private _scale      = (0.040625 * 8 / 8000);
private _heliCtr    = [0.5, 0.5];
private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];

private _pointsArray = [_heli, _displayTargets, _scanPos,
    _ntsIndex, _antsIndex, _scale, _heliCtr, _systemWas,
    _heli getVariable "fza_dms_shotAt", _fcrAzBias, _atmHalfFov, true
] call fza_mpd_fnc_buildFCRPoints;

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];
[_heli, _pointsArray, _mpdIndex, _scale, _heliCtr, _dir, _scanPos] call fza_mpd_fnc_drawIcons;
