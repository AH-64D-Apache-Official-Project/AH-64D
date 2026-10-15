/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduUpdate

Description:
    Puts the unit's IHADSS helmet in the right HDU state. The HDU only shows
    while the unit is alive in an AH-64 crew seat with the monocle out. The
    HDU-on helmet only belongs on the head, so any copy in the unit's uniform,
    vest or backpack goes back to the HDU-off helmet. Helmets are paired
    through their fza_ah64_hduOn / fza_ah64_hduOff config entries; other
    headgear is left alone.

Parameters:
    _unit - Local unit to update

Returns:
    Nothing

Examples:
    [player] call fza_ihadss_fnc_hduUpdate;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_unit", objNull, [objNull]]];

if (!local _unit) exitWith {};

private _cfgWeapons = configFile >> "CfgWeapons";
private _heli       = objectParent _unit;
private _show       = alive _unit
    && {_heli isKindOf "fza_ah64base"}
    && {_unit == driver _heli || {_unit == gunner _heli}}
    && {!(_heli getVariable ["fza_ah64_monocleinbox", true])};

private _headgear = headgear _unit;
private _target   = getText (_cfgWeapons >> _headgear >> (["fza_ah64_hduOff", "fza_ah64_hduOn"] select _show));
if (_target != "" && {_target != _headgear}) then {
    _unit addHeadgear _target;
};

{
    _x params ["_items", "_fnc_swap"];
    {
        private _off = getText (_cfgWeapons >> _x >> "fza_ah64_hduOff");
        if (_off != "" && {_off != _x}) then {
            [_unit, _x, _off] call _fnc_swap;
        };
    } forEach _items;
} forEach [
    [uniformItems _unit,  {params ["_unit", "_from", "_to"]; _unit removeItemFromUniform _from;  _unit addItemToUniform _to;}],
    [vestItems _unit,     {params ["_unit", "_from", "_to"]; _unit removeItemFromVest _from;     _unit addItemToVest _to;}],
    [backpackItems _unit, {params ["_unit", "_from", "_to"]; _unit removeItemFromBackpack _from; _unit addItemToBackpack _to;}]
];
