params["_name", "_value"];

if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

if (value) then {
	switch (_name) do {
		case "fza_ah64_crosshairAction": {
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

			// I haven't gotten these to work reliably enough to make it worth adding. Leaving here just in case that changes
			// - mattysmith22

			/*

			//ownship [0.18,4.1,-0.735]
			private _ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_rmpd_ownship");
			if (player == gunner _heli) then {
				_ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_g_rmpd_ownship");
			};
			_ownship = worldtoscreen _ownship;
			if (count _ownship < 2) then {
				_ownship = [0, 0];
			};*/
		};
		case "fza_ah64_cycleMPDLeft": {
			switch ([_heli, 0] call fza_fnc_mpdGetCurrentDisplay) do {
				case "fuel": {
					[_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
				};
				case "wpn": {
					[_heli, 0, "wca"] call fza_fnc_mpdSetDisplay;
				};
				case "wca": {
					[_heli, 0, "flt"] call fza_fnc_mpdSetDisplay;
				};
				case "flt": {
					[_heli, 0, "fuel"] call fza_fnc_mpdSetDisplay;
				}
			}
		};
		case "fza_ah64_cycleMPDRight": {
			switch ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay) do {
				case "tsd": {
					[_heli, 1, "fcr"] call fza_fnc_mpdSetDisplay;
				};
				case "fcr": {
					[_heli, 1, "wca"] call fza_fnc_mpdSetDisplay;
				};
				case "wca": {
					[_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
				};
				case "ase": {
					[_heli, 1, "eng"] call fza_fnc_mpdSetDisplay;
				};
				case "eng": {
					[_heli, 1, "tsd"] call fza_fnc_mpdSetDisplay;
				};
			}
		};
		case "fza_ah64_radarMode": {
			_heli setVariable ["fza_ah64_agmode", (_heli getVariable "fza_ah64_agmode") + 1, true]; 
		};
		case "fza_ah64_was": {
			[_heli] call fza_fnc_weaponActionSwitch;
		};
		case "fza_ah64_laserDesig": {
			[_heli] call fza_fnc_laserArm;
		};
		case "fza_ah64_targFilter": {
			[_heli] call fza_fnc_tsdFilter;
		};
		case "fza_ah64_tsdRange": {
			[_heli] call fza_fnc_tsdRange;
		};
		case "fza_ah64_tsdMode": {
			switch(_heli getVariable "fza_ah64_tsdmode") do {
				case "nav": {
					_heli setVariable ["fza_ah64_tsdmode", "atk"];
					[_heli] call fza_fnc_targetingVariable;
				};
				case "atk": {
					_heli setVariable ["fza_ah64_tsdmode", "nav"];
				};
			}
		};
		case "fza_ah64_pfzSelect": {
			[_heli] call fza_fnc_targetingPFZCycle;
		};
		case "fza_ah64_toggleIHADSS": {
			[_heli] call fza_fnc_ihadsstoggle;
		};
		case "fza_ah64_toggleNVS": {
			_heli setVariable ["fza_ah64_ihadss_pnvs_cam", !(_heli getVariable "fza_ah64_ihadss_pnvs_cam")];
		};
		case "fza_ah64_modeIHADSS": {
			_heli setVariable ["fza_ah64_hmdfsmode",
				switch (_heli getVariable "fza_ah64_hmdfsmode") do {
					case "trans": {"cruise"};
					case "cruise": {"hover"};
					case "hover": {
						_heli setVariable ["fza_ah64_bobpos", [(getposasl _heli select 0), (getposasl _heli select 1)], true];
						_heli setVariable ["fza_ah64_bobhdg", getdir _heli, true];
						"bobup"
					};
					case "bobup": {"trans"};
				}
				, true];
		};
		case "fza_ah64_jammersToggle": {
			if (_heli getVariable "fza_ah64_rfjstate" == 1) exitwith {
				_heli setVariable ["fza_ah64_rfjstate", 0, true];
			};
			if (_heli getVariable "fza_ah64_irjstate" == 1) exitwith {
				_heli setVariable ["fza_ah64_irjstate", 0, true];
			};

			_heli setVariable ["fza_ah64_rfjstate", (_heli getVariable "fza_ah64_rfjstate") + 1, true];
			_heli setVariable ["fza_ah64_irjstate", (_heli getVariable "fza_ah64_irjstate") + 1, true];
		};
		case "fza_ah64_autopage": {
			switch(_heli getVariable "fza_ah64_aseautopage") do {
				case 0: {
					_heli setVariable ["fza_ah64_aseautopage", 1];
				};
				case 1: {
					_heli setVariable ["fza_ah64_aseautopage", 2];
				};
				case 2: {
					_heli setVariable ["fza_ah64_aseautopage", 0];
				};
			};
		};
		case "fza_ah64_laserCycle": {
			[_heli] call fza_fnc_laserCycle;
		};
		case "fza_ah64_headTrackingToggle": {
			fza_ah64_tiron = !fza_ah64_tiron;
		};
		case "fza_ah64_lockCameraToTarget": {
			[_heli] call fza_fnc_targetingLockCamToTarget;
		};
	}
}

if !(value) then {
	switch (_name) do {
		case "fza_ah64_laserDesig": {
			[_heli] call fza_fnc_laserDisarm;
		};
	};
};