params ["_heli"];

//Needs to pull from config...
_heli setVariable ["fza_sfmplus_simpleEng_idleDelayMax",  1.0];
_heli setVariable ["fza_sfmplus_simpleEng_n1_start",      0.23];
_heli setVariable ["fza_sfmplus_simpleEng_startTimeMax", 60.0];

//Engine states
_heli setVariable ["fza_sfmplus_simpleEng_state",         ["OFF", "OFF"]];   //OFF, MOTOR, START, ON
_heli setVariable ["fza_sfmplus_simpleEng_isStarting",    [false, false]];
_heli setVariable ["fza_sfmplus_simpleEng_isOn",          [false, false]];
_heli setVariable ["fza_sfmplus_simpleEng_isCutoff",      [true, true]];
_heli setVariable ["fza_sfmplus_simpleEng_starterBroken", [false, false]];
_heli setVariable ["fza_sfmplus_simpleEng_noFuel",        [false, false]];
//Engine values
_heli setVariable ["fza_sfmplus_simpleEng_ng_pct",        [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_coreTemp_degC", [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_tgt_degC",      [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_fuelFlow_pph",  [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_starterDamage", [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_throttlePct",   [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_outputTq",      [0.0, 0.0]];


//Old
_heli setVariable ["fza_sfmplus_simpleEngine_setRPM",     [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_simpleEng_startTime",     [0.0, 0.0]];

_heli setVariable ["fza_sfmplus_simpleEngBaseTq"  ,       [0.0, 0.0]];
