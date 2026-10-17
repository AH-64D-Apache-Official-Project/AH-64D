/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_slaveCenterline

Description:
    Slaves the FCR centerline to an acquisition source: its azimuth from the
    nose, within +-90 deg. With FCR or FXD as the source the centerline goes to
    the nose. Not in TPM, or the 360 deg ATM sector which has no centerline.

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

private _fcrMode = _heli getVariable ["fza_ah64_fcrMode", 0];
if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {};
if (_fcrMode == FCR_DISP_MODE_ATM && {([168, 90, 45, 22.5] select (_heli getVariable ["fza_ah64_fcrScanSize", 0])) >= 168}) exitWith {};

private _bias = 0;
if !(_acq in ["FCR", "FXD"]) then {
    (_heli vectorWorldToModelVisual ([_heli, _acq] call fza_fnc_targetingAcqVec)) params ["_x", "_y"];
    _bias = round (((_x atan2 _y) max -90) min 90);
};
if (_bias == (_heli getVariable ["fza_ah64_fcrAzBias", 0])) exitWith {};

[_heli, _bias] call fza_fcr_fnc_setCenterline;
