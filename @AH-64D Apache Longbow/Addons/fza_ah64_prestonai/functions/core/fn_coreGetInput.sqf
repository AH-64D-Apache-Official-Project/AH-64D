params ["_heli", "_name"];

private _state     = _heli getVariable "fza_prestonai_heliState";
private _mode      = _heli getVariable "fza_prestonai_heliMode";
private _onGnd     = isTouchingGround _heli;

switch (_name) do {
    //Preston commands
    case "fza_ah64_AIActnUp": {
        if (_state == "ON") then {
            if (_mode == "HVR") then {
                [_heli] call fza_prestonai_fnc_actHvrAltIncrease;
            };
        };
    };
    case "fza_ah64_AIActnDown": {
        if (_state == "ON") then {
            if (_mode == "HVR") then {
                [_heli] call fza_prestonai_fnc_actHvrAltDecrease;
            };
        };
    };
    case "fza_ah64_AIActnLeft": {
        if (_state == "OFF") then {
            [_heli] spawn fza_prestonai_fnc_actionsAPUOn;
        };
        if (_state == "APU") then {
            [_heli] spawn fza_prestonai_fnc_actionsAPUOff;
        };
        if (_state == "ON") then {
            if (_mode == "HVR") then {

            };
        };
    };
    case "fza_ah64_AIActnRight": {
        if (_state == "OFF") then {
            [_heli] spawn fza_prestonai_fnc_actionsEnginesOn;
        };
        if (_state == "APU") then {
            [_heli] spawn fza_prestonai_fnc_actionsEnginesOn;
        };
        if (_state == "ON") then {
            if (_mode == "HVR") then {

            };
        };
    };
    case "fza_ah64_AIActnOne": {
        if (_mode == "HVR" && _onGnd) then {
            _mode = "GND";
            _heli setVariable ["fza_prestonai_heliMode", _mode];
        };
    };
    case "fza_ah64_AIActnTwo": {
        if (_mode == "GND") then {
            _mode = "HVR";
            _heli setVariable ["fza_prestonai_heliMode", _mode];
        };
    };
};