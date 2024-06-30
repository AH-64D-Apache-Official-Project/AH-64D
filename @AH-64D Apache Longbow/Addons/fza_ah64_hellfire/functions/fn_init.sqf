/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_init

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

if (!(_heli getVariable ["fza_ah64_hellfireInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_hellfireInitialised",        true,  true];

    _heli setVariable ["fza_ah64_hellfireTrajectory",         "DIR", true];

    _heli setVariable ["fza_ah64_laserMissilePrimaryCode",    0,     true];
    _heli setVariable ["fza_ah64_laserMissileAlternateCode",  1,     true];
    _heli setVariable ["fza_ah64_laserLRFDCode",              "A",   true];
    _heli setVariable ["fza_ah64_laserLSTCode",               "B",   true];
    _heli setVariable ["fza_ah64_laserChannelCodes",          ["A", "B", "C", "D"], true];
    _heli setVariable ["fza_ah64_laserChannelIndex", createHashMapFromArray
        [ ["A",1111],["B",1112]
        , ["C",1113],["D",1114]
        , ["E",1121],["F",1122]
        , ["G",1123],["H",1124]
        , ["J",1131],["K",1132]
        , ["L",1133],["M",1134]
        , ["N",1141],["P",1142]
        , ["Q",1143],["R",1144]
        ], true];
};