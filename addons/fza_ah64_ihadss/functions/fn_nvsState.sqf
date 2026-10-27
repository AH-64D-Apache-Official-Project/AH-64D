/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_nvsState

Description:
    A crew station's night vision sensor. Each crew station has its own NVS
    MODE switch; NVS SELECT gives the TADS to one crew station and the PNVS to
    the other, the CPG having the TADS by default.

Parameters:
    _heli - The helicopter
    _seat - "plt", "cpg" or a unit, default the player

Returns:
    [NVS MODE (NVS_MODE_OFF, NVS_MODE_NORM or NVS_MODE_FIXED), sensor ("PNVS" or "TADS")]

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_nvsState) params ["_nvsMode", "_nvsSensor"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", ["_seat", player]];

_seat = [_heli, _seat] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {[NVS_MODE_OFF, "PNVS"]};

[
    _heli getVariable ["fza_ah64_nvsMode_" + _seat, NVS_MODE_OFF],
    ["PNVS", "TADS"] select ((_heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"]) == _seat)
]
