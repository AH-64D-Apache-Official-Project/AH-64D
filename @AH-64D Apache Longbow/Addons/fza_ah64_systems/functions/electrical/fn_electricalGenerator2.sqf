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
params ["_heli", "_apuOn", "_rtrRPM"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _gen2On  = _heli getVariable "fza_systems_gen2On";
private _gen2Damage = _heli getHitPointDamage "hit_elec_generator2";

if (_apuOn || _rtrRPM > SYS_MIN_RPM) then {
    //Generator 2
    if (_gen2Damage <= SYS_GEN_DMG_THRESH) then {
        _gen2On = true;
    } else {
        _gen2On = false;
    };
} else {
    _gen2On = false;
};
_heli setVariable ["fza_systems_gen2On", _gen2On, true];