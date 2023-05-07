/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqVec

Description:
    Get a vector from the aircraft to t

    This currently is hard-coded to the TADS position

Parameters:
    _heli - The helicopter to act on

Returns:
    A world-space vector (of undetermined length) pointing towards the acquisition source

Examples:
    [_heli] call fza_fnc_targetingAcqVec

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

// Currently the direction is the only component used and we do not have ranging information.

_heli vectorModelToWorldVisual (([1] + ([_heli, [0], true] call CBA_fnc_turretDir)) call CBA_fnc_polar2vect)