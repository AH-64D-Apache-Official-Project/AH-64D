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
params ["_heli", "_deltaTime"];

//Update the Main Transmission
[_heli, _deltaTime] call fza_systems_fnc_drivetrainTransmission;
//Update the Tail Rotor Gearboxes
[_heli] call fza_systems_fnc_drivetrainTailRotorGearboxes;
//Update Nose Gearbox 1
[_heli] call fza_systems_fnc_drivetrainNoseGearbox1;
//Update Nose Gearbox 2
[_heli] call fza_systems_fnc_drivetrainNoseGearbox2;fza_ah64_systems/functions/drivetrain/fn_drivetrainNoseGearbox1.sqf