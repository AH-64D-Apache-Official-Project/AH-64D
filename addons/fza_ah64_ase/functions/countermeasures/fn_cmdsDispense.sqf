/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmdsDispense

Description:
    Runs a countermeasure dispense program where the aircraft is local, one cartridge at a
    time through fza_ase_fnc_cmdsFire. One program at a time: a request while one is still
    firing is dropped. Holds off AUTO and SEMI (fza_ase_fnc_cmds) until the
    program has run and ASE_CMDS_HOLD has passed.

Parameters:
    _heli    - The helicopter
    _program - Steps of [sec after the previous step, flares, chaff] (ASE_CMDS_PGM_*)
    _side    - "L" or "R" for the flares, "B" to split them between both sides

Returns:
    Nothing

Examples:
    [_heli, ASE_CMDS_PGM_MAN_FLARE, "B"] call fza_ase_fnc_cmdsDispense;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_program", ["_side", "B"]];

if !(local _heli) exitWith {
    [_heli, _program, _side] remoteExec ["fza_ase_fnc_cmdsDispense", _heli];
};
if (CBA_missionTime < (_heli getVariable ["fza_ah64_ase_cmdsBusy", -1])) exitWith {};

private _hidas  = ASE_HIDAS(_heli);
private _chaff  = [["fza_CMChaffLauncher", "fza_chaff_30_mag"], ["fza_CMChaffLauncherL", "fza_chaff_64_mag"]] select _hidas;
private _flareL = ["fza_CMFlareLauncherL", "fza_flare_32L_mag"];
private _flareR = ["fza_CMFlareLauncherR", "fza_flare_32R_mag"];

private _time  = 0;
private _end   = 0;
private _queue = createHashMap;
{
    _x params ["_delay", "_flares", "_chaffs"];
    _time = _time + _delay;

    // [weapon, magazine, the other side's flares]
    private _shots = [];
    if (_hidas) then {
        private _left = switch (_side) do {
            case "L": {_flares};
            case "R": {0};
            default {ceil (_flares / 2)};
        };
        for "_i" from 1 to _left do {_shots pushBack (_flareL + [_flareR]);};
        for "_i" from 1 to (_flares - _left) do {_shots pushBack (_flareR + [_flareL]);};
    };
    for "_i" from 1 to _chaffs do {_shots pushBack (_chaff + [[]]);};

    // A dispenser fires its cartridges one after another
    {
        _x params ["_weapon", "_magazine", "_other"];
        private _start = _time max (_queue getOrDefault [_weapon, -1]);
        _queue set [_weapon, _start + ASE_CMDS_SHOT_GAP];
        _end = _end max _start;
        [fza_ase_fnc_cmdsFire, [_heli, _weapon, _magazine, _hidas, _other], _start] call CBA_fnc_waitAndExecute;
    } forEach _shots;
} forEach _program;

_heli setVariable ["fza_ah64_ase_cmdsBusy", CBA_missionTime + _end + ASE_CMDS_SHOT_GAP];

private _hold = CBA_missionTime + _end + ASE_CMDS_HOLD;
if (_hold > (_heli getVariable ["fza_ah64_ase_cmdsHold", -1])) then {
    _heli setVariable ["fza_ah64_ase_cmdsHold", _hold, true];
};
