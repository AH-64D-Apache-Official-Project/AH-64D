/* ----------------------------------------------------------------------------
Function: fza_auxtank_fnc_damage

Description:
    Handles general damage to the aircraft. Determines whether a failure should be simulated and if so, sets it up.

Parameters:
    _heli - The helicopter to modify
    _system - The *HitPoint* that was damaged
    _damage - The damage amount of the *HitPoint* (0-1)

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_auxtank_fnc_damage
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli", "_system", "_damage"];

private _largeAmmoClass = "fza_ah64_auxtank_explosion_large";
private _mediumAmmoClass = "fza_ah64_auxtank_explosion_medium";
private _smallAmmoClass = "fza_ah64_auxtank_explosion_small";
private _ammoClass = _largeAmmoClass;

if (_system == "hit_msnEquip_pylon1" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#0] call BIS_fnc_inString) exitwith {};
    if (_heli getvariable "fza_sfmplus_stn1FuelMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn1FuelMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn1FuelMass" < 90) exitwith {};
    _AuxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [-2.38,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [1, ""];
    
};
if (_system == "hit_msnEquip_pylon2" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#4] call BIS_fnc_inString) exitwith {};
    if (_heli getvariable "fza_sfmplus_stn2FuelMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn2FuelMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn2FuelMass" < 90) exitwith {};
    _AuxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [-1.66,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [5, ""];
};
if (_system == "hit_msnEquip_pylon3" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#8] call BIS_fnc_inString) exitwith {};
    if (_heli getvariable "fza_sfmplus_stn3FuelMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn3FuelMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn3FuelMass" < 90) exitwith {};
    _AuxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [1.66,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [9, ""];
};
if (_system == "hit_msnEquip_pylon4" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#12] call BIS_fnc_inString) exitwith {};
    if (_heli getvariable "fza_sfmplus_stn4FuelMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn4FuelMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getvariable "fza_sfmplus_stn4FuelMass" < 90) exitwith {};
    _AuxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [2.38,2.3,-2]);   
    triggerAmmo _AuxtankExplosion; 
    _heli setPylonLoadout [13, ""];
};