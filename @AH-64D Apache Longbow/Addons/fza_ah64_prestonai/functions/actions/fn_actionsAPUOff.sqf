params ["_heli"];

systemChat "APU coming off...";

sleep 2;

[_heli] call fza_systems_fnc_interactAPUButton;

sleep 6;

systemChat "Battery coming off...";

[_heli] call fza_systems_fnc_interactBattSwitch;

_heli setVariable ["fza_prestonai_heliState", "OFF"];  