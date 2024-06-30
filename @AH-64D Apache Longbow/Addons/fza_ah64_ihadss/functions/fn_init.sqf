/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_init

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
     _heli - the helicopter upon which to execute the code

Returns:
    Nothing

Examples:
    [_heli] call fza_hellfire_fnc_init
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_ihadssInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_ihadssInitialised", true, true];

    _heli setVariable ["fza_ah64_tadsStow",        true,    true];

    _heli setVariable ["fza_ah64_hmdfsmode",       "trans", true];
    _heli setVariable ["fza_ah64_monocleinbox",    true,    true];
    _heli setVariable ["fza_ah64_ihadss_pnvs_cam", false,   true];
       
    _heli setVariable ["fza_ah64_tadsThermal",     true,    true];
    _heli setVariable ["fza_ah64_tadsZoom",        0,       true];
    _heli setVariable ["fza_ah64_tadsA3ti",        false,   true];
};