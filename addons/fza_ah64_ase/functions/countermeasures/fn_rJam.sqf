/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJam

Description:
    Handles the AN/ALQ-136 radar jammer. In OPER and warmed up it transmits while a radar
    from any direction acquires or tracks the aircraft. The barrage covers every radar in the
    cone off the nose, friendly or not, with one roll per range band that jams the whole band
    or none of it. A launcher fed only over datalink is jammed while all its side's radars are.

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_rJam

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

if (_heli animationPhase "msn_equip_american" != 1 && {_heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF] != ASE_RJAM_STATE_OFF}) then {
    _heli setVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF, true];
};
if (_heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF] != ASE_RJAM_STATE_OPER || {ASE_RJAM_WARMING(_heli)}) exitWith {
    _heli setVariable ["fza_ah64_ase_rJamXmit", false];
};

private _debug    = missionNamespace getVariable ["fza_ase_rJamDebug", false];
// Other AH-64Ds' FCRs included: a jammed one is locked out until the jam ends (fza_fcr_fnc_controller)
private _jammable = {
    params ["_emitter"];
    alive _emitter
};

// Triggered by a radar from any direction acquiring or tracking the aircraft
private _threats = [];
{
    _x params ["_object", "_type", ["_sensors", []]];
    if (_debug) then {diag_log format ["fza_ase_rJam threat: %1 %2 %3 %4", typeOf vehicle _object, _type, _sensors, round (_heli getRelDir vehicle _object)];};
    if !(_type in ["marked", "locked"]) then {continue;};
    if (_sensors findIf {private _sensor = toLower _x; _sensor find "radar" >= 0 && {_sensor find "passive" < 0}} < 0) then {continue;};
    private _emitter = vehicle _object;
    if (_emitter in _threats || {!([_emitter] call _jammable)}) then {continue;};
    _threats pushBack _emitter;
} forEach getSensorThreats _heli;

