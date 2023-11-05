/* ----------------------------------------------------------------------------
Function: fza_wca_fnc_init


Description:
    initilizes the values for the helicopter

Parameters:
    Heli: Object - The helicopter to modify

Returns:
    Nothing

Examples:
    [_heli] call fza_laser_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_wcaInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_wcaInitialised", true, true];
    
    _heli setVariable ["fza_ah64_emerHydOn",              false, true];
    _heli setVariable ["fza_ah64_gndOrideOn",             false, true];
    _heli setVariable ["fza_ah64_armSafeArmed",           false, true];
    _heli setVariable ["fza_ah64_mstrCautAudioOn",        false, true];
    _heli setVariable ["fza_ah64_activeCaut", createHashMapFromArray [["exists", true]], true];
    _heli setVariable ["fza_ah64_mstrWarnAudioOn",        false, true];
    _heli setVariable ["fza_ah64_activeWarn", createHashMapFromArray [["exists", true]], true];
    _heli setVariable ["fza_ah64_engineOverspeed",        [false, false], true];
    _heli setVariable ["fza_ah64_mstrCautLightOn",        false, true];
    _heli setVariable ["fza_ah64_mstrWarnLightOn",        false, true];
};