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

if (player != driver _heli && player != gunner _heli) exitWith {};

private _deltaTime = ["ase_deltaTime"] call BIS_fnc_deltaTime;
private _dcBusOn   = _heli getVariable "bmkhs_dcBusOn";
private _hidas     = ASE_HIDAS(_heli);

// HIDAS has no power switches: its RLWR and MWS come on with the DC bus
if (_hidas && _dcBusOn) then {
    if (_heli getVariable "fza_ah64_ase_rlwrPwr" != ASE_RLWR_STATE_ON) then {_heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_ON];};
    if (_heli getVariable "fza_ah64_ase_msnEquipPwr" != ASE_MSNEQUIP_STATE_ON) then {_heli setVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_ON];};
    _heli setVariable ["fza_ah64_ase_hidasPowered", true];
};
if (!_hidas && {_heli getVariable ["fza_ah64_ase_hidasPowered", false]}) then {
    _heli setVariable ["fza_ah64_ase_hidasPowered", false];
    _heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF];
    _heli setVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF];
};

private _rlwrPwr   = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _aseUpdateTime = _heli getVariable "fza_ah64_ase_updateTimer";
private _mwsPwr   = (_heli animationPhase "msn_equip_british" == 1 && _heli getVariable "fza_ah64_ase_msnEquipPwr" == 1);

if (_dcBusOn) then {
    [_heli, _deltaTime] call fza_ase_fnc_irJam;
    if ((_aseUpdateTime + (1 / 5)) - CBA_missionTime < 0) then {
        _heli setVariable ["fza_ah64_ase_updateTimer", CBA_missionTime];

        [_heli] call fza_ase_fnc_rwr params [["_rwrObjects", []], ["_rwrAudio", []]];
        [_heli] call fza_ase_fnc_lwr params [["_lwrObjects", []], ["_lwrAudio", []]];
        [_heli] call fza_ase_fnc_mws params [["_mwsObjects", []], "", ["_mwsDeclared", []]];
        if (_rlwrPwr == ASE_RLWR_STATE_OFF) then {_lwrObjects = []; _rwrObjects = [];};
        if !_mwsPwr then {_mwsObjects = []; _mwsDeclared = [];};
        if (_hidas) then {[_heli, _mwsDeclared] call fza_ase_fnc_cmds;};

        _heli setVariable ["fza_ah64_ase_objects", (_rwrObjects + _lwrObjects + _mwsObjects)];
        _heli setVariable ["fza_ah64_ase_rlwrcount", count(_rwrObjects + _lwrObjects)];
        [_heli, (_rwrAudio + _lwrAudio)] call fza_ase_fnc_audioController;
        [_heli] call fza_ase_fnc_rJam;
    };
};

if !_dcBusOn then {
    _heli setVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE];
    _heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_IRJAM_STATE_OFF];
    if (_heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF] != ASE_RJAM_STATE_OFF) then {
        _heli setVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF, true];
    };
    _heli setVariable ["fza_ah64_ase_rJamXmit", false];
    // Tells radios in front of it it has stopped, if it was transmitting when the power went
    if ((_heli getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) > -1) then {[_heli] call fza_ase_fnc_rJam;};
};
