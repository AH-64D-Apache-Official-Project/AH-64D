/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatDisengage

Description:
    Disengages the image auto tracker, leaving the TADS in manual track.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_iatDisengage
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

[_heli, "fza_ah64_iat", IAT_IDLE] call fza_fnc_updateNetworkGlobal;
_heli setVariable ["fza_ihadss_iatLocal", nil];
_heli setVariable ["fza_ihadss_iatDriving", false];
