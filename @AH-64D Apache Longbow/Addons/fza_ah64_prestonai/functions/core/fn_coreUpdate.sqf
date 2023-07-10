params ["_heli"];

if (!isplayer driver _heli) then {
    private _deltaTime   = ["prestonai_deltaTime"] call BIS_fnc_deltaTime;

    [_heli] call fza_prestonai_fnc_coreContextMenu;

    [_heli, _deltaTime] call fza_prestonai_fnc_coreOutput;
};