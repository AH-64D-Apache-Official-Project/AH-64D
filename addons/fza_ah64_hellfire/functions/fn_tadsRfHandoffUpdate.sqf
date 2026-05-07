/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tadsRfHandoffUpdate
Description:
    Builds and caches a frozen TADS->RF handoff package after 3 seconds of
    continuous laser designation. Package resets when the laser is lost/off.
Parameters:
    _heli - The helicopter
Returns:
    Nothing
Author:
    GitHub Copilot
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _selectedMissile = _heli getVariable ["fza_ah64_selectedMissile", ""];
private _laserObj = laserTarget _heli;

private _resetData = {
    params ["_heliObj"];
    [_heliObj, "fza_ah64_tadsRfHandoffStart", -1] call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffLast", []] call fza_fnc_updateNetworkGlobal;
    [_heliObj, "fza_ah64_tadsRfHandoffData", []] call fza_fnc_updateNetworkGlobal;
};

if (isNull _laserObj) exitWith {
    [_heli] call _resetData;
};

if (_selectedMissile != "fza_agm114l_wep" || _sight != SIGHT_TADS) exitWith {};

private _now = CBA_missionTime;
private _start = _heli getVariable ["fza_ah64_tadsRfHandoffStart", -1];
private _lastSample = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];
private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
private _pos = getPosASL _laserObj;

if (_start < 0) then {
    [_heli, "fza_ah64_tadsRfHandoffStart", _now] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_tadsRfHandoffLast", [_pos, 1]] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_tadsRfHandoffData", []] call fza_fnc_updateNetworkGlobal;
    _start = _now;
    _lastSample = [_pos, 1];
    _handoffData = [];
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

    if ((_now - _start) >= 3) then {
        // Freeze handoff package after 3 seconds; firing later introduces error by design.
        [_heli, "fza_ah64_tadsRfHandoffData", [_avgPos, _now]] call fza_fnc_updateNetworkGlobal;
    };
};
