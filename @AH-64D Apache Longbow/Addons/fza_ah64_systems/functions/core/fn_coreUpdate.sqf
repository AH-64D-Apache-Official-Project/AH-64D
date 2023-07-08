/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_CoreUpdate

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
params ["_heli"];

private _deltaTime = ["systems_deltaTime"] call BIS_fnc_deltaTime;

//Update the Electrical System
[_heli, _deltaTime] call fza_systems_fnc_electricalController;
//Update the APU
[_heli, _deltaTime] call fza_systems_fnc_apu;
//Update the Hydraulic System
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsController;
//Update the Drivetrain
[_heli, _deltaTime] call fza_systems_fnc_drivetrainController;