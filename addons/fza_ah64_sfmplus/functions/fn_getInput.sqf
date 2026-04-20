/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getInput

Description:
    Handles keyboard and HOTAS input for the simulation.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

if (currentPilot _heli != player || !local _heli) exitWith {};

private _paused             = isNull findDisplay 49;
private _chatting           = isNull findDisplay 24;
private _inDialog           = !dialog;
private _isZeus             = isNull findDisplay 312;
private _inMap              = !visibleMap;
private _inInventory        = isNull findDisplay 602;

private _isPlaying          = isGameFocused && _paused && _chatting && _inDialog && _isZeus && _inMap && _inInventory && !fza_ah64_lastFrameGetIn;

private _config             = configOf _heli >> "Fza_SfmPlus";
private _configVehicles     = configOf _heli;
private _inputLagValue      = getNumber (_config >> "inputLagValue");

private _hydFailure         = false;
private _tailRtrFixed       = false;

private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";

//Keyboard
private _kbStickyInterupt   = _heli getVariable "fza_sfmplus_kbStickyInterupt";
private _fltControlLockout  = _heli getVariable "fza_sfmplus_flightControlLockOut";

private _yawBreakout        = false;
private _kbPedalLeftRight   = _heli getVariable "fza_sfmplus_kbPedalLeftRight";

private _priHydPumpDamage   = _heli getHitPointDamage "hit_hyd_pripump";
private _priHydPSI          = _heli getVariable "fza_systems_priHydPsi";

private _utilHydPumpDamage  = _heli getHitPointDamage "hit_hyd_utilpump";
private _utilHydPSI         = _heli getVariable "fza_systems_utilHydPsi";
private _utilLevel_pct      = _heli getVariable "fza_systems_utilLevel_pct";

private _emerHydOn          = _heli getVariable "fza_ah64_emerHydOn";
private _apuOn              = _heli getVariable "fza_systems_apuOn";

/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic & Pedal Input /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _heliCyclicFwdOut   = _heli getVariable "fza_sfmplus_heliCyclicForwardOut";
private _heliCyclicBackOut  = _heli getVariable "fza_sfmplus_heliCyclicBackwardOut";
private _cyclicFwdAft       = _heliCyclicFwdOut - _heliCyclicBackOut;
_cyclicFwdAft               = [_cyclicFwdAft, -1.0, 1.0] call BIS_fnc_clamp;
//systemChat format ["_cyclicFwdAft = %1", _cyclicFwdAft toFixed 2];

private _heliCyclicLeftOut  = _heli getVariable "fza_sfmplus_heliCyclicLeftOut";
private _heliCyclicRightOut = _heli getVariable "fza_sfmplus_heliCyclicRightOut";
private _cyclicLeftRight    = _heliCyclicLeftOut - _heliCyclicRightOut;
_cyclicLeftRight            = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
//systemChat format ["_cyclicLeftRight = %1", _cyclicLeftRight toFixed 2];

