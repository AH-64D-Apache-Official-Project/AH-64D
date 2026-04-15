/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_ageShot

Description:
    Sets all records in the Shot file to old, underlaying them on the FCR and TSD

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_dms_fnc_ageShot;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _shotAtArray = _heli getvariable "fza_dms_shotAt";
{
    _x params ["_index", "_ident", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    if (_x isEqualTo -1) then {continue;};
    if (_overlay == 0) then {continue;};
    _x set [6, 0];
} foreach _shotAtArray;

[_heli, "fza_dms_shotAt", _shotAtArray] call fza_fnc_updateNetworkGlobal;
