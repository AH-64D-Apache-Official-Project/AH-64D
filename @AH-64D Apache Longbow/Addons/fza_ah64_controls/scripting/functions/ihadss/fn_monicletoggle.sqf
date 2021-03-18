/* ----------------------------------------------------------------------------
Function: fza_fnc_monicletoggle
Description:
Parameters:
Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_monicletoggle;
Author:
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64_monocleinbox", !(_heli getVariable "fza_ah64_monocleinbox")];