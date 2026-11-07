params ["_heli", "_state"];

if ((_heli getVariable "fza_dms_zoneState") isNotEqualTo _state) then {
    _heli setVariable ["fza_dms_zoneState", _state, true];
};
