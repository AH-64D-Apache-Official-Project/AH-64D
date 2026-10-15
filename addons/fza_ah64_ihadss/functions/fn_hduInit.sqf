/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduInit

Description:
    Registers the player events that keep the IHADSS HDU state correct:
    unit, loadout, vehicle and seat changes, items put into containers, and
    death.

Parameters:
    None

Returns:
    Nothing

Examples:
    call fza_ihadss_fnc_hduInit;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

{
    [_x, {[_this#0] call fza_ihadss_fnc_hduUpdate}, true] call CBA_fnc_addPlayerEventHandler;
} forEach ["unit", "loadout", "vehicle", "turret"];

["fza_ah64_hduPut", "Put", {
    params ["", "_container", "_item"];
    private _off = getText (configFile >> "CfgWeapons" >> _item >> "fza_ah64_hduOff");
    if (_off != "" && {_off != _item}) then {
        [_container] call fza_ihadss_fnc_hduCleanContainer;
    };
}] call CBA_fnc_addBISPlayerEventHandler;

["fza_ah64_hduKilled", "Killed", {
    [_this#0] call fza_ihadss_fnc_hduUpdate;
}] call CBA_fnc_addBISPlayerEventHandler;
