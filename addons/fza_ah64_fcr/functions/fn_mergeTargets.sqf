/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_mergeTargets

Description:
    Scan-to-scan correlation, made as each full scan cycle completes; what it
    shows appears when the wiper next crosses each target (revealTime,
    fza_fcr_fnc_targetShown).

    A scanburst is FCR_BURST_SCANS cycles: a single scan's length, and each
    burst-length stretch of a continuous scan. A real target's scanburst
    result is bright, dim or not shown by its chances, made as the scanburst's
    last cycle starts so each target shows it the moment the wiper crosses it
    on that last sweep
    (FCR_STATIONARY_*, FCR_MOVING_*). A mover shows its latest result; a
    stationary target its best of the last FCR_STATIONARY_MEMORY, so one
    painted continuously builds up and holds. A target shown between scanbursts
    shows where the sensor sees it each cycle, or where it was last seen; a new
    one waits for the scanburst's last sweep. A destroyed target stays a radar
    return within the stationary target range.

    Clutter (false returns): the radar holds up to FCR_CLUTTER_POOL clutter
    discretes in the scanned sector (buildings, walls, rocks, pylons the
    terrain does not mask). Clutter is uncorrelated: each scanburst shows each
    one bright, dim or not at all afresh (FCR_CLUTTER_BRIGHT, FCR_CLUTTER_DIM).
    One that leaves the sector or is masked is replaced.

    ATM is not correlated: every target the scan sees is bright, one it no
    longer sees goes at once, and it has no clutter.

Parameters:
    _heli       - The helicopter
    _fcrTargets - Fresh scan records from fza_fcr_fnc_buildScanSnapshot
    _fcrAzBias  - Azimuth bias of this scan, degrees
    _cycle      - Full cycles completed since the scan started

Returns:
    Correlated target array.

Record format (17 elements):
    [pos, type, moving, obj, aziAngle, elevAngle, range, revealOffset,
     0    1     2       3    4         5          6      7
     results, revealTime, dispPos, dispAzi, dispRange, dispBright, bright, shown, isClutter]
     8        9           10       11       12         13          14      15     16
    results are its scanburst results, newest last: 0 not shown, 1 dim, 2 bright. Fields 10-13 are what was shown
    before this scan ([] pos when nothing was).

Author:
    Snow(Dryden), BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_fcrTargets", "_fcrAzBias", "_cycle"];

