params ["_heli", "_type", "_index", "_valueType"];

private _result = [_heli, _type, _index] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;

if (_db # _dbIndex isEqualTo -1) exitWith {};
_db # _dbIndex select _valueType