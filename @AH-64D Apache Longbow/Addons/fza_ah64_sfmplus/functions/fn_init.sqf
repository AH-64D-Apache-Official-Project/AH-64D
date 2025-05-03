/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_init

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
    _heli - the helicopter upon which to execute the code

Returns:
    Nothing

Examples:
    [_heli] call fza_sfmplus_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_sfmPlusInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_sfmPlusInitialised", true, true];

    //FMC
    _heli setVariable ["fza_ah64_fmcPitchOn",                true,  true];
    _heli setVariable ["fza_ah64_fmcRollOn",                 true,  true];
    _heli setVariable ["fza_ah64_fmcYawOn",                  true,  true];
    _heli setVariable ["fza_ah64_fmcCollOn",                 true,  true];
    _heli setVariable ["fza_ah64_fmcTrimOn",                 true,  true];
    //Force Trim
    _heli setVariable ["fza_ah64_forceTrimInterupted",       false, true];
    _heli setVariable ["fza_ah64_forceTrimPosPitch",         0.0,   true];
    _heli setVariable ["fza_ah64_forceTrimPosRoll",          0.0,   true];
    _heli setVariable ["fza_ah64_forceTrimPosPedal",         0.0,   true];
    //Attitude Hold
    _heli setVariable ["fza_ah64_attHoldActive",             false, true];
    _heli setVariable ["fza_ah64_attHoldDesiredPos",         getPos _heli, true];
    _heli setVariable ["fza_ah64_attHoldDesiredVel",         [0.0, 0.0], true];
    _heli setVariable ["fza_ah64_attHoldDesiredAtt",         [0.0, 0.0], true];
    _heli setVariable ["fza_ah64_attHoldSubMode",            "pos", true];   //pos, vel, att
    //Altitude Hold
    _heli setVariable ["fza_ah64_altHoldActive",             false, true];
    _heli setVariable ["fza_ah64_altHoldDesiredAlt",         0.0,   true];
    _heli setVariable ["fza_ah64_altHoldSubMode",            "rad", true];   //rad, bar
    _heli setVariable ["fza_ah64_altHoldCollRef",            0.0,   true];
    //Heading Hold
    _heli setVariable ["fza_ah64_hdgHoldActive",             false, true];
    _heli setVariable ["fza_ah64_hdgHoldDesiredHdg",         0.0,   true];
    _heli setVariable ["fza_ah64_hdgHoldDesiredSideslip",    0.0,   true];
    _heli setVariable ["fza_ah64_hdgHoldSubMode",            "hdg", true];    //hdg, trn
    _heli setVariable ["fza_ah64_hdgHoldPedalRef",           0.0,   true];    //<-- probably not needed, kept just in case...

    _heli setvariable ["fza_ah64_stabilatorPosition",        0.0,   true];

    _heli setVariable ["fza_ah64_IAFSInstalled",              true, true];
    _heli setVariable ["fza_ah64_IAFSOn",                    false, true];
};