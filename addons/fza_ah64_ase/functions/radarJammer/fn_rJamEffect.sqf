/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamEffect

Description:
    Jams a threat: the active radars that are on, and its datalink targets if it receives
    them, are held off every frame for the given time, which drops its track and any lock
    built on it. Only what was on is turned back on afterwards. A jam already running is
    extended. Run where the threat is local.

Parameters:
    _emitter: Object - The threat vehicle
    _duration: Number - Seconds to jam it for, at most ASE_RJAM_JAM_TIME
    _restore: Array - Internal: [radars, datalink] to put back, from a new owner's hand-over
        or the server's check (fza_ase_fnc_rJamWatch)

Returns:
    Nothing

Examples:
    [_emitter, 4] remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params [["_emitter", objNull, [objNull]], ["_duration", 0, [0]], ["_restore", [], [[]]]];

if (isNull _emitter) exitWith {};
if (!local _emitter) exitWith {
    _this remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter];
};
_duration = 0 max _duration min ASE_RJAM_JAM_TIME;

// Public, for its crew's SENS panel (fza_ase_fnc_rJamOverlay) and the server's check
private _jammedUntil = _emitter getVariable ["fza_ah64_rJamUntil", -1];
_emitter setVariable ["fza_ah64_rJamUntil", (CBA_missionTime + _duration) max _jammedUntil, true];
// Held off here already, or by its last owner until a hand-over brings what to put back
if (_emitter getVariable ["fza_ah64_rJamRunning", false]) exitWith {};
if (_jammedUntil > CBA_missionTime && {_restore isEqualTo []}) exitWith {};

// Only what is on now: its active radars, and whether it receives datalink targets
if (_restore isEqualTo []) then {
    private _sensors   = configOf _emitter >> "Components" >> "SensorsManagerComponent" >> "Components";
    private _allRadars = ("getText (_x >> 'componentType') == 'ActiveRadarSensorComponent'" configClasses _sensors) apply {configName _x};
    _restore = [
        _allRadars select {(_emitter isVehicleSensorEnabled _x) findIf {(_x param [1, false]) isEqualTo true} >= 0},
        vehicleReceiveRemoteTargets _emitter
    ];
};
_restore params [["_radars", [], [[]]], ["_datalink", false, [false]]];
_radars = _radars select {_x isEqualType ""};
if (_radars isEqualTo [] && !_datalink) exitWith {
    _emitter setVariable ["fza_ah64_rJamUntil", nil, true];
};

// What to put back, public, so the server can if whoever holds it off goes away without doing it
_emitter setVariable ["fza_ah64_rJamRestore", [_radars, _datalink], true];
_emitter setVariable ["fza_ah64_rJamRunning", true];
[_emitter] remoteExecCall ["fza_ase_fnc_rJamWatch", 2];

// The machines of its crew, a player remote controlling one of them, and a UAV operator's
if (_duration > 0) then {
    private _viewers = ((crew _emitter) + (UAVControl _emitter)) select {_x isEqualType objNull && {!isNull _x}};
    if (_viewers isNotEqualTo []) then {
        remoteExecCall ["fza_ase_fnc_rJamOverlay", _viewers];
    };
};

// Held off every frame until the jam ends, then restored; a new owner takes over what is left
[{
    params ["_args", "_handle"];
    _args params ["_emitter", "_radars", "_datalink"];
    if (isNull _emitter) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

    private _until = _emitter getVariable ["fza_ah64_rJamUntil", -1];
    if (!local _emitter || {!alive _emitter} || {CBA_missionTime >= _until}) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        _emitter setVariable ["fza_ah64_rJamRunning", nil];
        if (local _emitter) then {
            {_emitter enableVehicleSensor [_x, true];} forEach _radars;
            if (_datalink) then {_emitter setVehicleReceiveRemoteTargets true;};
            _emitter setVariable ["fza_ah64_rJamUntil", nil, true];
            _emitter setVariable ["fza_ah64_rJamRestore", nil, true];
        } else {
            if (!alive _emitter) exitWith {};
            [_emitter, (_until - CBA_missionTime) max 0, [_radars, _datalink]] remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter];
        };
    };

    {
        if ((_emitter isVehicleSensorEnabled _x) findIf {(_x param [1, false]) isEqualTo true} >= 0) then {
            _emitter enableVehicleSensor [_x, false];
        };
    } forEach _radars;
    if (_datalink && {vehicleReceiveRemoteTargets _emitter}) then {
        _emitter setVehicleReceiveRemoteTargets false;
    };
}, 0, [_emitter, _radars, _datalink]] call CBA_fnc_addPerFrameHandler;
