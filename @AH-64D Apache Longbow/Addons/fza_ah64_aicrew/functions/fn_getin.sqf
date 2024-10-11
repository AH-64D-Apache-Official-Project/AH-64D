/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_getin


Description:
    handles what the ai does when he GETS IN

Parameters:
    heli: Object - Vehicle the event handler is assigned to
    role: String - Can be either "driver", "gunner" or "cargo"
    unit: Object - Unit that entered the vehicle
    turret: Array - turret path

Returns:
    Nothing

Examples:
    [_heli] call fza_aiCrew_fnc_getin
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_role", "_unit", "_turret"];

if (isplayer _unit) exitWith {};

if (_unit == driver _heli) then {
    sleep 1.2;
    [_heli] spawn fza_fnc_doortoggleP;
};

if (_unit == gunner _heli) then {
    sleep 1.2;
    [_heli] spawn fza_fnc_doortoggleG;
};