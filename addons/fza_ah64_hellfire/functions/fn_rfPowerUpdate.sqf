/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_rfPowerUpdate

Description:
    Powers the RF missiles by the MSL PWR selection, with RF the selected
    missile type and none otherwise, on the machine where the turret is local,
    which alone writes the power state:

        ALL  - every RF missile
        AUTO - by the RF missiles available: 8 or more 4, 4-7 2, 2-3 1, 1 none
        NONE - none

    With AUTO or NONE leaving none powered, one is while missiles are
    actioned with RF selected. The missiles powered are the next to fire. A
    missile newly powered aligns and is ready RF_BOOT_MIN to RF_BOOT_MAX
    seconds later (fza_hellfire_fnc_rfState).

    Writes fza_ah64_rfPower, [[pylon slot 0-15, ready time], ...], only when
    the missiles powered change.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if !(_heli turretLocal [0]) exitWith {};

private _rfAmmo    = getText (configFile >> "CfgWeapons" >> "fza_agm114l_wep" >> "fza_ammoType");
private _inventory = [_heli] call fza_fnc_weaponMissileInventory;
// The RF missiles in the order they are fired, the one selected first (fza_fnc_weaponMissileGetSelected)
private _rfSlots   = MSL_FIRING_ORDER select {(_inventory # _x) isEqualTo _rfAmmo};
private _selected  = [_inventory, _rfAmmo, _heli] call fza_fnc_weaponMissileGetSelected;
if (_selected != -1) then {_rfSlots = [_selected] + (_rfSlots - [_selected])};
private _available = count _rfSlots;

// Powered only with RF the selected missile type
private _rfSelected = (_heli getVariable ["fza_ah64_selectedMissile", ""]) == "fza_agm114l_wep";
private _count = if (!_rfSelected) then {0} else {switch (_heli getVariable ["fza_ah64_mslPwr", MSL_PWR_AUTO]) do {
    case MSL_PWR_ALL:  {_available};
    case MSL_PWR_AUTO: {
        switch (true) do {
            case (_available >= 8): {4};
            case (_available >= 4): {2};
            case (_available >= 2): {1};
            default {0};
        };
    };
    default {0};
}};
if (_count == 0 && {_rfSelected && {_available > 0
    && {(_heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE]) == WAS_WEAPON_MSL}}}) then {
    _count = 1;
};

// Missiles still powered keep their ready time; one newly powered starts aligning
private _power = _heli getVariable ["fza_ah64_rfPower", []];
private _new   = (_rfSlots select [0, _count]) apply {
    private _slot = _x;
    private _was  = _power findIf {(_x # 0) == _slot};
    if (_was != -1) then {_power # _was} else {[_slot, CBA_missionTime + RF_BOOT_MIN + random (RF_BOOT_MAX - RF_BOOT_MIN)]};
};
[_heli, "fza_ah64_rfPower", _new] call fza_fnc_updateNetworkGlobal;
