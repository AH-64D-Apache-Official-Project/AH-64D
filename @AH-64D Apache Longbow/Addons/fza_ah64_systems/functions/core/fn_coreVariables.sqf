/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_variables

Description:
    ...

Parameters:
    _heli      - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_systems\headers\systems.hpp"

if (!(_heli getVariable ["fza_ah64_aircraftSystemsInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftSystemsInitialised", true, true];

    //Switch states
    _heli setVariable ["fza_systems_battSwitchOn",      false, true];

    //Electrical System
    //--Battery
    _heli setVariable ["fza_systems_battPower_pct",     1.0, true];
    //--Buses
    _heli setVariable ["fza_systems_battBusOn",         false, true];
    _heli setVariable ["fza_systems_acBusOn",           false, true];
    _heli setVariable ["fza_systems_dcBusOn",           false, true];
    //--Gen 1 and RTRU 1
    _heli setVariable ["fza_systems_gen1On",            false, true];
    _heli setVariable ["fza_systems_rect1On",           false, true];
    //--Gen 2 and RTRU 2
    _heli setVariable ["fza_systems_gen2On",            false, true];
    _heli setVariable ["fza_systems_rect2On",           false, true];

    //APU
    _heli setVariable ["fza_systems_apuBtnOn",          false, true];
    _heli setVariable ["fza_systems_apuRPM_pct",        0.0, true];
    _heli setVariable ["fza_systems_apuOn",             false, true];


    //Hydraulics
    _heli setVariable ["fza_systems_priHydPSI_pct",     1.0, true];
    _heli setVariable ["fza_systems_priLevel_pct",      1.0, true];
    _heli setVariable ["fza_systems_utilHydPSI_pct",    1.0, true];
    _heli setVariable ["fza_systems_utilLevel_pct",     1.0, true];
    _heli setVariable ["fza_systems_accHydPSI_pct",     1.0, true];
};

_heli setVariable ["fza_systems_apuStartDelay",     5.0];
_heli setVariable ["fza_systems_apuFF_kgs",         0.0];
_heli setVariable ["fza_systems_priHydPsi",         1.0];
_heli setVariable ["fza_systems_utilHydPsi",        1.0];
_heli setVariable ["fza_systems_dmgTimerCont",      0.0];
_heli setVariable ["fza_systems_dmgTimerTrans",     0.0];
_heli setVariable ["fza_systems_accHydPsi",         0.0];
private _battTime = SYS_BATT_TIMER * 60;
_heli setVariable ["fza_systems_battTimer",         _battTime];
private _leakTimer = SYS_LEAK_TIMER * 60;
_heli setVariable ["fza_systems_hydLeakTimer",      _leakTimer];
private _accTime = SYS_ACC_TIMER * 60;
_heli setVariable ["fza_systems_accTimer",          _accTime];