params ["_heli", "_name"];

private _state = _heli getVariable "fza_prestonai_heliState";

switch (_name) do {
    //Preston commands
    case "fza_ah64_AIActnUp": {

    };
    case "fza_ah64_AIActnDown": {

    };
    case "fza_ah64_AIActnLeft": {
        if (_state == "OFF") then {
            [_heli] spawn fza_prestonai_fnc_actionsAPUOn;
        };
        if (_state == "APU") then {
            [_heli] spawn fza_prestonai_fnc_actionsAPUOff;
        };
    };
    case "fza_ah64_AIActnRight": {
        if (_state == "OFF") then {
            [_heli] spawn fza_prestonai_fnc_actionsEnginesOn;
        };
        if (_state == "APU") then {
            [_heli] spawn fza_prestonai_fnc_actionsEnginesOn;
        }
    };
    case "fza_ah64_AIActnOne": {

    };
    case "fza_ah64_AIActnTwo": {

    };

};