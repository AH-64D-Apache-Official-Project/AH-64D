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
params ["_heli", "_deltaTime", "_attHoldCycPitchOut", "_attHoldCycRollOut", "_hdgHoldPedalYawOut"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _config            = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles    = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel       = getText (_configVehicles>> "fza_flightModel");
private _pitchTorque       = getNumber (_config >> "cyclicPitchTorque");
private _rollTorque        = getNumber (_config >> "cyclicRollTorque");
private _yawTorque         = getNumber (_config >> "pedalYawTorque");

private _hydFailure        = false;
private _tailRtrFixed      = false;

private _priHydPumpDamage  = _heli getHitPointDamage "hit_hyd_pripump";
private _priHydPSI         = _heli getVariable "fza_systems_priHydPsi";

private _utilHydPumpDamage = _heli getHitPointDamage "hit_hyd_utilpump";
private _utilHydPSI        = _heli getVariable "fza_systems_utilHydPsi";
private _utilLevel_pct     = _heli getVariable "fza_systems_utilLevel_pct";

private _accOn             = _heli getVariable "fza_systems_accOn";

private _cyclicFwdAft      = (inputAction "HeliCyclicForward") - (inputAction "HeliCyclicBack");//animationSourcePhase "cyclicForward";
private _cyclicLeftRight   = (inputAction "HeliCyclicLeft") - (inputAction "HeliCyclicRight");//_heli animationSourcePhase "cyclicAside";
private _pedalLeftRight    = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");

private _tailRtrDamage     = _heli getHitPointDamage "hitvrotor";

private _collectiveOut     = 0.0;
if (_flightModel == "SFMPlus") then {
    private _collectiveVal = _heli animationSourcePhase "collective";

    if (fza_ah64_sfmPlusKeyboardOnly) then {
        _collectiveVal         = [_collectiveVal, 0.5, 1.0] call BIS_fnc_clamp;
        _collectiveOut         = linearConversion[ 0.5, 1.0, _collectiveVal, 0.0, 2.0];

        private _V_mps            = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
        private _collectiveOutMod = linearConversion [0.00, 12.35, _V_mps, 0.775, 0.853, true];

        _collectiveOut = [_collectiveOut, 0.0, _collectiveOutMod] call BIS_fnc_clamp;
    } else {
        _collectiveOut = linearConversion[-1.0, 1.0, _collectiveVal, 0.0, 1.0];
    };
} else {
    //systemChat format ["HeliSim Input Handler"];
    //Keyboard collective
    private _keyCollectiveUp = inputAction "HeliCollectiveRaise";
    private _keyCollectiveDn = inputAction "HeliCollectiveLower";
    //Joystick collective
    private _joyCollectiveUp = inputAction "HeliCollectiveRaiseCont";
    private _joyCollectiveDn = inputAction "HeliCollectiveLowerCont";

    if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
        _hydFailure = true;
    };

    if (!_hydFailure) then {
        if (isNil "fza_sfmplus_collectiveOutput") then {
            fza_sfmplus_collectiveOutput = 0;
        };

        if (fza_ah64_sfmPlusKeyboardOnly) then {
            //systemChat format ["Keyboard only!"];
            private _collectiveVal = fza_sfmplus_collectiveOutput;
            if (_keyCollectiveUp > 0.1) then { _collectiveVal = _collectiveVal + ((1.0 / 3.0) * _deltaTime); };
            if (_keyCollectiveDn > 0.1) then { _collectiveVal = _collectiveVal - ((1.0 / 3.0) * _deltaTime); };
            fza_sfmplus_collectiveOutput = [_collectiveVal, 0.0, 1.0] call bis_fnc_clamp;
        } else {
            //systemChat format ["Joystick only!"];
            private _collectiveVal = _joyCollectiveUp - _joyCollectiveDn;
            _collectiveVal = [_collectiveVal, -1.0, 1.0] call BIS_fnc_clamp;
            _collectiveVal = linearConversion[ -1.0, 1.0, _collectiveVal, 0.0, 1.0];

            private _isPlaying = isNull findDisplay 49;

            if (isNil "fza_sfmplus_prevCollective" || isNil "fza_sfmplus_lastIsPlaying") then {
                fza_sfmplus_collectiveOutput = _collectiveVal;
            } else {
                if (_isPlaying && fza_sfmplus_lastIsPlaying) then {
                    fza_sfmplus_collectiveOutput = fza_sfmplus_prevCollective;
                };
            };

            fza_sfmplus_lastIsPlaying = _isPlaying;
            fza_sfmplus_prevCollective = _collectiveVal;
        };
    };
};

//Cyclic and Pedal Torque
_cyclicFwdAft    = [_cyclicFwdAft,    -1.0, 1.0] call BIS_fnc_clamp;
_cyclicLeftRight = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
_pedalLeftRight  = [_pedalLeftRight,  -1.0, 1.0] call BIS_fnc_clamp;

private _foreAftTorque   = (_cyclicFwdAft    + _attHoldCycPitchOut) *  _pitchTorque;
private _leftRightTorque = (_cyclicLeftRight + _attHoldCycRollOut)  *  _rollTorque;

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilLevel_pct < SYS_HYD_MIN_LVL) then {
    _tailRtrFixed = true;
};

if (_tailRtrDamage == 1.0 || _tailRtrFixed == true) then {
    _yawTorque = 0.0;
};
private _pedalTorque     = _pedalLeftRight  * _yawTorque;

private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

if (_eng1PwrLvrState in ["IDLE","FLY"] || _eng2PwrLvrState in ["IDLE","FLY"]) then {
    //Primary and Utility Hydraulics
    if (_priHydPumpDamage < SYS_HYD_DMG_THRESH || _utilHydPumpDamage < SYS_HYD_DMG_THRESH) then {
        _heli addTorque (_heli vectorModelToWorld[_foreAftTorque, _leftRightTorque, _pedalTorque]);
    };
    //Emergency Hydraulics
    if (_accOn) then {
        _heli addTorque (_heli vectorModelToWorld[_foreAftTorque, _leftRightTorque, _pedalTorque]);
    };
};