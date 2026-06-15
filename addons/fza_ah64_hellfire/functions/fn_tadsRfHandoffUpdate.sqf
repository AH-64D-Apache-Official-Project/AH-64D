/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tadsRfHandoffUpdate
Description:
    Builds and caches a frozen TADS->RF handoff package after a per-handoff
    random delay (2.5 to 5.0 seconds) of continuous laser designation. The
    package persists across the laser going on/off and is only dumped on a
    weapon reselect, leaving TADS, or firing (see fza_hellfire_fnc_arhOnFired).
Parameters:
    _heli - The helicopter
Returns:
    Nothing
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

#define TADS_RF_HANDOFF_SAMPLE_INTERVAL  0.5

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _selectedMissile = _heli getVariable ["fza_ah64_selectedMissile", ""];
private _was = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];
private _laserObj = laserTarget _heli;

// Cached handoff package is sticky across laser on/off (gunners routinely
// release the laser right as they fire). Only dump it once AGM114L+TADS is
// no longer selected (covers weapon reselect and leaving TADS); firing
// resets it via fza_hellfire_fnc_arhOnFired.
if (_selectedMissile != "fza_agm114l_wep" /*|| _sight != SIGHT_TADS*/ || _was != WAS_WEAPON_MSL) exitWith {
    [_heli] call fza_hellfire_fnc_tadsRfHandoffReset;
};

private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];

// With no laser and no frozen package yet, there's nothing to sample or scan from.
if (isNull _laserObj && {_handoffData isEqualTo []}) exitWith {};

private _start = _heli getVariable ["fza_ah64_tadsRfHandoffStart", -1];
private _handoffDelay = _heli getVariable ["fza_ah64_tadsRfHandoffDelay", -1];
private _lastSample = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];

// Sampling/freezing only makes sense while actively lasing; a frozen package
// keeps the LOBL validation/scan below running even after the laser is off.
if (!isNull _laserObj) then {
    private _pos = getPosASL _laserObj;

    if (_start < 0) then {
        _handoffDelay = 2.5 + random 2.5;
        [_heli, "fza_ah64_tadsRfHandoffStart", CBA_missionTime] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_tadsRfHandoffLast", [_pos, 1]] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_tadsRfHandoffData", []] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_tadsRfHandoffDelay", _handoffDelay] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_tadsRfHandoffLastScanTime", CBA_missionTime] call fza_fnc_updateNetworkGlobal;
        _start = CBA_missionTime;
        _lastSample = [_pos, 1];
        _handoffData = [];
    };

    if (_handoffDelay < 0) then {
        // Backward-compat fallback for existing vehicles that lack this runtime var.
        _handoffDelay = 2.5 + random 2.5;
        [_heli, "fza_ah64_tadsRfHandoffDelay", _handoffDelay] call fza_fnc_updateNetworkGlobal;
    };

    if (_handoffData isEqualTo []) then {
        private _lastSampleTime = _heli getVariable ["fza_ah64_tadsRfHandoffLastSampleTime", -1];

        // Throttle the position average/broadcast instead of running it every frame.
        if ((CBA_missionTime - _lastSampleTime) >= TADS_RF_HANDOFF_SAMPLE_INTERVAL) then {
            _heli setVariable ["fza_ah64_tadsRfHandoffLastSampleTime", CBA_missionTime];

            private _avgPos = _pos;
            private _samples = 1;
            private _maxSamples = 6;

            if (_lastSample isEqualType [] && {count _lastSample == 2}) then {
                _lastSample params ["_lastAvgPos", "_lastSamples"];
                _samples = ((_lastSamples max 1) + 1) min _maxSamples;
                private _wNew = 1 / _samples;
                private _wOld = 1 - _wNew;
                _avgPos = (_lastAvgPos vectorMultiply _wOld) vectorAdd (_pos vectorMultiply _wNew);
            };

            [_heli, "fza_ah64_tadsRfHandoffLast", [_avgPos, _samples]] call fza_fnc_updateNetworkGlobal;

            if ((CBA_missionTime - _start) >= _handoffDelay) then {
                // Freeze handoff package after the randomized handoff delay.
                [_heli, "fza_ah64_tadsRfHandoffData", [_avgPos, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
            };
        };
    };
};

private _scanPos = [0, 0, 0];
private _currentHandoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
private _currentLastSample  = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];
if (_currentHandoffData isEqualType [] && {count _currentHandoffData >= 1}) then {
    _scanPos = _currentHandoffData # 0;
} else {
    if (_currentLastSample isEqualType [] && {count _currentLastSample >= 1}) then {
        _scanPos = _currentLastSample # 0;
    };
};

if (_scanPos isNotEqualTo [0, 0, 0]) then {
    private _seekerAngle  = getNumber (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "seekerAngle");
    private _currentLobl  = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];

    // Validate existing lock first — keep it if the object is still alive and in cone.
    if (!isNull _currentLobl && {alive _currentLobl} && {
        ([_heli, [getPosASL _currentLobl, speed _currentLobl, _currentLobl], true, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1
    }) exitWith {};

    if (!isNull _currentLobl) then {
        [_heli, "fza_ah64_tadsRfHandoffLoblTarget", objNull] call fza_fnc_updateNetworkGlobal;
    };

    if ((CBA_missionTime - _start) < _handoffDelay) exitWith {};

    // Throttle acquisition scan to at most once every 2 seconds.
    private _lastScanTime = _heli getVariable ["fza_ah64_tadsRfHandoffLastScanTime", -1];
    if ((CBA_missionTime - _lastScanTime) < 2) exitWith {};
    [_heli, "fza_ah64_tadsRfHandoffLastScanTime", CBA_missionTime] call fza_fnc_updateNetworkGlobal;

    // Lock lost or not yet acquired — scan for a new candidate.
    private _scanTypes  = getArray (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "fza_arhLockTypes");
    private _candidates = nearestObjects [ASLToAGL _scanPos, _scanTypes, TADS_RF_LOBL_SCAN_RADIUS];
    private _loblTarget = objNull;
    {
        if (([_heli, [getPosASL _x, speed _x, _x], true, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1) exitWith {
            _loblTarget = _x;
        };
    } forEach _candidates;
    [_heli, "fza_ah64_tadsRfHandoffLoblTarget", _loblTarget] call fza_fnc_updateNetworkGlobal;
} else {
    [_heli, "fza_ah64_tadsRfHandoffLoblTarget", objNull] call fza_fnc_updateNetworkGlobal;
};
