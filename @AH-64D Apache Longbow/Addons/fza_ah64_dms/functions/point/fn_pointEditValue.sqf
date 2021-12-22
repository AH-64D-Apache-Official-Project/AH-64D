#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_id", "_valueType", "_newValue"];
private _result = [_heli, _id] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;

private _dbRow = _db # _dbIndex;

private _operationCompleted = false;

switch (_valueType) do {
    case POINT_SET_FREE_TEXT: {
        _id params ["_index"];

        private _ident = _dbRow # POINT_GET_IDENT;

        [_ident] call fza_dms_fnc_pointGetIdentDetails params ["", "", "", "", "_iconText1", "_iconText2"];

        _dbRow set [POINT_GET_FREE_TEXT, _newValue];
        _dbRow set [POINT_GET_ICON_TEXT_A, [_iconText1, _index, _newValue] call fza_dms_fnc_pointFillIconText];
        _dbRow set [POINT_GET_ICON_TEXT_B, [_iconText2, _index, _newValue] call fza_dms_fnc_pointFillIconText];
        _operationCompleted = true;
    };
    case POINT_SET_ARMA_POS: {
        private _altMsl = _dbRow # POINT_GET_ALT_MSL;
        _dbRow set [POINT_GET_ARMA_POS, _newValue];
        _dbRow set [POINT_GET_GRID_COORD, [_newValue] call fza_dms_fnc_posToGrid];
        _dbRow set [POINT_GET_LAT_LONG, [_newValue] call fza_dms_fnc_posToLatLong call fza_dms_fnc_latLongToString];
        _dbRow set [POINT_GET_ALT_AGL, (_altMsl - getTerrainHeightASL _newValue) max 0];
        _operationCompleted = true;
    };
    case POINT_SET_ALT_MSL: {
        private _pos = _dbRow # POINT_GET_ARMA_POS;
        _dbRow set [POINT_GET_ALT_MSL, _newValue];
        _dbRow set [POINT_GET_ALT_AGL, (_altMsl - getTerrainHeightASL _armaPos) max 0];
        _operationCompleted = true;
    };
};

if !(_operationCompleted) exitWith {false};

_heli setVariable [_dbName, _db, true];
true;