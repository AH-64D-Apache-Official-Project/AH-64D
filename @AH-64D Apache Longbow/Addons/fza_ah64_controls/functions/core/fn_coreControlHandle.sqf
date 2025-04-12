#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_sfmplus\headers\core.hpp"

params["_name", "_value"];
if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

private _onGnd      = [_heli] call fza_sfmplus_fnc_onGround;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

if (_value) then {
    //When button pressed
    switch (_name) do {
        case "defaultAction": {
            _heli setVariable ["fza_ah64_salvofired", 0];
            _heli setVariable ["fza_ah64_burst_fired", 0];
        };
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
            [_heli, "fza_ah64_sight", SIGHT_HMD] call fza_fnc_setSeatVariable;
        };
        case "fza_ah64_sightSelectTADS": {
            [_heli, "fza_ah64_sight", SIGHT_TADS] call fza_fnc_setSeatVariable;
        };
        case "fza_ah64_sightSelectFXD": {
            [_heli, "fza_ah64_sight", SIGHT_FXD] call fza_fnc_setSeatVariable;
        };
        case "fza_ah64_sightSelectFCR": {
            [_heli, "fza_ah64_sight", SIGHT_FCR] call fza_fnc_setSeatVariable;
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
            private _fcrState = _heli getVariable "fza_ah64_fcrState";
            private _onGnd = [_heli] call fza_sfmplus_fnc_onGround;
            private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";
            if (!_gndOrideOn && _onGnd || _fcrState#0 == FCR_MODE_FAULT) exitwith {};
            if (_fcrState#0 != FCR_MODE_ON_SINGLE) exitwith {
                player action ["ActiveSensorsOn", _heli];
                _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_SINGLE, CBA_missionTime], true];
                _heli setVariable ["fza_ah64_fcrTargets", [], true];
                _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
            };
            player action ["ActiveSensorsOff", _heli];
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime], true];
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
            if (!_gndOrideOn && _onGnd) exitWith {[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;};

            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_GUN) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_GUN] call fza_fnc_weaponActionSwitch;
            };
        };
        case "fza_ah64_wasRkt": {
            if (!_gndOrideOn && _onGnd) exitWith {[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;};

            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_RKT) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_RKT] call fza_fnc_weaponActionSwitch;
            };
        };
        case "fza_ah64_wasMsl": {
            if (!_gndOrideOn && _onGnd) exitWith {[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;};

            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_MSL) then {
                [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
            } else {
                [_heli, WAS_WEAPON_MSL] call fza_fnc_weaponActionSwitch;
            };
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
            [_heli] call fza_fcr_fnc_cycleNTS;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_up": {
            if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
                _heli setVariable ["fza_ah64_forceTrimInterupted", true, true];
            };
        };
        case "fza_ah64_forceTrimHoldModeSwitch_right": {
            [_heli] call fza_sfmplus_fnc_fmcAltitudeHoldEnable;
        };
        case "fza_ah64_forceTrimHoldModeSwitch_down": {
            if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
                [_heli] call fza_sfmplus_fnc_fmcHoldModesDisable;
            };
        };
        case "fza_ah64_forceTrimHoldModeSwitch_left": {
            if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
                [_heli] call fza_sfmplus_fnc_fmcAttitudeHoldEnable;
            };
        };
        case "fza_ah64_fcrModeSwitch_up": {
            _heli setVariable ["fza_ah64_fcrMode", 1, true];
            _heli setVariable ["fza_ah64_fcrTargets", [], true];
            _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
        };
        case "fza_ah64_fcrModeSwitch_down": {
            _heli setVariable ["fza_ah64_fcrMode", 2, true];
            _heli setVariable ["fza_ah64_fcrTargets", [], true];
            _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
        };
        case "launchCM": {
            [_heli] call fza_ase_fnc_Chaff;
        };
        case "fza_ah64_flare": {
            [_heli] call fza_ase_fnc_Flare;
        };
        case "fza_ah64_freeCursor": {
            private _cursorEnabled = (_heli getVariable "fza_ah64_freeCursorEnabled");
            _heli setVariable ["fza_ah64_freeCursorEnabled", !_cursorEnabled];
            if (_cursorEnabled) then {
                _heli setVariable ["fza_ah64_freeCursorHpos", 0.5];
                _heli setVariable ["fza_ah64_freeCursorVpos", 0.5];
                ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlSetPosition[0.5 - 0.005, 0.5 - 0.009];
                ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlSetPosition[0.5 - 0.25, 0.5 + 0.02];
                ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlCommit 0.01;
                ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlCommit 0.01;
            };
        };
        case "zoomIn": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode in [1, 2]) exitWith { //FLIR is free to zoom into 1,2,3
                _zoomindex = [_inputindex + 1, 1, 3] call BIS_fnc_clamp;
                _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
            };
            if (_Visionmode == 0) exitWith { //DTV can only ZOOM into 2,3
                _zoomindex = [_inputindex + 1, 2, 3] call BIS_fnc_clamp;
                _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
            };
            if (_Visionmode == 3) exitWith { //DVO can only Zoom into 1
                _heli setvariable ["fza_ah64_tadsZoom", 1];
            };
        };
        case "zoomOut": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode in [1, 2]) exitWith { //FLIR is free to zoom out to 0,1,2,
                _zoomindex = [_inputindex - 1, 0, 2] call BIS_fnc_clamp;
                _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
            };
            if (_Visionmode == 0) exitWith { //DTV can only ZOOM out to 0,2
                _zoomindex = [_inputindex - 1, 0, 2] call BIS_fnc_clamp;
                if (_zoomindex == 1) then {_zoomindex = 0;}; //Skipp Medium on DTV
                _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
            };
            if (_Visionmode == 3) exitWith { //DVO can only Zoom out to 1
                _heli setvariable ["fza_ah64_tadsZoom", 0];
            };
        };
        case "NightVision": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
            private _flirDamage = _heli getHitPointDamage "hit_msnEquip_tads_flir";
            private _dtvDamage  = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
            private _tadsVision = _heli getVariable "fza_ah64_tadsVision";
            private _Visionmode = _heli currentVisionMode [0];
            private _a3ti_vis   = call A3TI_fnc_getA3TIVision;
            if !(isNil "_a3ti_vis") exitwith {};

            //End of FLir Cylce
            if (_Visionmode#0 == 2 && _Visionmode#1 == 1) then {
                if (fza_ah64_tadsCycleIncludeDTV && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitwith {
                    ["fza_ah64_SensorSelect_DTV", true] call fza_fnc_coreControlHandle;
                };
                if (fza_ah64_tadsCycleIncludeDVO && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitwith {
                    ["fza_ah64_SensorSelect_DVO", true] call fza_fnc_coreControlHandle;
                };
            };

            //End of DTV Cycle
            if (_tadsVision == "DTV") then {
                if (fza_ah64_tadsCycleIncludeDVO && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitwith { //should be DVO damage
                    ["fza_ah64_SensorSelect_DVO", true] call fza_fnc_coreControlHandle;
                };
                if (_flirDamage < SYS_SIGHT_DMG_THRESH) exitwith {
                    ["fza_ah64_SensorSelect_FLIR", true] call fza_fnc_coreControlHandle;
                };
            };

            //End of DVO Cycle
            if (_tadsVision == "DVO") then {
                if (_flirDamage < SYS_SIGHT_DMG_THRESH) exitwith {
                    ["fza_ah64_SensorSelect_FLIR", true] call fza_fnc_coreControlHandle;
                };
            };
        };
        case "fza_ah64_tadsLHGFov_W": {
            if (player != gunner _heli) exitWith {};
            _heli setvariable ["fza_ah64_tadsZoom", 0];
        };
        case "fza_ah64_tadsLHGFov_M": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 1;
            if (_Visionmode == 0) then {_zoomindex = 0;}; //DTV Cannot use Meduim, skip to Wide (0)
            _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
        };
        case "fza_ah64_tadsLHGFov_N": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 2;
            if (_Visionmode == 3) then {_zoomindex = 1;}; //DVO cannot surpase Medium (1)
            _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
        };
        case "fza_ah64_tadsLHGFov_Z": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 3;
            if (_Visionmode == 3) then {_zoomindex = 1;}; //DVO cannot surpase Medium (1)
            _heli setvariable ["fza_ah64_tadsZoom", _zoomindex];
        };
        case "fza_ah64_SensorSelect_FLIR": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitwith {};
            _heli setvariable ["fza_ah64_tadsVision", "FLIR"];
        };
        case "fza_ah64_SensorSelect_DTV": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitwith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
            if (_inputindex == 1) then {_heli setvariable ["fza_ah64_tadsZoom", 0];};
            _heli setvariable ["fza_ah64_tadsVision", "DTV"];
        };
        case "fza_ah64_SensorSelect_DVO": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitwith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
            if (_inputindex > 1) then {_heli setvariable ["fza_ah64_tadsZoom", 1];};
            _heli setvariable ["fza_ah64_tadsVision", "DVO"];
        };
        case "fza_ah64_tadsLHGLmc": {
            if (player != gunner _heli) exitWith {};
            private _lmc = _heli getvariable "fza_ah64_LmcActive";
            _heli setVariable ["fza_ah64_LmcActive", !_lmc, true];
        };
        case "fza_ah64_kbAttHoldDisengage": {
            _heli setVariable ["fza_sfmplus_kbAttHoldDisengage", true];
        };
        case "Headlights": {
            private _lightval = _heli getVariable "fza_ah64_lightSearchLight";
            _heli setVariable ["fza_ah64_lightSearchLight", !_lightval, true];
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
            if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
                //Velocity Hold Velocities
                private _curVel   = velocityModelSpace _heli;
                private _curVelX  = (_curVel # 0) * -1.0;
                private _curVelY  = _curVel # 1;
                //Attitude Hold Pitch & Roll
                private _curAtt   = _heli call BIS_fnc_getPitchBank;
                private _curPitch = _curAtt # 0;
                private _curRoll  = _curAtt # 1;
                _heli setVariable ["fza_ah64_forceTrimInterupted",    false,                 true];
                _heli setVariable ["fza_ah64_attHoldDesiredPos",      getPos _heli,          true];
                _heli setVariable ["fza_ah64_attHoldDesiredVel",      [_curVelX, _curVelY],  true];
                _heli setVariable ["fza_ah64_attHoldDesiredAtt",      [_curPitch, _curRoll], true];
                _heli setVariable ["fza_ah64_hdgHoldDesiredHdg",      getDir _heli,          true];
                _heli setVariable ["fza_ah64_hdgHoldDesiredSideslip", fza_ah64_sideslip,     true];
                [_heli] call fza_sfmplus_fnc_fmcForceTrimSet;
            };
        };
        case "fza_ah64_kbAttHoldDisengage": {
            _heli setVariable ["fza_sfmplus_kbAttHoldDisengage", false];
        };
    };
};