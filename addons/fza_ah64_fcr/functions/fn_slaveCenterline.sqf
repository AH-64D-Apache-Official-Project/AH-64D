/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_slaveCenterline

Description:
    Slaves the FCR centerline to an acquisition source: its azimuth from the
    nose, all the way round. With FCR or FXD as the source the centerline goes
    to the nose. Only for the local crew station owning the FCR (FCR_OWNER), and
    not while a scan runs: a scan holds the azimuth it was started on. Not in
    TPM, or the 360 deg ATM sector which has no centerline.

Parameters:
    _heli - The helicopter
    _acq  - Acquisition source name

Returns:
    Nothing

Examples:
    [_heli, "PHS"] call fza_fcr_fnc_slaveCenterline

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_acq"];

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat" || {FCR_OWNER(_heli) != _seat}) exitWith {};
if (((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) exitWith {};

private _fcrMode = _heli getVariable ["fza_ah64_fcrMode", 0];
if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {};
if (_fcrMode == FCR_DISP_MODE_ATM && {([168, 90, 45, 22.5] select (_heli getVariable ["fza_ah64_fcrScanSize", 0])) >= 168}) exitWith {};

private _bias = 0;
if !(_acq in ["FCR", "FXD"]) then {
    (_heli vectorWorldToModelVisual ([_heli, _acq] call fza_fnc_targetingAcqVec)) params ["_x", "_y"];
    _bias = round (_x atan2 _y);
};
if (_bias == (_heli getVariable ["fza_ah64_fcrAzBias", 0])) exitWith {};

[_heli, _bias] call fza_fcr_fnc_setCenterline;
