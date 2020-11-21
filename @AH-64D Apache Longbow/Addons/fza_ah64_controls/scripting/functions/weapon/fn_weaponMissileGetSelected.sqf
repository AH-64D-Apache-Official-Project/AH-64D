params ["_inventory", "_ammo"];
_priorities = [0,12,1,13,2,14,3,15,4,8,5,9,6,10,7,11];
_index = _priorities findIf {_inventory # _x isEqualTo _ammo};

if (_index == -1) exitWith {-1};
_priorities # _index