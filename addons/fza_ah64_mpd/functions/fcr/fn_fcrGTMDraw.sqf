#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _displayTargets = _heli getVariable "fza_ah64_fcrTargets";
private _systemWas = _heli getVariable "fza_ah64_was";

//FCR wiper
// Use the later of scan-start or last-update as reference:
//   first scan: _fcrScanStartTime is newest → wiper starts at 0
//   subsequent scans: _time resets each fn_update → no end-of-cycle flicker
private _fcrScanDeltaTime = CBA_missionTime - (_fcrScanStartTime max _time);
if (_fcrScanState != FCR_MODE_OFF) then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _fcrScanDeltaTime % 3.2];
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

private _pointsArray = [];
private _scale = (0.08125 * 8 / 8000);
private _heliCtr = [0.5, 0.87];

private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

//Shot At UnderLay
private _shotATList = _heli getVariable "fza_dms_shotAt";
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 0) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [[_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180 - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _gtmHalfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    private _distance_m = _scanPos distance2D _pos;

    //FCR max show
    if (count _pointsArray > 15) exitWith {};
    //Sweep reveal: tracked targets visible at prev position before bar passes; fresh targets hidden
    private _beforeReveal = (_fcrScanState != FCR_MODE_OFF && _fcrScanDeltaTime < (_x # 7));
    if (_beforeReveal) then {
        if (count _x > 9) then {
            // Tracked target: display at heading-corrected previous position until bar sweeps past
            _aziAngle = _x # 9;
            _range    = _x # 10;
        } else {
            continue; // Fresh target: hidden until bar sweeps past
        };
    };

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
private _shotATList = _heli getVariable "fza_dms_shotAt";
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 1) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [[_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180 - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _gtmHalfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

//Total target count (ghosts excluded)
private _fcrTgtCount  = { (count _x) < 9 || (_x # 8) == 0 } count _displayTargets;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

[_heli, _pointsArray, _mpdIndex,  _scale, _heliCtr, _dir, _scanPos] call fza_mpd_fnc_drawIcons;
