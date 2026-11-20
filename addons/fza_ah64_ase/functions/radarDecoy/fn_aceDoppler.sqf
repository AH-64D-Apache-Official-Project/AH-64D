/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_aceDoppler

Description:
    ACE's Doppler radar seeker (ace_missileguidance_fnc_seekerType_Doppler), with ground
    clutter and chaff checked at its radar poll rate: by the launcher's radar while it guides
    the missile, then by the missile's seeker. Chaff seduces the missile for
    ASE_RADAR_CHAFF_SEDUCE_TIME, after which the radar searches for its target again. Low, and
    slow along the line of sight, the target's reflection pulls the aim below it (multipath).
    Chaff effectiveness and multipath are per missile, from its ace_missileguidance class.
    Seeker state 14 is when a seduction ends, 15 whether the launcher's radar has lost the
    target, 16 the target it was seduced off.

Parameters:
    0: Not used
    1: Guidance arguments <ARRAY>
    2: Seeker state <ARRAY>
    3: Not used
    4: Timestep <NUMBER>

Returns:
    Seeker position, PosASL <ARRAY>

Examples:
    call fza_ase_fnc_aceDoppler

Author:
    tcvm (ACE), Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\radarDecoy.h"
params ["", "_args", "_seekerStateParams", "", ["_timestep", 0]];

// Not the state ACE's Doppler onFired sets up
if (count _seekerStateParams < 14) exitWith {call ace_missileguidance_fnc_seekerType_Doppler};

_args params ["_firedEH", "_launchParams", "", "_seekerParams", "", "_targetData"];
_firedEH params ["_shooter", "", "", "", "", "", "_projectile"];
_launchParams params ["_target"];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_isActive", "_activeRadarEngageDistance", "_timeWhenActive", "_expectedTargetPos", "_lastTargetPollTime", "_shooterHasRadar", "_wasActive", "_lastKnownVelocity", "_lastTimeSeen", "_doesntHaveTarget", ["_lockTypes", ["Air", "LandVehicle", "Ship"]], ["_minimumFilterSpeed", 30], ["_minimumFilterTime", 1e-4], ["_maxTerrainCheck", 16000], ["_seducedUntil", -1], ["_externalLost", false], ["_seducedFrom", objNull]];

private _debug = missionNamespace getVariable ["ace_missileguidance_debug_drawGuidanceInfo", false];
if (isNil "fza_ase_radarProjectileTypes") then {fza_ase_radarProjectileTypes = createHashMap;};
private _isProjectile = {
    if (isNull _this) exitWith {false};
    private _type = typeOf _this;
    private _is   = fza_ase_radarProjectileTypes get _type;
    if (isNil "_is") then {
        _is = _type isKindOf ["Default", configFile >> "CfgAmmo"];
        fza_ase_radarProjectileTypes set [_type, _is];
    };
    _is
};
private _active = _isActive || {CBA_missionTime >= _timeWhenActive};

if (isNil "fza_ase_radarMissileParams") then {fza_ase_radarMissileParams = createHashMap;};
private _missileParams = fza_ase_radarMissileParams getOrDefaultCall [typeOf _projectile, {
    private _config = configOf _projectile >> "ace_missileguidance";
    [
        [_config >> "fza_ase_chaffEffectiveness", "NUMBER", ASE_RADAR_CHAFF_EFFECTIVENESS] call CBA_fnc_getConfigEntry,
        [_config >> "fza_ase_multipathError", "NUMBER", ASE_RADAR_MULTIPATH_ERROR] call CBA_fnc_getConfigEntry,
        [_config >> "fza_ase_multipathMaxSpeed", "NUMBER", ASE_RADAR_MULTIPATH_SPEED] call CBA_fnc_getConfigEntry,
        [_config >> "fza_ase_multipathMaxHeight", "NUMBER", ASE_RADAR_MULTIPATH_HEIGHT] call CBA_fnc_getConfigEntry
    ]
}, true];
_missileParams params ["_chaffEffectiveness", "_multipathError", "_multipathMaxSpeed", "_multipathMaxHeight"];

