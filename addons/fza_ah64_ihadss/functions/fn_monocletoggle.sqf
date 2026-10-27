/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_monocletoggle

Description:
    adds or removes player monicle
Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_ihadss_fnc_monocletoggle;

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

// The HDU is the IHADSS helmet's: without it the monocle cannot come down
if ((_heli getVariable ["fza_ah64_monocleinbox", true]) && {!([player] call fza_ihadss_fnc_hasHelmet)}) exitWith {};

_heli setVariable ["fza_ah64_monocleinbox", !(_heli getVariable "fza_ah64_monocleinbox")];
[player] call fza_ihadss_fnc_hduUpdate;
