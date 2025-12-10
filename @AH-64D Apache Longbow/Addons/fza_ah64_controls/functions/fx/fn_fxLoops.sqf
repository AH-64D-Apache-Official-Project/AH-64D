/* ----------------------------------------------------------------------------
Function: fza_fnc_fxLoops

Description:
    loops battery or apu audio

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fxLoops;

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli","_type"];

/* private _start_time = time;
private _timed_apu = _start_time + 24;
private _timed_bat = _start_time + 0; */

// private _apuOn     = _heli getVariable "fza_systems_apuBtnOn";
// private _battBusOn = _heli getVariable "fza_systems_battBusOn";

systemChat str ["APU LOOP", _type ,time];

switch (_type) do {
    case "apu": {
        #define PREP_FREQ_OFFSET 1.15

        private _apuBtnOn_OLD = _heli getVariable ["fza_systems_apuBtnOn", false];
        private _apuRPM_pct_TargetNum = parseNumber _apuBtnOn_OLD; // (0/1)
        private _apuRPM_pct_StartNum = parseNumber !_apuBtnOn_OLD; // (0/1)

        //- Toggle APU startup sound (0/1)
        setCustomSoundController [
            _heli,
            "CustomSoundController9",
            _apuRPM_pct_TargetNum
        ];

        // [_heli,_apuBtnOn_OLD,_apuRPM_pct_TargetNum,_apuRPM_pct_StartNum] spawn {
            // params ["_heli","_apuBtnOn_OLD","_apuRPM_pct_TargetNum","_apuRPM_pct_StartNum"];
            while {
                private _apuBtnOn = _heli getVariable ["fza_systems_apuBtnOn", false];
                private _apuRPM_pct = _heli getVariable "fza_systems_apuRPM_pct";

                _apuBtnOn_OLD == _apuBtnOn &&
                abs(_apuRPM_pct - _apuRPM_pct_StartNum) < 0.99
            } do {
                private _apuRPM_pct = _heli getVariable "fza_systems_apuRPM_pct";
                setCustomSoundController [_heli,"CustomSoundController1", PREP_FREQ_OFFSET * _apuRPM_pct];
                setCustomSoundController [_heli,"CustomSoundController2",_apuRPM_pct];
            };

            //- clean up (straight to targetNum)
            setCustomSoundController [_heli,"CustomSoundController1", PREP_FREQ_OFFSET * _apuRPM_pct_TargetNum];
            setCustomSoundController [_heli,"CustomSoundController2", _apuRPM_pct_TargetNum];
        // };
    };

    //- Battery sound
    case "batt": {
        private _battBusOn = _heli getVariable "fza_systems_battBusOn";
        setCustomSoundController [_heli,"CustomSoundController5", parseNumber _battBusOn];
    };

    //- Battery sound
    case "powerLever": {
        private _getEngPctTarget = {
            private _engPowerLeverState = _heli getVariable ["fza_sfmplus_engPowerLeverState", ["OFF","OFF"]];
            
            private _engPct = _engPowerLeverState apply {
                private _index = ["OFF","IDLE","FLY"] find _x;
                linearConversion [0, 2, _index, 0, 0.25];
            };
            
            _engPct vectorDotProduct [1,1]; //- Return total max : 0.5
        };

        private _engPowerLeverState_OLD = _heli getVariable ["fza_sfmplus_engPowerLeverState", ["OFF","OFF"]];
        private _engPct_toValue = call _getEngPctTarget;
        // private _engPctNP_toValue = linearConversion [0, 1, _engPctNP vectorDotProduct [1,1], 0, 0.5, true];

        while {
            private _engPowerLeverState = _heli getVariable ["fza_sfmplus_engPowerLeverState", ["OFF","OFF"]];
            // private _engPctNP_Num = getCustomSoundController [_heli, "CustomSoundController15"];
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPowerLeverState_OLD isEqualTo _engPowerLeverState &&
            abs(_engPct - _engPct_toValue) > 0.01
        } do {
            private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";
            private _engPct = getCustomSoundController [_heli, "CustomSoundController15"];

            _engPct = [_engPct, _engPct_toValue, _deltaTime / 1.5] call BIS_fnc_lerp;
            // private _engPctNP = _heli getVariable ["fza_sfmplus_engPctNP", [0.0,0.0]];
            // _engPctNP = linearConversion [0, 1, _engPctNP vectorDotProduct [1,1], 0, 0.5, true];
            
            setCustomSoundController [_heli,"CustomSoundController15", _engPct];

            hintSilent str getCustomSoundController [_heli, "CustomSoundController15"];
            sleep _deltaTime;
        };
    };
};

/* if ( _battBusOn) then {
    private _bat = "Land_ClutterCutter_small_F" createVehicle[0, 0, 0];
    _bat attachTo[_heli, [0, 5, 0]];
    hideObjectGlobal _bat;

    while {
        _battBusOn && alive _heli;
    }
    do {
        if (time > _timed_bat) then {
            _timed_bat = time + 13;
            [_bat, ["fza_ah64_bat_loop_3D", 10]] remoteExec["say3d"];
        };
        sleep 1;
    };
    deleteVehicle _bat;
}; */