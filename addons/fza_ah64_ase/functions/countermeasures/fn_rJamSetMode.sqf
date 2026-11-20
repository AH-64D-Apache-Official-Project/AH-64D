/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamSetMode

Description:
    Sets the radar jammer to OFF, STBY or OPER. Leaving OFF starts the warm-up; OPER selected
    before it ends doesn't jam until it does.

Parameters:
    _heli: Object - The helicopter
    _mode: Number - ASE_RJAM_STATE_OFF, ASE_RJAM_STATE_STBY or ASE_RJAM_STATE_OPER

Returns:
    Nothing

Examples:
    [_heli, ASE_RJAM_STATE_STBY] call fza_ase_fnc_rJamSetMode

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params [["_heli", objNull, [objNull]], ["_mode", -1, [0]]];

if !(_mode in [ASE_RJAM_STATE_OFF, ASE_RJAM_STATE_STBY, ASE_RJAM_STATE_OPER]) exitWith {};
if (_heli animationPhase "msn_equip_american" != 1 || {!(_heli getVariable ["bmkhs_dcBusOn", false])}) exitWith {};

private _current = _heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF];
if (_current == ASE_RJAM_STATE_OFF && _mode != ASE_RJAM_STATE_OFF) then {
    _heli setVariable ["fza_ah64_ase_rJamWarmStart", CBA_missionTime, true];
};
if (_mode != _current) then {
    _heli setVariable ["fza_ah64_ase_rJamMode", _mode, true];
};
