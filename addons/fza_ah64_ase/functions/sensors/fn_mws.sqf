/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_mws


Description:
    Proccessor function for the MISSILE WARNING SYSTEM for the british ASE equipment.
    Declares incoming munitions, locked on or not (fza_ase_fnc_incoming).

Parameters:
    heli: Object - Vehicle the event handler is assigned to
    munitions: Array - missiles and rockets within ASE_MWS_RANGE (fza_ase_fnc_aseManager)

Returns:
    [_mwsObjects, munitions declared for the first time, every munition declared]

Examples:
    [_heli, _munitions] call fza_ase_fnc_mws

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", ["_munitions", []]];

private _mwsObjects = [];
private _new        = [];
private _declared   = [];
private _log        = (_heli getVariable ["fza_ah64_missilelog", []]) select {alive _x};

_munitions apply {
    if ((vehicle ((getShotParents _x)#0)) == _heli) then {continue;};
    private _vectorModel = _heli vectorWorldToModelVisual ((getPosASL _heli) vectorFromTo getPosASL _x);
    if (abs((_vectorModel call CBA_fnc_vect2Polar)#2) > 45) then {continue;};
    if !([_heli, _x] call fza_ase_fnc_incoming) then {continue;};

    _declared pushBack _x;
    _mwsObjects pushBack [ASE_MSL, _x, "RLWR_MSL_LNC"];
    if !(_x in _log) then {
        _log pushBack _x;
        _new pushBack _x;
        [_heli, objNull, _x] spawn fza_ase_fnc_missileWarning;
    };
};
_heli setVariable ["fza_ah64_missilelog", _log];

[_mwsObjects, _new, _declared]
