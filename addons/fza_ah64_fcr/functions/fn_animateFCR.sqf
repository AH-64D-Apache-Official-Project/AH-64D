/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_animateFCR

Description:
    Drives the physical FCR (Longbow) dish rotation to match the current scan
    state. Called every frame from fn_controller (local only; animateSource
    replicates automatically over the network).

    States:
        Off / Fault   - Dish returns to forward-facing (0°) at _dishSpeed.
        Cueing        - Scan started but _fcrScanDeltaTime < 0 (future start
                        time); dish animates to the scan start position.
        Active scan   - Dish tracks the scan bar exactly, updated each frame.

    GTM scan: near bar sweeps left (-halfFov) → right (+halfFov) in 1.6 s,
              far bar sweeps right → left in the next 1.6 s.
    ATM scan: full 360° revolution over 6.4 s.

Parameters:
    _heli - The helicopter to act upon

Returns:
    nil

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _waitingForStart = _heli getVariable ["fza_ah64_fcrWaitingForStart", false];

private _fcrAzBias  = _heli getVariable ["fza_ah64_fcrAzBias",    0];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];

// Dish rotation speed for cueing and return: ~86°/s
private _dishSpeed = 1.5;

private _applyModeSign = {
    params ["_rad"];
    // GTM model axis is mirrored; ATM aligns with positive rotation
    _rad * ([-1, 1] select (_fcrMode == 2))
};

private _stepTowards = {
    params ["_targetRad", "_speedRadPerSec"];
    private _current = _heli animationPhase "longbow";
    private _delta = _targetRad - _current;
    if (_delta > pi) then { _delta = _delta - (2 * pi); };
    if (_delta < -pi) then { _delta = _delta + (2 * pi); };

    private _maxStep = _speedRadPerSec * (diag_deltaTime max 0.001);
    private _step = _delta max (-_maxStep) min _maxStep;
    private _next = _current + _step;

    if (_next > pi) then { _next = _next - (2 * pi); };
    if (_next < -pi) then { _next = _next + (2 * pi); };

    _heli animateSource ["longbow", _next];
};

private _fcrScanDeltaTime = CBA_missionTime - (_fcrScanStartTime max _time);

// --- Off / Fault: return dish to boresight -----------------------------------
if (_fcrScanState == FCR_MODE_OFF || _fcrScanState == FCR_MODE_FAULT) exitWith {
    _heli setVariable ["fza_ah64_fcrWaitingForStart", false, true];
    [([0] call _applyModeSign), _dishSpeed] call _stepTowards;
};

// --- Cueing: animate to scan start position ----------------------------------
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

    // Once physically at the scan start, latch backend start to now.
    if (abs _err <= 0.01) exitWith {
        if (_waitingForStart || _fcrScanDeltaTime < 0) then {
            _heli setVariable ["fza_ah64_fcrState", [_fcrScanState, CBA_missionTime], true];
            _heli setVariable ["fza_ah64_fcrWaitingForStart", false, true];
        };
        _heli animateSource ["longbow", _startRad];
    };

    [_startRad, _dishSpeed] call _stepTowards;
};

// --- Active scan: track scan bar each frame ----------------------------------
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
    private _t = _fcrScanDeltaTime % 6.4;
    _targetDeg = _fcrAzBias + (_t / 6.4) * 360;
    // Normalise to ±180° so the animation phase stays in range
    // Note: 180° and -180° map to the same physical angle, so no visual jump
    if (_targetDeg > 180) then { _targetDeg = _targetDeg - 360; };
};

// Physical dish command: model axis is mirrored vs display azimuth, so negate
private _targetRad = [(_targetDeg * (pi / 180))] call _applyModeSign;
private _scanSpeed = if (_fcrMode == 1) then {
    // GTM: 2*halfFov per 1.6s (rad/s)
    ((_gtmHalfFov * 2) * (pi / 180)) / 1.6
} else {
    // ATM: full 360 in 6.4s (rad/s)
    (2 * pi) / 6.4
};

// Track the sweep at commanded rate (no instantaneous snap)
[_targetRad, _scanSpeed] call _stepTowards;
