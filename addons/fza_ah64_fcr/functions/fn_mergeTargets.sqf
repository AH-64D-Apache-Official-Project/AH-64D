/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_mergeTargets

Description:
    Scan-to-scan correlation, made as each full scan cycle completes. Each
    target gets one wiper pass a cycle, detected or missed by chance. The
    result shows when the wiper next crosses the target (revealTime,
    fza_fcr_fnc_targetShown): the position it was detected at, or on a miss
    where it was last shown.

    Moving targets stand out of the clutter (FCR_MISS_MOVING), correlated over
    the last scanburst of passes (FCR_BURST_SCANS). Stationary targets are
    harder to see (FCR_MISS_STATIONARY) and build up a memory while painted:
    a count, +1 a detection and -1 a miss,
    up to FCR_MEMORY_CAP. Either is bright at FCR_BRIGHT_HITS, dim below that,
    and goes at none.

    A target the sensor no longer reports is missed; a destroyed target stays a
    radar return within the stationary target range. Clutter discretes in the
    scanned sector (buildings, walls, rocks, pylons) are false returns: a few
    are detected each cycle (FCR_FALSE_PER_CYCLE), and once known detected
    again by chance (FCR_MISS_FALSE), correlated like stationary targets.

    ATM is not correlated: every target the scan sees is bright, one it no
    longer sees goes at once, and it has no false returns.

Parameters:
    _heli       - The helicopter
    _fcrTargets - Fresh scan records from fza_fcr_fnc_buildScanSnapshot
    _fcrAzBias  - Azimuth bias of this scan, degrees

Returns:
    Correlated target array.

Record format (17 elements):
    [pos, type, moving, obj, aziAngle, elevAngle, range, revealOffset,
     0    1     2       3    4         5          6      7
     memory, revealTime, dispPos, dispAzi, dispRange, dispBright, bright, lastHit, isFalse]
     8       9           10       11       12         13          14      15       16
    memory is a moving target's last scanburst of pass results, newest last, or a
    stationary target's count; fields 10-13 are what was shown before this
    scan's result ([] pos when nothing was).

Author:
    Snow(Dryden), BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrTargets", "_fcrAzBias"];

