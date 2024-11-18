/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_irJam

Description:
    Handles the AN/ALQ-144 IR Jammer

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_irJam

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_ase\headers\ase.h"

params ["_heli", "_deltaTime"];

private _dcBusOn    = _heli getVariable "fza_systems_dcBusOn";
private _irJamPwr   = _heli getVariable "fza_ah64_ase_msnEquipPwr";
private _msnEquipUs = _heli animationPhase "msn_equip_american";
private _irJamData  = _heli getVariable "fza_ah64_ase_irJamState";

if (!_dcBusOn || (_heli getHitPointDamage "hit_msnEquip_irJam" >= SYS_ASE_DMG_THRESH && _msnEquipUs == 1)) exitwith {
    _irJamData set [0, ASE_IRJAM_STATE_WARM];
    _heli setVariable ["fza_ah64_ase_irJamState", _irJamData];
};

switch (_irJamData#0) do {
    case ASE_IRJAM_STATE_OFF: {
        if (_irJamPwr == ASE_MSNEQUIP_STATE_ON) then {
            _irJamData set [0, ASE_IRJAM_STATE_WARM];
            _heli setVariable ["fza_ah64_ase_irJamState", _irJamData];
        };
    };
    case ASE_IRJAM_STATE_WARM: {
        _irJamTimer = [_irJamData#1, 1.0, (1.0 / ASE_IRJAM_PWR_ON_TIME) * _deltaTime] call BIS_fnc_lerp;

        if (_irJamTimer > 0.99) then {
            _irJamData set [0, ASE_IRJAM_STATE_OPER];
        };
        _irJamData set [1, _irJamTimer];
        _heli setVariable ["fza_ah64_ase_irJamState", _irJamData];
    };
    case ASE_IRJAM_STATE_OPER: {
        if (_irJamPwr == ASE_MSNEQUIP_STATE_OFF) then {
            _irJamData set [0, ASE_IRJAM_STATE_OFF];
            _irJamData set [1, 0];
        } else {
            if ((CBA_missionTime - _irJamData#2) >= 1 && _msnEquipUs == 1 && local _heli) then {
                [_heli, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
                _irJamData set [2, CBA_missionTime];
            };
        };
        _heli setVariable ["fza_ah64_ase_irJamState", _irJamData];
    };
};