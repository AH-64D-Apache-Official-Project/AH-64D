params ["_object", "_engineNum"];

_object setVariable ["fza_ah64_engineNumber", _engineNum];
_object setVariable [_object getVariable "fza_ah64_stateStartTime", "OFF"];