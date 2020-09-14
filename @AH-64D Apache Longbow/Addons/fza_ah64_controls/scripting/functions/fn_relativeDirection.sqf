//usage: [relunit,unitposx,unitposy,relobjposx,relobjposy] call thisscript
private["_heli", "_heliposx", "_heliposy", "_relobjposx", "_relobjposy"];

_heli = _this select 0;
_heliposx = _this select 1;
_heliposy = _this select 2;
_relobjposx = _this select 3;
_relobjposy = _this select 4;

_reldir = (_relobjposx - _heliposx) atan2(_relobjposy - _heliposy);
if (_reldir < 0) then {
    _reldir = _reldir + 360;
};
_uniquereldir = (360 + (_reldir - (direction _heli))) Mod 360;

_uniquereldir;