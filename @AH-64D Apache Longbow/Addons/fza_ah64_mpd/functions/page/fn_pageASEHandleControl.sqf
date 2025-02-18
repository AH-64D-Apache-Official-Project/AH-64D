#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_mpdIndex", "_control"];

private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";

switch(_control) do {
    //Chaff
    case "t1": {
        private _newState = [ASE_CHAFF_STATE_SAFE, ASE_CHAFF_STATE_ARM] select (_heli getVariable "fza_ah64_ase_chaffState" == ASE_CHAFF_STATE_SAFE);
        _heli setVariable ["fza_ah64_ase_chaffState", _newState, true];
    };
    //IR Jammer
    case "r1": {
        private _newState = [ASE_MSNEQUIP_STATE_OFF, ASE_MSNEQUIP_STATE_ON] select (_heli getVariable "fza_ah64_ase_msnEquipPwr" == ASE_MSNEQUIP_STATE_OFF);
        _heli setVariable ["fza_ah64_ase_msnEquipPwr", _newState, true];
    };
    //RLWR
    case "r6": {
        if !(_dcBusOn) exitwith {};
        private _newState = [ASE_RLWR_STATE_OFF, ASE_RLWR_STATE_ON] select (_heli getVariable "fza_ah64_ase_rlwrPwr" == ASE_RLWR_STATE_OFF);
        _heli setVariable ["fza_ah64_ase_rlwrPwr", _newState, true];
        if (_newstate == ASE_RLWR_STATE_ON) then {
            [_heli, 7, "APR-39", "fza_ah64_APR_39_power_up", 1.8] call fza_audio_fnc_addASEMessage;
            private _otherTurret = [_heli, true] call fza_fnc_currentTurret;
            private _turretUnit = _heli turretUnit _otherTurret;
            [_heli, 7, "APR-39", "fza_ah64_APR_39_power_up", 1.8] remoteExec ["fza_audio_fnc_addASEMessage", [_turretUnit]];
        };
    };
    case "t2": {
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    //Autopage
    case "l3": {
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_SRH];
    };
    case "l4": {
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_ACQ];
    };
    case "l5": {
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_TRK];
    };
    case "l6": {
        _heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_OFF];
    };
};