/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqVec

Description:
    Get a vector from the aircraft to the acquisition source point (in world space)

    TADS - the TADS LOS
    PHS  - the pilot's head
    GHS  - the CPG's head
    FCR  - the NTS, or the FCR centerline without one
    FXD  - fixed forward, 4.9 deg below the airframe datum
    W01, C51, T01 - the coordinate point; as FXD for ?01 or a point no longer stored

Parameters:
    _heli - The helicopter to act on
    _acq - The acquisition source to read

Returns:
    A world-space vector (of undetermined magnitude) pointing towards the acquisition source

Examples:
    [_heli, "TADS"] call fza_fnc_targetingAcqVec

Author:
    mattysmith22, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_acq"];

// A crew member's head LOS; the local player's from the camera, as eyeDirection does not follow the head in a vehicle
private _headDir = {
    params ["_unit"];
    switch (true) do {
        // No head LOS without the IHADSS helmet
        case (isNull _unit || {!([_unit] call fza_ihadss_fnc_hasHelmet)}): {_heli vectorModelToWorldVisual [0, 1, 0]};
        case (_unit == player): {getCameraViewDirection player};
        default                 {eyeDirection _unit};
    };
};

switch _acq do {
    case "TADS" : {
        private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
        private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
        _heli vectorModelToWorldVisual ([1, _tadsAzimuth, _tadsElevation] call CBA_fnc_polar2vect)
    };
    case "PHS" : {[driver _heli] call _headDir};
    case "GHS" : {[gunner _heli] call _headDir};
    case "FCR" : {
        private _ntsPos = (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) param [1, [0, 0, 0]];
        if (_ntsPos isEqualTo [0, 0, 0]) then {
            private _bias = _heli getVariable ["fza_ah64_fcrAzBias", 0];
            _heli vectorModelToWorldVisual [sin _bias, cos _bias, 0]
        } else {
            (getPosASLVisual _heli) vectorFromTo _ntsPos
        };
    };
    default {
        private _pointPos = if (ACQ_IS_POINT(_acq)) then {[_heli, _acq] call fza_fnc_targetingAcqPoint} else {[]};
        if (_pointPos isEqualTo []) then {
            _heli vectorModelToWorldVisual [0, cos 4.9, -sin 4.9]
        } else {
            (getPosASLVisual _heli) vectorFromTo _pointPos
        };
    };
};
