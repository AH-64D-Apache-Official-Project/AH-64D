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
//private _isFreeLook         = freeLook;

//if (fza_ah64_sfmPlusDisableFreelook) then {
//    _isFreeLook = false;
//};
private _isPlaying          = isGameFocused && _paused && _chatting && _inDialog && _isZeus && _inMap && _inInventory && !fza_ah64_lastFrameGetIn; //&& !_isFreeLook

private _config             = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles     = configFile >> "CfgVehicles" >> typeof _heli;
private _inputLagValue      = getNumber (_config >> "inputLagValue");

private _hydFailure         = false;
private _tailRtrFixed       = false;

private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";

//Keyboard
private _keyboardTimeScalar = 1.0 / 1.75;
private _keyboardLimitVal   = 1.0;

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
private _cyclicFwdAft       = _heli animationSourcePhase "cyclicForward";
_cyclicFwdAft               = linearConversion [-0.5, 0.5, _cyclicFwdAft, -1.0, 1.0, true];

private _cyclicLeftRight    = (_heli animationSourcePhase "cyclicAside") * -1.0;
_cyclicLeftRight            = linearConversion [-0.5, 0.5, _cyclicLeftRight, -1.0, 1.0, true];

//systemChat format ["_cyclicFwdAft = %1 -- _cyclicLeftRight = %2", _cyclicFwdAft toFixed 2, _cyclicLeftRight toFixed 2];

private _pedalLeftRight     = (inputAction "HeliRudderRight")   - (inputAction "HeliRudderLeft");
_pedalLeftRight             = linearConversion [-0.5, 0.5, _pedalLeftRight,  -1.0, 1.0, true];

if (!_isPlaying) then {
    _cyclicFwdAft      = 0.0;
    _cyclicLeftRight   = 0.0;
};

if (fza_ah64_sfmPlusControlScheme == MNKB) then {
    //Cyclic Pitch
    if (fza_ah64_sfmPlusKeyboardStickyPitch) then {
        private _cyclicPitchValue = _heli getVariable "fza_sfmplus_cyclicPitchValue";
        if (_cyclicFwdAft > 0.1) then {
            _cyclicPitchValue = _cyclicPitchValue + (_keyboardTimeScalar * _deltaTime);
        };
        if (_cyclicFwdAft < -0.1) then {
            _cyclicPitchValue = _cyclicPitchValue - (_keyboardTimeScalar * _deltaTime);
        };
        //Set pitch
        _cyclicFwdAft         = [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_cyclicPitchValue", [_cyclicPitchValue, -1.0, 1.0] call BIS_fnc_clamp];
    };
    //Cyclic Roll
    if (fza_ah64_sfmPlusKeyboardStickyRoll) then {
        private _cyclicRollValue = _heli getVariable "fza_sfmplus_cyclicRollValue";
        if (_cyclicLeftRight > 0.1) then {
            _cyclicRollValue = _cyclicRollValue + (_keyboardTimeScalar * _deltaTime);
        };
        if (_cyclicLeftRight < -0.1) then {
            _cyclicRollValue = _cyclicRollValue - (_keyboardTimeScalar * _deltaTime);
        };
        //Set roll
        _cyclicLeftRight     = [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_cyclicRollValue", [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp];
    };
    //Pedal yaw
    if (fza_ah64_sfmPlusKeyboardStickyYaw) then {
        private _pedalYawValue = _heli getVariable "fza_sfmplus_pedalYawValue";
        if (_pedalLeftRight > 0.1) then {
            _pedalYawValue = _pedalYawValue + (_keyboardTimeScalar * _deltaTime);
        };
        if (_pedalLeftRight < -0.1) then {
            _pedalYawValue = _pedalYawValue - (_keyboardTimeScalar * _deltaTime);
        };
        //Set yaw
        _pedalLeftRight     = [_pedalYawValue, -1.0, 1.0] call BIS_fnc_clamp;
        _heli setVariable ["fza_sfmplus_pedalYawValue", [_pedalYawValue, -1.0, 1.0] call BIS_fnc_clamp];
    };
    //systemChat format ["_cyclicFwdAft = %1 -- _cyclicLeftRight = %2 -- _pedalLeftRight = %3", _cyclicFwdAft, _cyclicLeftRight, _pedalLeftRight];
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
    } else {
        _collectiveValue = _joyCollectiveUp - _joyCollectiveDn;
        _collectiveValue = [_collectiveValue, -1.0, 1.0] call BIS_fnc_clamp;
        _collectiveValue = linearConversion[ -1.0, 1.0, _collectiveValue, 0.0, 1.0];
    };

    if (isNil "fza_sfmplus_lastIsPlaying") then {
        _collectiveOutput = _collectiveValue;
    } else {
        if (_isPlaying && fza_sfmplus_lastIsPlaying) then {
            _collectiveOutput = _collectivePrevious;
        };
    };

    fza_sfmplus_lastIsPlaying          = _isPlaying;
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