/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalBattery

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
#include "\fza_ah64_systems\headers\systems.hpp"

private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";
private _battPower    = _heli getVariable "fza_systems_battPower_pct";
private _acBusOn      = _heli getVariable "fza_systems_acBusOn";
private _battTimer    = _heli getVariable "fza_systems_battTimer";
private _battDamage   = _heli getHitPointDamage "hit_elec_battery";
private _battBusOn    = _heli getVariable "fza_systems_battBusOn";

if (_battSwitchOn) then {
    if (_battDamage <= SYS_BATT_DMG_THRESH && _battPower >= 0.25) then {
        _battBusOn = true;
    } else {
        _battBusOn = false;
    };
} else {
    _battBusOn = false;
};
//Set the state of the battery bus
if (Local _heli) then {
    [_heli, "fza_systems_battBusOn", _battBusOn] call fza_fnc_updateNetworkGlobal;
};
//Set the Avionic sound state 
setCustomSoundController [_heli, "CustomSoundController7", [0,1] select _battBusOn];

//Drain the battery
if (_battBusOn && !_acBusOn) then {
    _battPower = [_battPower, 0.0, (1.0 / _battTimer) * _deltaTime] call BIS_fnc_lerp;
};
//Recharge the battery
if (_battBusOn && _acBusOn) then {
    _battPower = [_battPower, 1.0, _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_systems_battPower_pct", _battPower];

//Components belonging to the battery bus include:
//--FS/BS UFD
//--FS/BS Fire test panel
//--FS/BS Landing/Searchlight
//--VHF radio
//--UHF radio
//--FM1 radio
//--FM2 radio
//--Standby instruments