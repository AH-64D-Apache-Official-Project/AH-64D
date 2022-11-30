/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_PylonSwapper

Description:
	swaps the hellfire and rockets between the pylons
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

DEBUG:
	_heli = vehicle player; 
    _wassing = "rockets"; 
    _turret = -1; 
    _PylonInfo = getAllPylonsInfo vehicle player; 
    if (vehicle player turretLocal [-1]) then {_turret = 0;}; 
    [_wassing,_PylonInfo,_heli] remoteExec ["fza_weapons_fnc_pylonswapper", vehicle player turretUnit [_turret]]; 
    [_wassing,_PylonInfo,_heli] call fza_weapons_fnc_pylonswapper;


Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_wasselect","_PylonInfo","_heli"];

_RocketWas = 0; 
_hellfirewas = 0;
if (_wasselect == "rockets") then {_RocketWas = -1}; 
if (_wasselect == "Hellfire") then {_hellfirewas = -1};
{
	_x params ["_Pylonindex","_PylonName","_Assignedturret","_MagazineName","_ammocount"]; 
	if ("fza_agm114" in _MagazineName) then { 
		_heli removeMagazinesTurret [_MagazineName,[_RocketWas]];
	}; 
	if ("fza_275" in _MagazineName) then { 
		_heli removeMagazinesTurret [_MagazineName,[_hellfirewas]];
	}; 
} foreach _PylonInfo;
{    
	_x params ["_Pylonindex","_PylonName","_Assignedturret","_MagazineName","_ammocount"]; 
	if ("fza_agm114" in _MagazineName) then { 
		_heli setPylonLoadout [_Pylonindex, _MagazineName, true, [_hellfirewas]]; 
		_heli setammoonpylon [_Pylonindex, _ammocount]; 
	}; 
	if ("fza_275" in _MagazineName) then { 
		_heli setPylonLoadout [_Pylonindex, _MagazineName, true, [_RocketWas]];
		_heli setammoonpylon [_Pylonindex, _ammocount];
	}; 
} foreach _PylonInfo;

//remove weapons
_heli removeWeaponTurret ["fza_agm114A_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_agm114C_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_agm114k_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_agm114L_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_agm114M_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_agm114N_wep",[_RocketWas]];
_heli removeWeaponTurret ["fza_275_m151_wep",[_hellfirewas]];
_heli removeWeaponTurret ["fza_275_m229_wep",[_hellfirewas]];
_heli removeWeaponTurret ["fza_275_m261_wep",[_hellfirewas]];
_heli removeWeaponTurret ["fza_275_m257_wep",[_hellfirewas]];
_heli removeWeaponTurret ["fza_275_m255_wep",[_hellfirewas]];