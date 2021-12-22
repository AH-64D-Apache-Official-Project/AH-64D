#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_id", "_ident", "_freeText", "_armaPos", "_altMsl"];
if (_id isEqualTo []) exitWith {false};
_id params ["_type", "_index"];
if !([_type, _ident] call fza_dms_fnc_fza_dms_fnc_pointIsValidIdent) exitWith {false};

private _result = [_heli, _id] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

_result = [_ident] call fza_dms_fnc_pointGetIdentDetails;
if (isNil "_result") exitWith {false};
_result params ["_iconTex", "", "_color", "_iconType", "_iconText1", "_iconText2"];

private _gridCoord = [_armaPos] call fza_dms_fnc_posToGrid;
private _latLong   = [_armaPos] call fza_dms_fnc_posToLatLong call fza_dms_fnc_latLongToString;

private _pointData = 
    [ MPD_POSMODE_WORLD
    , _armaPos
    , _iconTex
    , _color
    , _iconType
    , [_iconText1, _index, _freeText] call fza_dms_fnc_pointFillIconText
    , [_iconText2, _index, _freeText] call fza_dms_fnc_pointFillIconText
    , _freeText
    , _type
    , _ident
    , _gridCoord
    , _latLong
    , _altMsl
    , (_altMsl - getTerrainHeightASL _armaPos) max 0];

private _db = _heli getVariable _dbName;
_db set [_dbIndex, _pointData];

_heli setVariable [_dbName, _db, true];
true;