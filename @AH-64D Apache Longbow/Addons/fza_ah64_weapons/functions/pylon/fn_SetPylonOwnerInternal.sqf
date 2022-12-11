/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_SetPylons

Description:
	swaps the hellfire and rockets between the pylons
	
Parameters:
	_heli - The helicopter object he code is to be executed on
	_WasSelect - Either "_rocketWas" or "_hellfirewas", this selection places these weapons on the pilot seat and the later on the gunner
	_PylonInfo - Output from func getAllPylonsInfo (recomended to pass in before messing with the pylons on 2 clients of the same helicopter at the same time, so input is identical)

Returns:
	...

Examples:
	...
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_WasSelect","_PylonInfo"];

_rocketWas = -1; 
_hellfirewas = -1;
if (_wasselect == "rockets") then {_hellfirewas = 0}; 
if (_wasselect == "Hellfire") then {_rocketWas = 0};
{
	_x params ["_pylonIndex","_pylonName","_assignedturret","_magazineName","_ammoCount"];
	if ("fza_agm114" in _MagazineName) then { 
		_heli removeMagazinesTurret [_MagazineName,[_rocketWas]];
	}; 
	if ("fza_275" in _MagazineName) then { 
		_heli removeMagazinesTurret [_MagazineName,[_hellfirewas]];
	}; 
} foreach _PylonInfo;
{    
	_x params ["_pylonIndex","_pylonName","_assignedturret","_magazineName","_ammoCount"];
	if ("fza_agm114" in _MagazineName) then { 
		_heli setPylonLoadout [_Pylonindex, _MagazineName, true, [_hellfirewas]]; 
		_heli setammoonpylon [_Pylonindex, _ammocount]; 
	}; 
	if ("fza_275" in _MagazineName) then { 
		_heli setPylonLoadout [_Pylonindex, _MagazineName, true, [_rocketWas]];
		_heli setammoonpylon [_Pylonindex, _ammocount];
	}; 
} foreach _PylonInfo;