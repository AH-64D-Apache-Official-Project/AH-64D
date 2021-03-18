/* ----------------------------------------------------------------------------
Function: fza_fnc_Ihadsstoggle
Description:
Parameters:
Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_Ihadsstoggle;
Author:
---------------------------------------------------------------------------- */
params["_heli"];

_heli setVariable ["fza_ah64_ihadssoff", switch (_heli getVariable "fza_ah64_ihadssoff") do {
    case 1 : {0};
    case 0 : {1};
}];