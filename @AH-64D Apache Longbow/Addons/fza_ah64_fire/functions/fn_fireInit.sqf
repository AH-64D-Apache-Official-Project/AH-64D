/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_fireInit

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
    
    _heli setVariable ["fza_ah64_fire1arm", false, true];
    _heli setVariable ["fza_ah64_fire2arm", false, true];
    _heli setVariable ["fza_ah64_fireapuarm", false, true];
};
_heli setVariable ["fza_ah64_fire_left_fx", []];
_heli setVariable ["fza_ah64_fire_right_fx", []];
_heli setVariable ["fza_ah64_fire_apu_fx", []];