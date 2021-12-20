params ["_heli", "_type", "_index", "_ident", "_freeText", "_armaPos", "_altMsl"];

if !([_type, _ident] call fza_dms_fnc_fza_dms_fnc_pointIsValidIdent) exitWith {false};

private _result = [_heli, _type, _index] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

_result = [_ident] call fza_dms_fnc_pointGetIdentDetails;
if (_result isEqualTo -1) exitWith {false};
_result params ["_iconTex", "_iconOffset"];


private _result = [_heli, _type, _idenmt] call fza_dms_fnc_pointGetArrayIndex;

private _gridCoord = [_armaPos] call fza_dms_fnc_posToGrid;
private _latLong = [_armaPos] call fza_dms_fnc_posToLatLong call fza_dms_fnc_latLongToString;

private _pointData = [_ident, _freeText, _type, _iconTex, _iconOffset, 0, _armaPos, _gridCoord, _latLong, _altMsl, (_altMsl - getTerrainHeightASL _armaPos) max 0];

private _db = _heli getVariable _dbName;
_db set [_dbIndex, _pointData];

_heli setVariable [_dbName, _db, true];
true;