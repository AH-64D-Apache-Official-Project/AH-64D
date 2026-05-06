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

private _pointsArray = [];
private _scale = (0.040625 * 8 / 8000);
private _heliCtr = [0.5, 0.5];

private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];

//Shot At UnderLay
private _shotATList = _heli getVariable "fza_dms_shotAt";
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 0) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [([_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _atmHalfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    private _distance_m = _scanPos distance2D _pos;

    //FCR max show
    if (count _pointsArray > 15) exitWith {};
    private _isGhost = (_x # 8 > 0);
    private _beforeReveal = (_fcrScanState != FCR_MODE_OFF && (CBA_missionTime - _lastFullCycle) < (_x # 7));
    if (_isGhost && (_x # 8 >= 3) && !_beforeReveal) then { continue; };
    if (!_isGhost && _beforeReveal) then {
        if (count _x > 9) then {
            _aziAngle = _x # 9;
            _range    = _x # 10;
        } else {
            continue;
        };
    };
    if (_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) then {continue;};

    //Selection status
    private _selStatus = 0;
    if (_forEachIndex == _ntsIndex) then { _selStatus = 1; };
    if (_forEachIndex == _antsIndex) then { _selStatus = 2; };

    private _ident = [_type, _distance_m, _moving, _selStatus, _systemWas == WAS_WEAPON_NONE] call fza_mpd_fnc_buildFCRIdent;
    if (_ident == "") then {continue;};

    private _x = _heliCtr#0 + sin _aziAngle * (_range * _scale);
    private _y = _heliCtr#1 - cos _aziAngle * (_range * _scale);
    private _uiCtr = [_x, _y, 0];

    _pointsArray pushBack [MPD_POSMODE_SCREEN, _uiCtr, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _displayTargets;

//Shot At Overlay
_shotATList = _heli getVariable "fza_dms_shotAt";
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 1) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [([_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _atmHalfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

private _fcrTgtCount = {
    (_x # 8) == 0
    && (_fcrScanState == FCR_MODE_OFF || (CBA_missionTime - _lastFullCycle) >= (_x # 7) || count _x > 9)
} count _displayTargets;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

[_heli, _pointsArray, _mpdIndex,  _scale, _heliCtr, _dir, _scanPos] call fza_mpd_fnc_drawIcons;
