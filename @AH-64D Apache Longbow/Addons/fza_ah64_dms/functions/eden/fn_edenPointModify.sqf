params ["_logic"];

diag_log "Stuff happened here";

private _cfg = configOf _logic;

private _pointTypes = getArray (_cfg >> "fza_point_type");

private _index = _logic getVariable "fza_dms_point_index";

if !(isNil "_index") then {
    private _validIndex = true;
    {
        _validIndex = _validIndex || [_x, _index] call fza_dms_fnc_pointValidIndex;
    } forEach _pointTypes;

    if !_validIndex then {
        throw format ["Invalid index: '%1'", _index];
    };
};

private _ident = _logic getVariable "fza_dms_point_ident";

private _identType = -1;
if !(isNil "_ident") then {
    {
        if ([_x, _ident] call fza_dms_fnc_pointIsValidIdent) then {_identType = _x};
    } forEach _pointTypes;

    if (_identType == -1) then {
        throw format ["Invalid ident: '%1'", _ident];
    };
};

private _free = _logic getVariable "fza_dms_point_free";

if (!isNil "_free" && {count _free > 3}) then {
    throw format ["Free text cannot have more than 3 characters"];
};

if (isNil "_index" || isNil "_ident" || isNil "_free") exitWith {};

if !isServer exitWith {};

diag_log "Actually applying stuff";

[missionNamespace, [_identType, _index], _ident, _free, getPos _logic, getPosASL _logic # 2] call fza_dms_fnc_pointCreate;