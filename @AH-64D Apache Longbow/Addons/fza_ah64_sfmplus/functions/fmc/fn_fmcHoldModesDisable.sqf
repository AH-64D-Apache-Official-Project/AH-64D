params ["_heli"];

//playsound "fza_ah64_flt_control";
if (_heli getVariable "fza_ah64_altHoldActive" || _heli getVariable "fza_ah64_attHoldActive") then {
    [_heli] call fza_audio_fnc_flightTone;
};

//De-activate attitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_attHoldActive",     false,      true];
_heli setVariable ["fza_ah64_attHoldDesiredVel", [0.0, 0.0], true];
_heli setVariable ["fza_ah64_attHoldDesiredAtt", [0.0, 0.0], true];

//De-activate altitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_altHoldActive",     false, true];
_heli setVariable ["fza_ah64_altHoldDesiredAlt", 0.0,   true];
