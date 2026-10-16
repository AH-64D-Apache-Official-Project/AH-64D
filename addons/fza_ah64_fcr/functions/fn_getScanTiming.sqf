/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_getScanTiming

Description:
    Scan timing for the current display mode at the constant antenna azimuth
    rate — one bar/pass covers the scan width, so smaller sectors complete
    faster. ATM wide is one full rotation per cycle.

Parameters:
    _heli - The helicopter

Returns:
    [_barTime, _fullCycle] - seconds per bar/pass and per full scan cycle

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";

if (_fcrMode == FCR_DISP_MODE_ATM) exitWith {
    private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];
    private _bar = [(_atmHalfFov * 2) / FCR_SCAN_RATE_DEGS, 180 / FCR_SCAN_RATE_DEGS] select (_atmHalfFov >= 168);
    [_bar, _bar * 2]
};

if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {
    private _tpmHalfFov = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
    private _bar = (_tpmHalfFov * 2) / FCR_TPM_SCAN_RATE_DEGS;
    [_bar, _bar * 2]
};

private _halfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
private _bar = (_halfFov * 2) / FCR_SCAN_RATE_DEGS;
[_bar, _bar * 2]
