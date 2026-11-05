/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatUpdate

Description:
    The image auto tracker, each frame on the CPG's machine. Tracking, it
    drives the TADS onto its target, or in offset tracking onto a point the
    manual tracker moves about it, kept so the target stays in the field of
    view. A target it cannot hold (fza_ihadss_fnc_iatCheck) is followed
    where it was heading while the gates flash; not reacquired in time, it
    goes to stop mode and leaves the TADS to the CPG, with LMC on carrying
    on at the rate it was turning. Dropped without power, with the TADS not
    the sight or an NVS sensor, or with the LST taking the TADS.

Parameters:
    _heli       - The helicopter
    _lstDriving - True when the LST drives the TADS

Returns:
    ASL position the TADS is driven to, [] when the IAT is not driving it

Examples:
    --- Code
    private _iatTarget = [_heli, false] call fza_ihadss_fnc_iatUpdate;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", ["_lstDriving", false]];

private _iat = +(_heli getVariable ["fza_ah64_iat", IAT_IDLE]);
_iat params ["_state", "_offset", "_obj", "_trackPoint", "_coastPos", "_vel", "_seenAt", "_half", "_startedAt"];
if (_state == IAT_OFF || {player != gunner _heli}) exitWith {
    _heli setVariable ["fza_ihadss_iatDriving", false];
    []
};

