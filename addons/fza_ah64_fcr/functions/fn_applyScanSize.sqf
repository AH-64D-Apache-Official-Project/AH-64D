/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_applyScanSize

Description:
    Latches the selected scan size into the per-mode half-FOV variables as a
    scan starts (fza_fcr_fnc_armScanStart). Selecting a size stops the scan
    (fza_fnc_coreControlHandle), so a size is never changed mid-scan.

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
    [_heli] call fza_fcr_fnc_videoClear;
};

if (_atmHalf != (_heli getVariable ["fza_ah64_fcrAtmHalfFov", 168])) then {
    _heli setVariable ["fza_ah64_fcrAtmHalfFov", _atmHalf, true];
};

// The centerline stays where it was commanded; the size only sets the scan limits either side of it
