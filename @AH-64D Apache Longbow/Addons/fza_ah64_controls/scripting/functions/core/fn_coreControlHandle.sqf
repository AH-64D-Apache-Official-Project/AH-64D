#include "\fza_ah64_controls\headers\systemConstants.h"

params["_name", "_value"];

if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

if (value) then {
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

			private _clickSound = ["none"];

			switch (_system) do {
				case "lmpd";
				case "rmpd" : {
					_clickSound = [_heli, _system, _control] call fza_fnc_mpdHandleControl;
				};
				case "fire": {
					_clickSound = [_heli, _system, _control] call fza_fnc_fireHandleControl;
				};
				case "door": {
					if (_control == "handle") then {
						if (player == gunner _heli) then {
							[_heli] spawn fza_fnc_doortoggleG;
						} else {
							[_heli] spawn fza_fnc_doortogglep;
						};
					}
				};
				case "engine": {
					[_heli, _system, _control] call fza_fnc_engineHandleControl;
				};
				case "ihadss": {
					_clickSound = [_heli, _system, _control] call fza_fnc_ihadssHandleControl;
				};
				case "pnvs": {
					if (_control == "daynight") then {
						_heli setVariable ["fza_ah64_ihadss_pnvs_day", !(_heli getVariable "fza_ah64_ihadss_pnvs_day")];
						["fza_ah64_knob", 0.1] spawn fza_fnc_playAudio;
					}
				};
				case "nvs": {
					private _nvsSwitch = (if (driver _heli == player) then {"plt_nvsmode"} else {"cpg_nvsmode"});
					if (_control == "mode") then {
						if (_heli animationphase _nvsSwitch < 1) then {
							_heli animateSource[_nvsSwitch, 1];
							_heli setVariable ["fza_ah64_ihadss_pnvs_cam", true];
						} else {
							_heli animateSource[_nvsSwitch, 0];
							_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
						};
						["fza_ah64_switch_flip3", 0.1] spawn fza_fnc_playAudio;
					}
				};
				case "light": {
					_clickSound = [_heli, _system, _control] call fza_fnc_lightHandleControl;
				};
			};
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
		case "fza_ah64_fcrModeGTM": {
			_heli setVariable ["fza_ah64_agmode", FCR_MODE_GND, true];
		};
		case "fza_ah64_fcrModeATM": {
			_heli setVariable ["fza_ah64_agmode", FCR_MODE_AIR, true];
		};
		case "fza_ah64_symbologySelectUp": {
			switch (_heli getVariable "fza_ah64_hmdfsmode") do {
				case "trans": {
					_heli setVariable ["fza_ah64_hmdfsmode", "cruise", true];
				};
				default: {
					_heli setVariable ["fza_ah64_hmdfsmode", "trans", true];
				};
			};
		};
		case "fza_ah64_symbologySelectUp": {
			switch (_heli getVariable "fza_ah64_hmdfsmode") do {
				case "hover": {
					_heli setVariable ["fza_ah64_bobpos", [(getposasl _heli select 0), (getposasl _heli select 1)], true];
					_heli setVariable ["fza_ah64_bobhdg", getdir _heli, true];
					_heli setVariable ["fza_ah64_hmdfsmode", "bobup", true];
				};
				default: {
					_heli setVariable ["fza_ah64_hmdfsmode", "hover", true];
				};
			};
		};
		case "fza_ah64_symbologySelectPress": {
			[_heli, 0, "flt"] call fza_fnc_mpdSetDisplay;
		};
		case "fza_ah64_fcrSingleScan": {
			player action ["ActiveSensorsOn", vehicle player];
			["fza_ah64_disableRadar", { player action ["ActiveSensorsOff", vehicle player]; }, 2, "seconds"] call BIS_fnc_runLater;
		};
		case "fza_ah64_targetStoreUpdate": {

			private _position = positionCameraToWorld [0.5, 0.5];
			
			if (_position distance (getPos _heli) > 7000) exitWith {};

			if (count (_heli getVariable "fza_ah64_waypointdata") > 30) exitwith {
				_heli vehiclechat "Waypoint limits reached.";
			};

			_heli setVariable ["fza_ah64_waypointdata", (_heli getVariable "fza_ah64_waypointdata") + [[(_position select 0), (_position select 1), 0]], true];
		};
		case "fza_ah64_waypointIncrease": {
			if (_heli getVariable "fza_ah64_curwpnum" < (count (_heli getVariable "fza_ah64_waypointdata") - 1)) then {
				_heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") + 1, true];
			};
		};
		case "fza_ah64_waypointDecrease": {
			if((_heli getVariable "fza_ah64_curwpnum") > 0) then {
				_heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") - 1, true];
			};
		};
		case "fza_ah64_laserCycle": {
			[_heli] call fza_fnc_laserCycle;
		};
		case "SwitchWeaponGrp1": {
			if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_GUN) {
				[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
			} else {
				[_heli, WAS_WEAPON_GUN] call fza_fnc_weaponActionSwitch;
			}
		};
		case "SwitchWeaponGrp2": {
			if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_RKT) {
				[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
			} else {
				[_heli, WAS_WEAPON_RKT] call fza_fnc_weaponActionSwitch;
			}
		};
		case "SwitchWeaponGrp3": {
			if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_MSL) {
				[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
			} else {
				[_heli, WAS_WEAPON_MSL] call fza_fnc_weaponActionSwitch;
			}
		};
		case "SwitchWeaponGrp4": {
			_heli setVariable ["fza_ah64_armed", !(_heli getVariable "fza_ah64_armed"), true];
		};
		case "nextWeapon";
		case "prevWeapon": {
			[_heli] call fza_fnc_weaponUpdateSelected;
		}
	};
};

if !(value) then {
	//When button releassed
	switch (_name) do {
		case "fza_ah64_laserDesig": {
			[_heli] call fza_fnc_laserDisarm;
		};
	};
};