// Testing: fza_ase_radarDebug = true
private _log = missionNamespace getVariable ["fza_ase_radarDebug", false];
private _say = {
    private _id = _projectile getVariable ["fza_ase_radarLogId", 0];
    diag_log format ["fza_ase radar | #%1 %2", _id, _this];
    systemChat format ["Radar #%1: %2", _id, _this];
};
// Chat only when it changes
private _sayIfChanged = {
    params ["_seen", "_text"];
    if ((_projectile getVariable ["fza_ase_radarSeen", true]) isEqualTo _seen) exitWith {
        diag_log format ["fza_ase radar | #%1 %2", _projectile getVariable ["fza_ase_radarLogId", 0], _text];
    };
    _projectile setVariable ["fza_ase_radarSeen", _seen];
    _text call _say;
};
if (_log && {isNil {_projectile getVariable "fza_ase_radarLogId"}}) then {
    fza_ase_radarLogCount = (missionNamespace getVariable ["fza_ase_radarLogCount", 0]) + 1;
    _projectile setVariable ["fza_ase_radarLogId", fza_ase_radarLogCount];
    _projectile setVariable ["fza_ase_radarLogTarget", _target];
    format ["launch %1 from %2 at %3, %4 m, launcher guides it %5 s more, filter %6 m/s, ground gate %7 m",
        typeOf _projectile, typeOf vehicle _shooter, typeOf _target, (_projectile distance _target) toFixed 0,
        (0 max (_timeWhenActive - CBA_missionTime)) toFixed 1, _minimumFilterSpeed,
        (_maxTerrainCheck min (_minimumFilterTime * 3e8)) toFixed 0] call _say;
    _projectile addEventHandler ["Explode", {
        params ["_projectile", "_pos"];
        private _real = _projectile getVariable ["fza_ase_radarLogTarget", objNull];
        if (isNull _real) exitWith {};
        private _id   = _projectile getVariable ["fza_ase_radarLogId", 0];
        private _text = format ["%1 exploded %2 m from %3", typeOf _projectile, (_pos vectorDistance getPosASL _real) toFixed 0, typeOf _real];
        diag_log format ["fza_ase radar | #%1 %2", _id, _text];
        systemChat format ["Radar #%1: %2", _id, _text];
    }];
};

// Seduction over: the radar searches again, finding its target if it's in the seeker's cone,
// in sight and out of clutter; else the seeker searches around the chaff
if (_seducedUntil >= 0 && {CBA_missionTime >= _seducedUntil || {!alive _target}}) then {
    if (alive _target) then {_expectedTargetPos = getPosASLVisual _target;};
    private _found = alive _seducedFrom && {!_active || {
        [_projectile, getPosASLVisual _seducedFrom, _seekerAngle] call ace_missileguidance_fnc_checkSeekerAngle && {
            ([_projectile, _seducedFrom, true] call ace_missileguidance_fnc_checkLos) || {[_projectile, _seducedFrom, false] call ace_missileguidance_fnc_checkLos}
        } && {
            !([_seducedFrom, _projectile, _minimumFilterSpeed, _minimumFilterTime, _maxTerrainCheck] call fza_ase_fnc_aceRadarFilter)
        }
    }};
    _target = [objNull, _seducedFrom] select _found;
    if (_found) then {_expectedTargetPos = getPosASLVisual _target;} else {_projectile setMissileTarget objNull;};
    if (_log) then {format ["seduction over, %1", ["seeker searching around the chaff", "back on " + typeOf _target] select _found] call _say;};
    _doesntHaveTarget = false;
    _seekerStateParams set [14, -1];
    _seekerStateParams set [16, objNull];
    _seekerStateParams set [9, false];
};

