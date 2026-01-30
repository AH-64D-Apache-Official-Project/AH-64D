/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqVec

Description:
    Get a vector from the aircraft to the acquisition source point (in world space)

Parameters:
    _heli - The helicopter to act on
    _acq - The acquisition source to read

Returns:
    A world-space vector (of undetermined magnitude) pointing towards the acquisition source

Examples:
    [_heli] call fza_fnc_targetingAcqVec

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_acq"];

// Currently the direction is the only component used and we do not have ranging information.

switch _acq do {
    case "TADS" : {
        private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
        private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
        _heli vectorModelToWorldVisual ([1, _tadsAzimuth, _tadsElevation] call CBA_fnc_polar2vect)
    };
    case "PHS" : {
        if (isNull driver _heli) exitWith {[_heli, "FXD"] call fza_fnc_targetingAcqVec};
        eyeDirection driver _heli;
    };
    case "FXD" : {
        _heli vectorModelToWorldVisual [0,1,0];
    };
};