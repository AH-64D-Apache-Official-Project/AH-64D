
params ["_heli"];

private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";

if (_battSwitchOn) exitwith {
    [_heli] call fza_systems_fnc_interactBattSwitch;
    [_heli] spawn fza_fnc_fxLoops;
};

[_heli] call fza_systems_fnc_interactBattSwitch;