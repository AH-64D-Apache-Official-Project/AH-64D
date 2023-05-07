params ["_heli", "_id"];

private _result = [_heli, _id] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;
_db set [_dbIndex, -1];

_heli setVariable [_dbName, _db, true];
["fza_dms_pointDeleted", [_heli, _id]] call CBA_fnc_globalEvent;
true;