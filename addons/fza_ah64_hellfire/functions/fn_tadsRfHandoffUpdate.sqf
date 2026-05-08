/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tadsRfHandoffUpdate
Description:
    Builds and caches a frozen TADS->RF handoff package after a per-handoff
    random delay (2.5 to 5.0 seconds) of continuous laser designation.
    Package resets when the laser is lost/off.
Parameters:
    _heli - The helicopter
Returns:
    Nothing
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _selectedMissile = _heli getVariable ["fza_ah64_selectedMissile", ""];
private _laserObj = laserTarget _heli;

private _resetData = {
    params ["_heliObj"];
    [_heliObj, "fza_ah64_tadsRfHandoffStart",     -1]      call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffLast",      []]      call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffData",      []]      call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffLoblTarget", objNull] call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffDelay",     -1]      call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffLastScanTime", -1]   call fza_fnc_updateNetworkGlobal;
    _heliObj setVariable ["fza_ah64_tadsRfHandoffLastCmCheckTime", -1];
    _heliObj setVariable ["fza_ah64_tadsRfHandoffLastDecoyTime", -1];
};

if (isNull _laserObj) exitWith {
    [_heli] call _resetData;
};

if (_selectedMissile != "fza_agm114l_wep" || _sight != SIGHT_TADS) exitWith {};

private _start = _heli getVariable ["fza_ah64_tadsRfHandoffStart", -1];
private _handoffDelay = _heli getVariable ["fza_ah64_tadsRfHandoffDelay", -1];
private _lastSample = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];
private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
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
    private _lastCmCheckTime = _heli getVariable ["fza_ah64_tadsRfHandoffLastCmCheckTime", -1];
    private _lastDecoyTime = _heli getVariable ["fza_ah64_tadsRfHandoffLastDecoyTime", -1];

    private _chaffCoef = missionNamespace getVariable ["ace_missileguidance_chaffEffectivenessCoef", 1.0];
    if (!isNull _currentLobl && {alive _currentLobl} && {
        ([_heli, [getPosASL _currentLobl, speed _currentLobl, _currentLobl], true, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1
    } && {
        if ((CBA_missionTime - _lastCmCheckTime) < RF_CM_CHECK_INTERVAL_HANDOFF) exitWith { true };

        _heli setVariable ["fza_ah64_tadsRfHandoffLastCmCheckTime", CBA_missionTime];
        private _chaffNearby = _currentLobl nearObjects 50;
        _chaffNearby = _chaffNearby select {
            // 8 = radar blocking (bit 3)
            (([getNumber (configOf _x >> "weaponLockSystem"), 4] call ace_common_fnc_binarizeNumber) select 3)
            && { [_heli, getPosASLVisual _x, _seekerAngle] call fza_hellfire_fnc_isTargetInSeekerCone }
            && { [_heli, _x, false] call ace_missileguidance_fnc_checkLos }
        };
        private _perChaffChance = (RF_CM_PER_CHAFF_CHANCE * _chaffCoef) max 0 min 0.95;
        private _chaffCount = count _chaffNearby;
        private _combinedChance = 1 - ((1 - _perChaffChance) ^ _chaffCount);
        private _chaffDefeated = _chaffCount > 0 && { random 1 < _combinedChance };
        if (_chaffDefeated) then {
            _heli setVariable ["fza_ah64_tadsRfHandoffLastDecoyTime", CBA_missionTime];
        };
        !_chaffDefeated
    }) exitWith {};

    if (!isNull _currentLobl) then {
        [_heli, "fza_ah64_tadsRfHandoffLoblTarget", objNull] call fza_fnc_updateNetworkGlobal;
    };

    if ((CBA_missionTime - _lastDecoyTime) < RF_REACQUIRE_DELAY) exitWith {};

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
        if (!isNull _loblTarget) exitWith {};
        private _radarSig  = getNumber (configOf _x >> "radarTargetSize");
        if (_radarSig <= 0) then { _radarSig = 1.0 };
        private _normRange = ((_x distance (ASLToAGL _scanPos)) / FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) min 1;
        private _detectionProb = _radarSig ^ (1 + _normRange);
        if ((random 1 <= _detectionProb) && {
            ([_heli, [getPosASL _x, speed _x, _x], true, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1
        }) then {
            _loblTarget = _x;
        };
    } forEach _candidates;
    [_heli, "fza_ah64_tadsRfHandoffLoblTarget", _loblTarget] call fza_fnc_updateNetworkGlobal;
} else {
    [_heli, "fza_ah64_tadsRfHandoffLoblTarget", objNull] call fza_fnc_updateNetworkGlobal;
};
