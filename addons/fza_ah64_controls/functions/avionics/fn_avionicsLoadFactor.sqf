/* ----------------------------------------------------------------------------
Function: fza_fnc_avionicsLoadFactor

Description:
    The aircraft's vertical load factor, the gmeterZ sound controller averaged
    over the last 0.25 s, as the raw controller is jumpy. One sample a frame,
    whoever asks first (the IHADSS G readout, the rocket ACCEL LIMIT).

Parameters:
    _heli - The helicopter

Returns:
    Load factor (G)

Examples:
    --- Code
    [_heli] call fza_fnc_avionicsLoadFactor
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _now      = diag_tickTime;
private _gSamples = (_heli getVariable ["fza_ihadss_gSamples", []]) select {_now - (_x # 0) <= 0.25};
if (_heli getVariable ["fza_ihadss_gSampleFrame", -1] != diag_frameNo) then {
    _heli setVariable ["fza_ihadss_gSampleFrame", diag_frameNo];
    _gSamples pushBack [_now, _heli getSoundController "gmeterZ"];
};
_heli setVariable ["fza_ihadss_gSamples", _gSamples];
if (_gSamples isEqualTo []) exitWith {1};
private _gSum = 0;
{_gSum = _gSum + (_x # 1)} forEach _gSamples;
_gSum / count _gSamples
