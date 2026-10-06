/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_perfVariables

Description:
    Defines the initial performance page variables and initializes them.

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

_heli setVariable ["fza_ah64_perfDataChange",  ""];

_heli setVariable ["fza_ah64_maxTq_cont",    0.0];
_heli setVariable ["fza_ah64_maxTq_de",      0.0];
_heli setVariable ["fza_ah64_maxTq_se",      0.0];

_heli setVariable ["fza_ah64_maxGwt_de_ige", 0.0];
_heli setVariable ["fza_ah64_maxGwt_de_oge", 0.0];
_heli setVariable ["fza_ah64_maxGwt_se_ige", 0.0];
_heli setVariable ["fza_ah64_maxGwt_se_oge", 0.0];

_heli setVariable ["fza_ah64_goNoGoTq_ige",  0.0];
_heli setVariable ["fza_ah64_goNoGoTq_oge",  0.0];

_heli setVariable ["fza_ah64_hvrTq_ige",     0.0];
_heli setVariable ["fza_ah64_hvrTq_oge",     0.0];

_heli setVariable ["fza_ah64_tas_vne",       0.0];
_heli setVariable ["fza_ah64_tas_vsse",      0.0];

_heli setVariable ["fza_ah64_tas_rngTas",    0.0];
_heli setVariable ["fza_ah64_tas_rngTq",     0.0];
_heli setVariable ["fza_ah64_tas_rngFf",     0.0];

_heli setVariable ["fza_ah64_tas_endTas",    0.0];
_heli setVariable ["fza_ah64_tas_endTq",     0.0];
_heli setVariable ["fza_ah64_tas_endFf",     0.0];
