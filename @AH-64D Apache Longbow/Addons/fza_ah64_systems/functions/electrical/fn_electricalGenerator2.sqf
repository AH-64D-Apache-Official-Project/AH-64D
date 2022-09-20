/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalGenerator2

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
params ["_heli", "_apuState", "_rtrRPM"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _gen2State  = _heli getVariable "fza_systems_gen2State";
private _gen2Damage = _heli getHitPointDamage "hit_elec_generator2";

if (_apuState == "ON" || _rtrRPM > SYS_MIN_RPM) then {
    //Generator 2
    if (_gen2Damage <= SYS_GEN_DMG_VAL) then {
        _gen2State = "ON";
    } else {
        _gen2State = "OFF";
    };
} else {
    _gen2State = "OFF";
};
_heli setVariable ["fza_systems_gen2State", _gen2State];