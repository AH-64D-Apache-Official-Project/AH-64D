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
// Cyclic Pitch & Roll  /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _cyclicFwdAft       = (inputAction "HeliCyclicForward") - (inputAction "HeliCyclicBack");
private _cyclicLeftRight    = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");

if (!_isPlaying) then {
    _cyclicFwdAft    = 0.0;
    _cyclicLeftRight = 0.0;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Pitch         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicFwdAft = linearConversion [-0.5, 0.5, _cyclicFwdAft, -1.0, 1.0];
    systemChat format ["_cyclicFwdAft = %1", _cyclicFwdAft];
};
_cyclicFwdAft                = [_cyclicFwdAft, -1.0, 1.0] call BIS_fnc_clamp;
_cyclicFwdAft                = [_heli, "pitch", _cyclicFwdAft, _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Roll          /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicLeftRight = linearConversion [-0.5, 0.5, _cyclicLeftRight, -1.0, 1.0];
    systemChat format ["_cyclicLeftRight = %1", _cyclicLeftRight];
};
_cyclicLeftRight             = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
_cyclicLeftRight             = [_heli, "roll", _cyclicLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// Pedal Yaw            /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _pedalLeftRight      = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _pedalLeftRight = linearConversion [-0.5, 0.5, _pedalLeftRight, -1.0, 1.0];
    systemChat format ["_pedalLeftRight = %1", _pedalLeftRight];
};
_pedalLeftRight              = [_heli, "yaw", _pedalLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// Mouse & Keyboard     /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _divisor  = 3.0;
private _inputVal = 0.001;
//Cyclic Pitch
if (fza_ah64_sfmPlusControlScheme == MNKB && fza_ah64_sfmplusEnableKbPitchTrim) then {
    private _cyclicPitchValue = _heli getVariable "fza_sfmplus_cyclicPitchValue";
    if (_cyclicFwdAft > 0.1) then {
        _cyclicPitchValue = _cyclicPitchValue + ((1 / _divisor) * _deltaTime);
    };
    if (_cyclicFwdAft < -0.1) then {
        _cyclicPitchValue = _cyclicPitchValue - ((1 / _divisor) * _deltaTime);
    };
    //Set pitch
    _cyclicPitchValue     = (round (_cyclicPitchValue / _inputVal)) * _inputVal;
    _cyclicFwdAft         = [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp;
    _heli setVariable ["fza_sfmplus_cyclicPitchValue", [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp];
} else {;
    _cyclicFwdAft      = [_cyclicFwdAft,    -1.0, 1.0] call BIS_fnc_clamp;
};

if (fza_ah64_sfmPlusControlScheme == MNKB && fza_ah64_sfmplusEnableKbRollTrim) then {
    private _cyclicRollValue = _heli getVariable "fza_sfmplus_cyclicRollValue";
    if (_cyclicLeftRight > 0.1) then {
        _cyclicRollValue = _cyclicRollValue + ((1 / _divisor) * _deltaTime);
    };
    if (_cyclicLeftRight < -0.1) then {
        _cyclicRollValue = _cyclicRollValue - ((1 / _divisor) * _deltaTime);
    };
    //Set pitch
    _cyclicRollValue     = (round (_cyclicRollValue / _inputVal)) * _inputVal;
    _cyclicLeftRight         = [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp;
    _heli setVariable ["fza_sfmplus_cyclicRollValue", [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp];
} else {;
    _cyclicLeftRight   = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
};

if (fza_ah64_sfmPlusControlScheme == MNKB) then {
    private _gndSpeed           = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Autocyclic           /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    private _pidAutoCyclicRollPos  = _heli getVariable "fza_sfmplus_pid_autoCyclicRollPos";
    //_pidAutoCyclicRollPos set ["kp", APCR_KP];
    //_pidAutoCyclicRollPos set ["ki", APCR_KI];
    //_pidAutoCyclicRollPos set ["kd", APCR_KD];
    private _pidAutoCyclicRollVel  = _heli getVariable "fza_sfmplus_pid_autoCyclicRollVel";
    //_pidAutoCyclicRollVel set ["kp", APCR_KP];
    //_pidAutoCyclicRollVel set ["ki", APCR_KI];
    //_pidAutoCyclicRollVel set ["kd", APCR_KD];
    private _pidAutoCyclicPitch = _heli getVariable "fza_sfmplus_pid_autoCyclicPitch";
    //_pidAutoCyclicPitch set ["kp", APCP_KP];
    //_pidAutoCyclicPitch set ["ki", APCP_KI];
    //_pidAutoCyclicPitch set ["kd", APCP_KD];
    
    ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind"))
    params [
             "_velX"
           , "_velY"
           , "_velZ"
           ];
    
    private _rollBreakout = false;
    private _autoCyclicBreakoutVal = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");
    if (_autoCyclicBreakoutVal < -0.1 || _autoCyclicBreakoutVal > 0.1) then {
        _rollBreakout = true;
    };

    systemChat format ["bank = %1", (_heli call BIS_fnc_getPitchBank select 1) toFixed 2];
    private _rollPosOutput = [_pidAutoCyclicRollPos,  _deltaTime, 0.0, -_velX] call fza_fnc_pidRun;
    _rollPosOutput         = [_rollPosOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    private _rollVelOutput = [_pidAutoCyclicRollVel,  _deltaTime, 0.0, -(_heli call BIS_fnc_getPitchBank select 1)] call fza_fnc_pidRun;
    _rollVelOutput         = [_rollVelOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    private _rollOutput    = linearConversion[0.0, 5.1444, _gndSpeed, _rollPosOutput, _rollVelOutput, true];
    _rollOutput            = [_rollOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    if (_rollBreakout) then {
        _rollOutput = 0.0;
    };

    private _pitchHold   = [_pidAutoCyclicPitch, _deltaTime, 0.0,  _velY] call fza_fnc_pidRun;
    private _pitchOutput = linearConversion[0.0, 5.1444, _gndSpeed, _pitchHold, 0.0, true];
    _pitchOutput         = [_pitchOutput, -1.0, 1.0] call BIS_fnc_clamp;
    
    _cyclicLeftRight     = [_cyclicLeftRight + _rollOutput,  -1.0, 1.0] call BIS_fnc_clamp;
    _cyclicFwdAft        = [_cyclicFwdAft + _pitchOutput, -1.0, 1.0] call BIS_fnc_clamp;
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Autopedals           /////////////////////////////////////////////////////////////////////
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
    private _yawOutput        = 0.0;

    private _curHdg        = getDir _heli;
    private _desiredHdg    = _heli getVariable "fza_sfmPlus_autoPedalHdg";
    private _hdgError      = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
    private _desiredSlip   = 0.0;
    private _sideslipError = [_desiredSlip - fza_ah64_sideslip] call CBA_fnc_simplifyAngle180;

    private _breakout = false;
    private _autoPedalBreakoutVal = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
    if (_autoPedalBreakoutVal < -0.1 || _autoPedalBreakoutVal > 0.1) then {
        _breakout = true;
    };

    if (_breakout || _gndSpeed > HDG_HOLD_SPEED_SWITCH_DECEL) then {
        _heli setVariable ["fza_sfmPlus_autoPedalHdg", getDir _heli, true];
    };
    _hdgOut         = [_pidAutoPedalHdg,  _deltaTime, 0.0, _hdgError] call fza_fnc_pidRun;
    _sideslipOut    = [_pidAutoPedalSlip, _deltaTime, 0.0, _sideslipError] call fza_fnc_pidRun;
    _yawOutput      = linearConversion[0.0, HDG_HOLD_SPEED_SWITCH_ACCEL, _gndSpeed, _hdgOut, _sideslipOut, true];
    _yawOutput      = [_yawOutput, -1.0, 1.0] call BIS_fnc_clamp;
    _pedalLeftRight = [_pedalLeftRight + _yawOutput, -1.0, 1.0] call BIS_fnc_clamp;
} else {;
    _pedalLeftRight    = [_pedalLeftRight,  -1.0, 1.0] call BIS_fnc_clamp;
};
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