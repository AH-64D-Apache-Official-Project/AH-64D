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

if (!(currentPilot _heli == player) || !(local _heli)) exitWith {};

private _paused             = isNull findDisplay 49;
private _chatting           = isNull findDisplay 24;
private _inDialog           = !dialog;
private _isZeus             = isNull findDisplay 312;
private _inMap              = !visibleMap;
private _inInventory        = isNull findDisplay 602;

private _isPlaying          = isGameFocused && _paused && _chatting && _inDialog && _isZeus && _inMap && _inInventory && !fza_ah64_lastFrameGetIn; 

private _config             = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles     = configFile >> "CfgVehicles" >> typeof _heli;
private _inputLagValue      = getNumber (_config >> "inputLagValue");

private _hydFailure         = false;
private _tailRtrFixed       = false;

private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";

//Keyboard
private _keyboardTimeScalar = 1.0 / 1.5;
private _keyboardLimitVal   = 1.0;

private _kbPitchSwitchVel   = 5.1444;
private _pitchBreakout      = false;
private _desiredPitch       = _heli getVariable "fza_sfmplus_autoCyclic_desiredPitch";
private _kbCyclicFwdAft     = _heli getVariable "fza_sfmplus_kbCyclicFwdAft";

private _kbRollSwitchVel    = 5.14444;
private _rollBreakout       = false;
private _desiredRoll        = _heli getVariable "fza_sfmplus_autoCyclic_desiredRoll";
private _kbCyclicLeftRight  = _heli getVariable "fza_sfmplus_kbCyclicLeftRight";

private _kbYawSwitchVel     = 5.14444 * 2.4;  //10kts = 5.1444 m/s
private _yawBreakout        = false;
private _kbPedalLeftRight   = _heli getVariable "fza_sfmplus_kbPedalLeftRight";

private _collectiveOutput   = _heli getVariable "fza_sfmplus_collectiveOutput";
private _collectivePrevious = _heli getVariable "fza_sfmplus_collectivePrevious";
private _collectiveValue    = _heli getVariable "fza_sfmplus_collectiveValue";

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
private _cyclicFwdAft       = (inputAction "HeliCyclicForward") - (inputAction "HeliCyclicBack");
private _cyclicLeftRight    = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");
private _pedalLeftRight     = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");

if (!_isPlaying) then {
    _cyclicFwdAft    = 0.0;
    _cyclicLeftRight = 0.0;
};

