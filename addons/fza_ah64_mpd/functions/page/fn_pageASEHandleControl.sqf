#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_mpdIndex", "_control"];

private _dcBusOn = _heli getVariable ["bmkhs_dcBusOn", false];
private _hidas   = ASE_HIDAS(_heli);
// SRCH, ACQ, TRCK, OFF and round again, for AUTOPAGE and VOICE
private _nextLevel = {
    [ASE_AUTOPAGE_SRH, ASE_AUTOPAGE_ACQ, ASE_AUTOPAGE_TRK, ASE_AUTOPAGE_OFF] select _this
};

switch(_control) do {
    //Chaff
    case "t1": {
        if (_hidas) exitWith {};
        private _newState = [ASE_CHAFF_STATE_SAFE, ASE_CHAFF_STATE_ARM] select (_heli getVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE] == ASE_CHAFF_STATE_SAFE);
        _heli setVariable ["fza_ah64_ase_chaffState", _newState, true];
    };
    //HIDAS CMDS mode
    case "l1": {
        if !(_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_cmdsMode", ((_heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN]) + 1) % 3, true];
    };
    //IR Jammer, or the HIDAS autopage
    case "r1": {
        if (_hidas) exitWith {
            _heli setVariable ["fza_ah64_ase_autopage", (_heli getVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_OFF]) call _nextLevel];
        };
        private _newState = [ASE_MSNEQUIP_STATE_OFF, ASE_MSNEQUIP_STATE_ON] select (_heli getVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF] == ASE_MSNEQUIP_STATE_OFF);
        _heli setVariable ["fza_ah64_ase_msnEquipPwr", _newState, true];
    };
    //HIDAS voice
    case "r2": {
        if !(_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_voiceLevel", (_heli getVariable ["fza_ah64_ase_voiceLevel", ASE_AUTOPAGE_SRH]) call _nextLevel];
    };
    //RLWR
    case "r6": {
        if (_hidas) exitWith {};
        private _newState = [ASE_RLWR_STATE_OFF, ASE_RLWR_STATE_ON] select (_heli getVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF] == ASE_RLWR_STATE_OFF);
        if !(_dcBusOn) exitWith {};
        _heli setVariable ["fza_ah64_ase_rlwrPwr", _newState, true];
        if (_newstate == ASE_RLWR_STATE_ON) then {
            [_heli, 7, "APR-39", "fza_ah64_APR_39_power_up", 1.8] remoteExec ["fza_audio_fnc_addASEMessage", [driver _heli, gunner _heli]];
        };
    };
    case "t2": {
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
    };
    //RFI, on the FCR mast
    case "l2": {
        if (_heli animationPhase "fcr_enable" != 1) exitWith {};
        private _on = (_heli getVariable ["fza_ah64_ase_rfiPwr", ASE_RFI_STATE_ON]) == ASE_RFI_STATE_ON;
        _heli setVariable ["fza_ah64_ase_rfiPwr", [ASE_RFI_STATE_ON, ASE_RFI_STATE_OFF] select _on, true];
    };
    //CAQ: the cursor chooses an RFI emitter as the acquisition source
    case "r4": {
        private _seat = ["plt", "cpg"] select (([_heli] call fza_fnc_currentTurret) isEqualTo [0]);
        if ((_heli getVariable ["fza_ah64_ase_rfiPwr", ASE_RFI_STATE_ON]) != ASE_RFI_STATE_ON
            || {_heli animationPhase "fcr_enable" != 1}
            || {([_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable) == SIGHT_FCR}) exitWith {};
        private _caq = +(_heli getVariable ["fza_mpd_aseCaq", [false, false]]);
        _caq set [_mpdIndex, !(_caq # _mpdIndex)];
        _heli setVariable ["fza_mpd_aseCaq", _caq];
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    //Radar Jammer
    case "b4": {
        [_heli, ASE_RJAM_STATE_OFF] call fza_ase_fnc_rJamSetMode;
    };
    case "b5": {
        [_heli, ASE_RJAM_STATE_STBY] call fza_ase_fnc_rJamSetMode;
    };
    case "b6": {
        [_heli, ASE_RJAM_STATE_OPER] call fza_ase_fnc_rJamSetMode;
    };
    //Autopage
    case "l3": {
        if (_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_SRH];
    };
    case "l4": {
        if (_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_ACQ];
    };
    case "l5": {
        if (_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_TRK];
    };
    case "l6": {
        if (_hidas) exitWith {};
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_OFF];
    };
};
