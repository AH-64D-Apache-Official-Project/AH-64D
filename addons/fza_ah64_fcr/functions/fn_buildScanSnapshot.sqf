/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_buildScanSnapshot

Description:
    Processes raw sensor tracks into FCR target records. Applies sensor
    validity, range, FOV, elevation, and target-type filters, then computes
    the sweep reveal offset for each target.

Parameters:
    _heli    - the helicopter
    _fcrMode - current FCR mode (1 = GTM, 2 = ATM)
    _fcrAzBias - azimuth bias offset in degrees (from fza_ah64_fcrAzBias)

Returns:
    Array of target records:
    [pos, type, moving, obj, relAzi, elevAngle, range, revealOffset]
    Indices [0..7]

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrMode", "_fcrAzBias"];

private _gtmElevMax = _heli getVariable ["fza_ah64_fcrGtmElevMax",    25];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov",    45];
private _atmElevMin = _heli getVariable ["fza_ah64_fcrAtmElevMin", -22.5];
private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov",   168];

private _fcrTracks  = getSensorTargets _heli;
private _fcrTargets = [];

{
    _x params ["_target", "_type", "_relationship", "_sensor"];

    private _range       = _heli distance2D _target;
    private _heliPos     = getPosASL _heli;
    private _targetPos   = getPosASL _target;
    private _targetSpeed = vectorMagnitude velocity _target;

    // Sensor and range validity checks
    if (!("activeradar" in _sensor) || _heli getHit "radar" > 0.9) then { continue; };
    if (_range <= FCR_LIMIT_MIN_RANGE) then { continue; };
    if !(_range < FCR_LIMIT_STATIONARY_RANGE ||
        _targetSpeed > FCR_LIMIT_MOVING_MIN_SPEED_KMH && _range < FCR_LIMIT_MOVING_RANGE)
        then { continue; };
    if (count _fcrTargets > 256) exitWith {};

    // Compute target angles relative to the helicopter
    private _targDir   = _heliPos vectorFromTo _targetPos;
    private _zdist     = _targDir vectorDotProduct vectorDir _heli;
    private _ydist     = _targDir vectorDotProduct vectorUp  _heli;
    private _elevAngle = _ydist atan2 _zdist;
    private _relAzi    = [([_heli getRelDir _target] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;

    // Elevation and azimuth FOV filters
    if (_elevAngle > _gtmElevMax  && _fcrMode == 1) then { continue; };
    if (_elevAngle < _atmElevMin  && _fcrMode == 2) then { continue; };
    if ((abs _relAzi) > _gtmHalfFov && _fcrMode == 1) then { continue; };
    if ((abs _relAzi) > _atmHalfFov && _fcrMode == 2) then { continue; };

    // Classify target type
    private _type = FCR_TYPE_UNKNOWN;
    if (_target isKindOf "tank")       then { _type = FCR_TYPE_TRACKED; };
    if (_target isKindOf "car")        then { _type = FCR_TYPE_WHEELED; };
    if (_target isKindOf "helicopter") then { _type = FCR_TYPE_HELICOPTER; };
    if (_target isKindOf "plane")      then { _type = FCR_TYPE_FLYER; };
    if ([_target] call fza_ase_fnc_targetIsAda) then { _type = FCR_TYPE_ADU; };

    // ATM only shows moving air targets
    if ((_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) && _targetSpeed < 5 && _fcrMode == 2) then { continue; };

    private _moving = (_targetSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH);

    // Sweep reveal offset:
    //   GTM near bar (< 4km) sweeps L->R over 0.0->1.6s
    //   GTM far bar  (>=4km) sweeps R->L over 1.6->3.2s
    //   ATM sweeps   L->R over 0.0->6.4s
    private _revealOffset = if (_fcrMode == 1) then {
        if (_range < 4000) then {
            ((_relAzi + _gtmHalfFov) / (_gtmHalfFov * 2)) * 1.6
        } else {
            1.6 + ((_gtmHalfFov - _relAzi) / (_gtmHalfFov * 2)) * 1.6
        }
    } else {
        ((_relAzi + _atmHalfFov) / (_atmHalfFov * 2)) * 6.4
    };

    _fcrTargets pushBack [
        [round (_targetPos#0), round (_targetPos#1), round (_targetPos#2)],
        _type, _moving, _target,
        [_relAzi,    1] call BIS_fnc_cutDecimals,
        [_elevAngle, 1] call BIS_fnc_cutDecimals,
        _range, _revealOffset
    ];
} forEach _fcrTracks;

_fcrTargets
