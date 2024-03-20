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

if (_system == "hit_msnEquip_pylon1" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#0] call BIS_fnc_inString) exitwith {};
    _AuxtankExplosion = "ammo_Missile_mim145" createVehicle (_heli modelToWorld [-2.38,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [1, ""];
    
};
if (_system == "hit_msnEquip_pylon2") then {
    if !(["auxTank", (getPylonMagazines _heli)#4] call BIS_fnc_inString) exitwith {};
    _AuxtankExplosion = "fza_auxTank_explosion" createVehicle (_heli modelToWorld [-1.66,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [5, ""];
};
if (_system == "hit_msnEquip_pylon3" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#8] call BIS_fnc_inString) exitwith {};
    _AuxtankExplosion = "fza_auxTank_explosion" createVehicle (_heli modelToWorld [1.66,2.3,-2]);   
    triggerAmmo _AuxtankExplosion;
    _heli setPylonLoadout [9, ""];
};
if (_system == "hit_msnEquip_pylon4" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#12] call BIS_fnc_inString) exitwith {};
    _AuxtankExplosion = "fza_auxTank_explosion" createVehicle (_heli modelToWorld [2.38,2.3,-2]);   
    triggerAmmo _AuxtankExplosion; 
    _heli setPylonLoadout [13, ""];
};