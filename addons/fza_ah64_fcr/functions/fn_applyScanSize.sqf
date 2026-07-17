/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_applyScanSize

Description:
    Latches the selected scan size (TM 4.42.1: adopted at the beginning of the
    next scan) into the per-mode half-FOV variables. Called from armScanStart
    and at continuous-scan full-cycle wrap.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _size    = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _gtmHalf = [45, 22.5, 15, 7.5] select _size;
private _atmHalf = [168, 90, 45, 22.5] select _size;

if (_gtmHalf != (_heli getVariable ["fza_ah64_fcrGtmHalfFov", 45])) then {
    _heli setVariable ["fza_ah64_fcrGtmHalfFov", _gtmHalf, true];
    _heli setVariable ["fza_ah64_fcrRMAPHardClear", true];
    private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
    private _clamped = (_azBias min (90 - _gtmHalf)) max (_gtmHalf - 90);
    if (_clamped != _azBias) then {
        _heli setVariable ["fza_ah64_fcrAzBias", _clamped, true];
    };
};

if (_atmHalf != (_heli getVariable ["fza_ah64_fcrAtmHalfFov", 168])) then {
    _heli setVariable ["fza_ah64_fcrAtmHalfFov", _atmHalf, true];
};
