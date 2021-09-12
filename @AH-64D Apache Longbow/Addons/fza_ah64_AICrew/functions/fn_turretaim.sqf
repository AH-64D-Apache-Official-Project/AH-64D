/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_turretaim


Description:

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_turretaim
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

/* currantly does not work*/
if (isplayer driver _heli && isplayer gunner _heli) exitWith {};


private _inhibit = "";
private _usingRocket = currentweapon _heli isKindOf["fza_hydra70", configFile >> "CfgWeapons"];
private _usingCannon = currentweapon _heli in ["fza_m230", "fza_burstlimiter"];

if (_usingCannon) then {
	private _pan = _heli animationPhase "tads_tur";
	private _tilt = _heli animationPhase "tads";
	if !(-86 < deg _pan && deg _pan < 86) then {
		_inhibit = "AZ LIMIT";
	};
	if !(-60 < deg _tilt && deg _tilt < 11) then {
		_inhibit = "EL LIMIT";
	};
    if (_inhibit != "") then {
        _safemessage = "_inhibit";
        _heli selectweapon "fza_burstlimiter";
    };
	_heli animateSource["mainTurret", [_pan, rad -86, rad 86] call BIS_fnc_clamp];
	_heli animateSource["mainGun", [_tilt, rad -60, rad 11] call BIS_fnc_clamp];
} else {
	_heli animateSource["mainTurret", 0];
	_heli animateSource["mainGun", 0.298];
};
_heli setVariable ["fza_ah64_weaponInhibited", _inhibit, true];