private _now         = CBA_missionTime;
private _prevTargets = _heli getVariable ["fza_ah64_fcrTargets", []];
private _isAtm       = (_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_ATM;
private _size        = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _scans       = FCR_BURST_SCANS select _size;
private _missStill   = FCR_MISS_STATIONARY select _size;
private _missMoving  = FCR_MISS_MOVING select _size;
private _missFalse   = FCR_MISS_FALSE select _size;
private _brightHits  = FCR_BRIGHT_HITS select _size;

_heli getVariable "fza_ah64_fcrState" params ["", "_fcrScanStartTime"];
private _cycleLen = ([_heli] call fza_fcr_fnc_getScanTiming) # 1;
// ATM sectors are swept on both passes; GTM/RMAP bars split by range and ATM wide rotates, so once per cycle
private _bothPasses = _isAtm && {(_heli getVariable ["fza_ah64_fcrAtmHalfFov", 168]) < 168};

// The next time at or after now that the wiper crosses a target with this reveal offset
private _revealTimeOf = {
    params ["_offset"];
    private _t = _fcrScanStartTime + _offset + _cycleLen * ((ceil ((_now - _fcrScanStartTime - _offset) / _cycleLen)) max 0);
    if (_bothPasses) then {
        private _back = _cycleLen - _offset;
        _t = _t min (_fcrScanStartTime + _back + _cycleLen * ((ceil ((_now - _fcrScanStartTime - _back) / _cycleLen)) max 0));
    };
    _t
};

// A record for this scan: the pass result added to the target's memory, over what it is showing now
private _record = {
    params ["_scan", "_prev", "_hit", ["_isFalse", false]];
    private _memory = 0;
    private _shown  = [];
    if (_prev isNotEqualTo []) then {
        _memory = _prev # 8;
        _shown  = [_prev, _now] call fza_fcr_fnc_targetShown;
    };
    private _hitCount = 0;
    if (_isAtm) then {
        _memory   = [true];
        _hitCount = 1;
    } else {
        if (_scan # 2) then {
            // Moving: the last scanburst of passes; a stationary count carries over as that many detections
            if !(_memory isEqualType []) then {
                _memory = [];
                for "_i" from 1 to ((_prev param [8, 0]) min _scans) do {_memory pushBack true};
            } else {
                _memory = +_memory;
            };
            _memory pushBack _hit;
            _memory   = _memory select [(count _memory - _scans) max 0];
            _hitCount = {_x} count _memory;
        } else {
            // Stationary: a count; a moving target's passes carry over as its detections
            if (_memory isEqualType []) then {_memory = {_x} count _memory};
            _memory   = ((_memory + ([-1, 1] select _hit)) max 0) min FCR_MEMORY_CAP;
            _hitCount = _memory;
        };
    };
    // Never shown and nothing to show: not a target
    if (_hitCount == 0 && {_shown isEqualTo []}) exitWith {[]};
    (_scan select [0, 8]) + [_memory, [_scan # 7] call _revealTimeOf]
        + ([[[], 0, 0, false], _shown] select (_shown isNotEqualTo []))
        + [_isAtm || {_hitCount >= _brightHits}, _hit, _isFalse]
};

// A wreck is still a radar return, where it lies, though the sensor no longer reports it
if (!_isAtm) then {
    {
        private _obj = _x # 3;
        if ((_x # 16) || {isNull _obj || {alive _obj || {(_fcrTargets findIf {(_x # 3) isEqualTo _obj}) != -1}}}) then {continue};
        private _range = _heli distance2D _obj;
        if (_range <= FCR_LIMIT_MIN_RANGE || {_range >= FCR_LIMIT_STATIONARY_RANGE}) then {continue};
        private _pos    = getPosASL _obj;
        private _relAzi = [([_heli getRelDir _obj] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
        _fcrTargets pushBack [
            [round (_pos#0), round (_pos#1), round (_pos#2)], _x # 1, false, _obj,
            [_relAzi, 1] call BIS_fnc_cutDecimals, _x # 5, _range, [_heli, _relAzi, _range] call fza_fcr_fnc_revealOffset
        ];
    } forEach _prevTargets;
};

private _correlated = [];

// Seen by the sensor: this pass detects it or misses it (ATM always detects)
{
    private _obj     = _x # 3;
    private _prevIdx = _prevTargets findIf {(_x # 3) isEqualTo _obj};
    private _prev    = if (_prevIdx == -1) then {[]} else {_prevTargets # _prevIdx};
    private _rec     = [_x, _prev, _isAtm || {random 1 >= ([_missStill, _missMoving] select (_x # 2))}] call _record;
    if (_rec isNotEqualTo []) then {_correlated pushBack _rec};
} forEach _fcrTargets;

if (_isAtm) exitWith {_correlated};

// Not reported by the sensor: a real target is missed, a clutter discrete detected again by chance
{
    private _obj = _x # 3;
    if ((_fcrTargets findIf {(_x # 3) isEqualTo _obj}) != -1) then {continue};
    private _isFalse = _x # 16;
    private _rec = [_x, _x, _isFalse && {random 1 >= _missFalse}, _isFalse] call _record;
    if (_rec isNotEqualTo []) then {_correlated pushBack _rec};
} forEach _prevTargets;

// New false returns: clutter discretes at random in the scanned sector, more the wider it is. Each looks at up to 15
// random points for one, so cluttered ground gives them and open ground hardly any; the radar sees only what the
// terrain does not mask, judged to the top of the object.
private _half     = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
private _expected = FCR_FALSE_PER_CYCLE * _half / 45;
private _count    = -1;
private _p        = 1;
while {_p > exp (-_expected)} do {
    _count = _count + 1;
    _p = _p * random 1;
};
private _heliPos   = getPosASL _heli;
private _sensorPos = _heli modelToWorldWorld (_heli selectionPosition ["sensorPos", "Memory"]);
private _scanDir   = direction _heli + _fcrAzBias;
for "_i" from 1 to _count do {
    private _obj = objNull;
    for "_try" from 1 to 15 do {
        // Uniform over the sector's area
        private _range = sqrt (FCR_LIMIT_MIN_RANGE ^ 2 + random (FCR_LIMIT_STATIONARY_RANGE ^ 2 - FCR_LIMIT_MIN_RANGE ^ 2));
        private _point = _heliPos getPos [_range, _scanDir - _half + random (2 * _half)];
        _obj = (nearestTerrainObjects [_point, ["BUILDING", "HOUSE", "WALL", "ROCK", "ROCKS", "POWER LINES", "TRANSMITTER", "BUNKER", "FORTRESS", "VIEW-TOWER", "LIGHTHOUSE", "FUEL STATION", "CHURCH", "CHAPEL"], 75, true, true]) param [0, objNull];
        if (!isNull _obj) exitWith {};
    };
    if (isNull _obj || {(_correlated findIf {(_x # 3) isEqualTo _obj}) != -1}) then {continue};
    private _pos = getPosASL _obj;
    if (terrainIntersectASL [_sensorPos, _obj modelToWorldWorld [0, 0, ((boundingBoxReal _obj) # 1 # 2) - 0.5]]) then {continue};
    private _objRange = _heli distance2D _obj;
    private _relAzi   = [([_heli getRelDir _obj] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    if (abs _relAzi > _half || {_objRange <= FCR_LIMIT_MIN_RANGE || {_objRange >= FCR_LIMIT_STATIONARY_RANGE}}) then {continue};
    // Each discrete keeps one classification, so its symbol never changes type
    private _type = [FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN,
        FCR_TYPE_WHEELED, FCR_TYPE_WHEELED, FCR_TYPE_TRACKED, FCR_TYPE_TRACKED] select (floor ((_pos # 0) + (_pos # 1)) mod 10);
    private _scan = [
        [round (_pos#0), round (_pos#1), round (_pos#2)], _type, false, _obj,
        [_relAzi, 1] call BIS_fnc_cutDecimals, 0, _objRange, [_heli, _relAzi, _objRange] call fza_fcr_fnc_revealOffset
    ];
    _correlated pushBack ([_scan, [], true, true] call _record);
};

_correlated
