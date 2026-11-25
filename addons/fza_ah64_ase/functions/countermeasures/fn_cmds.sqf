/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmds

Description:
    HIDAS countermeasure dispensing on munitions the MWS declares. Any program holds off
    the next until it has run and ASE_CMDS_HOLD has passed, then whatever is still
    incoming is reassessed.
    AUTO dispenses after the reaction time, one program for every threat incoming.
    SEMI asks for consent (fza_ase_fnc_cmdsConsent) while anything is incoming.
    MAN does nothing.
    A radar-guided threat, or one from a launcher tracking the aircraft, gets the radar
    program. The flares come from the threats' side, or both sides near the nose or tail.

Parameters:
    _heli     - The helicopter
    _declared - Every munition declared incoming now

Returns:
    Nothing

Examples:
    [_heli, _declared] call fza_ase_fnc_cmds;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_declared"];

if !(ASE_OWNER(_heli)) exitWith {};

private _mode     = _heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN];
private _pending  = _heli getVariable ["fza_ah64_ase_cmdsConsent", []];
private _holding  = CBA_missionTime < (_heli getVariable ["fza_ah64_ase_cmdsHold", -1]);

// A request lapses once nothing is incoming, or out of SEMI
if (_pending isNotEqualTo [] && {_mode != ASE_CMDS_SEMI || {_declared isEqualTo []}}) then {
    _pending = [];
    _heli setVariable ["fza_ah64_ase_cmdsConsent", [], true];
};

// [program, side] for a set of threats
private _programFor = {
    params ["_heli", "_threats"];
    private _tracking = (_heli getVariable ["fza_ah64_ase_data", []]) param [2, []];
    private _radar = _threats findIf {
        (vehicle ((getShotParents _x) param [0, objNull]) in _tracking)
        || {([getNumber (configOf _x >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND) != 0}
    } >= 0;
    private _sides = _threats apply {
        private _dir = _heli getRelDir _x;
        if (_dir < ASE_CMDS_BOTH_DEG || {_dir > 360 - ASE_CMDS_BOTH_DEG} || {abs (_dir - 180) < ASE_CMDS_BOTH_DEG}) then {"B"} else {["L", "R"] select (_dir < 180)};
    };
    [[ASE_CMDS_PGM_IR, ASE_CMDS_PGM_RF] select _radar, [_sides # 0, "B"] select (count (_sides arrayIntersect _sides) > 1)]
};

switch (_mode) do {
    case ASE_CMDS_AUTO: {
        if (_declared isEqualTo [] || {_holding}) exitWith {};
        [_heli, _declared] call _programFor params ["_program", "_side"];
        private _delay = ASE_CMDS_REACT_MIN + random (ASE_CMDS_REACT_MAX - ASE_CMDS_REACT_MIN);
        [fza_ase_fnc_cmdsDispense, [_heli, _program, _side], _delay] call CBA_fnc_waitAndExecute;
        // Held from now, fza_ase_fnc_cmdsDispense extends it to the program's end
        private _length = 0;
        {_length = _length + (_x # 0);} forEach _program;
        _heli setVariable ["fza_ah64_ase_cmdsHold", CBA_missionTime + _delay + _length + ASE_CMDS_SHOT_GAP + ASE_CMDS_HOLD, true];
    };
    case ASE_CMDS_SEMI: {
        if (_declared isEqualTo [] || {_pending isEqualTo [] && _holding}) exitWith {};
        private _request = [_heli, _declared] call _programFor;
        if (_request isNotEqualTo _pending) then {
            _heli setVariable ["fza_ah64_ase_cmdsConsent", _request, true];
        };
    };
};
