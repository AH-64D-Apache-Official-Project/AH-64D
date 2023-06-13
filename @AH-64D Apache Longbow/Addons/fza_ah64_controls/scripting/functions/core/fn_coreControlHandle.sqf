#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

params["_name", "_value"];

if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

if (_value) then {
    //When button pressed
    switch (_name) do {
        case "fza_ah64_crosshairInteract": {
            private _controls = [_heli] call fza_fnc_coreGetObjectsLookedAt;
            if (_controls isEqualTo []) exitWith {};
            
            //If there are multiple controls in the range, make sure we use the closest one
            if(count _controls > 1) then {
                _controls = [_controls, [], {_x # 6}, "ASCEND"] call BIS_fnc_sortBy;
            };
            
            (_controls # 0) params ["", "", "_system", "_control"];

            [_heli, _system, _control] call fza_fnc_coreCockpitInteract;
        };
        case "fza_ah64_laserDesig": {
            [_heli] call fza_fnc_laserArm;
        };
        case "fza_ah64_sightSelectHMD": {
            [_heli, SIGHT_HMD] call fza_fnc_targetingSetSightSelect;
        };
        case "fza_ah64_sightSelectTADS": {
            [_heli, SIGHT_TADS] call fza_fnc_targetingSetSightSelect;
        };
        case "fza_ah64_sightSelectFXD": {
            [_heli, SIGHT_FXD] call fza_fnc_targetingSetSightSelect;
        };
        case "fza_ah64_sightSelectFCR": {
            [_heli, SIGHT_FCR] call fza_fnc_targetingSetSightSelect;
        };
        case "fza_ah64_symbologySelectUp": {
            switch (_heli getVariable "fza_ah64_hmdfsmode") do {
                case "trans": {
                    _heli setVariable ["fza_ah64_hmdfsmode", "cruise", true];
                };
                default {
                    _heli setVariable ["fza_ah64_hmdfsmode", "trans", true];
                };
            };
        };
        case "fza_ah64_symbologySelectDown": {
            switch (_heli getVariable "fza_ah64_hmdfsmode") do {
                case "hover": {
                    _heli setVariable ["fza_ah64_bobpos", [(getposasl _heli select 0), (getposasl _heli select 1)], true];
                    _heli setVariable ["fza_ah64_bobhdg", getdir _heli, true];
                    _heli setVariable ["fza_ah64_hmdfsmode", "bobup", true];
                };
                default {
                    _heli setVariable ["fza_ah64_hmdfsmode", "hover", true];
                };
            };
        };
        case "fza_ah64_symbologySelectPress": {
            [_heli, 0, "flt"] call fza_mpd_fnc_setCurrentPage;
        };
        case "fza_ah64_fcrSingleScan": {
            player action ["ActiveSensorsOn", vehicle player];
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_SINGLE, time], true];
        };
        case "fza_ah64_targetStoreUpdate": {
            // Todo: Implemen target store
        };
        case "fza_ah64_missileAdvance": {
            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_MSL) then {
                [_heli] call fza_fnc_weaponMissileCycle
            };
        };
        case "fza_ah64_wasGun": {
            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_GUN) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_GUN] call fza_fnc_weaponActionSwitch;
            };
        };
        case "fza_ah64_wasRkt": {
            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_RKT) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_RKT] call fza_fnc_weaponActionSwitch;
            };
        };
        case "fza_ah64_wasMsl": {
            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_MSL) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_MSL] call fza_fnc_weaponActionSwitch;
            };
        };
        case "fza_ah64_masterSafe": {
            _heli setVariable ["fza_ah64_armed", !(_heli getVariable "fza_ah64_armed"), true];
        };
        case "SwitchWeaponGrp1";
        case "SwitchWeaponGrp2";
        case "SwitchWeaponGrp3";
        case "SwitchWeaponGrp4";
        case "nextWeapon";
        case "prevWeapon": {
            ["fza_ah64_weaponUpdate", {[vehicle player] call fza_fnc_weaponUpdateSelected}, 1, "frames"] call BIS_fnc_runLater;
        };
        case "vehLockTargets": {
            [_heli] call fza_fnc_targetingsensorCycle;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_up": {
            _heli setVariable ["fza_ah64_forceTrimInterupted", true, true];
        };
        case "fza_ah64_forceTrimHoldModeSwitch_right": {
            [_heli] call fza_sfmplus_fnc_fmcAltitudeHoldEnable;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_down": {
            [_heli] call fza_sfmplus_fnc_fmcHoldModesDisable;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_left": {
            [_heli] call fza_sfmplus_fnc_fmcAttitudeHoldEnable;
        };
        case "fza_ah64_fcrModeSwitch_up": {
            _heli setVariable ["fza_ah64_fcrMode", 1, true];
        };
        case "fza_ah64_fcrModeSwitch_down": {
            _heli setVariable ["fza_ah64_fcrMode", 2, true];
        case "launchCM": {
            [_heli] call fza_ase_fnc_Chaff;
        };
        case "fza_ah64_flare": {
            [_heli] call fza_ase_fnc_Flare;
        };
    };
};

if !(_value) then {
    //When button releassed
    switch (_name) do {
        case "fza_ah64_laserDesig": {
            [_heli] call fza_fnc_laserDisarm;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_up": {
            _heli setVariable ["fza_ah64_forceTrimInterupted",    false,      true];
            _heli setVariable ["fza_ah64_attHoldDesiredPos",      getPos _heli, true];
            _heli setVariable ["fza_ah64_hdgHoldDesiredHdg",      getDir _heli, true];
            _heli setVariable ["fza_ah64_hdgHoldDesiredSideslip", fza_ah64_sideslip, true];
            [_heli] call fza_sfmplus_fnc_fmcForceTrimSet;
        };
    };
};