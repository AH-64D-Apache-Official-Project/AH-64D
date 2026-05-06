/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_armScanStart

Description:
    Arms FCR scan start: computes cue delay then sets the waiting flag so the
    backend waits for the dish to reach the mode-specific start angle.

Parameters:
    _heli       - The helicopter
    _scanState  - FCR_MODE_ON_SINGLE or FCR_MODE_ON_CONTINUOUS

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_scanState"];

private _fcrMode    = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

private _startDeg = if (_fcrMode == 1) then {
    _fcrAzBias - _gtmHalfFov
} else {
    _fcrAzBias
};

private _currentRad = _heli animationPhase "longbow";
private _startRad   = (_startDeg * (pi / 180)) * ([-1, 1] select (_fcrMode == 2));
private _angDist    = abs (_currentRad - _startRad);
if (_angDist > pi) then { _angDist = (2 * pi) - _angDist; };
private _cueDelay   = _angDist / (pi / 3.2);

_heli setVariable ["fza_ah64_fcrWaitingForStart", true, true];
_heli setVariable ["fza_ah64_fcrState", [_scanState, CBA_missionTime + _cueDelay], true];
[_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
