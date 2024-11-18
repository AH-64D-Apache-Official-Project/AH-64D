/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_aseManager


Description:
    Handles all ASE systems on the aircraft

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_aseManager

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

if (!(player == driver _heli) && !(player == gunner _heli)) exitwith {};

private _deltaTime = ["ase_deltaTime"] call BIS_fnc_deltaTime;
private _dcBusOn   = _heli getVariable "fza_systems_dcBusOn";
private _rlwrPwr   = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _aseUpdateTime = _heli getVariable "fza_ah64_ase_updateTimer";

if (_dcBusOn) then {
    [_heli, _deltaTime] call fza_ase_fnc_irJam;
    if ((_aseUpdateTime + (1 / 2)) - CBA_missionTime < 0) then {
        _heli setVariable ["fza_ah64_ase_updateTimer", CBA_missionTime];

        [_heli] call fza_ase_fnc_rwr params [["_rwrObjects", []], ["_rwrAudio", []]];
        if (_rlwrPwr == ASE_RLWR_STATE_OFF) then {_rwrObjects = [];};

        _heli setVariable ["fza_ah64_ase_rlwrObjects", _rwrObjects];
        [_heli, _rwrAudio] call fza_ase_fnc_audioController;
    };
};

if !_dcBusOn then {
    _heli setVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE];
    _heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_IRJAM_STATE_OFF];
};