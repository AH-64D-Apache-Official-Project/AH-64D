/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_getout


Description:
    Handles shutdown of SFM+ when AI pilot Gets out

Parameters:
    heli: Object - Vehicle the event handler is assigned to
    role: String - Can be either "driver", "gunner" or "cargo"
    unit: Object - Unit that left the vehicle
    turret: Array - turret path

Returns:
    Nothing

Examples:
    [_heli] call fza_aiCrew_fnc_getout

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_role", "_unit", "_turret"];

if (isplayer _unit) exitWith {};

if (_unit == driver _heli) then {
    //Ai variables
    _heli setVariable ["fza_ah64_aiESStop", true];

    //engine
    _heli setVariable ["fza_sfmplus_engStartSwihState",     ["OFF", "OFF"]];
    _heli setVariable ["fza_sfmplus_engState",              ["OFF", "OFF"]];
    _heli setVariable ["fza_sfmplus_engPowerLeverState",    ["OFF", "OFF"]];
    [_heli, "fza_ah64_powerLever1", 0, 10] call fza_fnc_animSetValue;
    [_heli, "fza_ah64_powerLever2", 0, 10] call fza_fnc_animSetValue;
    [_heli, "fza_ah64_apu", false] call fza_fnc_animSetValue;
    [_heli, "fza_ah64_battery", false] call fza_fnc_animSetValue;
    [_heli, "fza_ah64_rtrbrake", true] call fza_fnc_animSetValue;
};