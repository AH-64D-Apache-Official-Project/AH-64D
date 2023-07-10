params ["_heli"];

private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";
private _apuBtnOn     = _heli getVariable "fza_systems_apuBtnOn";

//If the battery is already on...don't do anything with it
if (!_battSwitchOn) then {
    systemChat "Battery coming on...";

    sleep 2;

    [_heli] call fza_systems_fnc_interactBattSwitch;

    sleep 3;
};
//If the APU is already on...don't do anything with it
if (!_apuBtnOn) then {
    systemChat "APU coming on...";

    sleep 2;

    [_heli] call fza_systems_fnc_interactAPUButton;

    sleep 10;
};
////////////////////////////////////////////////////////////////////////////////
//Engine One  //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
systemChat "Starting engine number one...";

sleep 2;

[_heli, 0] call fza_sfmplus_fnc_interactStartSwitch;

sleep 2;

systemChat "Ng is on the rise...";

sleep 1;

systemChat "TGT is less than 80, power lever to idle, time noted...";

sleep 1;

[_heli, 0, "IDLE"] call fza_sfmplus_fnc_interactPowerLever;

sleep 3;

systemChat "Engine oil is on the rise...";

sleep 3;

systemChat "TGT is on the rise...";

sleep 3;

systemChat "Got Np, that's all indications within 45 seconds, continuing to monitor TGT and NG";

sleep 6;

systemChat "That's a good start on one...";

sleep 5;
////////////////////////////////////////////////////////////////////////////////
//Engine Two  //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
systemChat "Starting engine number two...";

sleep 2;

[_heli, 1] call fza_sfmplus_fnc_interactStartSwitch;

sleep 2;

systemChat "Ng is on the rise...";

sleep 1;

systemChat "TGT is less than 80, power lever to idle, time noted...";

sleep 1;

[_heli, 1, "IDLE"] call fza_sfmplus_fnc_interactPowerLever;

sleep 3;

systemChat "Engine oil is on the rise...";

sleep 3;

systemChat "TGT is on the rise...";

sleep 3;

systemChat "Got Np, that's all indications within 45 seconds, continuing to monitor TGT and NG";

sleep 6;

systemChat "That's a good start on two...";

sleep 3;
////////////////////////////////////////////////////////////////////////////////
//Both Engines  ////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
systemChat "Alright, engine oil PSI is less than 70 and nose gearbox temps are grater than 20, power levers one and two coming to fly...";

sleep 3;

[_heli, 0, "FLY"] call fza_sfmplus_fnc_interactPowerLever;
[_heli, 1, "FLY"] call fza_sfmplus_fnc_interactPowerLever;

sleep 6;

systemChat "Power levers one and two are to fly, Np and Nr are verified at 101% and no master cautions or warnings are displayed.";

sleep 1;

systemChat "APU identified, and seleced off.";

sleep 3;

[_heli] call fza_systems_fnc_interactAPUButton;