if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicFwdAft    = linearConversion [-0.5, 0.5, _cyclicFwdAft,    -1.0, 1.0, true];
    _cyclicLeftRight = linearConversion [-0.5, 0.5, _cyclicLeftRight, -1.0, 1.0, true];
    _pedalLeftRight  = linearConversion [-0.5, 0.5, _pedalLeftRight,  -1.0, 1.0, true];
} else {
    ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind"))
    params [
             "_velX"
           , "_velY"
           , "_velZ"
           ];
    
    (_heli call BIS_fnc_getPitchBank)
    params ["_curPitch", "_curRoll"];

    private _gndSpeed = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Cyclic Pitch      /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////    
    private _pitchBreakoutVal = (inputAction "HeliCyclicForward") - (inputAction "HeliCyclicBack");
    if (_pitchBreakoutVal < -0.1 || _pitchBreakoutVal > 0.1) then {
        _pitchBreakout = true;
    };

    if (_pitchBreakout) then {
        _kbCyclicFwdAft = [_kbCyclicFwdAft, _cyclicFwdAft, _keyboardTimeScalar * _deltaTime] call BIS_fnc_lerp;
        _kbCyclicFwdAft = [_kbCyclicFwdAft, -1.0, 1.0] call BIS_fnc_clamp;
    } else {
        _kbCyclicFwdAft = 0.0;
    };
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Cyclic Auto Pitch /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _pidAutoCyclicPitchPos = _heli getVariable "fza_sfmplus_pid_autoCyclicPitchPos";
    //_pidAutoCyclicPitchPos set ["kp", APCP_KP];
    //_pidAutoCyclicPitchPos set ["ki", APCP_KI];
    //_pidAutoCyclicPitchPos set ["kd", APCP_KD];
    private _pidAutoCyclicPitchVel = _heli getVariable "fza_sfmplus_pid_autoCyclicPitchVel";
    //_pidAutoCyclicPitchVel set ["kp", APCP_KP];
    //_pidAutoCyclicPitchVel set ["ki", APCP_KI];
    //_pidAutoCyclicPitchVel set ["kd", APCP_KD];

    //systemChat format ["_desiredPitch = %1 -- _curPitch = %2", _desiredPitch toFixed 2, _curPitch toFixed 2];
    private _pitchPosOutput = [_pidAutoCyclicPitchPos,  _deltaTime, 0.0, _velY] call fza_fnc_pidRun;
    _pitchPosOutput         = [_pitchPosOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    
    if (_pitchBreakout) then {
        _desiredPitch = _curPitch;
    };

    private _pitchError     = [_curPitch - _desiredPitch]  call CBA_fnc_simplifyAngle180;
    private _pitchVelOutput = [_pidAutoCyclicPitchVel,  _deltaTime, 0.0, -_pitchError] call fza_fnc_pidRun;
    _pitchVelOutput         = [_pitchVelOutput,  -1.0, 1.0] call BIS_fnc_clamp;

    private _pitchOutput    = linearConversion[0.0, _kbPitchSwitchVel, _gndSpeed, _pitchPosOutput, _pitchVelOutput, true];
    _pitchOutput            = [_pitchOutput, -1.0, 1.0] call BIS_fnc_clamp;

    if (_pitchBreakout) then {
        _pitchOutput = 0.0;
        [_pidAutoCyclicPitchPos] call fza_fnc_pidReset;
        [_pidAutoCyclicPitchVel] call fza_fnc_pidReset;
    };

    _cyclicFwdAft           = _kbCyclicFwdAft + _pitchOutput;
    _heli setVariable ["fza_sfmplus_kbCyclicFwdAft",          _cyclicFwdAft];
    _heli setVariable ["fza_sfmplus_autoCyclic_desiredPitch", _desiredPitch, true];
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Cyclic Roll       /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _rollBreakoutVal = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");
    if (_rollBreakoutVal < -0.1 || _rollBreakoutVal > 0.1) then {
        _rollBreakout = true;
    };

    if (_rollBreakout) then {
        _kbCyclicLeftRight = [_kbCyclicLeftRight, _cyclicLeftRight, _keyboardTimeScalar * _deltaTime] call BIS_fnc_lerp;
        _kbCyclicLeftRight = [_kbCyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
    } else {
        _kbCyclicLeftRight = 0.0;
    };
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Cyclic Auto Roll  /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _pidAutoCyclicRollPos  = _heli getVariable "fza_sfmplus_pid_autoCyclicRollPos";
    //_pidAutoCyclicRollPos set ["kp", APCR_KP];
    //_pidAutoCyclicRollPos set ["ki", APCR_KI];
    //_pidAutoCyclicRollPos set ["kd", APCR_KD];
    private _pidAutoCyclicRollVel  = _heli getVariable "fza_sfmplus_pid_autoCyclicRollVel";
    //_pidAutoCyclicRollVel set ["kp", APCR_KP];
    //_pidAutoCyclicRollVel set ["ki", APCR_KI];
    //_pidAutoCyclicRollVel set ["kd", APCR_KD];

    //systemChat format ["_desiredRoll = %1 -- _curRoll = %2", _desiredRoll toFixed 2, _curRoll toFixed 2];
    private _rollPosOutput = [_pidAutoCyclicRollPos, _deltaTime, 0.0, -_velX] call fza_fnc_pidRun;
    _rollPosOutput         = [_rollPosOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    
    if (_rollBreakout) then {
        _desiredRoll = _curRoll;
    };

    private _rollError     = [_curRoll - _desiredRoll]  call CBA_fnc_simplifyAngle180;
    private _rollVelOutput = [_pidAutoCyclicRollVel, _deltaTime, 0.0, -_rollError] call fza_fnc_pidRun;
    _rollVelOutput         = [_rollVelOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    
    private _rollOutput    = linearConversion[0.0, _kbRollSwitchVel, _gndSpeed, _rollPosOutput, _rollVelOutput, true];
    _rollOutput            = [_rollOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    
    if (_rollBreakout) then {
        _rollOutput = 0.0;
        [_pidAutoCyclicRollPos] call fza_fnc_pidReset;
        [_pidAutoCyclicRollVel] call fza_fnc_pidReset;
    };

     _cyclicLeftRight   = _kbCyclicLeftRight + _rollOutput;
    _heli setVariable ["fza_sfmplus_kbCyclicLeftRight",      _cyclicLeftRight];
    _heli setVariable ["fza_sfmplus_autoCyclic_desiredRoll", _desiredRoll, true];
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Pedal Yaw         /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _yawBreakoutVal = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
    if (_yawBreakoutVal < -0.1 || _yawBreakoutVal > 0.1) then {
        _yawBreakout = true;
    };

    if (_yawBreakout) then {
        _kbPedalLeftRight = [_kbPedalLeftRight, _pedalLeftRight, _keyboardTimeScalar * _deltaTime] call BIS_fnc_lerp;
        _kbPedalLeftRight = [_kbPedalLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
    } else {
        _kbPedalLeftRight = 0.0;
    };
    /////////////////////////////////////////////////////////////////////////////////////////////
    // KB Auto Pedal        /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _pidAutoPedalHdg = _heli getVariable "fza_sfmplus_pid_autoPedalHdg";
    //_pidAutoPedalHdg set ["kp", APH_KP];
    //_pidAutoPedalHdg set ["ki", APH_KI];
    //_pidAutoPedalHdg set ["kd", APH_KD];
    private _pidAutoPedalSlip = _heli getVariable "fza_sfmplus_pid_autoPedalSlip";
    //_pidAutoPedalSlip set ["kp", APS_KP];
    //_pidAutoPedalSlip set ["ki", APS_KI];
    //_pidAutoPedalSlip set ["kd", APS_KD];

    private _hdgOut        = 0.0;
    private _sideslipOut   = 0.0;
    private _yawOutput     = 0.0;

    private _curHdg        = getDir _heli;
    private _desiredHdg    = _heli getVariable "fza_sfmPlus_autoPedalHdg";
    private _hdgError      = 0.0;
    private _desiredSlip   = 0.0;
    private _sideslipError = 0.0;

    if (_yawBreakout || _gndSpeed > HDG_HOLD_SPEED_SWITCH_DECEL) then {
        _desiredHdg = getDir _heli;
    };

    //systemChat format ["_desiredHdg = %1 -- _curHdg = %2 -- _yawBreakout = %3", _desiredHdg toFixed 2, _curHdg toFixed 2, _yawBreakout]; 
    _hdgError       = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
    _hdgOut         = [_pidAutoPedalHdg,  _deltaTime, 0.0, _hdgError] call fza_fnc_pidRun;
    _sideslipError  = [_desiredSlip - fza_ah64_sideslip] call CBA_fnc_simplifyAngle180;
    _sideslipOut    = [_pidAutoPedalSlip, _deltaTime, 0.0, _sideslipError] call fza_fnc_pidRun;
    _yawOutput      = linearConversion[0.0, _kbYawSwitchVel, _gndSpeed, _hdgOut, _sideslipOut, true];
    _yawOutput      = [_yawOutput, -1.0, 1.0] call BIS_fnc_clamp;

    if (_yawBreakout) then {
        _yawOutput = 0.0;
        [_pidAutoPedalHdg]  call fza_fnc_pidReset;
        [_pidAutoPedalSlip] call fza_fnc_pidReset;
    };

    _pedalLeftRight   = _kbPedalLeftRight + _yawOutput;
    _heli setVariable ["fza_sfmplus_kbPedalLeftRight", _pedalLeftRight];
    _heli setVariable ["fza_sfmPlus_autoPedalHdg",     _desiredHdg, true];
};
_cyclicFwdAft    = [_heli, "pitch", _cyclicFwdAft,    _inputLagValue] call fza_sfmplus_fnc_actuator;
_cyclicLeftRight = [_heli, "roll",  _cyclicLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
_pedalLeftRight  = [_heli, "yaw",   _pedalLeftRight,  _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective           /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//Keyboard collective
private _keyCollectiveUp = inputAction "HeliCollectiveRaise";
private _keyCollectiveDn = inputAction "HeliCollectiveLower";
//Joystick collective
private _joyCollectiveUp = inputAction "HeliCollectiveRaiseCont";
private _joyCollectiveDn = inputAction "HeliCollectiveLowerCont";

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
    _hydFailure = true;
};

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilLevel_pct < SYS_HYD_MIN_LVL) then {
    _tailRtrFixed = true;
};

if (!_hydFailure || _emerHydOn) then {
    if (fza_ah64_sfmPlusControlScheme == MNKB) then {
        if (_keyCollectiveUp > 0.1) then { _collectiveValue = _collectiveValue + ((1.0 / 6.0) * _deltaTime); };
        if (_keyCollectiveDn > 0.1) then { _collectiveValue = _collectiveValue - ((1.0 / 6.0) * _deltaTime); };
        _collectiveValue = [_collectiveValue, 0.0, 1.0] call bis_fnc_clamp;

        if (_isPlaying) then {
            _collectiveOutput = _collectiveValue;
        };
    } else {
        _collectiveValue = _joyCollectiveUp - _joyCollectiveDn;
        _collectiveValue = [_collectiveValue, -1.0, 1.0] call BIS_fnc_clamp;
        _collectiveValue = linearConversion[ -1.0, 1.0, _collectiveValue, 0.0, 1.0];

        if (isNil "fza_sfmplus_lastIsPlaying") then {
            _collectiveOutput = _collectiveValue;
        } else {
            if (_isPlaying && fza_sfmplus_lastIsPlaying) then {
                _collectiveOutput = _collectivePrevious;
            };
        };

        fza_sfmplus_lastIsPlaying  = _isPlaying;
        _heli setVariable ["fza_sfmplus_collectivePrevious", _collectiveValue];
    };
};
_heli setVariable ["fza_sfmplus_collectiveOutput", (round (_collectiveOutput / 0.005)) * 0.005];
_heli setVariable ["fza_sfmplus_collectiveValue", _collectiveOutput];
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic and Pedals    /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (_isZeus && (!_hydFailure || _emerHydOn)) then {
    if (fza_ah64_sfmPlusControlScheme == MNKB) then {
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
    _heli setVariable ["fza_sfmplus_collectiveOutput", _collectiveOutput];
};

if (fza_ah64_lastFrameGetIn) then {
    fza_ah64_lastFrameGetIn = false;
};