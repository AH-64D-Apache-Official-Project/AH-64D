/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_init


Description:
    To set up the aircraft for full ai crew

Parameters:
    Heli: Object - The helicopter to modify

Returns:
    Nothing

Examples:
    [_heli] call fza_aiCrew_fnc_init

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Gets AI rocketpods to work & aim accurately
_heli animateSource["pylon1", 0.5]; 
_heli animateSource["pylon2", 0.5]; 
_heli animateSource["pylon3", 0.5]; 
_heli animateSource["pylon4", 0.5];