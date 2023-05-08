/* ----------------------------------------------------------------------------
Function: fza_fnc_currentTurret

Description:
     Returns the current turret of the player

     Can be modified to find the opposite turret instead.

Parameters:
    _heli - the aircraft to use this on
    _invert - (Optional) (default: false) Whether this mapping should be inverted (i.e. swap PLT and CPG)
    _person - (Optional) (default: player) the person who we are checking the turret status of

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_doortoggleP;
    statement="[this] spawn fza_fnc_doortoggleP";

Author:
    Unknown
---------------------------------------------------------------------------- */
params 
    [ "_heli"
    , ["_invert", false, [true]]
    , ["_person", player, [objNull]]
    ];

private _turret = _heli unitTurret _person;

if (_invert && _turret isEqualTo [0]) exitWith {[-1]};
if (_invert && _turret isEqualTo [-1]) exitWith {[0]};
_turret;