/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_init

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_fire_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_fire_aircraftInitialised", true, true];
    //System States
    _heli setVariable ["fza_ah64_apu_fire", false, true];
    _heli setVariable ["fza_ah64_e1_fire", false, true];
    _heli setVariable ["fza_ah64_e2_fire", false, true];
    _heli setVariable ["fza_ah64_firepdisch", false, true];
    _heli setVariable ["fza_ah64_firerdisch", false, true];
    
    _heli setVariable ["fza_ah64_fireArmed1", [false, 0, CBA_missionTime], true];
    _heli setVariable ["fza_ah64_fireArmed2", [false, 0, CBA_missionTime], true];
    _heli setVariable ["fza_ah64_fireArmedApu", [false, 0, CBA_missionTime], true];
};
_heli setVariable ["fza_ah64_fire_left_fx", []];
_heli setVariable ["fza_ah64_fire_right_fx", []];
_heli setVariable ["fza_ah64_fire_apu_fx", []];
_heli setVariable ["fza_ah64_firetest", 0];