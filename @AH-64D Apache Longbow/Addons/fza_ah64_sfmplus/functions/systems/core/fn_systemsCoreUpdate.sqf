/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsCoreUpdate

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
[_heli, _deltaTime] call fza_sfmplus_fnc_systemsElectricalBattery;
//Update the APU
[_heli, _deltaTime] call fza_sfmplus_fnc_systemsAPU;
//Update the Generators
[_heli] call fza_sfmplus_fnc_systemsElectricalGenController;
//Update damage
[_heli, _deltaTime] call fza_sfmplus_fnc_systemsDamageUpdate;

hintsilent format ["Battery State: %1
                    \nBattery Bus State: %4
                    \nAPU Button State: %5
                    \nAPU State: %2
                    \nAPU RPM: %3
                    \nAC Bus State: %6
                    \nDC Bus State: %7
                    \nBatt Power = %8
                    \nXmsn Dmg = %9", 
                    _heli getVariable "fza_sfmplus_battSwitchState",
                    _heli getVariable "fza_sfmplus_apuState",
                    _heli getVariable "fza_sfmplus_apuRPM_pct",
                    _heli getVariable "fza_sfmplus_battBusState",
                    _heli getVariable "fza_sfmplus_apuBtnState",
                    _heli getVariable "fza_sfmplus_ACBusState",
                    _heli getVariable "fza_sfmplus_DCBusState",
                    _heli getVariable "fza_sfmplus_battPower_pct",
                    _heli getHitPointDamage "hit_drives_transmission"];