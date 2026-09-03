/* ----------------------------------------------------------------------------
Function: fza_fnc_fxLoops

Description:
    Update loops for sound effects

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli,"batt"] spawn fza_fnc_fxLoops;

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli","_type"];

if (!canSuspend) exitWith {
    _this spawn fza_fnc_fxLoops;
};

private _deltaTime = 0.017; //- 60 fps

switch (_type) do {
    case "apu": {
        //- Toggle APU startup sound (0/1)
        setCustomSoundController [_heli, "CustomSoundController9", parseNumber (_heli getVariable ["fza_systems_apuBtnOn", false])];

        if (_heli getVariable ["fza_audio_apuLoopActive", false]) exitWith {};
        _heli setVariable ["fza_audio_apuLoopActive", true];

        private _apuRPM_pct_PREV = -1;

        while {
            private _apuRPM_pct = _heli getVariable ["fza_systems_apuRPM_pct", 0];

            alive _heli &&
            abs(_apuRPM_pct - _apuRPM_pct_PREV) > 0.0005
        } do {
            private _apuRPM_pct = _heli getVariable ["fza_systems_apuRPM_pct", 0];
            setCustomSoundController [_heli,"CustomSoundController1", _apuRPM_pct];
            _apuRPM_pct_PREV = _apuRPM_pct;
            sleep _deltaTime;
        };

        if (!isNull _heli) then {
            _heli setVariable ["fza_audio_apuLoopActive", false];
        };
    };

    //- Battery sound
    case "batt": {
        sleep _deltaTime;

        if (alive _heli) then {
            private _battBusOn = _heli getVariable ["fza_systems_battBusOn", false];
            setCustomSoundController [_heli,"CustomSoundController2", parseNumber _battBusOn];
        };
    };

    //- Power Lever
    case "powerLever": {
        if (_heli getVariable ["fza_audio_powerLeverLoopActive", false]) exitWith {};
        _heli setVariable ["fza_audio_powerLeverLoopActive", true];

        private _engMaxNG = getNumber (configOf _heli >> "Fza_SfmPlus" >> "engMaxNG");
        private _engPct_toValue_PREV = -1;

        while {
            private _engPctNG = _heli getVariable ["fza_sfmplus_engPctNG", [0.0, 0.0]];
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];
            private _engPct_toValue = ((_engPctNG # 0) + (_engPctNG # 1)) / (_engMaxNG * 2);

            alive _heli &&
            (
                abs(_engPct - _engPct_toValue) > 0.001 ||
                abs(_engPct_toValue - _engPct_toValue_PREV) > 0.0005
            )
        } do {
            private _engPctNG = _heli getVariable ["fza_sfmplus_engPctNG", [0.0, 0.0]];
            private _engPct_toValue = ((_engPctNG # 0) + (_engPctNG # 1)) / (_engMaxNG * 2);
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPct = [_engPct, _engPct_toValue, _deltaTime / 1.5] call BIS_fnc_lerp;

            setCustomSoundController [_heli,"CustomSoundController15", _engPct];
            _engPct_toValue_PREV = _engPct_toValue;
            sleep _deltaTime;
        };

        if (!isNull _heli) then {
            _heli setVariable ["fza_audio_powerLeverLoopActive", false];
        };
    };
};
