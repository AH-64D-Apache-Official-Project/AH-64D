params ["_heli"];

if (!isplayer driver _heli) then {
    [_heli] call fza_prestonai_fnc_coreContextMenu;
};