// Jams from one machine: where the aircraft is local, or the CPG's with no player pilot
private _owner = local _heli || {player == gunner _heli && {!isPlayer driver _heli}};
if (_threats isNotEqualTo [] && {_owner}) then {
    private _hasRadar = {
        params ["_vehicle"];
        if (isNil "fza_ase_rJamHasRadar") then {fza_ase_rJamHasRadar = createHashMap;};
        private _type = typeOf _vehicle;
        private _has  = fza_ase_rJamHasRadar get _type;
        if (isNil "_has") then {
            _has = ("getText (_x >> 'componentType') == 'ActiveRadarSensorComponent'" configClasses (configOf _vehicle >> "Components" >> "SensorsManagerComponent" >> "Components")) isNotEqualTo [];
            fza_ase_rJamHasRadar set [_type, _has];
        };
        _has
    };

    // The barrage covers the cone off the nose: the radars there acquiring or tracking the aircraft, and every other
    // radar, friendly or not, the aircraft detects emitting there
    private _detected = [];
    {
        _x params ["_object", "", "_relationship", ["_sensors", []]];
        if !("passiveradar" in _sensors) then {continue;};
        private _emitter = vehicle _object;
        if (_emitter in _detected || {!([_emitter] call _jammable)}) then {continue;};
        if (_debug) then {diag_log format ["fza_ase_rJam detected: %1 %2 %3", typeOf _emitter, _relationship, round (_heli getRelDir _emitter)];};
        _detected pushBack _emitter;
    } forEach getSensorTargets _heli;
    private _emitters = _threats + _detected;
    _emitters = (_emitters arrayIntersect _emitters) select {abs ([_heli getRelDir _x] call CBA_fnc_simplifyAngle180) <= ASE_RJAM_CONE_DEG};

    // One roll for each range band, at the burn-through chance of its nearest radar: it jams the whole band, or none of
    // it. A band starts at the nearest radar not yet in one, so a site isn't split by a band edge.
    private _jammed = [];
    if (_emitters isNotEqualTo [] && {CBA_missionTime >= (_heli getVariable ["fza_ah64_ase_rJamNextRoll", -1])}) then {
        _heli setVariable ["fza_ah64_ase_rJamNextRoll", CBA_missionTime + ASE_RJAM_ROLL_INTERVAL];
        private _ranged = [_emitters apply {[_heli distance _x, _x]}, [], {_x # 0}] call BIS_fnc_sortBy;
        private _bands  = [];
        {
            _x params ["_distance", "_emitter"];
            if (_bands isEqualTo [] || {_distance - ((_bands select -1) # 0) > ASE_RJAM_BAND}) then {
                _bands pushBack [_distance, []];
            };
            ((_bands select -1) # 1) pushBack _emitter;
        } forEach _ranged;

        {
            _x params ["_nearest", "_band"];
            private _chance  = linearConversion [ASE_RJAM_BURN_RANGE, ASE_RJAM_FULL_RANGE, _nearest, ASE_RJAM_CHANCE_MIN, ASE_RJAM_CHANCE_MAX, true];
            private _success = random 1 < _chance;
            if (_debug) then {diag_log format ["fza_ase_rJam roll: %1 from %2 m, chance %3, jammed %4", _band apply {typeOf _x}, round _nearest, _chance, _success];};
            if (!_success) then {continue;};
            {
                [_x, ASE_RJAM_JAM_TIME] remoteExecCall ["fza_ase_fnc_rJamEffect", _x];
                _jammed pushBack [_x, CBA_missionTime + ASE_RJAM_JAM_TIME];
            } forEach _band;
        } forEach _bands;
        if (_jammed isNotEqualTo []) then {
            _heli setVariable ["fza_ah64_ase_rJamXmitUntil", CBA_missionTime + ASE_RJAM_JAM_TIME, true];
        };
    };

    // A launcher locking the aircraft over datalink, with no radar of its own, is jammed for as long as every radar of
    // its side the aircraft detects emitting, or holds as jammed, is
    private _held  = _heli getVariable ["fza_ah64_ase_rJamHeld", []];
    private _radars = (_threats + _detected + (_held apply {_x # 0})) select {alive _x && {[_x] call _hasRadar}};
    _radars = _radars arrayIntersect _radars;
    {
        private _launcher = _x;
        if ([_launcher] call _hasRadar) then {continue;};
        private _side  = side _launcher;
        private _feeds = _radars select {side _x == _side};
        if (_feeds isEqualTo []) then {continue;};
        private _until = selectMin (_feeds apply {_x getVariable ["fza_ah64_rJamUntil", -1]});
        if (_until <= CBA_missionTime || {(_launcher getVariable ["fza_ah64_rJamUntil", -1]) >= _until - 0.5}) then {continue;};
        if (_debug) then {diag_log format ["fza_ase_rJam datalink: %1 from %2 for %3 s", typeOf _launcher, _feeds apply {typeOf _x}, _until - CBA_missionTime];};
        [_launcher, _until - CBA_missionTime] remoteExecCall ["fza_ase_fnc_rJamEffect", _launcher];
        _jammed pushBack [_launcher, _until];
    } forEach _threats;

    // The RLWR holds what's jammed until it's back (fza_ase_fnc_rwr)
    if (_jammed isNotEqualTo []) then {
        private _new = _jammed apply {_x # 0};
        _held = _held select {_x # 1 > CBA_missionTime && {!((_x # 0) in _new)}};
        _held append (_jammed apply {[_x # 0, (_x # 1) + ASE_RJAM_HOLD_TIME]});
        _heli setVariable ["fza_ah64_ase_rJamHeld", _held, true];
    };
};

private _xmit = _threats isNotEqualTo [] || {CBA_missionTime < (_heli getVariable ["fza_ah64_ase_rJamXmitUntil", -1])};
_heli setVariable ["fza_ah64_ase_rJamXmit", _xmit];

// For radios in front of it (fza_ase_fnc_rJamComms): when it last transmitted, refreshed at most once a second, so it
// goes stale on its own if the crew goes away mid-jam
if (_xmit && {_owner} && {CBA_missionTime - (_heli getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) >= 1}) then {
    _heli setVariable ["fza_ah64_ase_rJamXmitStamp", CBA_missionTime, true];
};
