/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_CoreUpdate

Description:
	Updates all of the modules core functions.
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime = ((["systems_deltaTime"] call BIS_fnc_deltaTime) min 1/30);

//Update the Electrical System
[_heli, _deltaTime] call fza_systems_fnc_electricalController;
//Update the APU
[_heli, _deltaTime] call fza_systems_fnc_apu;
//Update the Hydraulic System
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsController;
//Update the Drivetrain
[_heli, _deltaTime] call fza_systems_fnc_drivetrainController;

hintsilent format ["Battery State: %1
                    \nBattery Bus State: %4
                    \nAPU Button State: %5
                    \nAPU State: %2
                    \nAPU RPM: %3
                    \nAC Bus State: %6
                    \nDC Bus State: %7
                    \nBatt Power = %8
                    \nXmsn Dmg = %9
                    \nPri Lvl = %10
                    \nUtil Lvl = %11", 
                    _heli getVariable "fza_systems_battSwitchState",
                    _heli getVariable "fza_systems_apuState",
                    _heli getVariable "fza_systems_apuRPM_pct",
                    _heli getVariable "fza_systems_battBusState",
                    _heli getVariable "fza_systems_apuBtnState",
                    _heli getVariable "fza_systems_ACBusState",
                    _heli getVariable "fza_systems_DCBusState",
                    _heli getVariable "fza_systems_battPower_pct",
                    _heli getHitPointDamage "hit_drives_transmission",
                    _heli getVariable "fza_systems_priLevel_pct",
                    _heli getVariable "fza_systems_utilLevel_pct"];