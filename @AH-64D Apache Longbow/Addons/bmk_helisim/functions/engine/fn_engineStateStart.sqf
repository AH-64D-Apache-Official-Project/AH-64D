params ["_heli", "_engNum", "_deltaTime", "_engState", "_engStart", "_engThrottlePos", "_engThrottleSetPoint"];

systemChat format ["Eng %1 state is STARTING", _engNum];

//This needs to check that Ng > min value and then transition to on...this is temporary
_engStart = false;
_engState = "ON";

if (_engThrottlePos == "OFF") then {
    _engStart = false;
    _engState = "OFF";
    _engThrottleSetPoint = 0.0;
};

[_heli, "bmk_helisim_engStart",            _engNum, _engStart] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engState",            _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _engThrottleSetPoint] call fza_sfmplus_fnc_setArrayVariable;