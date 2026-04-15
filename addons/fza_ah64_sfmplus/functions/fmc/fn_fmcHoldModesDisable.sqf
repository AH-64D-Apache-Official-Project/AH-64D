params ["_heli"];

//playsound "fza_ah64_flt_control";
if (_heli getVariable "fza_ah64_altHoldActive" || _heli getVariable "fza_ah64_attHoldActive") then {
    [_heli] spawn fza_audio_fnc_flightTone;
};

//De-activate attitude hold and set the reference back to 0
[_heli, "fza_ah64_attHoldActive", false] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_attHoldDesiredVel", [0.0, 0.0]] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_attHoldDesiredAtt", [0.0, 0.0]] call fza_fnc_updateNetworkGlobal;

//De-activate altitude hold and set the reference back to 0
[_heli, "fza_ah64_altHoldActive", false] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_altHoldDesiredAlt", 0.0] call fza_fnc_updateNetworkGlobal;
