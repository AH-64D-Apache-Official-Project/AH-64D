params ["_heli"];

_heli selectWeaponTurret ["fza_ma_safe", [0], "fza_ma_safe"];

_heli call fza_weapons_fnc_rocketPylonController;
_heli call fza_weapons_fnc_hellfirePylonController;
_heli call fza_weapons_fnc_cannonPylonController;
_heli call fza_weapons_fnc_pylonController;