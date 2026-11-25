/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfi

Description:
    AN/APR-48A radar frequency interferometer. On the machine that decides for the aircraft, hears every radar
    switched on within range and in line of sight of the mast, identifies, prioritises and publishes up to
    ASE_RFI_MAX of them as fza_ah64_ase_rfiEmitters.

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_rfi

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#define ANGLE_180(a) ((((a) % 360) + 540) % 360 - 180)
params ["_heli"];

if !(ASE_OWNER(_heli)) exitWith {};
private _now = CBA_missionTime;
private _working = [_heli] call fza_ase_fnc_rfiWorking;

// While it works, spread over frames, a few at a time: the list of radar vehicles is rebuilt
// (fza_ase_fnc_rfiCandidates), and the radars the last tick found in range have their line of sight from the mast
// checked, longest ago first
private _candidates = if (_working) then {[_heli] call fza_ase_fnc_rfiCandidates} else {[]};
private _los = _heli getVariable "fza_ah64_ase_rfiLos";
if (isNil "_los") then {
    _los = createHashMap;
    _heli setVariable ["fza_ah64_ase_rfiLos", _los];
};
(_heli getVariable ["fza_ah64_ase_rfiLosQueue", [[], 0]]) params ["_queue", "_next"];
if (_working && {_next < count _queue}) then {
    private _mast = _heli modelToWorldWorld (_heli selectionPosition ["sensorPos", "Memory"]);
    private _end  = (_next + ASE_RFI_LOS_PER_FRAME) min count _queue;
    for "_i" from _next to _end - 1 do {
        (_queue # _i) params ["_veh", "_key"];
        if (isNull _veh) then {continue;};
        _los set [_key, [!(terrainIntersectASL [_mast, aimPos _veh]), _now]];
    };
    _heli setVariable ["fza_ah64_ase_rfiLosQueue", [_queue, _end]];
};

if (_now < (_heli getVariable ["fza_ah64_ase_rfiNext", -1])) exitWith {};
_heli setVariable ["fza_ah64_ase_rfiNext", _now + ASE_RFI_TICK];

if !_working exitWith {
    _heli setVariable ["fza_ah64_ase_rfiTrack", createHashMap];
    _heli setVariable ["fza_ah64_ase_rfiWalk", []];
    _heli setVariable ["fza_ah64_ase_rfiLosQueue", [[], 0]];
    _heli setVariable ["fza_ah64_ase_rfiLos", createHashMap];
    [_heli, "fza_ah64_ase_rfiEmitters", []] call fza_fnc_updateNetworkGlobal;
};

// Modes against the ownship, highest first: a radar missile in flight puts its launcher in launch
private _threatModes = createHashMap;
private _setMode = {
    params ["_veh", "_mode"];
    if (isNull _veh) exitWith {};
    private _key = hashValue _veh;
    _threatModes set [_key, [_veh, ((_threatModes getOrDefault [_key, [_veh, -1]]) # 1) max _mode]];
};
{
    _x params ["_object", "_type"];
    switch (_type) do {
        case "missile": {
            if ([getNumber (configOf _object >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND == 8) then {
                [vehicle ((getShotParents _object) # 0), ASE_LNC] call _setMode;
            };
        };
        case "locked": {[vehicle _object, ASE_TRK] call _setMode;};
        case "marked": {[vehicle _object, ASE_ACQ] call _setMode;};
    };
} forEach getSensorThreats _heli;

// Track records by hashValue: [obj, code, fine error, coarse error, last heard, posASL, mode, tier, distance, air,
// fine, last fine fix, its bearing]
private _track = _heli getVariable "fza_ah64_ase_rfiTrack";
if (isNil "_track") then {
    _track = createHashMap;
    _heli setVariable ["fza_ah64_ase_rfiTrack", _track];
};
// The antennas are on the FCR and turn with it: its azimuth from the nose, right positive (fza_fcr_fnc_animateFCR)
private _antenna = -(deg (_heli animationPhase "longbow"));
private _heading = getDir _heli;

// Heard: radars switched on within range whose line of sight from the mast was clear when last checked, by hashValue as
// [vehicle, radar range, posASL, distance]; one not checked yet counts as masked until it is. Those in range are queued
// for checking, longest ago first.
private _inRange = [];
private _order   = [];
{
    _x params ["_veh", "_radarRange"];
    if (!alive _veh || {!isVehicleRadarOn _veh}) then {continue;};
    private _dist = _heli distance _veh;
    if (_dist > ((_radarRange * ASE_RFI_RANGE_COEF) min ASE_RFI_RANGE)) then {continue;};
    private _key = hashValue _veh;
    _order pushBack [(_los getOrDefault [_key, [false, -1e9]]) # 1, count _inRange];
    _inRange pushBack [_key, _veh, _radarRange, _dist];
} forEach _candidates;
_order sort true;
_inRange = _order apply {_inRange # (_x # 1)};
private _kept  = createHashMap;
private _heard = createHashMap;
{
    _x params ["_key", "_veh", "_radarRange", "_dist"];
    private _result = _los getOrDefault [_key, [false, -1e9]];
    _kept set [_key, _result];
    if (_result # 0) then {_heard set [_key, [_veh, _radarRange, aimPos _veh, _dist]];};
} forEach _inRange;
_heli setVariable ["fza_ah64_ase_rfiLos", _kept];
_heli setVariable ["fza_ah64_ase_rfiLosQueue", [_inRange apply {[_x # 1, _x # 0]}, 0]];
// And everything the aircraft's own sensors report: radars on it, radar missiles' launchers and passive radar contacts.
// A launcher fed by datalink has no radar of its own to hear, but locks on through the engine.
if (isNil "fza_ase_rfiRadarRange") then {fza_ase_rfiRadarRange = createHashMap;};
{
    if (!alive _x || {_x == _heli}) then {continue;};
    private _key = hashValue _x;
    if (_key in _heard) then {continue;};
    _heard set [_key, [_x, fza_ase_rfiRadarRange getOrDefault [typeOf _x, 0], aimPos _x, _heli distance _x]];
} forEach (((values _threatModes) apply {_x # 0}) + (((getSensorTargets _heli) select {"passiveradar" in (_x param [3, []])}) apply {vehicle (_x # 0)}));

private _heliPos  = getPosASL _heli;
private _elevSine = sin ASE_RFI_ELEV_LIMIT;
{
    private _key = _x;
    _y params ["_veh", "_radarRange", "_pos", "_dist"];
    // The arrays hear nothing more than ASE_RFI_ELEV_LIMIT above or below the aircraft
    if (abs ((_heli vectorWorldToModel (_heliPos vectorFromTo _pos)) # 2) > _elevSine) then {continue;};
    private _record = _track get _key;
    if (isNil "_record") then {
        private _cfg = configOf _veh >> "fza_aseIcon";
        _record = [_veh, ["SR", getText _cfg] select isText _cfg,
            random [-ASE_RFI_FINE_ERR, 0, ASE_RFI_FINE_ERR], random [-ASE_RFI_COARSE_ERR, 0, ASE_RFI_COARSE_ERR]];
        _track set [_key, _record];
    };

    private _mode = (_threatModes getOrDefault [_key, [objNull, ASE_SRH]]) # 1;
    private _trackingOther = _mode == ASE_SRH && {[gunner _veh, commander _veh] findIf {
        private _target = vehicle assignedTarget _x;
        !isNull _target && {_target != _heli} && {_target isKindOf "Air"}
    } >= 0};
    if (_trackingOther) then {_mode = ASE_TRK;};

    // Friend and foe aren't told apart: every emitter is taken as hostile
    private _tier = switch (true) do {
        case (_mode >= ASE_ACQ && !_trackingOther): {1};
        case (_trackingOther):                       {2};
        case (_dist <= _radarRange):                 {3};
        case (_dist <= ASE_RFI_REACH):               {4};
        default                                      {5};
    };
    // A fine fix is kept out of the fine sector while the emitter stays where it was fixed
    private _world = _heli getDir _pos;
    if (abs ANGLE_180(_world - _heading - _antenna) <= ASE_RFI_FINE_DEG) then {
        _record set [11, _now];
        _record set [12, _world];
    };
    private _fixedAt = _record param [12, _world];
    private _fine = _now - (_record param [11, -1e9]) <= ASE_RFI_FINE_HOLD
        && {abs ANGLE_180(_world - _fixedAt) <= ASE_RFI_FINE_DRIFT};
    _record set [4, _now];
    _record set [5, _pos apply {round _x}];
    _record set [6, _mode];
    _record set [7, _tier];
    _record set [8, _dist];
    _record set [9, _veh isKindOf "Air" && {(getPos _veh) # 2 > 5}];
    _record set [10, _fine];
} forEach _heard;

// Radiating before silent, then by danger, then nearest
_order = [];
private _dropped = [];
{
    private _age = _now - (_y # 4);
    if (_age > ASE_RFI_DROP_TIME) then {_dropped pushBack _x; continue;};
    _order pushBack [([0, 2e6] select (_age > ASE_RFI_STALE_TIME)) + (_y # 7) * 1e5 + (_y # 8), _x];
} forEach _track;
{_track deleteAt _x;} forEach _dropped;
_order sort true;
private _shown = (_order select [0, ASE_RFI_MAX]) apply {_track get (_x # 1)};

private _emitters = _shown apply {
    _x params ["_veh", "_code", "_errFine", "_errCoarse", "_heard", "_pos", "_mode", "_tier", "", "_air", "_fine"];
    // Silent: where it was last heard, not where it has gone since
    [_veh, _code, _fine, round (([_errCoarse, _errFine] select _fine) * 10) / 10, _mode, _air, _now - _heard > ASE_RFI_STALE_TIME, [[], _pos] select (_heard < _now), _tier]
};
[_heli, "fza_ah64_ase_rfiEmitters", _emitters] call fza_fnc_updateNetworkGlobal;
