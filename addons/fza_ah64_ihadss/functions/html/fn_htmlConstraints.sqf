/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlConstraints

Description:
    Hellfire constraints box state for the IHADSS.

    The box is on the line of sight of the crew station driving the missiles
    (fza_fnc_wasUpdate): HMD, TADS or FCR (the NTS, or the FCR centerline
    without one), a steering cue to bring the nose onto it. With the SAL
    trajectory LO or HI it steers to the coordinate point in B5 of the ACQ
    list instead, no other acquisition source, and parks centred with no
    point there. RF has no trajectory and is always on the line of sight. The
    seeker only changes the box between LOAL and LOBL: SAL with the laser
    spot found, RF locked on the TADS handover target or the NTS.

    No box without an RF missile powered and aligned.

Parameters:
    _heli - The helicopter

Returns:
    [azimuth off the nose, elevation off the nose, LOBL, in constraints, allowable angle],
    or [] when there is nothing to show

Examples:
    --- Code
    private _msl = [_heli] call fza_ihadss_fnc_htmlConstraints
    ---

Author:
    Snow(Dryden), BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _isRf = _heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep";
// RF: no box without a missile powered and aligned (fza_hellfire_fnc_rfPowerUpdate)
if (_isRf && {([_heli] call fza_hellfire_fnc_rfState) != RF_STATE_READY}) exitWith {[]};

// The crew station driving the missiles, or this one with none
private _seat = _heli getVariable ["fza_ah64_wasDriver", ""];
if (_seat == "") then {_seat = [_heli] call fza_fnc_getSeat};
if (isNil "_seat") exitWith {[]};
private _sight = [_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable;

// The line of sight; fixed forward without AC power
private _dir = switch (true) do {
    case !(_heli getVariable ["bmkhs_acBusOn", false]): {_heli vectorModelToWorldVisual [0, 1, 0]};
    case (_sight == SIGHT_TADS): {[_heli, "TADS"] call fza_fnc_targetingAcqVec};
    case (_sight == SIGHT_FCR):  {[_heli, "FCR"] call fza_fnc_targetingAcqVec};
    default {[_heli, ["PHS", "GHS"] select (_seat == "cpg")] call fza_fnc_targetingAcqVec};
};

// SAL LO and HI: steering to the B5 coordinate point, no other acquisition source; parked centred on the line of sight
// with no point there
private _parked = false;
if (!_isRf && {(_heli getVariable ["fza_ah64_hellfireTrajectory", "LO"]) in ["LO", "HI"]}) then {
    private _point    = _heli getVariable ["fza_ah64_acqPoint_" + _seat, ACQ_POINT_NONE];
    private _pointPos = if (_point == ACQ_POINT_NONE) then {[]} else {[_heli, _point] call fza_fnc_targetingAcqPoint};
    if (_pointPos isEqualTo []) then {
        _parked = true;
    } else {
        _dir = (getPosASLVisual _heli) vectorFromTo _pointPos;
    };
};

private _indicateLobl   = false;
private _allowableAngle = 7.5;
if (_isRf) then {
    // RF is 20 deg in LOAL and LOBL, 5 deg when tracking a target inside 1 km
    _allowableAngle = 20;
    private _loblTarget = objNull;
    if (_sight == SIGHT_TADS) then {
        _loblTarget = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];
    } else {
        _loblTarget = (_heli getVariable ["fza_ah64_fcrNts", [objNull]]) # 0;
    };
    if (!isNull _loblTarget) then {
        _indicateLobl = ([_heli, [getPosASL _loblTarget, speed _loblTarget, _loblTarget], true] call fza_hellfire_fnc_arhTargetConstraint) # 1;
        if (_indicateLobl && {_heli distance _loblTarget < 1000}) then {_allowableAngle = 5};
    };
} else {
    _indicateLobl = !isNil {[_heli] call fza_hellfire_fnc_salFindLaserDesignation};
    if _indicateLobl then {_allowableAngle = 20};
};

private _vector = _heli vectorWorldToModelVisual _dir;
private _angles = [[(_vector # 0) atan2 (_vector # 1)] call CBA_fnc_simplifyAngle180, (_vector # 2) atan2 (_vector # 1)];
if (_parked) then {_angles = [0, 0]};

if (_heli ammo (_heli getVariable "fza_ah64_selectedMissile") == 0) then {
    _indicateLobl = false;
};

// Parked, the box shows out of constraints
private _inConstraints = !_parked && {((abs (_angles # 0)) max (abs (_angles # 1))) < _allowableAngle};

[_angles # 0, _angles # 1, _indicateLobl, _inConstraints, _allowableAngle]
