/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_rfState

Description:
    The state of the next RF missile to fire (fza_hellfire_fnc_rfPowerUpdate):
    unpowered, or none left; powered and aligning; or ready to receive a
    target. An RF missile cannot be fired until it is ready.

Parameters:
    _heli - The helicopter

Returns:
    RF_STATE_UNPOWERED, RF_STATE_ALIGNING or RF_STATE_READY

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _rfAmmo = getText (configFile >> "CfgWeapons" >> "fza_agm114l_wep" >> "fza_ammoType");
private _slot   = [[_heli] call fza_fnc_weaponMissileInventory, _rfAmmo, _heli] call fza_fnc_weaponMissileGetSelected;
if (_slot == -1) exitWith {RF_STATE_UNPOWERED};

private _power = _heli getVariable ["fza_ah64_rfPower", []];
private _index = _power findIf {(_x # 0) == _slot};
if (_index == -1) exitWith {RF_STATE_UNPOWERED};
[RF_STATE_ALIGNING, RF_STATE_READY] select (CBA_missionTime >= ((_power # _index) # 1))
