/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_systemsAPU

Description:
    Defines key values for the simulation.

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

private _apuBtnOn   = _heli getVariable "fza_systems_apuBtnOn";
private _battBusOn  = _heli getVariable "fza_systems_battBusOn";
private _apuOn      = _heli getVariable "fza_systems_apuOn";
private _apuDamage     = _heli getHitPointDamage "hit_apu";
private _apuStartDelay = _heli getVariable "fza_systems_apuStartDelay";
private _apuRPM_pct    = _heli getVariable "fza_systems_apuRPM_pct";
private _apuFF_kgs     = 0.0;

if (_apuBtnOn && _battBusOn && !(fuel _heli < 0.01)) then {
    _apuRPM_pct = [_apuRPM_pct, 1.0, (1.0 / _apuStartDelay) * _deltaTime] call BIS_fnc_lerp;
} else {
    _apuRPM_pct = [_apuRPM_pct, 0.0, _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_systems_apuRPM_pct", _apuRPM_pct];


setCustomSoundController [_heli,"CustomSoundController1", 1.15 * _apuRPM_pct];
setCustomSoundController [_heli,"CustomSoundController2",_apuRPM_pct];
hintSilent str getCustomSoundController [_heli, "CustomSoundController2"];

//Set the APU state
if (_apuRPM_pct <= SYS_MIN_RPM) then {
    _apuOn = false;
};
if (_apuRPM_pct > SYS_MIN_RPM) then {
    if (_apuDamage <= SYS_APU_DMG_THRESH) then {
        _apuOn = true;
    } else {
        _apuOn = false;
    };
};
_heli setVariable ["fza_systems_apuOn", _apuOn];
_heli setObjectTexture ["in_lt_apu", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _apuOn];

if (_apuOn) then {
    _apuFF_kgs = 0.0220;//175pph
};
_heli setVariable ["fza_systems_apuFF_kgs", _apuFF_kgs];