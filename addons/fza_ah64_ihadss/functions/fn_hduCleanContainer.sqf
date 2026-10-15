/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduCleanContainer

Description:
    Replaces any HDU-on IHADSS helmet in a container (box, vehicle, ground
    holder) with its HDU-off counterpart.

Parameters:
    _container - Object with item cargo

Returns:
    Nothing

Examples:
    [_groundHolder] call fza_ihadss_fnc_hduCleanContainer;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_container", objNull, [objNull]]];

private _cfgWeapons = configFile >> "CfgWeapons";

(getItemCargo _container) params ["_classes", "_counts"];
{
    private _off = getText (_cfgWeapons >> _x >> "fza_ah64_hduOff");
    if (_off != "" && {_off != _x}) then {
        private _count = _counts select _forEachIndex;
        [_container, _x, _count] call CBA_fnc_removeItemCargo;
        _container addItemCargoGlobal [_off, _count];
    };
} forEach _classes;