private _heliRudderLeftOut  = _heli getVariable "fza_sfmplus_heliRudderLeftOut";
private _heliRudderRightOut = _heli getVariable "fza_sfmplus_heliRudderRightOut";
private _pedalLeftRight     = _heliRudderRightOut - _heliRudderLeftOut;
_pedalLeftRight             = [_pedalLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
//systemChat format ["_pedalLeftRight = %1", _pedalLeftRight toFixed 2];

if (!_isPlaying || (freeLook && fza_ah64_sfmPlusMouseAsJoystick)) then {
    _cyclicFwdAft      = 0.0;
    _cyclicLeftRight   = 0.0;
};

//Cyclic Pitch
if (fza_ah64_sfmPlusKeyboardStickyPitch) then {
    private _cyclicPitchValue     = _heli getVariable "fza_sfmplus_cyclicPitchValue";
    private _prevCyclicPitchValue = _heli getVariable "fza_sfmplus_prevCyclicPitchValue";

    if (_kbStickyInterupt) then {
        _cyclicFwdAft         = [_cyclicFwdAft, _prevCyclicPitchValue] call fza_sfmplus_fnc_getInterpInput;
    } else {
        if (_cyclicFwdAft > 0.1) then {
            _cyclicPitchValue = _cyclicPitchValue + 0.01;
        };
        if (_cyclicFwdAft < -0.1) then {
            _cyclicPitchValue = _cyclicPitchValue - 0.01;
        };

       //_cyclicPitcValue = 

        _cyclicFwdAft         = [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_cyclicPitchValue",    [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp];
        _heli setVariable ["fza_sfmplus_prevCyclicPitchValue", _cyclicPitchValue];
    };
};
//Cyclic Roll
if (fza_ah64_sfmPlusKeyboardStickyRoll) then {
    private _cyclicRollValue     = _heli getVariable "fza_sfmplus_cyclicRollValue";
    private _prevCyclicRollValue = _heli getVariable "fza_sfmplus_prevCyclicRollValue";

    if (_kbStickyInterupt) then {
        _cyclicLeftRight     = [_cyclicLeftRight, _prevCyclicRollValue] call fza_sfmplus_fnc_getInterpInput;
    } else {
        if (_cyclicLeftRight > 0.1) then {
            _cyclicRollValue = _cyclicRollValue + 0.01;
        };
        if (_cyclicLeftRight < -0.1) then {
            _cyclicRollValue = _cyclicRollValue - 0.01;
        };
    
        _cyclicLeftRight     = [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_cyclicRollValue",    [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp];
        _heli setVariable ["fza_sfmplus_prevCyclicRollValue", _cyclicRollValue];
    };
};
//Pedal yaw
if (fza_ah64_sfmPlusKeyboardStickyYaw && !fza_ah64_sfmPlusAutoPedal) then {
    private _pedalYawValue     = _heli getVariable "fza_sfmplus_pedalYawValue";
    private _prevPedalYawValue = _heli getVariable "fza_sfmplus_prevPedalYawValue";

    if (_kbStickyInterupt) then {
        _pedalLeftRight    = [_pedalLeftRight, _prevPedalYawValue] call fza_sfmplus_fnc_getInterpInput;
    } else {
        if (_pedalLeftRight > 0.1) then {
            _pedalYawValue = _pedalYawValue + 0.01;
        };
        if (_pedalLeftRight < -0.1) then {
            _pedalYawValue = _pedalYawValue - 0.01;
        };

        _pedalLeftRight        = [_pedalYawValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_pedalYawValue", [_pedalYawValue, -1.0, 1.0] call BIS_fnc_clamp];
        _heli setVariable ["fza_sfmplus_prevPedalYawValue", _pedalYawValue];
    };
};
/////////////////////////////////////////////////////////////////////////////////////////////
// KB Auto Pedal        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusAutoPedal) then {
    private _gndSpeed   = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Pedal Yaw         /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _yawBreakoutVal = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
    if (_yawBreakoutVal < -0.01 || _yawBreakoutVal > 0.01) then {
        _yawBreakout = true;
    };

    private _pidAutoPedalHdg  = _heli getVariable "fza_sfmplus_pid_autoPedalHdg";
    private _pidAutoPedalSlip = _heli getVariable "fza_sfmplus_pid_autoPedalSlip";

    private _hdgOut        = 0.0;
    private _sideslipOut   = 0.0;
    private _yawOutput     = 0.0;
    private _curHdg        = getDir _heli;
    private _desiredHdg    = _heli getVariable "fza_sfmPlus_autoPedalHdg";
    private _hdgError      = 0.0;
    private _desiredSlip   = 0.0;
    private _sideslipError = 0.0;

    // Sub-mode tracking with hysteresis — mirrors fn_fmcHeadingHold sub-mode pattern.
    // "hdg": heading hold (low speed).  Enter slip above ACCEL (40 kts).
    // "slip": turn coordination (cruise). Return to hdg below DECEL (30 kts).
    private _subMode = _heli getVariable "fza_sfmplus_autoPedal_subMode";
    if (_subMode == "hdg"  && _gndSpeed >= HDG_HOLD_SPEED_SWITCH_ACCEL) then {
        _subMode = "slip";
        [_pidAutoPedalHdg] call fza_fnc_pidReset;
        _heli setVariable ["fza_sfmplus_autoPedal_subMode", "slip"];
    };
    if (_subMode == "slip" && _gndSpeed <  HDG_HOLD_SPEED_SWITCH_DECEL) then {
        _subMode = "hdg";
        [_pidAutoPedalSlip] call fza_fnc_pidReset;
        _heli setVariable ["fza_sfmplus_autoPedal_subMode", "hdg"];
    };

    if (_yawBreakout || _gndSpeed > HDG_HOLD_SPEED_SWITCH_DECEL) then {
        _desiredHdg       = getDir _heli;
        _kbPedalLeftRight = [_kbPedalLeftRight, _pedalLeftRight, (1.0 / 0.1) * _deltaTime] call BIS_fnc_lerp;
        _kbPedalLeftRight = [_kbPedalLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
        _pedalLeftRight   = _kbPedalLeftRight;

        _heli setVariable ["fza_sfmplus_kbPedalLeftRight", _kbPedalLeftRight];
        _heli setVariable ["fza_sfmPlus_autoPedalHdg",     _desiredHdg, true];
    } else {
        _heli setVariable ["fza_sfmplus_kbPedalLeftRight", 0.0];
    };

    _hdgError      = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
    _sideslipError = _desiredSlip - fza_ah64_sideslip;

    // Only run the active sub-mode PID — prevents integral windup in the idle mode.
    if (_subMode == "hdg") then {
        _hdgOut = [_pidAutoPedalHdg,  _deltaTime, 0.0, _hdgError]      call fza_fnc_pidRun;
        _hdgOut = [_hdgOut, -1.0, 1.0] call BIS_fnc_clamp;
    } else {
        _sideslipOut = [_pidAutoPedalSlip, _deltaTime, 0.0, _sideslipError] call fza_fnc_pidRun;
        _sideslipOut = [_sideslipOut, -1.0, 1.0] call BIS_fnc_clamp;
    };

    // Blend across the DECEL→ACCEL transition band (30–40 kts).
    // Since only the active PID contributes, the inactive output is 0, so authority
    // naturally fades at the mode boundary before the hysteresis switch fires.
    _yawOutput = linearConversion[HDG_HOLD_SPEED_SWITCH_DECEL, HDG_HOLD_SPEED_SWITCH_ACCEL, _gndSpeed, _hdgOut, _sideslipOut, true];
    // Normalize clamp by deltaTime so angular impulse (position * thrust * deltaTime) stays
    // constant regardless of step size. Prevents Euler instability during large time steps.
    private _apClamp = [0.033 / (_deltaTime max 0.001), 0.0, 1.0] call BIS_fnc_clamp;
    _yawOutput = [_yawOutput, -_apClamp, _apClamp] call BIS_fnc_clamp;

    if (_yawBreakout) then {
        [_pidAutoPedalHdg]  call fza_fnc_pidReset;
        [_pidAutoPedalSlip] call fza_fnc_pidReset;
    } else {
        _heli setVariable ["fza_ah64_forceTrimPosPedal", _yawOutput, true];
    };
};

if (_fltControlLockout) then {
    if (
        (_cyclicFwdAft    < CENTER_TRIM_VAL && _cyclicFwdAft    > -CENTER_TRIM_VAL) &&
        (_cyclicLeftRight < CENTER_TRIM_VAL && _cyclicLeftRight > -CENTER_TRIM_VAL) &&
        (_pedalLeftRight  < CENTER_TRIM_VAL && _pedalLeftRight  > -CENTER_TRIM_VAL)
       ) then {
            _heli setVariable ["fza_sfmplus_flightControlLockOut", false];
       };
       if (fza_sfmplus_cyclicCenterTrimMode) then {
            _cyclicFwdAft    = 0.0;
            _cyclicLeftRight = 0.0;
       };

       if (fza_sfmplus_pedalCenterTrimMode) then {
            _pedalLeftRight  = 0.0;
       };
};
_cyclicFwdAft    = [_heli, "pitch", _cyclicFwdAft,    _inputLagValue] call fza_sfmplus_fnc_actuator;
_cyclicLeftRight = [_heli, "roll",  _cyclicLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
_pedalLeftRight  = [_heli, "yaw",   _pedalLeftRight,  _inputLagValue] call fza_sfmplus_fnc_actuator;

//systemChat format ["_cyclicFwdAft = %1 -- _cyclicLeftRight = %2 -- _pedalLeftRight = %3", _cyclicFwdAft, _cyclicLeftRight, _pedalLeftRight];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective           /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//Keyboard collective
private _keyCollectiveUp = _heli getVariable "fza_sfmplus_kbHeliCollectiveRaiseOut";
private _keyCollectiveDn = _heli getVariable "fza_sfmplus_kbHeliCollectiveLowerOut";
//Joystick collective
private _joyCollectiveUp = _heli getVariable "fza_sfmplus_heliCollectiveRaiseOut";
private _joyCollectiveDn = _heli getVariable "fza_sfmplus_heliCollectiveLowerOut";

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
    _hydFailure = true;
};

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilLevel_pct < SYS_HYD_MIN_LVL) then {
    _tailRtrFixed = true;
};

if (!_hydFailure || _emerHydOn) then {
    if (fza_sfmplus_keyboardCollective) then {
        private _collectiveValue = _heli getVariable "fza_sfmplus_collectiveOutput";
        if (_keyCollectiveUp > 0.1) then { _collectiveValue = _collectiveValue + ((1.0 / 4.0) * _deltaTime); };
        if (_keyCollectiveDn > 0.1) then { _collectiveValue = _collectiveValue - ((1.0 / 4.0) * _deltaTime); };
        _collectiveValue = (round (_collectiveValue / 0.005)) * 0.005;
        _collectiveValue = [_collectiveValue, 0.0, 1.0] call bis_fnc_clamp;
        _heli setVariable ["fza_sfmplus_collectiveOutput", _collectiveValue];

        //systemChat format ["KB collective! -- %1", (_heli getVariable "fza_sfmplus_collectiveOutput") toFixed 3];
    } else {
        private _collectiveValue = _joyCollectiveUp - _joyCollectiveDn;
        _collectiveValue = [_collectiveValue, -1.0, 1.0] call BIS_fnc_clamp;
        _collectiveValue = linearConversion[ -1.0, 1.0, _collectiveValue, 0.0, 1.0];

        if (isNil "fza_sfmplus_lastIsPlaying") then {
            _heli setVariable ["fza_sfmplus_collectiveOutput", _collectiveValue];
        } else {
            if (_isPlaying && fza_sfmplus_lastIsPlaying) then {
                private _collectivePrevious = _heli getVariable "fza_sfmplus_collectivePrevious";
                _heli setVariable ["fza_sfmplus_collectiveOutput", _collectivePrevious];
            };
        };

        fza_sfmplus_lastIsPlaying = _isPlaying;
        _heli setVariable ["fza_sfmplus_collectivePrevious", _collectiveValue];
        
        //systemChat format ["HOTAS collective! -- %1", (_heli getVariable "fza_sfmplus_collectiveOutput") toFixed 3];
    };
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic and Pedals    /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (_isZeus && (!_hydFailure || _emerHydOn)) then {
    if (fza_ah64_sfmPlusMouseAsJoystick) then {
        _heli setVariable ["fza_sfmplus_cyclicFwdAft",    _cyclicFwdAft    * fza_ah64_sfmPlusMouseSense];
        _heli setVariable ["fza_sfmplus_cyclicLeftRight", _cyclicLeftRight * fza_ah64_sfmPlusMouseSense];
    } else {
        _heli setVariable ["fza_sfmplus_cyclicFwdAft",    _cyclicFwdAft];
        _heli setVariable ["fza_sfmplus_cyclicLeftRight", _cyclicLeftRight];
    };
    if (!_tailRtrFixed) then {
        _heli setVariable ["fza_sfmplus_pedalLeftRight", _pedalLeftRight];
    };
} else {
    _heli setVariable ["fza_sfmplus_cyclicFwdAft",     0.0];
    _heli setVariable ["fza_sfmplus_cyclicLeftRight",  0.0];
    _heli setVariable ["fza_sfmplus_pedalLeftRight",   0.0];
};

if (fza_ah64_lastFrameGetIn) then {
    fza_ah64_lastFrameGetIn = false;
};
