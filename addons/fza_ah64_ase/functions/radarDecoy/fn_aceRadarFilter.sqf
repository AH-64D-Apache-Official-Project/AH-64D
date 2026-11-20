/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_aceRadarFilter

Description:
    Whether a Doppler radar loses a target in ground clutter: slower along the line of sight
    than the Doppler filter, and either the beam's lower half reaches the ground around it or
    ground lies behind it within the missile's time filter. A running helicopter's rotor
    still shows it ASE_RADAR_ROTOR_CHANCE of checks. In place of ACE's
    ace_missileguidance_fnc_shouldFilterRadarHit, once a radar check.

Parameters:
    _target              - Target
    _radar               - The missile, or the launcher guiding it
    _minimumSpeed        - Doppler filter, m/s
    _minimumTime         - Echo time from ground behind the target that is clutter, s
    _maximumTerrainCheck - Furthest it looks behind the target, m

Returns:
    Whether the target is lost <BOOL>

Examples:
    [_target, _projectile, 5, 1e-6, 16000] call fza_ase_fnc_aceRadarFilter

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\radarDecoy.h"
params ["_target", "_radar", ["_minimumSpeed", 30, [0]], ["_minimumTime", 1e-4, [0]], ["_maximumTerrainCheck", 16000, [0]]];

if (isNull _target || {isNull _radar}) exitWith {false};

private _radarPos    = getPosASLVisual _radar;
private _targetPos   = getPosASLVisual _target;
private _lineOfSight = _radarPos vectorFromTo _targetPos;
private _log         = missionNamespace getVariable ["fza_ase_radarDebug", false];
private _radial      = abs ((velocity _target) vectorDotProduct _lineOfSight);

if (_radial > _minimumSpeed) exitWith {
    if (_log) then {
        diag_log format ["fza_ase radar | #%5 filter %1 from %2: radial %3 > %4 m/s, seen", typeOf _target, typeOf _radar, _radial toFixed 1, _minimumSpeed,
            _radar getVariable ["fza_ase_radarLogId", "L"]];
    };
    false
};

private _range   = _radarPos vectorDistance _targetPos;
private _agl     = (ASLToAGL _targetPos) # 2;
private _beam    = _range * tan ASE_RADAR_BEAM_HALF_ANGLE;
private _clutter = _agl < _beam;
private _behind  = ["none", "not checked"] select _clutter;
if !(_clutter) then {
    private _gate    = _maximumTerrainCheck min (_minimumTime * 3e8);
    private _from    = _targetPos;
    private _checked = 0;
    while {_checked < _gate && {!_clutter}} do {
        private _step = ASE_RADAR_TERRAIN_STEP min (_gate - _checked);
        private _to   = _from vectorAdd (_lineOfSight vectorMultiply _step);
        private _hit  = lineIntersectsSurfaces [_from, _to, _target, _radar];
        _clutter = _hit isNotEqualTo [];
        if (_clutter) then {_behind = ((_targetPos vectorDistance (_hit # 0 # 0)) toFixed 0) + " m";};
        _from    = _to;
        _checked = _checked + _step;
    };
};
private _rotor = _clutter && {_target isKindOf "Helicopter"} && {isEngineOn _target} && {random 1 < ASE_RADAR_ROTOR_CHANCE};
private _lost  = _clutter && {!_rotor};

if (_log) then {
    diag_log format ["fza_ase radar | #%11 filter %1 from %2 at %3 m: radial %4 <= %5 m/s, AGL %6 m vs beam %7 m, ground behind %8 (gate %9 m), %10",
        typeOf _target, typeOf _radar, _range toFixed 0, _radial toFixed 1, _minimumSpeed, _agl toFixed 0, _beam toFixed 0,
        _behind, (_maximumTerrainCheck min (_minimumTime * 3e8)) toFixed 0,
        ["seen, out of clutter", ["LOST in clutter", "seen by rotor return"] select _rotor] select _clutter,
        _radar getVariable ["fza_ase_radarLogId", "L"]];
};

_lost
