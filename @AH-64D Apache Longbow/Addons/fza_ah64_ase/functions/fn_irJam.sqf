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
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"

params ["_heli", "_deltaTime"];

private _dcBusOn    = _heli getVariable "fza_systems_dcBusOn";
private _irJamPwr   = _heli getVariable "fza_ah64_ase_msnEquipPwr";
private _irJamState = _heli getVariable "fza_ah64_ase_irJamState";
private _irJamTimer = _heli getVariable "fza_ah64_ase_irJamTimer";
private _irJamLaunchTimer = _heli getVariable "fza_ah64_ase_irJamLaunchTimer";

if (!_dcBusOn || _heli getHitPointDamage "hit_msnEquip_irJam" >= SYS_ASE_DMG_THRESH) exitwith {
    _heli setVariable ["fza_ah64_ase_irJamState", ASE_IRJAM_STATE_WARM];
};

switch (_irJamState) do {
    case ASE_IRJAM_STATE_OFF: {
        if (_irJamPwr == "on") then {
            _irJamState = ASE_IRJAM_STATE_WARM;
            _heli setVariable ["fza_ah64_ase_irJamState", _irJamState];
        };
    };
    case ASE_IRJAM_STATE_WARM: {
        _irJamTimer = [_irJamTimer, 1.0, (1.0 / ASE_IRJAM_PWR_ON_TIME) * _deltaTime] call BIS_fnc_lerp;

        if (_irJamTimer > 0.99) then {
            _irJamState = ASE_IRJAM_STATE_OPER;
        };
        _heli setVariable ["fza_ah64_ase_irJamTimer", _irJamTimer];
        _heli setVariable ["fza_ah64_ase_irJamState", _irJamState];
    };
    case ASE_IRJAM_STATE_OPER: {
        if (_irJamPwr == "off") then {
            _irJamTimer = 0.0;
            _irJamState = ASE_IRJAM_STATE_OFF;
            _heli setVariable ["fza_ah64_ase_irJamTimer", _irJamTimer];
            _heli setVariable ["fza_ah64_ase_irJamState", _irJamState];
        } else {
            if ((CBA_missionTime - _irJamLaunchTimer) >= 1 && _heli animationPhase "msn_equip_american" == 1) then {
                [_heli, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
                _heli setVariable ["fza_ah64_ase_irJamLaunchTimer", CBA_missionTime];
            };
        };
    };
};