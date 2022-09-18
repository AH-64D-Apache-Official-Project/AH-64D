/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsVariables

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
#include "\fza_ah64_sfmplus\headers\systems.hpp"

//Switch states
_heli setVariable ["fza_sfmplus_battSwitchState",   "OFF"];

//Electrical System
//--Battery
_heli setVariable ["fza_sfmplus_battPower_pct",     1.0];
private _battTime = SYS_BATT_TIMER * 60;
_heli setVariable ["fza_sfmplus_battTimer",         _battTime];
//--Buses
_heli setVariable ["fza_sfmplus_battBusState",      "OFF"];
_heli setVariable ["fza_sfmplus_ACBusState",        "OFF"];
_heli setVariable ["fza_sfmplus_DCBusState",        "OFF"];
//--Gen 1 and RTRU 1
_heli setVariable ["fza_sfmplus_gen1State",         "OFF"];
_heli setVariable ["fza_sfmplus_rtru1State",        "OFF"];
//--Gen 2 and RTRU 2
_heli setVariable ["fza_sfmplus_gen2State",         "OFF"];
_heli setVariable ["fza_sfmplus_rtru2State",        "OFF"];

//APU
_heli setVariable ["fza_sfmplus_apuBtnState",       "OFF"];
_heli setVariable ["fza_sfmplus_apuStartDelay",     5.0];
_heli setVariable ["fza_sfmplus_apuRPM_pct",        0.0];
_heli setVariable ["fza_sfmplus_apuState",          "OFF"];

//Damage
_heli setVariable ["fza_sfmplus_dmgTimerCont",      0.0];
_heli setVariable ["fza_sfmplus_dmgTimerTrans",     0.0];

//Hydraulics
_heli setVariable ["fza_sfmplus_priHydPSI_pct",     1.0];
_heli setVariable ["fza_sfmplus_priHydPsi",         0.0];
_heli setVariable ["fza_sfmplus_priLevel_pct",      1.0];

_heli setVariable ["fza_sfmplus_utilHydPSI_pct",    1.0];
_heli setVariable ["fza_sfmplus_utilHydPsi",        0.0];
_heli setVariable ["fza_sfmplus_utilLevel_pct",     1.0];

_heli setVariable ["fza_sfmplus_accHydPSI_pct",     1.0];
private _accTime = SYS_ACC_TIMER * 60;
_heli setVariable ["fza_sfmplus_accTimer",         _accTime];
_heli setVariable ["fza_sfmplus_utilHydPsi",        0.0];