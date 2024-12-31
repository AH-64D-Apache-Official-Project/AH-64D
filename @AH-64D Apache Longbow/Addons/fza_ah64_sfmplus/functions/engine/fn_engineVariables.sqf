/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engineVariables

Description:
    Defines core engine variables.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

//New
_heli setVariable ["fza_sfmplus_engState_new",          [0,0],          true];
_heli setVariable ["fza_sfmplus_engStartSwitchState",   [0,0],          true];
_heli setVariable ["fza_sfmplus_engThrottlePos",        [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engHasFuel",            [true,  true],  true];
_heli setVariable ["fza_sfmplus_engIsFuelCutoff",       [true,  true],  true];
_heli setVariable ["fza_sfmplus_engIsStarting",         [false, false], true];
_heli setVariable ["fza_sfmplus_engIsMotoring",         [false, false], true];
_heli setVariable ["fza_sfmplus_engIsOn",               [false, false], true];

_heli setVariable ["fza_sfmplus_engNg",                 [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engNp",                 [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engOil_psi",            [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engOil_temp",           [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_tgt",                   [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_fuelFlow",              [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engTq_out",             [0.0, 0.0],     true];
_heli setVariable ["fza_sfmplus_engTq_req",             [0.0, 0.0],     true];

//Old
if (!(_heli getVariable ["fza_ah64_aircraftEngineInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftEngineInitialised", true, true];

    _heli setVariable ["fza_sfmplus_engPowerLeverState",    [0, 0], true]; //OFF, IDLE, FLY
    _heli setVariable ["fza_sfmplus_engState",              ["OFF", "OFF"], true]; //OFF, STARTING, ON
};

if(isMultiplayer) then {
    _heli setVariable ["fza_sfmplus_lastTimePropagated", 0];
};

_heli setVariable ["fza_sfmplus_engIsOEI",           false];
_heli setVariable ["fza_sfmplus_isAutorotating",        false];

//Outputs
_heli setVariable ["fza_sfmplus_engFF",                 [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseNG",             [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctNG",              [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseNP",             [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctNP",              [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctTQ",              [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseTGT",            [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engTGT",                [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseOilPSI",         [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engOilPSI",             [0.0, 0.0]];