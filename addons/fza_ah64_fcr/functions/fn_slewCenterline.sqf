/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_slewCenterline

Description:
    Steps the FCR azimuth scan centerline left or right by the selected scan
    size: 90 deg wide, 22.5 medium, 15 narrow, 7.5 zoom, all the way round the
    aircraft, stopping a running scan. The new position is stored as a world
    bearing so the centerline remains heading stabilized until commanded again. Only acts for the crew
    station owning the FCR (FCR_OWNER) while the centerline is not following the
    acquisition source: for the pilot, slaved on selection, only with FXD as the
    source; for the CPG only while not slaved.

Parameters:
    _heli    - The helicopter
    _dirSign - -1 = left arrow, 1 = right arrow

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_dirSign"];

if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat)) exitWith {};
if (player == driver _heli && {([_heli, [-1]] call fza_fnc_targetingCurAcq) != "FXD"}) exitWith {};
if (player == gunner _heli && {_heli getVariable ["fza_ah64_cpgSlaved", false]}) exitWith {};

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {};

// Use the SELECTED size, not the latched half-FOV — the latch happens at the next scan
// start, so reading it here would give the previous size right after a change.
private _size = _heli getVariable ["fza_ah64_fcrScanSize", 0];
// Wide (ATM 360 rotation) has no centerline to offset
if (_fcrMode == FCR_DISP_MODE_ATM && {_size == 0}) exitWith {};

// The arrow fills while pressed (fza_mpd_fnc_fcrStatusDraw)
_heli setVariable ["fza_fcr_arrowPressed", [_dirSign, diag_tickTime]];

private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _newBias = [_azBias + _dirSign * ([90, 22.5, 15, 7.5] select _size)] call CBA_fnc_simplifyAngle180;
if (_newBias == _azBias) exitWith {};

// Moving the scan sector stops a running scan; the antenna then turns to the new centerline (fza_fcr_fnc_animateFCR)
[_heli] call fza_fcr_fnc_stopScan;
[_heli, _newBias] call fza_fcr_fnc_setCenterline;
