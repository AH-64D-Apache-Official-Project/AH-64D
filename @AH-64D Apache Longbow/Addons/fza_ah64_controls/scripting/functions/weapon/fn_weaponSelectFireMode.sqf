/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponSelectFireMode

Description:
    Selects the specific weapon AND firemode on a turret.

    May fail in some circumstances (if the firemode doesn't exist), if so will return false and log an error.

Parameters:
    _vehicle - The vehicle to apply this to
    _turret - The turret to work on
    _weapon - The name of the weapon to select - note this can also be done with the muzzle 
    _magazine - The magazine to select
    _fireMode - The name of the firemode to select
    
Returns:
	Bool - whether operation succeded

Examples:
    [_heli, [0], "fza_agm114_23_8", "TopDown"] call fza_fnc_weaponSelectFireMode;
Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_vehicle", "_turret", "_weapon", "_fireMode", ["_magazine", ""]];

if !(_vehicle turretLocal _turret) exitWith {
    ["Cannot switch turret's weapon, turret is not local"] call BIS_fnc_error;
    false;
};

_crewMember = _vehicle turretUnit _turret;

if (isNull _crewMember) exitWith {
    ["Cannot switch turret's weapon, there must be a crewmember in the seat"] call BIS_fnc_error;
    false;
};

_lastState = [];
_i = 0;
_crewMember action ["SwitchWeapon", _vehicle, _crewMember, 0];
while {!(_lastState isEqualTo (weaponState [_vehicle, _turret]))} do {
    _lastState = weaponState [_vehicle, _turret];
    _lastState params ["_curWep", "_curMuzz", "_curFireMode", "_curMag"];
    if ((_curWep == _weapon || _curMuzz == _weapon) && (_magazine == "" || _magazine == _curMag) && _curFireMode == _fireMode) exitWith {}; //Success!

    _i = _i + 1;
    _crewMember action ["SwitchWeapon", _vehicle, _crewMember, _i];
};

weaponState [_vehicle, _turret] params ["_curWep", "_curMuzz", "_curFireMode", "_curMag"];
if ((_curWep == _weapon || _curMuzz == _weapon) && (_magazine == "" || _magazine == _curMag) && _curFireMode == _fireMode) then {
    true
} else {
    ["Cannot switch turret's weapon, couldn't find (searched up to index %1)", _i] call BIS_fnc_error;
    false;
};