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
params ["_heli", "_deltaTime"];

//Update the battery
[_heli, _deltaTime] call fza_systems_fnc_electricalBattery;
//Update the APU
[_heli, _deltaTime] call fza_systems_fnc_apu;
//Update the Generators
[_heli] call fza_systems_fnc_electricalGenController;
//Update the Hydraulics
[_heli, _deltaTime] call fza_systems_fnc_hydraulicsController;
//Update damage
[_heli, _deltaTime] call fza_systems_fnc_damageUpdate;

hintsilent format ["Battery State: %1
                    \nBattery Bus State: %4
                    \nAPU Button State: %5
                    \nAPU State: %2
                    \nAPU RPM: %3
                    \nAC Bus State: %6
                    \nDC Bus State: %7
                    \nBatt Power = %8
                    \nXmsn Dmg = %9", 
                    _heli getVariable "fza_systems_battSwitchState",
                    _heli getVariable "fza_systems_apuState",
                    _heli getVariable "fza_systems_apuRPM_pct",
                    _heli getVariable "fza_systems_battBusState",
                    _heli getVariable "fza_systems_apuBtnState",
                    _heli getVariable "fza_systems_ACBusState",
                    _heli getVariable "fza_systems_DCBusState",
                    _heli getVariable "fza_systems_battPower_pct",
                    _heli getHitPointDamage "hit_drives_transmission"];