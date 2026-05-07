/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_animateFCR

Description:
    Drives the FCR dish rotation each frame to match the current scan state.
    Off/Fault: return to boresight. Cueing: step to scan start. Active: track bar.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _waitingForStart = _heli getVariable ["fza_ah64_fcrWaitingForStart", false];

private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias",    0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

private _dishSpeed  = pi / 3.2;

private _applyModeSign = {
    params ["_rad"];
    // GTM axis is mirrored; ATM aligns with positive rotation
    _rad * ([-1, 1] select (_fcrMode == 2))
};

private _stepTowards = {
    params ["_targetRad", "_speedRadPerSec"];
    private _current = _heli animationPhase "longbow";
    while {_current > pi}  do { _current = _current - (2 * pi); };
    while {_current < -pi} do { _current = _current + (2 * pi); };
    private _delta = _targetRad - _current;
    if (_delta > pi)  then { _delta = _delta - (2 * pi); };
    if (_delta < -pi) then { _delta = _delta + (2 * pi); };

    private _maxStep = _speedRadPerSec * ((diag_deltaTime max 0.001) min 0.05);
    private _step = _delta max (-_maxStep) min _maxStep;
    private _next = _current + _step;

    if (_next > pi)  then { _next = _next - (2 * pi); };
    if (_next < -pi) then { _next = _next + (2 * pi); };

    _heli animateSource ["longbow", _next, true];
};

// Monotonic from scan start — must not use _time (last update stamp) as it resets every half-cycle
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;

// Off / Fault: return to boresight
if (_fcrScanState == FCR_MODE_OFF || _fcrScanState == FCR_MODE_FAULT) exitWith {
    _heli setVariable ["fza_ah64_fcrWaitingForStart", false, true];
    [([0] call _applyModeSign), _dishSpeed] call _stepTowards;
};

// Cueing: step toward scan start position
if (_waitingForStart || _fcrScanDeltaTime < 0) exitWith {
    private _startDeg = if (_fcrMode == 1) then {
        _fcrAzBias - _gtmHalfFov   // GTM: left edge of scan sector
    } else {
        _fcrAzBias                 // ATM: boresight / front
    };
    private _startRad = [(_startDeg * (pi / 180))] call _applyModeSign;

    private _cur = _heli animationPhase "longbow";
    private _err = _startRad - _cur;
    if (_err > pi) then { _err = _err - (2 * pi); };
    if (_err < -pi) then { _err = _err + (2 * pi); };

    if (abs _err <= 0.01) exitWith {
        if (local _heli) then {
            [_heli, "fza_ah64_fcrState", [_fcrScanState, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
        };
        _heli animateSource ["longbow", _startRad, true];
    };

    [_startRad, _dishSpeed] call _stepTowards;
};

// Active scan: track bar position each frame
private _targetDeg = 0;

if (_fcrMode == 1) then {
    // GTM 3.2 s cycle: near bar L→R (0–1.6 s), far bar R→L (1.6–3.2 s)
    private _t = _fcrScanDeltaTime % 3.2;
    _targetDeg = if (_t <= 1.6) then {
        (_fcrAzBias - _gtmHalfFov) + (_t / 1.6) * (_gtmHalfFov * 2)
    } else {
        (_fcrAzBias + _gtmHalfFov) - ((_t - 1.6) / 1.6) * (_gtmHalfFov * 2)
    };
} else {
    // ATM 6.4 s cycle: full 360° revolution
    // Value goes 0→360° (not normalised to ±180°) so the wrap occurs at the front
    // where both sides are visually identical — avoids the ±π blend artifact
    private _t = _fcrScanDeltaTime % 6.4;
    _targetDeg = _fcrAzBias + (_t / 6.4) * 360;
};

private _targetRad = [(_targetDeg * (pi / 180))] call _applyModeSign;
_heli animateSource ["longbow", _targetRad, true];
