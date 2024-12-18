/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqModelVec

Description:
    identical to targetingAcqVec except return is in model space

Parameters:
    _heli - The helicopter to act on
    _acq - The acquisition source to read

Returns:
    A model-space vector (of undetermined magnitude) pointing towards the acquisition source

Examples:
    [_heli] call targetingAcqModelVec

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_acq"];

// Currently the direction is the only component used and we do not have ranging information.

switch _acq do {
    case "TADS" : {
        ([1] + ([_heli, [0], true] call CBA_fnc_turretDir)) call CBA_fnc_polar2vect
    };
    case "PHS" : {
        if (isNull driver _heli) exitWith {[_heli, "FXD"] call targetingAcqModelVec};
        _heli vectorWorldToModelVisual eyeDirection driver _heli;
    };
    case "FXD" : {
        [0,1,0];
    };
};