/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_perfVariables

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

_heli setVariable ["fza_sfmplus_PA",            0.0];
_heli setVariable ["fza_sfmplus_FAT",           0.0];
_heli setVariable ["fza_sfmplus_GWT",           0.0];
_heli setVariable ["fza_sfmplus_rho",           0.0];

_heli setVariable ["fza_sfmplus_maxTQ_CONT",    0.0];
_heli setVariable ["fza_sfmplus_maxTQ_DE",      0.0];
_heli setVariable ["fza_sfmplus_maxTQ_SE",      0.0];

_heli setVariable ["fza_sfmplus_maxGWT_DE_IGE", 0.0];
_heli setVariable ["fza_sfmplus_maxGWT_DE_OGE", 0.0];
_heli setVariable ["fza_sfmplus_maxGWT_SE_IGE", 0.0];
_heli setVariable ["fza_sfmplus_maxGWT_SE_OGE", 0.0];

_heli setVariable ["fza_sfmplus_goNoGoTQ_IGE",  0.0];
_heli setVariable ["fza_sfmplus_goNoGoTQ_OGE",  0.0];

_heli setVariable ["fza_sfmplus_hvrTQ_IGE",     0.0];
_heli setVariable ["fza_sfmplus_hvrTQ_OGE",     0.0];

_heli setVariable ["fza_sfmplus_TAS_vne",       0.0];
_heli setVariable ["fza_sfmplus_TAS_vsse",      0.0];

_heli setVariable ["fza_sfmplus_TAS_rngTAS",    0.0];
_heli setVariable ["fza_sfmplus_TAS_rngTQ",     0.0];
_heli setVariable ["fza_sfmplus_TAS_rngFF",     0.0];

_heli setVariable ["fza_sfmplus_TAS_endTAS",    0.0];
_heli setVariable ["fza_sfmplus_TAS_endTQ",     0.0];
_heli setVariable ["fza_sfmplus_TAS_endFF",     0.0];
