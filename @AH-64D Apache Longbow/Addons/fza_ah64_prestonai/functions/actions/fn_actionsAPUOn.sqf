params ["_heli"];

private _apuOn = _heli getVariable "fza_systems_apuOn";

systemChat "Battery coming on...";

sleep 2;

[_heli] call fza_systems_fnc_interactBattSwitch;

sleep 3;

systemChat "APU coming on...";

[_heli] call fza_systems_fnc_interactAPUButton;

sleep 10;

systemChat "APU on...";

_heli setVariable ["fza_prestonai_heliState", "APU"];