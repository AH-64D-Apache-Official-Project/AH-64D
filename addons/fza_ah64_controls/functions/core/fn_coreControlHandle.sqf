#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"

params["_name", "_value"];
if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

private _onGnd      = [_heli] call bmkhs_fnc_stateOnGround;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

// While the TADS is an NVS sensor it is not a sight, and is the FLIR in wide
private _tadsNvsMode = ([_heli] call fza_ihadss_fnc_tadsNvs) # 0;
private _tadsNvsBlocked = [
    "fza_ah64_sightSelectTADS", "fza_ah64_sightSelectLink", "fza_ah64_tadsLHGLmc", "zoomIn", "zoomOut", "NightVision",
    "fza_ah64_tadsLHGFov_W", "fza_ah64_tadsLHGFov_M", "fza_ah64_tadsLHGFov_N", "fza_ah64_tadsLHGFov_Z",
    "fza_ah64_SensorSelect_FLIR", "fza_ah64_SensorSelect_DTV", "fza_ah64_SensorSelect_DVO"
];
if (_value && {_tadsNvsMode != NVS_MODE_OFF} && {_name in _tadsNvsBlocked}) exitWith {};

if (_value) then {
    //When button pressed
    switch (_name) do {
        case "defaultAction": {
            _heli setVariable ["fza_ah64_salvofired", 0];
            _heli setVariable ["fza_ah64_burst_fired", 0];
        };
        case "fza_ah64_laserDesig": {
            [_heli] call fza_fnc_laserArm;
        };
        case "fza_ah64_sightSelectHMD": {
            [_heli, "fza_ah64_sight", SIGHT_HMD] call fza_fnc_setSeatVariable;
            // Given up by its owner, the FCR's scan stops
            if (FCR_OWNER(_heli) == ([_heli] call fza_fnc_getSeat)) then {
                [_heli] call fza_fcr_fnc_stopScan;
                _heli setVariable ["fza_ah64_fcrOwner", "", true];
            };
            if (player == gunner _heli && {CPG_LINK(_heli)}) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
        };
        case "fza_ah64_sightSelectTADS": {
            // The TADS is the CPG's sight
            if (player == driver _heli) exitWith {};
            [_heli, "fza_ah64_sight", SIGHT_TADS] call fza_fnc_setSeatVariable;
            if (FCR_OWNER(_heli) == "cpg") then {
                [_heli] call fza_fcr_fnc_stopScan;
                _heli setVariable ["fza_ah64_fcrOwner", "", true];
            };
            if (CPG_LINK(_heli)) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
        };
        case "fza_ah64_sightSelectLink": {
            // The CPG's, with an FCR fitted and TADS or FCR as the sight; a second press unlinks
            if (player != gunner _heli || {_heli animationPhase "fcr_enable" != 1}) exitWith {};
            private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
            if !(_sight in [SIGHT_TADS, SIGHT_FCR]) exitWith {};
            private _link = !CPG_LINK(_heli);
            _heli setVariable ["fza_ah64_cpgLink", _link, true];
            if (_sight != SIGHT_TADS) exitWith {};
            // TADS-L: the CPG owns both sights, the FCR as a second sensor following the TADS LOS (fza_fcr_fnc_controller).
            // Taken from the pilot, its scan stops. Unlinked, the TADS is a sight without the FCR again, and its scan stops.
            if (_link) then {
                if (FCR_OWNER(_heli) != "cpg") then {[_heli] call fza_fcr_fnc_stopScan};
                _heli setVariable ["fza_ah64_fcrOwner", "cpg", true];
            } else {
                [_heli] call fza_fcr_fnc_stopScan;
                _heli setVariable ["fza_ah64_fcrOwner", "", true];
            };
        };
        case "fza_ah64_sightSlave": {
            [_heli] call fza_fnc_targetingSlave;
        };
        case "fza_ah64_nvsSelectPnvs";
        case "fza_ah64_nvsSelectTads": {
            // NVS SELECT PNVS / TADS: selecting a night vision sensor gives the other one to the other crew
            // station, the last selection holding
            private _seat = [_heli] call fza_fnc_getSeat;
            if (isNil "_seat") exitWith {};
            private _other = ["plt", "cpg"] select (_seat == "plt");
            _heli setVariable ["fza_ah64_nvsTadsSeat", [_other, _seat] select (_name == "fza_ah64_nvsSelectTads"), true];
        };
        case "fza_ah64_sightSelectFCR": {
            if (_heli animationPhase "fcr_enable" != 1) exitWith {};
            [_heli, "fza_ah64_sight", SIGHT_FCR] call fza_fnc_setSeatVariable;
            // Selected by the CPG, or the FCR taken by the pilot, the CPG's link drops
            if (CPG_LINK(_heli)) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
            // The FCR is shared: the crew station that selects it last owns it, and only the owner scans, slews and slaves it.
            // Taken from the other crew station, its scan stops.
            private _seat = [_heli] call fza_fnc_getSeat;
            if (FCR_OWNER(_heli) != _seat) then {[_heli] call fza_fcr_fnc_stopScan};
            _heli setVariable ["fza_ah64_fcrOwner", _seat, true];
            // FCR sight select commands the centerline to the acquisition LOS, the nose with FCR or FXD as the source:
            // the pilot's always, as the pilot is slaved on selection; the CPG's only while slaved (fza_fnc_targetingSlave)
            if (player == driver _heli || {_heli getVariable ["fza_ah64_cpgSlaved", false]}) then {
                [_heli, [_heli, [_heli] call fza_fnc_currentTurret] call fza_fnc_targetingCurAcq] call fza_fcr_fnc_slaveCenterline;
            };
            private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
            if ("fza_agm114l_wep" in _missiles) then {
                _heli setVariable ["fza_ah64_selectedMissile", "fza_agm114l_wep", true];
                [_heli] call fza_fnc_weaponUpdateSelected;
            };
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
                    _heli setVariable ["fza_ah64_bobpos", [(getPosASL _heli select 0), (getPosASL _heli select 1)], true];
                    _heli setVariable ["fza_ah64_bobhdg", getDir _heli, true];
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
            // The scan switch only works for the crew station that owns the FCR, by selecting it as its sight
            if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat)) exitWith {};
            private _fcrState = _heli getVariable "fza_ah64_fcrState";
            private _onGnd = [_heli] call bmkhs_fnc_stateOnGround;
            private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";
            if (!_gndOrideOn && _onGnd || _fcrState#0 == FCR_MODE_FAULT) exitWith {};
            if (_fcrState#0 != FCR_MODE_ON_SINGLE) exitWith {
                player action ["ActiveSensorsOn", _heli];
                [_heli, FCR_MODE_ON_SINGLE] call fza_fcr_fnc_armScanStart;
                _heli setVariable ["fza_ah64_fcrTargets", [], true];
            };
            [_heli] call fza_fcr_fnc_stopScan;
        };
        case "fza_ah64_cpgStoreUpdate": {
            // The CPG's: a target stored along the sight LOS at the range shown, 0 without one
            if (player != gunner _heli) exitWith {};
            private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
            private _acq = ["GHS", "TADS", "FCR"] select ([SIGHT_HMD, SIGHT_TADS, SIGHT_FCR] find _sight max 0);
            ([_heli, "cpg"] call fza_fnc_targetingRange) params ["_range", "_text"];
            if (_text in ["", "R??"]) then {_range = 0};
            private _posASL = (getPosASL _heli) vectorAdd ((vectorNormalized ([_heli, _acq] call fza_fnc_targetingAcqVec)) vectorMultiply _range);
            [_heli, _posASL] call fza_fnc_targetingStore;
        };
        case "fza_ah64_missileAdvance": {
            if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_MSL && ([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) then {
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
        // A new mode cancels the scan; re-selecting the active mode is ignored, except RMAP where it toggles the video
        // (see fza_fcr_fnc_setMode)
        case "fza_ah64_fcrModeGTM": {
            [_heli, FCR_DISP_MODE_GTM] call fza_fcr_fnc_setMode;
        };
        case "fza_ah64_fcrModeRMAP": {
            [_heli, FCR_DISP_MODE_RMAP] call fza_fcr_fnc_setMode;
        };
        case "fza_ah64_fcrModeATM": {
            [_heli, FCR_DISP_MODE_ATM] call fza_fcr_fnc_setMode;
        };
        case "fza_ah64_fcrModeTPM": {
            [_heli, FCR_DISP_MODE_TPM] call fza_fcr_fnc_setMode;
        };
        // Scan size switch, for the crew station owning the FCR; a new size stops a running scan
        case "fza_ah64_fcrScanSize_W";
        case "fza_ah64_fcrScanSize_M";
        case "fza_ah64_fcrScanSize_N";
        case "fza_ah64_fcrScanSize_Z": {
            if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat)) exitWith {};
            private _size = ["fza_ah64_fcrScanSize_W", "fza_ah64_fcrScanSize_M", "fza_ah64_fcrScanSize_N", "fza_ah64_fcrScanSize_Z"] find _name;
            if (_size == (_heli getVariable ["fza_ah64_fcrScanSize", 0])) exitWith {};
            [_heli] call fza_fcr_fnc_stopScan;
            _heli setVariable ["fza_ah64_fcrScanSize", _size, true];
        };
        case "launchCM": {
            [_heli] call fza_ase_fnc_Chaff;
        };
        case "fza_ah64_flare": {
            [_heli] call fza_ase_fnc_Flare;
        };
        case "zoomIn": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsSelectedFov";
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode in [1, 2]) exitWith { //FLIR is free to zoom into 1,2,3
                _zoomindex = [_inputindex + 1, 1, 3] call BIS_fnc_clamp;
                _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
            };
            if (_Visionmode == 0) exitWith { //DTV can only ZOOM into 2,3
                _zoomindex = [_inputindex + 1, 2, 3] call BIS_fnc_clamp;
                _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
            };
            if (_Visionmode == 3) exitWith { //DVO can only Zoom into 1
                _heli setVariable ["fza_ah64_tadsSelectedFov", 1];
            };
        };
        case "zoomOut": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsSelectedFov";
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode in [1, 2]) exitWith { //FLIR is free to zoom out to 0,1,2,
                _zoomindex = [_inputindex - 1, 0, 2] call BIS_fnc_clamp;
                _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
            };
            if (_Visionmode == 0) exitWith { //DTV can only ZOOM out to 0,2
                _zoomindex = [_inputindex - 1, 0, 2] call BIS_fnc_clamp;
                if (_zoomindex == 1) then {_zoomindex = 0;}; //Skipp Medium on DTV
                _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
            };
            if (_Visionmode == 3) exitWith { //DVO can only Zoom out to 1
                _heli setVariable ["fza_ah64_tadsSelectedFov", 0];
            };
        };
        case "NightVision": {
            if (player != gunner _heli) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsSelectedFov";
            private _flirDamage = _heli getHitPointDamage "hit_msnEquip_tads_flir";
            private _dtvDamage  = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
            private _tadsVision = _heli getVariable "fza_ah64_tadsSelectedSensor";
            private _Visionmode = _heli currentVisionMode [0];
            private _a3ti_vis   = call A3TI_fnc_getA3TIVision;
            if !(isNil "_a3ti_vis") exitWith {};

            //End of FLir Cylce
            if (_Visionmode#0 == 2 && _Visionmode#1 == 1) then {
                if (fza_ah64_tadsCycleIncludeDTV && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitWith {
                    ["fza_ah64_SensorSelect_DTV", true] call fza_fnc_coreControlHandle;
                };
                if (fza_ah64_tadsCycleIncludeDVO && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitWith {
                    ["fza_ah64_SensorSelect_DVO", true] call fza_fnc_coreControlHandle;
                };
            };

            //End of DTV Cycle
            if (_tadsVision == "DTV") then {
                if (fza_ah64_tadsCycleIncludeDVO && _dtvDamage < SYS_SIGHT_DMG_THRESH) exitWith { //should be DVO damage
                    ["fza_ah64_SensorSelect_DVO", true] call fza_fnc_coreControlHandle;
                };
                if (_flirDamage < SYS_SIGHT_DMG_THRESH) exitWith {
                    ["fza_ah64_SensorSelect_FLIR", true] call fza_fnc_coreControlHandle;
                };
            };

            //End of DVO Cycle
            if (_tadsVision == "DVO") then {
                if (_flirDamage < SYS_SIGHT_DMG_THRESH) exitWith {
                    ["fza_ah64_SensorSelect_FLIR", true] call fza_fnc_coreControlHandle;
                };
            };
        };
        case "fza_ah64_tadsLHGFov_W": {
            if (player != gunner _heli) exitWith {};
            _heli setVariable ["fza_ah64_tadsSelectedFov", 0];
        };
        case "fza_ah64_tadsLHGFov_M": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 1;
            if (_Visionmode == 0) then {_zoomindex = 0;}; //DTV Cannot use Meduim, skip to Wide (0)
            _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
        };
        case "fza_ah64_tadsLHGFov_N": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 2;
            if (_Visionmode == 3) then {_zoomindex = 1;}; //DVO cannot surpase Medium (1)
            _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
        };
        case "fza_ah64_tadsLHGFov_Z": {
            if (player != gunner _heli) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            private _zoomindex  = 3;
            if (_Visionmode == 3) then {_zoomindex = 1;}; //DVO cannot surpase Medium (1)
            _heli setVariable ["fza_ah64_tadsSelectedFov", _zoomindex];
        };
        case "fza_ah64_SensorSelect_FLIR": {
            if (player != gunner _heli || {(_heli getVariable "fza_ah64_tadsSelectedSensor") == "FLIR"}) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitWith {};
            _heli setVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
        };
        case "fza_ah64_SensorSelect_DTV": {
            if (player != gunner _heli || {(_heli getVariable "fza_ah64_tadsSelectedSensor") == "DTV"}) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsSelectedFov";
            if (_inputindex == 1) then {_heli setVariable ["fza_ah64_tadsSelectedFov", 0];};
            _heli setVariable ["fza_ah64_tadsSelectedSensor", "DTV"];
        };
        case "fza_ah64_SensorSelect_DVO": {
            if (player != gunner _heli || {(_heli getVariable "fza_ah64_tadsSelectedSensor") == "DVO"}) exitWith {};
            private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
            if (_Visionmode == 1) exitWith {};
            private _inputindex = _heli getVariable "fza_ah64_tadsSelectedFov";
            if (_inputindex > 1) then {_heli setVariable ["fza_ah64_tadsSelectedFov", 1];};
            _heli setVariable ["fza_ah64_tadsSelectedSensor", "DVO"];
        };
        case "fza_ah64_tadsLHGLmc": {
            if (player != gunner _heli) exitWith {};
            private _lmc = _heli getVariable "fza_ah64_LmcActive";
            _heli setVariable ["fza_ah64_LmcActive", !_lmc, true];
        };
        case "Headlights": {
            private _lightval = _heli getVariable "fza_ah64_lightSearchLight";
            _heli setVariable ["fza_ah64_lightSearchLight", !_lightval, true];
        };
        case "fza_ah64_collectiveEmergJett": {
            _heli spawn fza_weapons_fnc_jettisonAll;
        };
        case "fza_minigame_up": {
            ["up", true] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_down": {
            ["down", true] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_left": {
            ["left", true] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_right": {
            ["right", true] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_fire": {
            ["fire", true] call fza_mg_fnc_minigameHandleInput;
        };
    };
};

if !(_value) then {
    //When button releassed
    switch (_name) do {
        case "fza_ah64_laserDesig": {
            [_heli] call fza_fnc_laserDisarm;
        };
        case "fza_minigame_up": {
            ["up", false] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_down": {
            ["down", false] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_left": {
            ["left", false] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_right": {
            ["right", false] call fza_mg_fnc_minigameHandleInput;
        };
        case "fza_minigame_fire": {
            ["fire", false] call fza_mg_fnc_minigameHandleInput;
        };
    };
};
