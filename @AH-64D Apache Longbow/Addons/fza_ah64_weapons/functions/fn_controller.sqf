params ["_heli"];

_heli selectWeaponTurret ["fza_ma_safe", [0], "fza_ma_safe"];

if (player == driver _heli && !isPlayer gunner _heli && !isManualFire _heli) then {
    player action ["ManualFire", _heli];
};

_heli call fza_weapons_fnc_rocketPylonController;
_heli call fza_weapons_fnc_hellfirePylonController;
_heli call fza_weapons_fnc_cannonPylonController;
_heli call fza_weapons_fnc_pylonController;