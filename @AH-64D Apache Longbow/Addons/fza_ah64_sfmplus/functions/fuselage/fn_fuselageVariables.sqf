/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_fuselageVariables

Description:
    Defines core fuselage variables.

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

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "fza_sfmplus";

_heli setVariable ["fza_sfmplus_fuselageCenter",		getArray (_config >> "fuselageCenter")];

_heli setVariable ["fza_sfmplus_fuselageTopCount",     	getNumber (_config >> "fuselageTopCount")];
_heli setVariable ["fza_sfmplus_fuselageTop",	 		getArray  (_config >> "fuselageTop")];

_heli setVariable ["fza_sfmplus_fuselageSideCount",     getNumber (_config >> "fuselageSideCount")];
_heli setVariable ["fza_sfmplus_fuselageSide",			getArray  (_config >> "fuselageSide")];

_heli setVariable ["fza_sfmplus_fuselageFrontCount",    getNumber (_config >> "fuselageFrontCount")];
_heli setVariable ["fza_sfmplus_fuselageFront",			getArray  (_config >> "fuselageFront")];