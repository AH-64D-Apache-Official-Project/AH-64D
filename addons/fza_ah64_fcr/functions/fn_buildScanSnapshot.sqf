#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrMode", "_fcrAzBias"];

private _gtmElevMax = _heli getVariable ["fza_ah64_fcrGtmElevMax",    25];
private _gtmHalfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov",    45];
private _atmElevMin = _heli getVariable ["fza_ah64_fcrAtmElevMin", -22.5];
private _atmHalfFov = _heli getVariable ["fza_ah64_fcrAtmHalfFov",   168];

private _fcrTracks  = getSensorTargets _heli;
private _fcrTargets = [];
private _heliPos    = getPosASL _heli;

{
    _x params ["_target", "_type", "_relationship", "_sensor"];

    private _range       = _heli distance2D _target;
    private _targetPos   = getPosASL _target;
    private _targetSpeed = vectorMagnitude velocity _target;

    if (!("activeradar" in _sensor) || _heli getHit "radar" > 0.9) then { continue; };
    if (_range <= FCR_LIMIT_MIN_RANGE) then { continue; };
    if !(_range < FCR_LIMIT_STATIONARY_RANGE ||
        _targetSpeed > FCR_LIMIT_MOVING_MIN_SPEED_KMH && _range < FCR_LIMIT_MOVING_RANGE)
        then { continue; };
    if (count _fcrTargets >= 256) exitWith {};

    private _targDir   = _heliPos vectorFromTo _targetPos;
    private _ydist     = _targDir vectorDotProduct vectorUp _heli;
    // Elevation above the antenna plane — valid at every azimuth (an atan2 against the
    // forward axis blows up to +-90/180 for targets abeam or behind a slewed sector)
    private _elevAngle = asin ((_ydist max -1) min 1);
    private _relAzi    = [([_heli getRelDir _target] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;

    if (_elevAngle > _gtmElevMax  && _fcrMode in [1, 3]) then { continue; };
    if (_elevAngle < _atmElevMin  && _fcrMode == 2) then { continue; };
    if ((abs _relAzi) > _gtmHalfFov && _fcrMode in [1, 3]) then { continue; };
    if (_fcrMode == 2) then {
        // Tail boom blanks ~12 deg either side of dead astern regardless of scan centerline
        if (abs ([_heli getRelDir _target] call CBA_fnc_simplifyAngle180) > 168) then { continue; };
        if (_atmHalfFov < 168 && (abs _relAzi) > _atmHalfFov) then { continue; };
    };

    private _type = FCR_TYPE_UNKNOWN;
    if (_target isKindOf "tank")       then { _type = FCR_TYPE_TRACKED; };
    if (_target isKindOf "car")        then { _type = FCR_TYPE_WHEELED; };
    if (_target isKindOf "helicopter") then { _type = FCR_TYPE_HELICOPTER; };
    if (_target isKindOf "plane")      then { _type = FCR_TYPE_FLYER; };
    if ([_target] call fza_ase_fnc_targetIsAda) then { _type = FCR_TYPE_ADU; };

    // ATM: air targets only, and they must be moving — nothing else enters the list,
    // so the target count matches what the format displays
    if (_fcrMode == 2) then {
        if !(_type in [FCR_TYPE_FLYER, FCR_TYPE_HELICOPTER]) then { continue; };
        if (_targetSpeed < 5) then { continue; };
    };

    private _moving = (_targetSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH);

    private _revealOffset = if (_fcrMode in [1, 3]) then {
        private _bar = (_gtmHalfFov * 2) / FCR_SCAN_RATE_DEGS;
        if (_range < 4000) then {
            ((_relAzi + _gtmHalfFov) / (_gtmHalfFov * 2)) * _bar
        } else {
            _bar + ((_gtmHalfFov - _relAzi) / (_gtmHalfFov * 2)) * _bar
        }
    } else {
        if (_atmHalfFov >= 168) then {
            // Wide rotation starts at the nose and sweeps counter-clockwise (matches the
            // display wiper); a target's reveal offset = its CCW angle from the nose
            private _ccw = (-_relAzi + 360) mod 360;
            _ccw / FCR_SCAN_RATE_DEGS
        } else {
            // Display mirrors the bearing math, so the visible first pass runs R→L: a target
            // at the right edge (+halfFov) reveals at t=0, the left edge (-halfFov) at t=bar
            ((_atmHalfFov - _relAzi) / (_atmHalfFov * 2)) * ((_atmHalfFov * 2) / FCR_SCAN_RATE_DEGS)
        }
    };

    // ATM draws nose-relative on a rotating PPI; store the nose-relative bearing frozen at
    // scan time so a later slew doesn't swing the symbol until the next scan refreshes it.
    // GTM/RMAP stay centerline-relative (their wedge is fixed forward).
    private _storeAzi = [_relAzi, _relAzi + _fcrAzBias] select (_fcrMode == 2);

    _fcrTargets pushBack [
        [round (_targetPos#0), round (_targetPos#1), round (_targetPos#2)],
        _type, _moving, _target,
        [_storeAzi,  1] call BIS_fnc_cutDecimals,
        [_elevAngle, 1] call BIS_fnc_cutDecimals,
        _range, _revealOffset
    ];
} forEach _fcrTracks;

_fcrTargets