if (!(_heli getVariable ["bmkhs_acBusOn", false]) || {_lstDriving}
    || {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_TADS}
    || {(([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF}) exitWith {
    [_heli] call fza_ihadss_fnc_iatDisengage;
    []
};

private _now    = CBA_missionTime;
private _vision = [_heli] call fza_ihadss_fnc_getVisionMode;
private _sensor = ["hit_msnEquip_tads_flir", "hit_msnEquip_tads_dtv"] select (_vision == 0);
if (_state != IAT_FAIL && {_heli getHitPointDamage "hit_msnEquip_tads_turret" >= SYS_SIGHT_DMG_THRESH || {_heli getHitPointDamage _sensor >= SYS_SIGHT_DMG_THRESH}}) then {
    _state = IAT_FAIL;
    [_heli, "fza_ah64_iat", [IAT_FAIL, false, objNull, [], [], [0, 0, 0], -1, [0, 0], _now, []]] call fza_fnc_updateNetworkGlobal;
};
if (_state in [IAT_STOP, IAT_FAIL, IAT_SIZING]) exitWith {
    _heli setVariable ["fza_ihadss_iatDriving", false];
    []
};

// [offset az, offset el, last checked, last update, last seen, where, its velocity, commanded az, el, their rates]
private _local = _heli getVariable ["fza_ihadss_iatLocal", [0, 0, -1, -1, _seenAt, [], [0, 0, 0], 0, 0, 0, 0]];
_local params ["_offAz", "_offEl", "_checkedAt", "_updatedAt", "_lastSeen", "_lastPos", "_lastVel", "_cmdAz", "_cmdEl", "_rateAz", "_rateEl"];
private _dt = if (_updatedAt < 0) then {0} else {((_now - _updatedAt) max 0) min 0.1};

private _pos = [_heli] call fza_ihadss_fnc_iatTargetPos;
if (_pos isEqualTo [] || {_now - _checkedAt >= IAT_CHECK_EVERY}) then {
    _checkedAt = _now;
    private _livePos = if (isNull _obj) then {[]} else {
        if (_trackPoint isNotEqualTo []) then {_trackPoint} else {(getPosASLVisual _obj) vectorAdd ((aimPos _obj) vectorDiff (getPosASL _obj))};
    };
    if ([_heli, _obj, _livePos, _half, _vision] call fza_ihadss_fnc_iatCheck) then {
        _lastPos = _livePos;
        _lastVel = [velocity _obj, [0, 0, 0]] select (_trackPoint isNotEqualTo []);
        _lastSeen = _now;
        if (_state == IAT_COAST) then {
            _state = IAT_TRACK;
            [_heli, "fza_ah64_iat", [IAT_TRACK, _offset, _obj, _trackPoint, [], [0, 0, 0], _now, _half, _startedAt, []]] call fza_fnc_updateNetworkGlobal;
        };
    } else {
        if (_state == IAT_TRACK) then {
            if (_lastPos isEqualTo []) then {_lastPos = _pos};
            _state = IAT_COAST;
            [_heli, "fza_ah64_iat", [IAT_COAST, _offset, _obj, _trackPoint, _lastPos, _lastVel, _lastSeen, _half, _startedAt, []]] call fza_fnc_updateNetworkGlobal;
        } else {
            if (_now - _lastSeen > IAT_REACQUIRE || {_lastPos isEqualTo []}) then {_state = IAT_STOP};
        };
    };
    _pos = [_heli] call fza_ihadss_fnc_iatTargetPos;
};

private _tadsPos = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
private _fov     = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);

if (_state == IAT_STOP || {_pos isEqualTo []}) exitWith {
    // The stop mode gates keep the size they had, as fractions of the field of view's half width
    private _stopGate = [IAT_GATE_MAX, IAT_GATE_MAX];
    if (_lastPos isNotEqualTo []) then {
        private _dist = (_lastPos vectorDistance _tadsPos) max 1;
        _stopGate = _half apply {((_x / _dist / _fov) max IAT_MIN_SIZE) min IAT_GATE_MAX};
    };
    [_heli, "fza_ah64_iat", [IAT_STOP, false, objNull, [], [], [0, 0, 0], -1, _half, _startedAt, _stopGate]] call fza_fnc_updateNetworkGlobal;
    _heli setVariable ["fza_ihadss_iatLocal", nil];
    _heli setVariable ["fza_ihadss_iatDriving", false];
    // LMC carries on at the rate the TADS was turning (fza_ihadss_fnc_linearMotionCompensator)
    if (_heli getVariable ["fza_ah64_LmcActive", false]) then {
        private _range = (([_heli, player] call fza_fnc_targetingRange) # 0) max 500;
        private _frame = diag_deltaTime max 0.005;
        _heli setVariable ["fza_ah64_lmcPosition", _tadsPos vectorAdd (_heli vectorModelToWorldVisual ([_range, _cmdAz, _cmdEl] call CBA_fnc_polar2vect))];
        _heli setVariable ["fza_ah64_lmcPrevInputs", [rad _rateAz * _frame * _range, rad _rateEl * _frame * _range]];
        _heli setVariable ["fza_ah64_lmcStartRange", -1];
    };
    []
};

// The turret trails a moving point, so it is commanded ahead of the target by the target's motion relative to the
// aircraft over the lead time (fza_ihadss_iatLead overrides it to tune)
private _targetVel = if (_state == IAT_COAST) then {_vel} else {
    if (isNull _obj || {_trackPoint isNotEqualTo []}) then {[0, 0, 0]} else {velocity _obj}
};
_pos = _pos vectorAdd ((_targetVel vectorDiff velocity _heli) vectorMultiply (missionNamespace getVariable ["fza_ihadss_iatLead", IAT_LEAD]));
private _rel = _heli vectorWorldToModelVisual (_pos vectorDiff _tadsPos);
_rel params ["_rx", "_ry", "_rz"];
private _az = _rx atan2 _ry;
private _el = _rz atan2 (sqrt (_rx * _rx + _ry * _ry));

// Offset tracking moves the offset about the target with the aim input, the TADS staying with the track: heads down as
// far as the game's own control would slew it (fza_ihadss_fnc_tadsNativeGain), otherwise as the TADS slews
// (fza_ihadss_fnc_tadsSlew). Both in deg per frame for input times the field of view.
if (_offset) then {
    private _noAim = call fza_ihadss_fnc_aimInputBlocked;
    private _uAz = inputAction "AimRight" - inputAction "AimLeft";
    private _uEl = inputAction "AimUp" - inputAction "AimDown";
    if (!_noAim && {abs _uAz >= 0.01 || {abs _uEl >= 0.01}}) then {
        private _k = 60 * _dt / (fza_ah64_tadsFOVs # 0);
        if (cameraView == "GUNNER") then {
            (missionNamespace getVariable ["fza_ihadss_tadsNativeGain", [0, 0, 0]]) params ["_sxy", "_sxx", "_n"];
            if (_n >= 30 && {_sxx > 0} && {_sxy > 0}) then {_k = _sxy / _sxx};
        };
        _offAz = _offAz + _uAz * _k * _fov;
        _offEl = _offEl + _uEl * _k * _fov;
    };
    // Held to the target staying in the field of view
    private _maxAz = 0.9 * atan _fov;
    private _maxEl = 0.9 * atan (0.75 * _fov);
    _offAz = (_offAz max -_maxAz) min _maxAz;
    _offEl = (_offEl max -_maxEl) min _maxEl;
} else {
    // Back onto the target at the manual tracker's full rate (fza_ihadss_fnc_tadsSlew), not in one step
    private _step = 60 * _fov / (fza_ah64_tadsFOVs # 0) * _dt;
    private _left = sqrt (_offAz * _offAz + _offEl * _offEl);
    if (_left <= _step) then {
        _offAz = 0;
        _offEl = 0;
    } else {
        _offAz = _offAz * (1 - _step / _left);
        _offEl = _offEl * (1 - _step / _left);
    };
};

private _newAz = _az + _offAz;
private _newEl = _el + _offEl;
if (_dt > 0) then {
    _rateAz = _rateAz + (((_newAz - _cmdAz) / _dt) - _rateAz) * ((_dt / 0.25) min 1);
    _rateEl = _rateEl + (((_newEl - _cmdEl) / _dt) - _rateEl) * ((_dt / 0.25) min 1);
};

_heli setVariable ["fza_ihadss_iatLocal", [_offAz, _offEl, _checkedAt, _now, _lastSeen, _lastPos, _lastVel, _newAz, _newEl, _rateAz, _rateEl]];
_heli setVariable ["fza_ihadss_iatDriving", true];
_tadsPos vectorAdd (_heli vectorModelToWorldVisual ([vectorMagnitude _rel, _newAz, _newEl] call CBA_fnc_polar2vect))
