/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_handleRearm

Description:
    Refills a discharged fire bottle once its engine is repaired. Discharging a
    bottle marks its engine damaged (fza_fire_fnc_handleControl), so a full
    repair is what refills it.

Parameters:
    _heli - The helicopter to act on

Returns:

Examples:
    [_heli] call fza_fire_fnc_handleRearm

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (_heli getHitPointDamage "hitengine1" == 0 && {_heli getVariable ["fza_ah64_firepdisch", false]}) then {
    _heli setVariable ["fza_ah64_firepdisch", false, true];
};
if (_heli getHitPointDamage "hitengine2" == 0 && {_heli getVariable ["fza_ah64_firerdisch", false]}) then {
    _heli setVariable ["fza_ah64_firerdisch", false, true];
};
