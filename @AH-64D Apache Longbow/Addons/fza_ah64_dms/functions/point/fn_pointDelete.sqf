params ["_heli", "_id"];

private _result = [_heli, _id] call fza_dms_fnc_pointGetArrayIndex;

if (_result isEqualTo -1) exitWith {false};
_result params ["_dbName", "_dbIndex"];

private _db = _heli getVariable _dbName;
_db set [_dbIndex, -1];

_heli setVariable [_dbName, _db, true];

private _routeData = _heli getVariable "fza_ah64_routeData";
{
    private _routeIndex = _foreachindex;
    private _routeArray = _x;
    {
        if (_x isEqualTo _id) then {
            _rteIndex = _heli getVariable "fza_ah64_routeCurPnt";
            _routeArray deleteAt _foreachindex;
            _routeData set [_routeIndex, _routeArray];
            if (_foreachindex == _rteIndex) then {
                [_heli, "fza_ah64_routeCurPnt", -1] call fza_fnc_updateNetworkGlobal;
                _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];
            };
            if (_foreachindex < _rteIndex) then {
                [_heli, "fza_ah64_routeCurPnt", (_rteIndex - 1)] call fza_fnc_updateNetworkGlobal;
                _heli setVariable ["fza_mpd_tsdRteCurrentRvw", (_rteIndex - 1)];
            };
        };
    } forEachReversed _x;
} foreach _routeData;

["fza_dms_pointDeleted", [_heli, _id]] call CBA_fnc_globalEvent;
true;