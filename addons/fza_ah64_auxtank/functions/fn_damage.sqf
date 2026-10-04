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
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_system", "_damage"];

private _largeAmmoClass = "fza_ah64_auxtank_explosion_large";
private _mediumAmmoClass = "fza_ah64_auxtank_explosion_medium";
private _smallAmmoClass = "fza_ah64_auxtank_explosion_small";
private _ammoClass = _largeAmmoClass;

if (_system == "hit_msnEquip_pylon1" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#0] call BIS_fnc_inString) exitWith {};
    if (_heli getVariable "bmkhs_stn1TankMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getVariable "bmkhs_stn1TankMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getVariable "bmkhs_stn1TankMass" < 90) exitWith {};
    _auxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [-2.38,2.3,-2]);
    triggerAmmo _auxtankExplosion;
    _heli setPylonLoadout [1, ""];

};
if (_system == "hit_msnEquip_pylon2" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#4] call BIS_fnc_inString) exitWith {};
    if (_heli getVariable "bmkhs_stn2TankMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getVariable "bmkhs_stn2TankMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getVariable "bmkhs_stn2TankMass" < 90) exitWith {};
    _auxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [-1.66,2.3,-2]);
    triggerAmmo _auxtankExplosion;
    _heli setPylonLoadout [5, ""];
};
if (_system == "hit_msnEquip_pylon3" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#8] call BIS_fnc_inString) exitWith {};
    if (_heli getVariable "bmkhs_stn3TankMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getVariable "bmkhs_stn3TankMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getVariable "bmkhs_stn3TankMass" < 90) exitWith {};
    _auxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [1.66,2.3,-2]);
    triggerAmmo _auxtankExplosion;
    _heli setPylonLoadout [9, ""];
};
if (_system == "hit_msnEquip_pylon4" && _damage > SYS_WPN_DMG_THRESH) then {
    if !(["auxTank", (getPylonMagazines _heli)#12] call BIS_fnc_inString) exitWith {};
    if (_heli getVariable "bmkhs_stn4TankMass" < 450) then {_ammoClass = _mediumAmmoClass;};
    if (_heli getVariable "bmkhs_stn4TankMass" < 200) then {_ammoClass = _smallAmmoClass;};
    if (_heli getVariable "bmkhs_stn4TankMass" < 90) exitWith {};
    _auxtankExplosion = _ammoClass createVehicle (_heli modelToWorld [2.38,2.3,-2]);
    triggerAmmo _auxtankExplosion;
    _heli setPylonLoadout [13, ""];
};
