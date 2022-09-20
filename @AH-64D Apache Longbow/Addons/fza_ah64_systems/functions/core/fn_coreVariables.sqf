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

//Switch states
_heli setVariable ["fza_systems_battSwitchState",   "OFF"];

//Electrical System
//--Battery
_heli setVariable ["fza_systems_battPower_pct",     1.0];
private _battTime = SYS_BATT_TIMER * 60;
_heli setVariable ["fza_systems_battTimer",         _battTime];
//--Buses
_heli setVariable ["fza_systems_battBusState",      "OFF"];
_heli setVariable ["fza_systems_ACBusState",        "OFF"];
_heli setVariable ["fza_systems_DCBusState",        "OFF"];
//--Gen 1 and RTRU 1
_heli setVariable ["fza_systems_gen1State",         "OFF"];
_heli setVariable ["fza_systems_rtru1State",        "OFF"];
//--Gen 2 and RTRU 2
_heli setVariable ["fza_systems_gen2State",         "OFF"];
_heli setVariable ["fza_systems_rtru2State",        "OFF"];

//APU
_heli setVariable ["fza_systems_apuBtnState",       "OFF"];
_heli setVariable ["fza_systems_apuStartDelay",     5.0];
_heli setVariable ["fza_systems_apuRPM_pct",        0.0];
_heli setVariable ["fza_systems_apuState",          "OFF"];
_heli setVariable ["fza_systems_apuFF_kgs",         0.0];

//Damage
_heli setVariable ["fza_systems_dmgTimerCont",      0.0];
_heli setVariable ["fza_systems_dmgTimerTrans",     0.0];

//Hydraulics
_heli setVariable ["fza_systems_priHydPSI_pct",     1.0];
_heli setVariable ["fza_systems_priHydPsi",         0.0];
_heli setVariable ["fza_systems_priLevel_pct",      1.0];

_heli setVariable ["fza_systems_utilHydPSI_pct",    1.0];
_heli setVariable ["fza_systems_utilHydPsi",        0.0];
_heli setVariable ["fza_systems_utilLevel_pct",     1.0];

_heli setVariable ["fza_systems_accHydPSI_pct",     1.0];
private _accTime = SYS_ACC_TIMER * 60;
_heli setVariable ["fza_systems_accTimer",          _accTime];
_heli setVariable ["fza_systems_accHydPsi",         0.0];

private _leakTimer = SYS_LEAK_TIMER * 60;
_heli setVariable ["fza_systems_hydLeakTimer",      _leakTimer];