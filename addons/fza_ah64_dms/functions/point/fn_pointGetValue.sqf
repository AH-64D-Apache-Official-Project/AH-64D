params ["_heli", "_id", "_valueType"];

private _result = [_heli, _id] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;

// A file saved before it had its special points is shorter
private _point = _db param [_dbIndex, -1];
if (_point isEqualTo -1) exitWith {};
_point select _valueType
