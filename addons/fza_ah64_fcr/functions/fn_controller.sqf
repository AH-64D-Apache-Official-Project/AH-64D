/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_controller

Description:
    handles the relavent Fire control radar per frame functions

Parameters:
    _heli - The apache to act upon

Returns:
    nil
    
Examples:
    [_heli] call fza_fcr_fnc_controller
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if ((player != driver _heli) && (isPlayer driver _heli)) exitWith {};

if (_heli animationPhase "fcr_enable" == 0) then {
    _heli enableVehicleSensor ["ActiveRadarSensorComponent", false];
} else {
    _heli enableVehicleSensor ["ActiveRadarSensorComponent", true];
};

if (_heli animationPhase "fcr_enable" != 1) exitWith {};

[_heli] call fza_fcr_fnc_stateControl;