if (_active) then {
    if !(_isActive) then {
        _seekerStateParams set [0, true];
    };
    if !(_wasActive) then {
        _seekerStateParams set [6, true];
        if (_log) then {format ["seeker active, %1 m from %2", (_projectile distance _target) toFixed 0, typeOf _target] call _say;};
    };
    _externalLost = false;
    _seekerStateParams set [15, false];

    // A projectile target is flown at without a radar search
    if !(_target call _isProjectile) then {
        if ((_lastTargetPollTime + ASE_RADAR_POLL_TIME) - CBA_missionTime < 0) then {
            private _searchPos = _expectedTargetPos;
            if (_searchPos isEqualTo [0, 0, 0] || { _doesntHaveTarget }) then {
                _seekerStateParams set [9, true];
                // Shot without a lock: search the ground ahead
                _searchPos = (getPosASL _projectile) vectorAdd (_projectile vectorModelToWorld [0, _seekerMaxRange, -((getPos _projectile)#2)]);
            };

            _target = objNull;
            _lastTargetPollTime = CBA_missionTime;
            _seekerStateParams set [4, _lastTargetPollTime];
            private _distanceToExpectedTarget = _seekerMaxRange min ((getPosASL _projectile) vectorDistance _searchPos);

            // How much ground the seeker sees
            private _projDir = vectorDir _projectile;
            private _projYaw = getDir _projectile;
            private _rotatedYaw = (+(_projDir select 0) * sin _projYaw) + (+(_projDir select 1) * cos _projYaw);
            if (_rotatedYaw isEqualTo 0) then { _rotatedYaw = 0.001 };
            private _projPitch = atan ((_projDir select 2) / _rotatedYaw);
            private _a1 = abs _projPitch;
            private _a2 = 180 - ((_seekerAngle / 2) + _a1);
            private _seekerBaseRadiusAtGround = ASE_RADAR_MIN_SCAN_AREA max (_distanceToExpectedTarget / sin(_a2) * sin(_seekerAngle / 2));

            private _seekerBaseRadiusAdjusted = linearConversion [0, _seekerBaseRadiusAtGround, (CBA_missionTime - _lastTimeSeen) * vectorMagnitude _lastKnownVelocity, ASE_RADAR_MIN_SCAN_AREA, _seekerBaseRadiusAtGround, false];
            if (_doesntHaveTarget) then {
                _seekerBaseRadiusAdjusted = _seekerBaseRadiusAtGround;
            };
            // In the cone, in sight (through smoke or past a bush) and not lost in clutter
            private _nearestObjects = nearestObjects [ASLToAGL _searchPos, _lockTypes, _seekerBaseRadiusAdjusted, false];
            private _inRadius = count _nearestObjects;
            _nearestObjects = _nearestObjects select {
                [_projectile, getPosASL _x, _seekerAngle] call ace_missileguidance_fnc_checkSeekerAngle && {
                    ([_projectile, _x, true] call ace_missileguidance_fnc_checkLos) || { ([_projectile, _x, false] call ace_missileguidance_fnc_checkLos) }
                } && {
                    !([_x, _projectile, _minimumFilterSpeed, _minimumFilterTime, _maxTerrainCheck] call fza_ase_fnc_aceRadarFilter)
                }
            };
            if (_nearestObjects isEqualTo []) exitWith {
                if (_log) then {
                    [false, format ["seeker LOST: %1 within %2 m of the search point, none in its cone, in sight and out of clutter", _inRadius, _seekerBaseRadiusAdjusted toFixed 0]] call _sayIfChanged;
                };
                _projectile setMissileTarget objNull;
                _seekerStateParams set [3, _searchPos];
                _searchPos
            };
            // The one closest to where the target was expected
            private _closestDistance = _seekerBaseRadiusAtGround;
            {
                if ((_x distance2D _searchPos) < _closestDistance) then {
                    _closestDistance = _x distance2D _searchPos;
                    _target = _x;
                };
            } forEach _nearestObjects;

            _expectedTargetPos = _searchPos;
            if (_log) then {
                [!isNull _target, format ["seeker on %1, %2 m", typeOf _target, (_projectile distance _target) toFixed 0]] call _sayIfChanged;
            };

            if (!isNull _target) then {
                private _chaff = [_target, _projectile, _minimumFilterSpeed, _seekerAngle, false, _chaffEffectiveness] call fza_ase_fnc_aceRadarChaff;
                if (!isNull _chaff) then {
                    _seekerStateParams set [14, CBA_missionTime + ASE_RADAR_CHAFF_SEDUCE_TIME];
                    _seekerStateParams set [16, _target];
                    if (_log) then {format ["seeker SEDUCED by chaff for %1 s, %2 m from %3", ASE_RADAR_CHAFF_SEDUCE_TIME, (_projectile distance _target) toFixed 0, typeOf _target] call _say;};
                    _target = _chaff;
                };
            };
        };
    };
} else {
    if (_debug) then {
        _seekerTypeName = "DOPPLER - EXT"; //IGNORE_PRIVATE_WARNING ["_seekerTypeName"]; // from doSeekerSearch
    };
    // Guided while the side's datalink has the target, or the launcher's radar sees it; not while seduced
    private _remoteTargets = listRemoteTargets side _shooter;
    if ((_seekerStateParams param [14, -1]) < 0 && {(_remoteTargets findIf { (_target in _x) && (_x#1 > 0) }) == -1}) then {
        private _vehicle = vehicle _shooter;
        if (!_shooterHasRadar || { !isVehicleRadarOn _vehicle } || { !alive _vehicle } || { !([_vehicle, _target, true] call ace_missileguidance_fnc_checkLos) && { !([_vehicle, _target, false] call ace_missileguidance_fnc_checkLos) } }) then {
            if (_log) then {
                format ["launcher lost %1 (no datalink track, radar %2, line of sight %3): seeker goes active, %4 m out", typeOf _target,
                    ["off", "on"] select (_shooterHasRadar && {isVehicleRadarOn _vehicle}),
                    ["none", "clear"] select ([_vehicle, _target, false] call ace_missileguidance_fnc_checkLos), (_projectile distance _target) toFixed 0] call _say;
            };
            _seekerStateParams set [0, true];
            _target = objNull;
        };
    };

    // The launcher's radar: clutter and chaff, as the seeker
    if (!isNull _target && {!(_target call _isProjectile)} && {(_lastTargetPollTime + ASE_RADAR_POLL_TIME) - CBA_missionTime < 0}) then {
        _seekerStateParams set [4, CBA_missionTime];
        private _radar = vehicle _shooter;
        _externalLost = [_target, _radar, _minimumFilterSpeed, _minimumFilterTime, _maxTerrainCheck] call fza_ase_fnc_aceRadarFilter;
        _seekerStateParams set [15, _externalLost];
        if (_log) then {
            [!_externalLost, format ["launcher %1 %2, missile %3 m out", ["has", "LOST in clutter"] select _externalLost, typeOf _target, (_projectile distance _target) toFixed 0]] call _sayIfChanged;
        };
        if (!_externalLost) then {
            private _chaff = [_target, _radar, _minimumFilterSpeed, -1, false, _chaffEffectiveness] call fza_ase_fnc_aceRadarChaff;
            if (!isNull _chaff) then {
                _seekerStateParams set [14, CBA_missionTime + ASE_RADAR_CHAFF_SEDUCE_TIME];
                _seekerStateParams set [16, _target];
                if (_log) then {format ["launcher SEDUCED by chaff for %1 s, missile %2 m from %3", ASE_RADAR_CHAFF_SEDUCE_TIME, (_projectile distance _target) toFixed 0, typeOf _target] call _say;};
                _target = _chaff;
            };
        };
    };
};

if (_debug) then {
    drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,0,0,1], ASLToAGL _expectedTargetPos, 0.75, 0.75, 0, "expected target pos", 1, 0.025, "TahomaB"];
    if (_target call _isProjectile && {(_seekerStateParams param [14, -1]) >= 0}) then {
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [0,0,1,1], ASLToAGL getPosASLVisual _target, 0.75, 0.75, 0, "chaff", 1, 0.025, "TahomaB"];
    };
    if (_externalLost) then {
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,1,0,1], ASLToAGL _expectedTargetPos, 0.75, 0.75, 0, "lost in clutter", 1, 0.025, "TahomaB"];
    };
    // Chaff near the real target, as the radar now looking sees it
    private _realTarget = [_target, _seekerStateParams param [16, objNull]] select ((_seekerStateParams param [14, -1]) >= 0);
    if (!isNull _realTarget && {!(_realTarget call _isProjectile)}) then {
        private _seekerActive = _seekerStateParams # 0;
        [_realTarget, [vehicle _shooter, _projectile] select _seekerActive, _minimumFilterSpeed, [-1, _seekerAngle] select _seekerActive, true, _chaffEffectiveness] call fza_ase_fnc_aceRadarChaff;
    };
};

if !(isNull _target) then {
    // Lost by the launcher's radar: flies on at where it was last seen
    if !(_externalLost) then {
        private _centerOfObject = getCenterOfMass _target;
        private _targetAdjustedPos = _target modelToWorldVisualWorld _centerOfObject;
        _expectedTargetPos = _targetAdjustedPos;

        private _lineOfSight = vectorDirVisual _projectile;
        private _realTargetVelocity = velocity _target;
        private _projectedTargetVelocity = _lineOfSight vectorMultiply (_realTargetVelocity vectorDotProduct _lineOfSight);
        private _relativeTargetVelocity = _realTargetVelocity vectorDiff _projectedTargetVelocity;

        // Chaff steers the missile but isn't a sighting of the target
        private _seduced = (_seekerStateParams param [14, -1]) >= 0;
        if !(_seduced) then {
            _seekerStateParams set [7, _relativeTargetVelocity];
            _seekerStateParams set [8, CBA_missionTime];
            _seekerStateParams set [9, false];
        };

        _targetData set [2, _projectile distance _target];
        _targetData set [3, _relativeTargetVelocity];

        if (_timestep != 0) then {
            private _acceleration = [(_relativeTargetVelocity vectorDiff _lastKnownVelocity) vectorMultiply (1 / _timestep), [0, 0, 0]] select _seduced;
            _targetData set [4, _acceleration];
        };
    };
    _projectile setMissileTarget _target;
};

if (_expectedTargetPos isEqualTo [0, 0, 0]) then {
    _expectedTargetPos = (getPosASLVisual _projectile) vectorAdd velocity _projectile;
};

// Low, and slow along the line of sight, the radar also sees the target's reflection and aims below it
private _aimPos = _expectedTargetPos;
if (!isNull _target && {!_externalLost} && {_multipathError > 0} && {!(_target call _isProjectile)}) then {
    private _radar  = [vehicle _shooter, _projectile] select (_seekerStateParams # 0);
    private _agl    = (ASLToAGL _expectedTargetPos) # 2;
    private _radial = abs ((velocity _target) vectorDotProduct ((getPosASLVisual _radar) vectorFromTo _expectedTargetPos));
    private _error  = _multipathError * linearConversion [0, _multipathMaxHeight, _agl, 1, 0, true]
        * linearConversion [0, _multipathMaxSpeed, _radial, 1, 0, true];
    if (_error <= 0) exitWith {};
    private _phase = _projectile getVariable "fza_ase_radarMultipathPhase";
    if (isNil "_phase") then {
        _phase = random 360;
        _projectile setVariable ["fza_ase_radarMultipathPhase", _phase];
    };
    private _drop = _error * (1 + sin (CBA_missionTime * ASE_RADAR_MULTIPATH_RATE + _phase)) / 2;
    _aimPos = _expectedTargetPos vectorAdd [0, 0, -_drop];
    if (_debug) then {
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,0.5,0,1], ASLToAGL _aimPos, 0.75, 0.75, 0, "multipath aim", 1, 0.025, "TahomaB"];
    };
    if (_log && {CBA_missionTime >= _projectile getVariable ["fza_ase_radarMultipathLog", 0]}) then {
        _projectile setVariable ["fza_ase_radarMultipathLog", CBA_missionTime + 0.5];
        diag_log format ["fza_ase radar | multipath: %1 at %2 m above ground, radial %3 m/s, error up to %4 m, aiming %5 m below it, missile %6 m out",
            typeOf _target, _agl toFixed 0, _radial toFixed 1, _error toFixed 1, _drop toFixed 0, (_projectile distance _target) toFixed 0];
    };
};

_targetData set [0, (getPosASLVisual _projectile) vectorFromTo _aimPos];

_seekerStateParams set [3, _expectedTargetPos];
_launchParams set [0, _target];
if (_log && {!isNull _target} && {!(_target call _isProjectile)}) then {_projectile setVariable ["fza_ase_radarLogTarget", _target];};
_aimPos
