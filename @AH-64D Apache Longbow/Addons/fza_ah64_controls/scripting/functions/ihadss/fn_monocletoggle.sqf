/* ----------------------------------------------------------------------------
Function: fza_fnc_monocletoggle

Description:
    adds or removes player monicle
Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_monocletoggle;

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64_monocleinbox", !(_heli getVariable "fza_ah64_monocleinbox")];