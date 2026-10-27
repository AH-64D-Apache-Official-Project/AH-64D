/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_nvsBias

Description:
    Correction added to the night vision sensor (PNVS or TADS) a crew station
    drives in NVS MODE NORM, so its HDU picture lines up with the world from
    where its head is, by the sensor's azimuth, measured in game: the pilot's
    NVS_BIAS_PLT, the CPG's NVS_BIAS_CPG, and with the CPG on the controls,
    whose head then moves with the aircraft, NVS_BIAS_CPG_FLYING.

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg"
    _az   - The sensor's azimuth from the nose (deg)

Returns:
    [azimuth, elevation] (deg)

Examples:
    --- Code
    ([_heli, "cpg", 30] call fza_ihadss_fnc_nvsBias) params ["_azBias", "_elBias"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat", ["_az", 0]];

private _table = switch (true) do {
    case (_seat != "cpg"):                     {NVS_BIAS_PLT};
    case (currentPilot _heli == gunner _heli): {NVS_BIAS_CPG_FLYING};
    default                                    {NVS_BIAS_CPG};
};

([_table, _az] call fza_fnc_linearInterp) params ["", "_azBias", "_elBias"];
[_azBias, _elBias]
