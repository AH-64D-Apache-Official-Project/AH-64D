/* ----------------------------------------------------------------------------
Function: fza_fnc_relativeDirection

Description:
    Gets the direction of an object as a rotation in degrees off the nose of the aircraft

Parameters:
    _heli - The heli to use as the object to reference from
    _heliposx - The x position of the aforementioned heli
    _heliposy - The y position of the aforementoned heli
    _relobjposx - The x position of the object to reference from
    _relobjposy - The y position of the object to reference from

Returns:
    Degrees off the nose of the aircraft, normalised to (0 <= x <= 360)

Examples:
    --- Code
    [_heli, getPos _heli # 0, getPos _heli # 1, getPos _target # 0, getPos _target # 1] call fza_fnc_relativeDirection
    //_ret => 120
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_heliposx", "_heliposy", "_relobjposx", "_relobjposy", ["_heliDirection", direction (_this # 0)]];

_reldir = (_relobjposx - _heliposx) atan2(_relobjposy - _heliposy);
if (_reldir < 0) then {
    _reldir = _reldir + 360;
};
_uniquereldir = (360 + (_reldir - _heliDirection)) Mod 360;

_uniquereldir;