/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfi

Description:
    AN/APR-48A radar frequency interferometer. On the machine that decides for the aircraft, hears what the RLWR
    hears: the radars pointed at the aircraft its passive radar picks up, and those acquiring, tracking or launching on
    it. Identifies, prioritises and publishes up to ASE_RFI_MAX of them as fza_ah64_ase_rfiEmitters.

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_rfi

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#define ANGLE_180(a) ((((a) % 360) + 540) % 360 - 180)
params ["_heli"];

if !(ASE_OWNER(_heli)) exitWith {};
private _now = CBA_missionTime;
if (_now < (_heli getVariable ["fza_ah64_ase_rfiNext", -1])) exitWith {};
_heli setVariable ["fza_ah64_ase_rfiNext", _now + ASE_RFI_TICK];

if !([_heli] call fza_ase_fnc_rfiWorking) exitWith {
    _heli setVariable ["fza_ah64_ase_rfiTrack", createHashMap];
    [_heli, "fza_ah64_ase_rfiEmitters", []] call fza_fnc_updateNetworkGlobal;
};

// Modes against the ownship, highest first: a radar missile in flight puts its launcher in launch
private _threatModes = createHashMap;
private _setMode = {
    params ["_veh", "_mode"];
    if (isNull _veh) exitWith {};
    private _key = hashValue _veh;
    _threatModes set [_key, [_veh, ((_threatModes getOrDefault [_key, [_veh, -1]]) # 1) max _mode]];
};
{
    _x params ["_object", "_type"];
    switch (_type) do {
        case "missile": {
            if ([getNumber (configOf _object >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND == 8) then {
                [vehicle ((getShotParents _object) param [0, objNull]), ASE_LNC] call _setMode;
            };
        };
        case "locked": {[vehicle _object, ASE_TRK] call _setMode;};
        case "marked": {[vehicle _object, ASE_ACQ] call _setMode;};
    };
} forEach getSensorThreats _heli;

// Heard, by hashValue: what the RLWR hears. Radars acquiring, tracking or launching on the aircraft (a launcher fed by
// datalink has no radar of its own, but locks on through the engine), and the passive radar's contacts.
private _heard = createHashMap;
{_heard set [_x, _y # 0];} forEach _threatModes;
{
    private _veh = vehicle (_x # 0);
    if (!alive _veh || {_veh == _heli}) then {continue;};
    _heard set [hashValue _veh, _veh];
} forEach ((getSensorTargets _heli) select {"passiveradar" in (_x param [3, []])});

// Track records by hashValue: [obj, code, fine error, coarse error, last heard, posASL, mode, tier, first heard, air,
// fine, last fine fix, its bearing]
private _track = _heli getVariable "fza_ah64_ase_rfiTrack";
if (isNil "_track") then {
    _track = createHashMap;
    _heli setVariable ["fza_ah64_ase_rfiTrack", _track];
};
// The antennas are on the FCR and turn with it: its azimuth from the nose, right positive (fza_fcr_fnc_animateFCR)
private _antenna = -(deg (_heli animationPhase "longbow"));
private _heading = getDir _heli;

{
    private _key = _x;
    private _veh = _y;
    if (!alive _veh) then {continue;};
    private _pos = aimPos _veh;
    private _record = _track get _key;
    if (isNil "_record") then {
        private _cfg = configOf _veh >> "fza_aseIcon";
        _record = [_veh, ["SR", getText _cfg] select isText _cfg,
            random [-ASE_RFI_FINE_ERR, 0, ASE_RFI_FINE_ERR], random [-ASE_RFI_COARSE_ERR, 0, ASE_RFI_COARSE_ERR]];
        _record set [8, _now];
        _track set [_key, _record];
    };

    // It knows only what is pointed at it, nothing of range: those acquiring, tracking or launching on the aircraft,
    // then air defence, then the rest. Friend and foe aren't told apart.
    private _mode = (_threatModes getOrDefault [_key, [objNull, ASE_SRH]]) # 1;
    private _tier = switch (true) do {
        case (_mode >= ASE_ACQ):      {1};
        case !(_veh isKindOf "Air"):  {2};
        default                       {3};
    };
    // A fine fix is kept out of the fine sector while the emitter stays where it was fixed
    private _world = _heli getDir _pos;
    if (abs ANGLE_180(_world - _heading - _antenna) <= ASE_RFI_FINE_DEG) then {
        _record set [11, _now];
        _record set [12, _world];
    };
    private _fixedAt = _record param [12, _world];
    private _fine = _now - (_record param [11, -1e9]) <= ASE_RFI_FINE_HOLD
        && {abs ANGLE_180(_world - _fixedAt) <= ASE_RFI_FINE_DRIFT};
    _record set [4, _now];
    _record set [5, _pos apply {round _x}];
    _record set [6, _mode];
    _record set [7, _tier];
    _record set [9, _veh isKindOf "Air" && {(getPos _veh) # 2 > 5}];
    _record set [10, _fine];
} forEach _heard;

// Radiating before silent, then by tier, then by mode, then the first heard
private _order   = [];
private _dropped = [];
{
    private _age = _now - (_y # 4);
    if (_age > ASE_RFI_DROP_TIME) then {_dropped pushBack _x; continue;};
    _order pushBack [[0, 1] select (_age > ASE_RFI_STALE_TIME), _y # 7, -(_y # 6), _y # 8, _x];
} forEach _track;
{_track deleteAt _x;} forEach _dropped;
_order sort true;
private _shown = (_order select [0, ASE_RFI_MAX]) apply {_track get (_x # 4)};

private _emitters = _shown apply {
    _x params ["_veh", "_code", "_errFine", "_errCoarse", "_heard", "_pos", "_mode", "_tier", "", "_air", "_fine"];
    // Silent: where it was last heard, not where it has gone since
    [_veh, _code, _fine, round (([_errCoarse, _errFine] select _fine) * 10) / 10, _mode, _air, _now - _heard > ASE_RFI_STALE_TIME, [[], _pos] select (_heard < _now), _tier]
};
[_heli, "fza_ah64_ase_rfiEmitters", _emitters] call fza_fnc_updateNetworkGlobal;
