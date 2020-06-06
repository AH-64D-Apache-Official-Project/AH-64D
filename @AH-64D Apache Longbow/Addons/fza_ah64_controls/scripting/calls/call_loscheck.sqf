private["_heli", "_target"];
_heli = _this select 0;

if (!(player in _heli)) exitwith {};

_target = _this select 1;

if ((terrainIntersect[aimpos _heli, getPosASL _target]) || (lineIntersects[aimpos _heli, getPosASL _target, _heli, _target])) then {};