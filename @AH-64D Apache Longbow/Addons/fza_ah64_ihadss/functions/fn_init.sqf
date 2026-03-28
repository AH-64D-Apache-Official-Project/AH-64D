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
    _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 0,   true];
       
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

["colorCorrections", 400, [0.95, 0.75, -0.05, [0.25, 0.25, 0.25, 0.0], [1, 1, 1, 0], [0.33, 0.33, 0.33, 0], [0, 0, 0, 0, 0, 0, 4]]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_monoChromeEffect = ppEffectCreate [_name, _priority];
        fza_ah64_monoChromeEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_monoChromeEffect ppEffectAdjust _effect;
    fza_ah64_monoChromeEffect ppEffectCommit 0;
};

["Resolution", 400, [360]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_flirResolutionEffect = ppEffectCreate [_name, _priority];
        fza_ah64_flirResolutionEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_flirResolutionEffect ppEffectAdjust _effect;
    fza_ah64_flirResolutionEffect ppEffectCommit 0;
};

["colorCorrections", 400, [1.00, 0.95, -0.05, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], [0.55, 0.55, 0.55, 0], [0, 0, 0, 0, 0, 0, 4]]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_dvoEffect = ppEffectCreate [_name, _priority];
        fza_ah64_dvoEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_dvoEffect ppEffectAdjust _effect;
    fza_ah64_dvoEffect ppEffectCommit 0;
};

["ChromAberration", 400, [0.0075, 0.0075, false]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_chromAberrationEffect = ppEffectCreate [_name, _priority];
        fza_ah64_chromAberrationEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_chromAberrationEffect ppEffectAdjust _effect;
    fza_ah64_chromAberrationEffect ppEffectCommit 0;
};

["DynamicBlur", 400, [0.3]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_flirBlurEffect = ppEffectCreate [_name, _priority];
        fza_ah64_flirBlurEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_flirBlurEffect ppEffectAdjust _effect;
    fza_ah64_flirBlurEffect ppEffectCommit 0;
};

["colorCorrections", 400, [0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]] spawn
{
    params ["_name", "_priority", "_effect", "_handle"];
    while {
        fza_ah64_blackScreenEffect = ppEffectCreate [_name, _priority];
        fza_ah64_blackScreenEffect < 0
    } do {
        _priority = _priority + 1;
    };
    fza_ah64_blackScreenEffect ppEffectAdjust _effect;
    fza_ah64_blackScreenEffect ppEffectCommit 0;
};