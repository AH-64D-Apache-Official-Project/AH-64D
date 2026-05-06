/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_buildFCRPoints

Description:
    Builds the FCR points array for an FCR MFD page from a pre-resolved display
    target list produced by fn_resolveDisplay. No reveal logic here — targets in
    _displayTargets are already filtered and have positions resolved.

    Shared by fn_fcrATMDraw and fn_fcrGTMDraw.

Parameters:
    _heli           - The helicopter
    _displayTargets - Pre-resolved array from fza_ah64_fcrDisplayTargets
                      Record: [pos, type, moving, obj, aziAngle, range, isGhost]
    _scanPos        - World position of the helicopter at last scan
    _ntsIndex       - Index of NTS target in _displayTargets (-1 = none)
    _antsIndex      - Index of ANTS target in _displayTargets (-1 = none)
    _scale          - MFD metres-to-screen scale factor
    _heliCtr        - [x, y] screen-space helicopter centre
    _systemWas      - fza_ah64_was value
    _shotATList     - fza_dms_shotAt array
    _fcrAzBias      - FCR azimuth bias in degrees
    _halfFov        - Half field-of-view in degrees (used to cull shot-at icons)
    _filterAirOnly  - (optional, default false) Skip non-air FCR targets when true

Returns:
    _pointsArray

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_displayTargets", "_scanPos", "_ntsIndex", "_antsIndex",
        "_scale", "_heliCtr", "_systemWas", "_shotATList", "_fcrAzBias",
        "_halfFov", ["_filterAirOnly", false]];

private _pointsArray   = [];
private _fcrPointCount = 0;

//Shot At UnderLay
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 0) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [([_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _halfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_range"];
    private _distance_m = _scanPos distance2D _pos;

    //FCR max show
    if (_fcrPointCount >= 16) exitWith {};

    if (_filterAirOnly && _type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) then {continue;};

    //Selection status
    private _selStatus = 0;
    if (_forEachIndex == _ntsIndex) then { _selStatus = 1; };
    if (_forEachIndex == _antsIndex) then { _selStatus = 2; };

    private _ident = [_type, _distance_m, _moving, _selStatus, _systemWas == WAS_WEAPON_NONE] call fza_mpd_fnc_buildFCRIdent;
    if (_ident == "") then {continue;};

    private _x = _heliCtr#0 + sin _aziAngle * (_range * _scale);
    private _y = _heliCtr#1 - cos _aziAngle * (_range * _scale);
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_x, _y, 0], "", POINT_TYPE_FCR, _forEachIndex, _ident];
    _fcrPointCount = _fcrPointCount + 1;
} forEach _displayTargets;

//Shot At Overlay
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay != 1) then {continue;};
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [([_heli getRelDir _shotPos] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _halfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_heliCtr#0 + sin _shotRelAzi * (_shotRange * _scale), _heliCtr#1 - cos _shotRelAzi * (_shotRange * _scale), 0], "", POINT_TYPE_BFT, _forEachIndex, "FCR_TSD_SHOTAT"];
} forEach _shotATList;

_pointsArray
