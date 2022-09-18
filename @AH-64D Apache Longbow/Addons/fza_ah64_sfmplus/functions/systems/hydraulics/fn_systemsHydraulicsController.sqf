/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsHydraulicsController

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
[_heli] call fza_sfmplus_fnc_systemsHydraulicsPriPump;
[_heli, _deltaTime] call fza_sfmplus_fnc_systemsHydraulicsPriReservoir;
//Utility System
[_heli] call fza_sfmplus_fnc_systemsHydraulicsUtilPump;
[_heli, _deltaTime] call fza_sfmplus_fnc_systemHydraulicsUtilReservoir;
//Accumulator
[_heli, _deltaTime] call fza_sfmplus_fnc_systemsHydraulicsAccumulator;
