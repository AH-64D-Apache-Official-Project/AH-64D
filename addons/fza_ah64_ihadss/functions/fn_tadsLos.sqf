/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsLos

Description:
    The TADS's position and line of sight in model space. The line of sight is
    the one sent by the machine turning the TADS (fza_ihadss_fnc_tadsLosSend),
    eased across the time between sends: the turret itself reaches the other
    machines only approximately. On the machine turning it, and before one has
    been sent, it is taken from the TADS's memory points as the turret has them
    here. Worked out once a frame.

    The TADS is turned by the crewmember with it as their NVS sensor, else the
    CPG, else the pilot with no player CPG.

Parameters:
    _heli - The helicopter

Returns:
    [position, unit direction, true on the machine turning the TADS], model space

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_pos", "_dir"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

(_heli getVariable ["fza_ihadss_tadsLosFrame", []]) params [["_frame", -1], ["_result", []]];
if (_frame == diag_frameNo) exitWith {_result};

private _pos = _heli selectionPosition "laserEnd";

([_heli] call fza_ihadss_fnc_tadsNvs) params ["_nvsMode", "", "_nvsUnit"];
private _driving = if (_nvsMode != NVS_MODE_OFF) then {_nvsUnit == player} else {
    player == gunner _heli || {!isPlayer gunner _heli && {player == driver _heli || {!isPlayer driver _heli}}}
};
// [x, y, z, azimuth, elevation]
private _packet = _heli getVariable ["fza_ah64_tadsLos", []];

_result = if (_driving || {!(_packet isEqualTypeArray [0, 0, 0, 0, 0])}) then {
    private _dir = vectorNormalized ((_heli selectionPosition "laserBegin") vectorDiff _pos);
    // laserBegin is the TADS turret's gunBeg, ahead of laserEnd; checked against the TADS angles all the same, and taken
    // from them with the points missing
    private _approx = [1, _heli getVariable ["fza_ah64_tadsAzimuth", 0], _heli getVariable ["fza_ah64_tadsElevation", 0]] call CBA_fnc_polar2vect;
    if (_dir vectorDotProduct _approx < 0) then {_dir = _dir vectorMultiply -1};
    if (_dir isEqualTo [0, 0, 0]) then {_dir = _approx};
    [_pos, _dir, _driving]
} else {
    // From where it was to the latest sent over one send period; after a gap, straight onto it
    private _sent = _packet select [0, 3];
    (_heli getVariable ["fza_ihadss_tadsLosEase", []]) params [["_easeFrame", -1], ["_from", _sent], ["_to", _sent], ["_since", 0], ["_out", _sent]];
    if (_easeFrame < diag_frameNo - 1) then {
        _out = _sent;
        _to  = _sent;
    };
    if (_to isNotEqualTo _sent) then {
        _from  = _out;
        _to    = _sent;
        _since = diag_tickTime;
    };
    private _k = (diag_tickTime - _since) / TADS_LOS_SEND_PERIOD;
    _out = if (_k >= 1) then {_to} else {vectorNormalized ((_from vectorMultiply (1 - _k)) vectorAdd (_to vectorMultiply _k))};
    if (_out isEqualTo [0, 0, 0]) then {_out = _to};
    _heli setVariable ["fza_ihadss_tadsLosEase", [diag_frameNo, _from, _to, _since, _out]];
    [_pos, _out, false]
};

_heli setVariable ["fza_ihadss_tadsLosFrame", [diag_frameNo, _result]];
_result
