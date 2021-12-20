params ["_heli", "_type", "_index"];

private _result = [_heli, _type, _index] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;
_db set [_dbIndex, -1];

_heli setVariable [_dbName, _db, true];
true;