/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalGenerator1

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

private _gen1State  = _heli getVariable "fza_systems_gen1State";
private _gen1Damage = _heli getHitPointDamage "hit_elec_generator1";

if (_apuState == "ON" || _rtrRPM > SYS_MIN_RPM) then {
    //Generator 1
    if (_gen1Damage <= SYS_GEN_DMG_VAL) then {
        _gen1State = "ON";
    } else {
        _gen1State = "OFF";
    };
} else {
    _gen1State = "OFF";
};
_heli setVariable ["fza_systems_gen1State", _gen1State];