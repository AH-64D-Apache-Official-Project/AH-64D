/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_hydraulicsController

Description:
    Updates all of the modules core functions.
    
Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

//Primary System
[_heli] call fza_systems_fnc_hydraulicsPriPump;
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsPriReservoir;
//Utility System
[_heli] call fza_systems_fnc_hydraulicsUtilPump;
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsUtilReservoir;
//Accumulator
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsAccumulator;
