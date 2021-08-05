/* ----------------------------------------------------------------------------
Function: fza_fnc_targetIsADA

Description:
    Returns whether the object should be counted as air defence artillery.

Parameters:
    _unit - The unit to check.

Returns:
	Bool - whether the aircraft is Air Defence Artillery or not.

Examples:
	if ([_x] call fza_fnc_targetIsADA) then {
		
    --- Code
	_ret = [_unit] call fza_fnc_targetIsADA
	//_ret => true
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_unit"];
_unit = typeof _unit;

//Active radar
_radarRange = getNumber (configFile >> "CfgVehicles" >> _unit >> "components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent" >> "AirTarget">> "maxRange");
if (_Radarrange > 0 && (_unit isKindOf "Land")) exitwith {true};
//Passed all checks, returns false
false;


/* // future expanision if active alone is to narrow
//Passive radar
_radarRange = getNumber (configFile >> "CfgVehicles" >> _unit >> "components" >> "SensorsManagerComponent" >> "Components" >> "PassiveRadarSensorComponent" >> "AirTarget">> "maxRange");
if (_Radarrange > 0 && (_unit isKindOf "Land")) exitwith {true};
//ir detection
_radarRange = getNumber (configFile >> "CfgVehicles" >> _unit >> "components" >> "SensorsManagerComponent" >> "Components" >> "IRSensorComponent" >> "AirTarget">> "maxRange");
if (_Radarrange > 0 && (_unit isKindOf "Land")) exitwith {true};
*/