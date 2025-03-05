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
       
    _heli setVariable ["fza_ah64_tadsVision",     "FLIR",    true];
    _heli setVariable ["fza_ah64_tadsZoom",        0,       true];
    _heli setVariable ["fza_ah64_tadsA3ti",        false,   true];
    
    //Tads
    _heli setVariable ["fza_ah64_lmcConstant",            [0,0], true];
    _heli setVariable ["fza_ah64_LmcActive",              false, true];
    _heli setVariable ["fza_ah64_lmcPosition",            [],    true];
    _heli setVariable ["fza_ah64_lmcStartRange",          1000,    true];
    _heli setVariable ["fza_ah64_lmcRange",          1000,    true];
};

fza_ah64_monoChromeEffect = ppEffectCreate["colorCorrections", 4000];
fza_ah64_monoChromeEffect ppEffectAdjust[1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.33, 0.33, 0.33, 0], [0, 0, 0, 0, 0, 0, 4]];
fza_ah64_monoChromeEffect ppEffectCommit 0;

fza_ah64_flirResolutionEffect = ppEffectCreate["Resolution", 4001];
fza_ah64_flirResolutionEffect ppEffectAdjust [420];
fza_ah64_flirResolutionEffect ppEffectCommit 0;

fza_ah64_blackScreenEffect = ppEffectCreate ["colorCorrections",1498];
fza_ah64_blackScreenEffect ppEffectAdjust [0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
fza_ah64_blackScreenEffect ppEffectCommit 0;