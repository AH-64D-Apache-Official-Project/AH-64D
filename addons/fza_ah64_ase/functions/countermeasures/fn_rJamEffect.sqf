/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamEffect

Description:
    Jams a threat: the active radars that are on, and its datalink targets if it receives
    them, are held off every frame for the given time, which drops its track and any lock
    built on it. Only what was on is turned back on afterwards. A jam already running is
    extended. Run where the threat is local.

Parameters:
    _emitter: Object - The threat vehicle
    _duration: Number - Seconds to jam it for
    _restore: Array - Internal: [radars, datalink] carried over when the threat changes owner

Returns:
    Nothing

Examples:
    [_emitter, 4] remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_emitter", "_duration", ["_restore", []]];

if (isNull _emitter) exitWith {};
if (!local _emitter) exitWith {
    _this remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter];
};

// Public, for its crew's SENS panel (fza_ase_fnc_rJamOverlay)
private _jammedUntil = _emitter getVariable ["fza_ah64_rJamUntil", -1];
_emitter setVariable ["fza_ah64_rJamUntil", (CBA_missionTime + _duration) max _jammedUntil, true];
if (_jammedUntil > CBA_missionTime && {_restore isEqualTo []}) exitWith {};

// Only what is on now: its active radars, and whether it receives datalink targets
if (_restore isEqualTo []) then {
    private _sensors   = configOf _emitter >> "Components" >> "SensorsManagerComponent" >> "Components";
    private _allRadars = ("getText (_x >> 'componentType') == 'ActiveRadarSensorComponent'" configClasses _sensors) apply {configName _x};
    _restore = [
        _allRadars select {(_emitter isVehicleSensorEnabled _x) findIf {(_x param [1, false]) isEqualTo true} >= 0},
        vehicleReceiveRemoteTargets _emitter
    ];
    if (missionNamespace getVariable ["fza_ase_rJamDebug", false]) then {
        diag_log format ["fza_ase_rJam effect: %1 radars %2 states %3 datalink %4", typeOf _emitter, _allRadars, _allRadars apply {_emitter isVehicleSensorEnabled _x}, _restore # 1];
    };
};
_restore params ["_radars", "_datalink"];
if (_radars isEqualTo [] && !_datalink) exitWith {
    _emitter setVariable ["fza_ah64_rJamUntil", nil, true];
};

// The machines of its crew, a player remote controlling one of them, and a UAV operator's
private _viewers = ((crew _emitter) + (UAVControl _emitter)) select {_x isEqualType objNull && {!isNull _x}};
if (_viewers isNotEqualTo []) then {
    [_emitter] remoteExec ["fza_ase_fnc_rJamOverlay", _viewers];
};

// Held off every frame until the jam ends, then restored; a new owner takes over what is left
[{
    params ["_args", "_handle"];
    _args params ["_emitter", "_radars", "_datalink"];
    if (isNull _emitter) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

    private _until = _emitter getVariable ["fza_ah64_rJamUntil", -1];
    if (!local _emitter || {CBA_missionTime >= _until}) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        if (local _emitter) then {
            _emitter setVariable ["fza_ah64_rJamUntil", nil, true];
            {_emitter enableVehicleSensor [_x, true];} forEach _radars;
            if (_datalink) then {_emitter setVehicleReceiveRemoteTargets true;};
        } else {
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
