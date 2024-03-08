params ["_heli"];

#define GUNPOWDER_IGNITION_TEMP 180

//ACE3 OVERHEATING
//Author: Commy2 and esteldunedain
private _barrelTemperature = [_heli, "fza_m230", 0] call ace_overheating_fnc_updateTemperature;

// Skip if no ammo in chamber
if (_heli ammo "fza_m230" < 1) exitWith {
    private _ambientTemperature = ambientTemperature select 0;
    _heli setVariable ["ace_overheating_fza_m230_ammoTemp", _ambientTemperature];
};

private _ammoTemperature = _heli getVariable ["ace_overheating_fza_m230_ammoTemp", ambientTemperature select 0];

// heat or cool the ammo
if (_ammoTemperature < _barrelTemperature) then {
    private _temperatureDifference = _barrelTemperature - _ammoTemperature;
    _ammoTemperature = _ammoTemperature + (1 max ((_temperatureDifference / 2.75) - 100));
} else {
    _ammoTemperature = _barrelTemperature;
};

// cookoff if too hot
if (_ammoTemperature > (GUNPOWDER_IGNITION_TEMP * ace_overheating_cookoffCoef)) then {
    hintsilent str ("cookoff - " + str CBA_missionTime);

    _heli sethitpointdamage ["hit_msnEquip_gun_turret", 1];

    // since a cookoff happened then the next round should start at the ambient temperature.
    _ammoTemperature = ambientTemperature select 0;
};

_heli setVariable ["ace_overheating_fza_m230_ammoTemp", _ammoTemperature];