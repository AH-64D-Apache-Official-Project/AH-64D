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

private _config = configOf _heli >> "fza_sfmplus";

_heli setVariable ["fza_sfmplus_fuselagePosition",              getArray  (_config >> "fuselagePosition")];

_heli setVariable ["fza_sfmplus_fuselageTopRotation",           getArray  (_config >> "fuselageTopRotation")];
_heli setVariable ["fza_sfmplus_fuselageTopDragCoefTable",      getArray  (_config >> "fuselageTopDragCoefTable")];
_heli setVariable ["fza_sfmplus_fuselageTopCount",     	        getNumber (_config >> "fuselageTopCount")];
_heli setVariable ["fza_sfmplus_fuselageTop",	 		        getArray  (_config >> "fuselageTop")];

_heli setVariable ["fza_sfmplus_fuselageSideRotation",          getArray  (_config >> "fuselageSideRotation")];
_heli setVariable ["fza_sfmplus_fuselageSideDragCoefTable",     getArray  (_config >> "fuselageSideDragCoefTable")];
_heli setVariable ["fza_sfmplus_fuselageSideCount",             getNumber (_config >> "fuselageSideCount")];
_heli setVariable ["fza_sfmplus_fuselageSide",			        getArray  (_config >> "fuselageSide")];

_heli setVariable ["fza_sfmplus_fuselageFrontRotation",         getArray  (_config >> "fuselageFrontRotation")];
_heli setVariable ["fza_sfmplus_fuselageFrontDragCoefTable",    getArray  (_config >> "fuselageFrontDragCoefTable")];
_heli setVariable ["fza_sfmplus_fuselageFrontCount",            getNumber (_config >> "fuselageFrontCount")];
_heli setVariable ["fza_sfmplus_fuselageFront",			        getArray  (_config >> "fuselageFront")];
