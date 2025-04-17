/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_mws


Description:
    Proccessor function for the MISSILE WARNING SYSTEM for the british ASE equipment

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    _mwsObjects

Examples:
    [_heli] call fza_ase_fnc_mws

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

private _mwsObjects = [];

nearestObjects [_heli, ["missilebase", "rocketbase"], 3000] apply {
    if (abs([_x getRelDir _heli] call CBA_fnc_simplifyAngle180) > 20) then {continue;};
    if ((vehicle (getShotParents _x)#0) == _heli) then {continue;};
    _heliToMsl = (getPosASL _heli) vectorFromTo getPosASL _x;
    _vectorModel = _heli vectorWorldToModelVisual _heliToMsl;
    if (abs((_vectorModel call CBA_fnc_vect2Polar)#2) > 45) then {continue;};
    _mwsObjects pushBack [ASE_MSL, _x, "RLWR_MSL_LNC"];
    private _missilelog = _x getVariable ["fza_ah64_missilelog", []];
    if !(_heli in _missilelog) then {
        _x setvariable ["fza_ah64_missilelog", (_missilelog + [_x])];
        [_heli, objnull, _x] spawn fza_ase_fnc_missileWarning;
        _x;
    };
};

[_mwsObjects]