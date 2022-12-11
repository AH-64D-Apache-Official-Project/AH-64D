/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_SetPylonOwner

Description:
	
Parameters:
	
Returns:
	...

Examples:
	...

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_Wassing"];

_wassing = "rockets"; 
_turret = -1; 
_PylonInfo = getAllPylonsInfo _heli; 
if (_heli turretLocal [-1]) then {_turret = 0;}; 
[_heli, _wassing,_PylonInfo] remoteExec ["fza_weapons_fnc_SetPylonOwnerInternal", _heli turretUnit [_turret]]; 
[_heli, _wassing,_PylonInfo] call fza_weapons_fnc_SetPylonOwnerInternal;