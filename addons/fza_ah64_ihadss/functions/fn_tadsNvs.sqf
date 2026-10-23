/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsNvs

Description:
    The TADS as a night vision sensor: the crew station NVS SELECT gave it to,
    and that crew station's NVS MODE. The mode is off unless a living player
    sits there, so a switch left on by someone who has gone never holds it.

Parameters:
    _heli - The helicopter

Returns:
    [NVS MODE, crew station ("plt" or "cpg"), its unit]; the TADS is an NVS
    sensor while the mode is not NVS_MODE_OFF

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_tadsNvs) params ["_mode", "_seat", "_unit"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _seat = _heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"];
private _unit = [gunner _heli, driver _heli] select (_seat == "plt");
private _mode = _heli getVariable ["fza_ah64_nvsMode_" + _seat, NVS_MODE_OFF];
if (isNull _unit || {!alive _unit} || {!isPlayer _unit}) then {_mode = NVS_MODE_OFF};

[_mode, _seat, _unit]
