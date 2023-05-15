params ["_heli"]

if (_heli getVariable "fza_ah64_attHoldActive" == false) then {
    _heli setVariable ["fza_ah64_attHoldActive", true, true];
} else {
    _heli setVariable ["fza_ah64_attHoldActive", false, true];
};