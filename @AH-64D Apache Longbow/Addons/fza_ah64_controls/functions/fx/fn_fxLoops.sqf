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

systemChat str ["fx LOOP", _type ,time];

switch (_type) do {
    case "apu": {
        // #define PREP_FREQ_OFFSET 1.15

        private _apuBtnOn_OLD = _heli getVariable ["fza_systems_apuBtnOn", false];
        private _apuRPM_pct_TargetNum = parseNumber _apuBtnOn_OLD; // (0/1)
        private _apuRPM_pct_StartNum = parseNumber !_apuBtnOn_OLD; // (0/1)

        //- Toggle APU startup sound (0/1)
        setCustomSoundController [_heli, "CustomSoundController9", _apuRPM_pct_TargetNum];

        // [_heli,_apuBtnOn_OLD,_apuRPM_pct_TargetNum,_apuRPM_pct_StartNum] spawn {
            // params ["_heli","_apuBtnOn_OLD","_apuRPM_pct_TargetNum","_apuRPM_pct_StartNum"];
            while {
                private _apuBtnOn = _heli getVariable ["fza_systems_apuBtnOn", false];
                private _apuRPM_pct = _heli getVariable "fza_systems_apuRPM_pct";

                _apuBtnOn_OLD == _apuBtnOn &&
                abs(_apuRPM_pct - _apuRPM_pct_StartNum) < 0.99
            } do {
                private _apuRPM_pct = _heli getVariable "fza_systems_apuRPM_pct";
                setCustomSoundController [_heli,"CustomSoundController1", _apuRPM_pct];
            };

            //- clean up (straight to targetNum)
            setCustomSoundController [_heli,"CustomSoundController1", _apuRPM_pct_TargetNum];
        // };
    };

    //- Battery sound
    case "batt": {
        private _battBusOn = _heli getVariable "fza_systems_battBusOn";
        setCustomSoundController [_heli,"CustomSoundController2", parseNumber _battBusOn];
    };

    //- Battery sound
    case "powerLever": {
        private _engPowerLeverState_OLD = _heli getVariable ["fza_sfmplus_engPowerLeverState", ["OFF","OFF"]];
        private _engPct_toValue = call {
            
            private _engPct = _engPowerLeverState_OLD apply {
                private _index = ["OFF","IDLE","FLY"] find _x;
                linearConversion [0, 2, _index, 0, 0.125];
            };
            
            _engPct vectorDotProduct [1,1]; //- Return total max : 0.5
        };

        while {
            private _engPowerLeverState = _heli getVariable ["fza_sfmplus_engPowerLeverState", ["OFF","OFF"]];
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPowerLeverState_OLD isEqualTo _engPowerLeverState &&
            abs(_engPct - _engPct_toValue) > 0.001
        } do {
            private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPct = [_engPct, _engPct_toValue, _deltaTime / 3.5] call BIS_fnc_lerp;
            
            setCustomSoundController [_heli,"CustomSoundController15", _engPct];
            sleep _deltaTime;
        };
    };
};