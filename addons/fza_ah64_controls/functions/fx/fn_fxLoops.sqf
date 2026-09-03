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

        private _apuBtnOn_OLD = _heli getVariable ["fza_systems_apuBtnOn", false];
        private _apuRPM_pct_TargetNum = parseNumber _apuBtnOn_OLD; // (0/1)
        private _apuRPM_pct_StartNum = parseNumber !_apuBtnOn_OLD; // (0/1)

        //- Toggle APU startup sound (0/1)
        setCustomSoundController [_heli, "CustomSoundController9", _apuRPM_pct_TargetNum];

        // [_heli,_apuBtnOn_OLD,_apuRPM_pct_TargetNum,_apuRPM_pct_StartNum] spawn {
            // params ["_heli","_apuBtnOn_OLD","_apuRPM_pct_TargetNum","_apuRPM_pct_StartNum"];
            while {
                private _apuBtnOn = _heli getVariable ["fza_systems_apuBtnOn", false];
                private _apuRPM_pct = _heli getVariable ["fza_systems_apuRPM_pct", _apuRPM_pct_StartNum];

                alive _heli &&
                _apuBtnOn_OLD == _apuBtnOn &&
                abs(_apuRPM_pct - _apuRPM_pct_StartNum) < 0.99
            } do {
                private _apuRPM_pct = _heli getVariable ["fza_systems_apuRPM_pct", _apuRPM_pct_StartNum];
                setCustomSoundController [_heli,"CustomSoundController1", _apuRPM_pct];
                sleep _deltaTime;
            };

            //- clean up (straight to targetNum)
            if (alive _heli) then {
                setCustomSoundController [_heli,"CustomSoundController1", _apuRPM_pct_TargetNum];
            };
        // };
    };

    //- Battery sound
    case "batt": {
        private _battBusOn = _heli getVariable ["fza_systems_battBusOn", false];
        setCustomSoundController [_heli,"CustomSoundController2", parseNumber _battBusOn];
    };

    //- Power Lever
    case "powerLever": {
        private _engMaxNG = getNumber (configOf _heli >> "Fza_SfmPlus" >> "engMaxNG");

        while {
            private _engPctNG = _heli getVariable ["fza_sfmplus_engPctNG", [0.0, 0.0]];
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];
            private _engPct_toValue = ((_engPctNG # 0) + (_engPctNG # 1)) / (_engMaxNG * 2);

            alive _heli &&
            abs(_engPct - _engPct_toValue) > 0.001
        } do {
            private _engPctNG = _heli getVariable ["fza_sfmplus_engPctNG", [0.0, 0.0]];
            private _engPct_toValue = ((_engPctNG # 0) + (_engPctNG # 1)) / (_engMaxNG * 2);
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPct = [_engPct, _engPct_toValue, _deltaTime / 1.5] call BIS_fnc_lerp;

            setCustomSoundController [_heli,"CustomSoundController15", _engPct];
            sleep _deltaTime;
        };
    };
};
