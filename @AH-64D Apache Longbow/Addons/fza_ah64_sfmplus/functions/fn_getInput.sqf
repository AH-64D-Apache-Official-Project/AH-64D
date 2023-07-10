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
params ["_heli", "_deltaTime", "_attHoldCycPitchOut", "_attHoldCycRollOut"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _config            = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles    = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel       = getText (_configVehicles>> "fza_flightModel");
private _pitchTorque       = getNumber (_config >> "cyclicPitchTorque");
private _rollTorque        = getNumber (_config >> "cyclicRollTorque");
private _yawTorque         = getNumber (_config >> "pedalYawTorque");
private _inputLagValue     = getNumber (_config >> "inputLagValue");
private _rtrRPM            = [_heli] call fza_sfmplus_fnc_getRtrRPM;

private _hydFailure        = false;
private _tailRtrFixed      = false;

private _priHydPumpDamage  = _heli getHitPointDamage "hit_hyd_pripump";
private _priHydPSI         = _heli getVariable "fza_systems_priHydPsi";

private _utilHydPumpDamage = _heli getHitPointDamage "hit_hyd_utilpump";
private _utilHydPSI        = _heli getVariable "fza_systems_utilHydPsi";
private _utilLevel_pct     = _heli getVariable "fza_systems_utilLevel_pct";

private _emerHydOn         = _heli getVariable "fza_ah64_emerHydOn";
private _apuOn             = _heli getVariable "fza_systems_apuOn";

//Cyclic pitch
private _cyclicFwdAft        = _heli animationSourcePhase "cyclicForward";
_cyclicFwdAft                = [_heli, _deltaTime, "pitch", _cyclicFwdAft, _inputLagValue] call fza_sfmplus_fnc_actuator;
private _cyclicFwdAftTrim    = _heli getVariable "fza_ah64_forceTrimPosPitch";

//Cyclic roll
private _cyclicLeftRight     = (_heli animationSourcePhase "cyclicAside") * -1.0;
_cyclicLeftRight             = [_heli, _deltaTime, "roll", _cyclicLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
private _cyclicLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosRoll";

//Pedals
private _pedalLeftRight      = (inputAction "HeliRudderRight") - (inputAction "HeliRudderLeft");
_pedalLeftRight              = [_heli, _deltaTime, "yaw", _pedalLeftRight, _inputLagValue] call fza_sfmplus_fnc_actuator;
_pedalLeftRight              = [_pedalLeftRight, -1.0, 1.0] call BIS_fnc_clamp;

//Collective
if (_flightModel == "SFMPlus") then {
    private _collectiveOut = 0.0;
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
    fza_sfmplus_collectiveOutput = _collectiveOut;
} else {
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
        if (isNil "fza_sfmplus_collectiveOutput") then {
            fza_sfmplus_collectiveOutput = 0;
        };

        if (currentPilot _heli == player ) then {
            if (fza_ah64_sfmPlusKeyboardOnly) then {
                private _collectiveVal = fza_sfmplus_collectiveOutput;
                if (_keyCollectiveUp > 0.1) then { _collectiveVal = _collectiveVal + ((1.0 / 3.0) * _deltaTime); };
                if (_keyCollectiveDn > 0.1) then { _collectiveVal = _collectiveVal - ((1.0 / 3.0) * _deltaTime); };
                fza_sfmplus_collectiveOutput = [_collectiveVal, 0.0, 1.0] call bis_fnc_clamp;
            } else {
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
};

private _isZeus = !isNull findDisplay 312;

//Cyclic and Pedals 
if (!_isZeus && currentPilot _heli == player) then {
    fza_sfmplus_cyclicFwdAft       = [_cyclicFwdAft,    -1.0, 1.0] call BIS_fnc_clamp;
    fza_sfmplus_cyclicLeftRight    = [_cyclicLeftRight, -1.0, 1.0] call BIS_fnc_clamp;
    if (!_tailRtrFixed) then {
        fza_sfmplus_pedalLeftRight = [_pedalLeftRight,  -1.0, 1.0] call BIS_fnc_clamp;
    };
} else {
    fza_sfmplus_cyclicFwdAft    = 0.0;
    fza_sfmplus_cyclicLeftRight = 0.0;
    fza_sfmplus_pedalLeftRight  = 0.0;
};

//Cyclic pitch torque
private _foreAftTorque   = (fza_sfmplus_cyclicFwdAft + _cyclicFwdAftTrim) * _pitchTorque;
private _fmcPitchTorque  = (_attHoldCycPitchOut * (_pitchTorque * 0.20));
_foreAftTorque           = (_foreAftTorque + _fmcPitchTorque) * _rtrRPM;

//Cyclic roll torque
private _leftRightTorque = (fza_sfmplus_cyclicLeftRight + _cyclicLeftRightTrim) * _rollTorque;
private _fmcRollTorque   = (_attHoldCycRollOut  * (_rollTorque  * 0.10));
_leftRightTorque         = (_leftRightTorque + _fmcRollTorque) * _rtrRPM;

//Hydrualic power is provided by the APU turnign the accesory gearbox or by the transmission
if (_apuOn || (_rtrRPM > SYS_HYD_MIN_RTR_RPM)) then {
    //Primary and Utility Hydraulics
    if (_priHydPumpDamage < SYS_HYD_DMG_THRESH || _utilHydPumpDamage < SYS_HYD_DMG_THRESH) then {
        if (currentPilot _heli == player || !isplayer driver _heli) then {
            _heli addTorque (_heli vectorModelToWorld[_foreAftTorque, _leftRightTorque, 0.0]);
        };
    };
};

//Emergency Hydraulics
if (_emerHydOn) then {
    if (currentPilot _heli == player || !isplayer driver _heli) then { 
        _heli addTorque (_heli vectorModelToWorld [_foreAftTorque, _leftRightTorque, 0.0]);
    };
};