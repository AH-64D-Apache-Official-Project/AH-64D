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

// Missiles and rockets are listed as they are created while a crew station here is manned (fza_ase_fnc_munitionInit);
// any already in flight when that starts are found once
if (isNil "fza_ase_munitionEh") then {call fza_ase_fnc_munitionInit;};
if (CBA_missionTime >= fza_ase_munitionTrackUntil) then {
    {fza_ase_munitions set [hashValue _x, _x];} forEach nearestObjects [_heli, ["missilebase", "rocketbase"], ASE_MWS_RANGE];
};
fza_ase_munitionTrackUntil = CBA_missionTime + ASE_MUNITION_TRACK_HOLD;

private _deltaTime = ["ase_deltaTime"] call BIS_fnc_deltaTime;
private _dcBusOn   = _heli getVariable ["bmkhs_dcBusOn", false];
private _hidas     = ASE_HIDAS(_heli);

// HIDAS has no power switches: its RLWR and MWS come on with the DC bus
if (_hidas && _dcBusOn) then {
    if (_heli getVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF] != ASE_RLWR_STATE_ON) then {_heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_ON];};
    if (_heli getVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF] != ASE_MSNEQUIP_STATE_ON) then {_heli setVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_ON];};
    _heli setVariable ["fza_ah64_ase_hidasPowered", true];
};
if (!_hidas && {_heli getVariable ["fza_ah64_ase_hidasPowered", false]}) then {
    _heli setVariable ["fza_ah64_ase_hidasPowered", false];
    _heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF];
    _heli setVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF];
};

private _rlwrPwr   = _heli getVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF];
private _aseUpdateTime = _heli getVariable ["fza_ah64_ase_updateTimer", 0];
private _mwsPwr   = (_heli animationPhase "msn_equip_british" == 1 && _heli getVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF] == ASE_MSNEQUIP_STATE_ON);

if (_dcBusOn) then {
    [_heli, _deltaTime] call fza_ase_fnc_irJam;
    if ((_aseUpdateTime + (1 / 5)) - CBA_missionTime < 0) then {
        _heli setVariable ["fza_ah64_ase_updateTimer", CBA_missionTime];

        private _munitions = [];
        private _gone = [];
        {
            if (isNull _y) then {_gone pushBack _x; continue;};
            if (_heli distance _y <= ASE_MWS_RANGE) then {_munitions pushBack _y;};
        } forEach fza_ase_munitions;
        {fza_ase_munitions deleteAt _x;} forEach _gone;
        [_heli, _munitions] call fza_ase_fnc_mws params [["_mwsObjects", []], "", ["_mwsDeclared", []]];
        if !_mwsPwr then {_mwsObjects = []; _mwsDeclared = [];};
        // A missile the MWS shows replaces its launcher's launch symbol on the RLWR
        private _mwsShown = _mwsObjects apply {_x # 1};
        [_heli] call fza_ase_fnc_rwr params [["_rwrObjects", []], ["_rwrAudio", []]];
        _rwrObjects = _rwrObjects select {(_x # 0) != ASE_LNC || {!((_x # 1) in _mwsShown)}};
        [_heli, _munitions, _mwsShown] call fza_ase_fnc_lwr params [["_lwrObjects", []], ["_lwrAudio", []]];
        if (_rlwrPwr == ASE_RLWR_STATE_OFF) then {_lwrObjects = []; _rwrObjects = []; _rwrAudio = []; _heli setVariable ["fza_ah64_ase_rlwrLast", nil];};
        if (_hidas) then {[_heli, _mwsDeclared] call fza_ase_fnc_cmds;};

        // The RLWR shows up to ASE_RLWR_MAX threats: by mode, those detected before those no longer detected, then
        // nearest. Only those shown are announced.
        private _rlwrObjects = _rwrObjects + _lwrObjects;
        private _order = [];
        {
            _x params ["_state", "_object", "", ["_ghost", false]];
            _order pushBack [-_state, [0, 1] select _ghost, _heli distance _object, _forEachIndex];
        } forEach _rlwrObjects;
        _order sort true;
        _rlwrObjects = (_order select [0, ASE_RLWR_MAX]) apply {_rlwrObjects # (_x # 3)};
        private _sources = _rlwrObjects apply {_x param [4, objNull]};
        _rwrAudio = _rwrAudio select {(_x # 0) in _sources};

        _heli setVariable ["fza_ah64_ase_objects", _rlwrObjects + _mwsObjects];
        _heli setVariable ["fza_ah64_ase_rlwrcount", {!(_x param [3, false])} count _rlwrObjects];
        [_heli, _rwrAudio + _lwrAudio] call fza_ase_fnc_audioController;
        [_heli] call fza_ase_fnc_rJam;
    };
};

[_heli] call fza_ase_fnc_rfi;

// Every frame without power, so written only when they differ
if !_dcBusOn then {
    if (_heli getVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE] != ASE_CHAFF_STATE_SAFE) then {
        _heli setVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE];
    };
    if (_rlwrPwr != ASE_RLWR_STATE_OFF) then {_heli setVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF];};
    if !(isNil {_heli getVariable "fza_ah64_ase_rlwrLast"}) then {_heli setVariable ["fza_ah64_ase_rlwrLast", nil];};
    if (_heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF] != ASE_RJAM_STATE_OFF) then {
        _heli setVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF, true];
    };
    _heli setVariable ["fza_ah64_ase_rJamXmit", false];
    // Tells radios in front of it it has stopped, if it was transmitting when the power went
    if ((_heli getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) > -1) then {[_heli] call fza_ase_fnc_rJam;};
};
