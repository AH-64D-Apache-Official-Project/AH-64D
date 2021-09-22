/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponTrajectoryChange

Description:
	Cycles through the available hellfires trajectory

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_weaponTrajectoryChange

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

weaponState [_heli, [0]] params ["", "", "", "_magazine"];
_ammoType = getText (configFile / "CfgMagazines" / _magazine / "ammo");
if (_ammoType == "fza_agm114l") then {
	weaponState [_heli, [0]] params ["_weapon", "",  "_fireMode", "_magazine"];
	_nextFireMode = switch (_fireMode) do {
		case "Cruise": {"TopDown"};
		case "TopDown": {"LoalDistance"};
		case "LoalDistance": {"Cruise"};
		default {["Unknown missile fire mode: %1", _fireMode] call BIS_fnc_error};
	};
	[_heli, [0], _weapon, _nextFireMode, _magazine] call fza_fnc_weaponSelectFireMode;
	_heli setVariable ["fza_ah64_ltype", _nextFireMode, true];
} else {
	[] call ace_missileguidance_fnc_cycleAttackProfileKeyDown;
};