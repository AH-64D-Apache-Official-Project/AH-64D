/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_armScanStart

Description:
    Arms FCR scan start: computes cue delay then sets the waiting flag so the
    backend waits for the dish to reach the mode-specific start angle.

Parameters:
    _heli       - The helicopter
    _scanState  - FCR_MODE_ON_SINGLE or FCR_MODE_ON_CONTINUOUS
    _preserve   - keep NTS and cycle count (mid-scan re-cue, e.g. size change)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_scanState", ["_preserve", false]];

[_heli, true] call fza_fcr_fnc_applyScanSize;

private _fcrMode    = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

private _startDeg = if (_fcrMode == FCR_DISP_MODE_GTM || _fcrMode == FCR_DISP_MODE_RMAP) then {
    _fcrAzBias - _gtmHalfFov
} else {
    if (_fcrMode == FCR_DISP_MODE_TPM) then {
        private _tpmHalfFov = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
        _fcrAzBias - _tpmHalfFov
    } else {
        // ATM sector sizes start at the left edge; wide (360 rotation) starts at the front
        private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168];
        _fcrAzBias - ([0, _atmHalfFov] select (_atmHalfFov < 168))
    }
};

private _currentRad = _heli animationPhase "longbow";
private _startRad   = (_startDeg * (pi / 180)) * ([-1, 1] select (_fcrMode == 2));
private _angDist    = abs (_currentRad - _startRad);
if (_angDist > pi) then { _angDist = (2 * pi) - _angDist; };
private _cueDelay   = _angDist / (FCR_SCAN_RATE_DEGS * (pi / 180));

[_heli, "fza_ah64_fcrWaitingForStart", true] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrState", [_scanState, CBA_missionTime + _cueDelay]] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrLastFullCycle", 0] call fza_fnc_updateNetworkGlobal;

if (_preserve) exitWith {};
[_heli, "fza_ah64_fcrNts",           [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrFullCycleCount", 0]                   call fza_fnc_updateNetworkGlobal;
