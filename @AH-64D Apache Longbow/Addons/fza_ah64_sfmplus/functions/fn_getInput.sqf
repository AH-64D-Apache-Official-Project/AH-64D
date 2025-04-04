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
private _cyclicFwdAft        = (inputAction "HeliCyclicForward") - (inputAction "HeliCyclicBack");
private _cyclicLeftRight     = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");

if (!_isPlaying) then {
    _cyclicFwdAft    = 0.0;
    _cyclicLeftRight = 0.0;
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Pitch         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicFwdAft = linearConversion [-0.5, 0.5, _cyclicFwdAft, -1.0, 1.0];
};
_cyclicFwdAft                = [_cyclicFwdAft, -1.0, 1.0] call BIS_fnc_clamp;
_cyclicFwdAft                = [_heli, "pitch", _cyclicFwdAft, _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Roll          /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicLeftRight = linearConversion [-0.5, 0.5, _cyclicLeftRight, -1.0, 1.0];
};
_cyclicLeftRight             = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
_cyclicLeftRight             = [_heli, "roll", _cyclicLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
/////////////////////////////////////////////////////////////////////////////////////////////
// "Sticky" cyclic       /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (fza_ah64_sfmPlusControlScheme == MNKB && fza_ah64_sfmplusEnableKbTrim && (_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Cyclic Pitch
    private _divisor  = 3;
    private _inputVal = 0.001;

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

    //Cyclic Roll
    private _cyclicRollValue = _heli getVariable "fza_sfmplus_cyclicRollValue";
    if (_cyclicLeftRight > 0.1) then {
        _cyclicRollValue = _cyclicRollValue + ((1 / _divisor) * _deltaTime);
    };
    if (_cyclicLeftRight < -0.1) then {
        _cyclicRollValue = _cyclicRollValue - ((1 / _divisor) * _deltaTime);
    };
    //Set roll
    _cyclicRollValue     = (round (_cyclicRollValue / _inputVal)) * _inputVal;
    _cyclicLeftRight     = [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp;
    _heli setVariable ["fza_sfmplus_cyclicRollValue", [_cyclicRollValue, -1.0, 1.0] call BIS_fnc_clamp];
    _cyclicLeftRight     = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
} else {;
    _cyclicFwdAft        = [_cyclicFwdAft,    -1.0, 1.0] call BIS_fnc_clamp;
    _cyclicLeftRight     = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
};

/////////////////////////////////////////////////////////////////////////////////////////////
// Pedal Yaw            /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _pedalLeftRight      = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _pedalLeftRight = linearConversion [-0.5, 0.5, _pedalLeftRight, -1.0, 1.0];
};
_pedalLeftRight              = [_heli, "yaw", _pedalLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
_pedalLeftRight              = [_pedalLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
//systemChat format ["_cyclicLeftRight = %1 -- _cyclicFwdAft = %2 -- _pedalLeftRight = %3", _cyclicLeftRight toFixed 2, _cyclicFwdAft toFixed 2, _pedalLeftRight toFixed 2];

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
    if (_keyCollectiveUp > 0.1) then { _collectiveValue = _collectiveValue + ((1.0 / 6.0) * _deltaTime); };
    if (_keyCollectiveDn > 0.1) then { _collectiveValue = _collectiveValue - ((1.0 / 6.0) * _deltaTime); };
    _collectiveValue = [_collectiveValue, 0.0, 1.0]    call bis_fnc_clamp;

    _hotasCollectiveValue = _joyCollectiveUp - _joyCollectiveDn;
    if (_heli getVariable ["fza_sfmplus_AnalogueCollective", 0] != _hotasCollectiveValue) then {
        _heli setVariable ["fza_sfmplus_AnalogueCollective", _hotasCollectiveValue];

        _collectiveValue = [_hotasCollectiveValue, -1.0, 1.0] call BIS_fnc_clamp;
        _collectiveValue = linearConversion[ -1.0, 1.0, _collectiveValue, 0.0, 1.0];
    };
    if (_isPlaying) then {
        _collectiveOutput = _collectiveValue;
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