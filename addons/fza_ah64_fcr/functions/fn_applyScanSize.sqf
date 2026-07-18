/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_applyScanSize

Description:
    Latches the selected scan size (TM 4.42.1: adopted at the beginning of the
    next scan) into the per-mode half-FOV variables. Called from armScanStart
    and at continuous-scan full-cycle wrap. When the active mode's sector
    actually changed mid-scan, re-cues the antenna to the new start edge so
    the new (faster/slower) cycle begins cleanly.

Parameters:
    _heli     - The helicopter
    _noRecue  - true when called from armScanStart (it is about to cue anyway)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", ["_noRecue", false]];

private _size    = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _gtmHalf = [45, 22.5, 15, 7.5] select _size;
private _atmHalf = [168, 90, 45, 22.5] select _size;

private _gtmChanged = _gtmHalf != (_heli getVariable ["fza_ah64_fcrGtmHalfFov", 45]);
private _atmChanged = _atmHalf != (_heli getVariable ["fza_ah64_fcrAtmHalfFov", 168]);

if (_gtmChanged) then {
    _heli setVariable ["fza_ah64_fcrGtmHalfFov", _gtmHalf, true];
    _heli setVariable ["fza_ah64_fcrRMAPHardClear", true];
    private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
    private _clamped = (_azBias min (90 - _gtmHalf)) max (_gtmHalf - 90);
    if (_clamped != _azBias) then {
        _heli setVariable ["fza_ah64_fcrAzBias", _clamped, true];
    };
};

if (_atmChanged) then {
    _heli setVariable ["fza_ah64_fcrAtmHalfFov", _atmHalf, true];
};

if (_noRecue) exitWith {};

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _activeChanged = switch (_fcrMode) do {
    case FCR_DISP_MODE_ATM: { _atmChanged };
    case FCR_DISP_MODE_TPM: { false };
    default { _gtmChanged };
};
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState"];
if (_activeChanged && _fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    [_heli, _fcrScanState, true] call fza_fcr_fnc_armScanStart;
};
