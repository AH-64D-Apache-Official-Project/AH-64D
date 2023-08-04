params ["_heli"];

//playsound "fza_ah64_flt_control";
if (_heli getVariable "fza_ah64_altHoldActive" || _heli getVariable "fza_ah64_attHoldActive") then {
    private _otherTurret = [_heli, true] call fza_fnc_currentTurret;
    "fza_ah64_flight_control" remoteExec ["playsound", _heli turretUnit _otherTurret];
    playsound "fza_ah64_flight_control";
};

//De-activate attitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_attHoldActive",     false,      true];
_heli setVariable ["fza_ah64_attHoldDesiredVel", [0.0, 0.0], true];
_heli setVariable ["fza_ah64_attHoldDesiredAtt", [0.0, 0.0], true];

//De-activate altitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_altHoldActive",     false, true];
_heli setVariable ["fza_ah64_altHoldDesiredAlt", 0.0,   true];