private _now         = CBA_missionTime;
private _prevTargets = _heli getVariable ["fza_ah64_fcrTargets", []];
private _isAtm       = (_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_ATM;
private _size        = _heli getVariable ["fza_ah64_fcrScanSize", 0];
// The cycle starting now is a scanburst's last: its result is shown as the wiper crosses each target on it
private _burstEnd    = (_cycle + 1) mod (FCR_BURST_SCANS select _size) == 0;

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

// A scanburst result by its chances: 2 bright, 1 dim, 0 not shown
private _roll = {
    params ["_bright", "_dim"];
    private _r = random 1;
    [[0, 1] select (_r < _bright + _dim), 2] select (_r < _bright)
};

// A record for this scan over what the previous one is showing now
private _record = {
    params ["_scan", "_prev", "_results", "_state", "_isClutter"];
    private _shown = if (_prev isEqualTo []) then {[]} else {[_prev, _now] call fza_fcr_fnc_targetShown};
    (_scan select [0, 8]) + [_results, [_scan # 7] call _revealTimeOf]
        + ([[[], 0, 0, false], _shown] select (_shown isNotEqualTo [])) + [_state == 2, _state > 0, _isClutter]
};

// A real target this cycle: a new scanburst result at the end of one ([] seen = not seen, scored not shown), what it
// shows by its results; [] when it has nothing to show and nothing to wait for
private _correlate = {
    params ["_scan", "_prev", "_seen"];
    if (_isAtm) exitWith {[_scan, _prev, [2], 2, false] call _record};
    private _results = +(_prev param [8, []]);
    if (_burstEnd) then {
        _results pushBack ([0, [
            [FCR_STATIONARY_BRIGHT select _size, FCR_STATIONARY_DIM select _size],
            [FCR_MOVING_BRIGHT select _size, FCR_MOVING_DIM select _size]
        ] select (_scan # 2) call _roll] select _seen);
        _results = _results select [(count _results - FCR_STATIONARY_MEMORY) max 0];
    };
    private _state = 0;
    if (_results isNotEqualTo []) then {
        _state = [selectMax _results, _results select -1] select (_scan # 2);
    };
    // Unseen with no result to show, or seen and still waiting on its first scanburst
    if (_state == 0 && {!_seen || {_results isNotEqualTo []}}
        && {_prev isEqualTo [] || {([_prev, _now] call fza_fcr_fnc_targetShown) isEqualTo []}}) exitWith {[]};
    [_scan, _prev, _results, _state, false] call _record
};

// A target's scan record from where it is now
private _scanOf = {
    params ["_obj", "_type", "_moving", "_elev"];
    private _pos    = getPosASL _obj;
    private _range  = _heli distance2D _obj;
    private _relAzi = [([_heli getRelDir _obj] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    [[round (_pos#0), round (_pos#1), round (_pos#2)], _type, _moving, _obj,
        [_relAzi, 1] call BIS_fnc_cutDecimals, _elev, _range, [_heli, _relAzi, _range] call fza_fcr_fnc_revealOffset]
};

// Targets matched by object through hashmaps built once, not by searching the file for each target
private _prevByObj = createHashMap;
{
    if !(_x # 16) then {_prevByObj set [hashValue (_x # 3), _x]};
} forEach _prevTargets;
private _seenObjs = createHashMapFromArray (_fcrTargets apply {[hashValue (_x # 3), true]});

// A wreck is still a radar return, where it lies, though the sensor no longer reports it
if (!_isAtm) then {
    {
        private _obj = _x # 3;
        if ((_x # 16) || {isNull _obj || {alive _obj || {hashValue _obj in _seenObjs}}}) then {continue};
        private _range = _heli distance2D _obj;
        if (_range <= FCR_LIMIT_MIN_RANGE || {_range >= FCR_LIMIT_STATIONARY_RANGE}) then {continue};
        _fcrTargets pushBack ([_obj, _x # 1, false, _x # 5] call _scanOf);
        _seenObjs set [hashValue _obj, true];
    } forEach _prevTargets;
};

private _correlated = [];

// Seen by the sensor
{
    private _prev = _prevByObj getOrDefault [hashValue (_x # 3), []];
    private _rec  = [_x, _prev, true] call _correlate;
    if (_rec isNotEqualTo []) then {_correlated pushBack _rec};
} forEach _fcrTargets;

if (_isAtm) exitWith {_correlated};

// Not reported by the sensor: held where it was last seen, scored not shown at the end of each scanburst
{
    if ((_x # 16) || {hashValue (_x # 3) in _seenObjs}) then {continue};
    private _rec = [_x, _x, false] call _correlate;
    if (_rec isNotEqualTo []) then {_correlated pushBack _rec};
} forEach _prevTargets;

// Clutter: the pool is held while in the sector and unmasked, topped up from clutter discretes at random in the sector
// (each looks at up to 15 random points, so cluttered ground fills it and open ground hardly), and shown afresh each
// scanburst. Masking is judged to the top of the object.
private _half      = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
private _heliPos   = getPosASL _heli;
private _sensorPos = _heli modelToWorldWorld (_heli selectionPosition ["sensorPos", "Memory"]);
private _scanDir   = direction _heli + _fcrAzBias;
private _visible = {
    params ["_obj"];
    private _range  = _heli distance2D _obj;
    private _relAzi = [([_heli getRelDir _obj] call CBA_fnc_simplifyAngle180) - _fcrAzBias] call CBA_fnc_simplifyAngle180;
    abs _relAzi <= _half && {_range > FCR_LIMIT_MIN_RANGE && {_range < FCR_LIMIT_STATIONARY_RANGE
        && {!terrainIntersectASL [_sensorPos, _obj modelToWorldWorld [0, 0, ((boundingBoxReal _obj) # 1 # 2) - 0.5]]}}}
};
private _clutter = [];
{
    if ((_x # 16) && {[_x # 3] call _visible}) then {_clutter pushBack _x};
} forEach _prevTargets;
for "_i" from (count _clutter + 1) to FCR_CLUTTER_POOL do {
    private _obj = objNull;
    for "_try" from 1 to 15 do {
        // Uniform over the sector's area
        private _range = sqrt (FCR_LIMIT_MIN_RANGE ^ 2 + random (FCR_LIMIT_STATIONARY_RANGE ^ 2 - FCR_LIMIT_MIN_RANGE ^ 2));
        private _point = _heliPos getPos [_range, _scanDir - _half + random (2 * _half)];
        _obj = (nearestTerrainObjects [_point, ["BUILDING", "HOUSE", "WALL", "ROCK", "ROCKS", "POWER LINES", "TRANSMITTER", "BUNKER", "FORTRESS", "VIEW-TOWER", "LIGHTHOUSE", "FUEL STATION", "CHURCH", "CHAPEL"], 75, true, true]) param [0, objNull];
        if (!isNull _obj) exitWith {};
    };
    if (isNull _obj || {(_clutter findIf {(_x # 3) isEqualTo _obj}) != -1 || {!([_obj] call _visible)}}) then {continue};
    // Each discrete keeps one classification, so its symbol never changes type
    private _pos = getPosASL _obj;
    private _type = [FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN, FCR_TYPE_UNKNOWN,
        FCR_TYPE_WHEELED, FCR_TYPE_WHEELED, FCR_TYPE_TRACKED, FCR_TYPE_TRACKED] select (floor ((_pos # 0) + (_pos # 1)) mod 10);
    _clutter pushBack [[], _type, false, _obj, 0, 0, 0, 0, [], 0, [], 0, 0, false, false, false, true];
};
{
    private _prev  = if ((_x # 0) isEqualTo []) then {[]} else {_x};
    private _state = [[0, 1] select (_x # 15), 2] select (_x # 14);
    if (_burstEnd) then {_state = [FCR_CLUTTER_BRIGHT select _size, FCR_CLUTTER_DIM select _size] call _roll};
    _correlated pushBack ([[_x # 3, _x # 1, false, 0] call _scanOf, _prev, [], _state, true] call _record);
} forEach _clutter;

_correlated
