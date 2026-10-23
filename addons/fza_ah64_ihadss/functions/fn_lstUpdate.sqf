/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_lstUpdate

Description:
    The laser spot tracker, each frame on the CPG's machine. Armed (LST mode
    AUTO or MAN) it searches about the TADS line of sight for a laser spot of
    the LST code designated by anyone but this aircraft, and tracks the TADS
    on one it finds. Without a spot, AUTO scans the TADS off the nose, 30 deg
    either side, in four bars 10 deg apart from 5 deg up: from the top right,
    along each bar at a steady rate, waiting at each corner until the TADS
    is there. MAN leaves the TADS to the CPG.
    Publishes the tracker status for the HAD.

Parameters:
    _heli - The helicopter

Returns:
    ASL position the TADS is driven to, [] when the LST is not driving it

Examples:
    --- Code
    private _lstTarget = [_heli] call fza_ihadss_fnc_lstUpdate;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"

// Search cone half angles (deg), range (m), search and track rates (s), a spot lost after (s)
#define LST_SEARCH_FOV   5
#define LST_TRACK_FOV    2
#define LST_RANGE        8000
#define LST_SEARCH_EVERY 0.1
#define LST_TRACK_EVERY  0.05
#define LST_LOST_AFTER   1
// The automatic scan off the nose: bar half width (deg), bar elevations top to bottom (deg), slew rate (deg/s), and how
// close the TADS has to be to a corner before it goes on (deg)
#define LST_SCAN_WIDTH   30
#define LST_SCAN_BARS    [5, -5, -15, -25]
#define LST_SCAN_RATE    60
#define LST_SCAN_REACHED 1

params ["_heli"];

private _mode = _heli getVariable ["fza_ah64_lstMode", LST_MODE_OFF];
// [spot ASL or [], last seen, last searched, last update, scan [corner index, commanded az, commanded el] or []]
private _state = _heli getVariable ["fza_ihadss_lst", [[], -1, -1, -1, []]];
_state params ["_spot", "_seenAt", "_searchedAt", "_updatedAt", "_scan"];
private _dt = ((CBA_missionTime - _updatedAt) max 0) min 0.1;

private _off = _mode == LST_MODE_OFF || {player != gunner _heli} || {!(_heli getVariable ["bmkhs_acBusOn", false])}
    || {(([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF};
if (_off || {_heli getHitPointDamage "hit_msnEquip_tads_turret" >= SYS_SIGHT_DMG_THRESH}
    || {_heli getHitPointDamage "hit_msnEquip_tads_dtv" >= SYS_SIGHT_DMG_THRESH}) exitWith {
    _heli setVariable ["fza_ihadss_lst", [[], -1, -1, -1, []]];
    _heli setVariable ["fza_ihadss_lstDriving", false];
    [_heli, "fza_ah64_lstStatus", ["LST FAIL", ""] select _off] call fza_fnc_updateNetworkGlobal;
    []
};

// A code without a laser code behind it (LSTCODE?) finds nothing
private _code = (_heli getVariable ["fza_ah64_laserChannelIndex", createHashMap]) getOrDefault [_heli getVariable ["fza_ah64_laserLSTCode", ""], ""];
private _tracking = _spot isNotEqualTo [] && {CBA_missionTime - _seenAt < LST_LOST_AFTER};
if (_code isEqualType 0 && {CBA_missionTime - _searchedAt >= ([LST_SEARCH_EVERY, LST_TRACK_EVERY] select _tracking)}) then {
    _searchedAt = CBA_missionTime;
    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
    private _found = ([
        _heli modelToWorldVisualWorld _losPos, _heli vectorModelToWorldVisual _losDir,
        [LST_SEARCH_FOV, LST_TRACK_FOV] select _tracking, LST_RANGE,
        [ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH], _code, _heli, objNull, [_heli]
    ] call ace_laser_fnc_seekerFindLaserSpot) # 0;
    if (!isNil "_found") then {
        _spot = _found;
        _seenAt = CBA_missionTime;
    };
};
_tracking = _spot isNotEqualTo [] && {CBA_missionTime - _seenAt < LST_LOST_AFTER};

private _target = [];
private _status = "LST SEARCH";
if (_tracking) then {
    _target = _spot;
    _status = "LST TRACK";
    _scan   = [];
} else {
    _spot = [];
    if (_mode == LST_MODE_AUTO) then {
        _status = "LST AUTO SEARCH";
        // The corners in order: along the top bar from the right, down, back along the next, and up to the start again
        private _corners = [];
        {
            private _side = [1, -1] select (_forEachIndex mod 2 == 1);
            _corners pushBack [_side * LST_SCAN_WIDTH, _x];
            _corners pushBack [-_side * LST_SCAN_WIDTH, _x];
        } forEach LST_SCAN_BARS;
        private _tadsAz = _heli getVariable ["fza_ah64_tadsAzimuth", 0];
        private _tadsEl = _heli getVariable ["fza_ah64_tadsElevation", 0];
        // Started from where the TADS is, slewing to the first corner
        if (_scan isEqualTo []) then {_scan = [0, _tadsAz, _tadsEl]};
        _scan params ["_corner", "_cmdAz", "_cmdEl"];
        (_corners # _corner) params ["_toAz", "_toEl"];
        // The commanded line of sight moves straight to the corner at the slew rate
        private _dAz  = _toAz - _cmdAz;
        private _dEl  = _toEl - _cmdEl;
        private _left = sqrt (_dAz * _dAz + _dEl * _dEl);
        private _step = LST_SCAN_RATE * _dt;
        if (_left <= _step) then {
            _cmdAz = _toAz;
            _cmdEl = _toEl;
            // On to the next corner once the TADS itself is there
            if (abs (_tadsAz - _toAz) <= LST_SCAN_REACHED && {abs (_tadsEl - _toEl) <= LST_SCAN_REACHED}) then {
                _corner = (_corner + 1) mod (count _corners);
            };
        } else {
            _cmdAz = _cmdAz + _dAz * _step / _left;
            _cmdEl = _cmdEl + _dEl * _step / _left;
        };
        _scan = [_corner, _cmdAz, _cmdEl];
        _target = (_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd"))
            vectorAdd (_heli vectorModelToWorldVisual ([5000, _cmdAz, _cmdEl] call CBA_fnc_polar2vect));
    } else {
        _scan = [];
    };
};

_heli setVariable ["fza_ihadss_lst", [_spot, _seenAt, _searchedAt, CBA_missionTime, _scan]];
_heli setVariable ["fza_ihadss_lstDriving", _target isNotEqualTo []];
[_heli, "fza_ah64_lstStatus", _status] call fza_fnc_updateNetworkGlobal;
_target
