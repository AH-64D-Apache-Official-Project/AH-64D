/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleCrosshairAction

Description:
    Called when the action crosshair button is pressed.

Parameters:
	_heli - The apache helicopter to handle a click for

Returns:
	Nothing

Examples:
	(begin example)
	// When you want to click what the player is looking at.
    [_heli] call fza_fnc_controlHandleCrosshairAction
	(end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli"];

private _controls = [_heli] call fza_fnc_coreGetObjectsLookedAt;

if (player != driver _heli && player != gunner _heli) exitWith {systemChat "None chosen"};

if (_controls isEqualTo []) exitWith {};

//If there are multiple controls in the range, make sure we use the closest one
if(count _controls > 1) then {
	_controls = [_controls, {}, {_x # 3}, "ASCEND"] call BIS_fnc_sortBy;
};

(_controls # 0) params ["", "", "_system", "_control"];

systemChat format ["System %1, Handle %2", _system, _control];

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
				[_heli, "gdoor"] execVM "\fza_ah64_controls\scripting\door_toggle.sqf";
			} else {
				[_heli, "pdoor"] execVM "\fza_ah64_controls\scripting\door_toggle.sqf";
			};
		}
	};
	case "engine": {
		_clickSound = [_heli, _system, _control] call fza_fnc_engineHandleControl;
	};
	case "ihadss": {
		_clickSound = [_heli, _system, _control] call fza_fnc_ihadssHandleControl;
	};
	case "pnvs": {
		if (_control == "daynight") then {
			if (fza_ah64_ihadss_pnvs_day) then {
				fza_ah64_ihadss_pnvs_day = false;
			} else {
				fza_ah64_ihadss_pnvs_day = true;
			};
			_clicksound = ["fza_ah64_knob", 0.1];
		}
	};
	case "nvs": {
		private _nvsSwitch = (if (driver _heli == player) then {"plt_nvsmode"} else {"cpg_nvsmode"});
		if (_control == "mode") then {
			if (_heli animationphase _nvsSwitch < 1) then {
				_heli animate[_nvsSwitch, 1];
				fza_ah64_ihadss_pnvs_cam = true;
			} else {
				_heli animate[_nvsSwitch, 0];
				fza_ah64_ihadss_pnvs_cam = false;
			};
			_clicksound = ["fza_ah64_switch_flip3", 0.1];
		}
	};
	case "light": {
		_clickSound = [_heli, _system, _control] call fza_fnc_lightHandleControl;
	};
};

if (count _clicksound > 1) then {
    _clicksound execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
};

//ownship [0.18,4.1,-0.735]
private _ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_rmpd_ownship");
if (player == gunner _heli) then {
    _ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_g_rmpd_ownship");
};
_ownship = worldtoscreen _ownship;
if (count _ownship < 2) then {
    _ownship = [0, 0];
};

//RIGHT MPD WP Add

if (fza_ah64_pr_mpd == "tsd" && fza_ah64_waypointfin == 0 && (_ownship select 0) > 0.3 && (_ownship select 0) < 0.7 && (_ownship select 1) > 0.3 && (_ownship select 1) < 0.9) then {
    _scalenum = 5;
    if (_rmpdllc distance _rmpdurc > 0.45) then {
        _scalenum = 2.5;
    };
    _direction = ((0.5) - (_ownship select 0)) atan2((_ownship select 1) - (0.5));
    _direction = _direction + getdir _heli;
    if (_direction < 0) then {
        _direction = _direction + 360;
    };
    if (_direction > 360) then {
        _direction = _direction - 360;
    };
    _wpposx = (getposatl _heli select 0) + ((sin _direction) * ((_scalenum / fza_ah64_rangesetting) * (_ownship distance[fza_ah64_mousehorpos, fza_ah64_mousevertpos])));
    _wpposy = (getposatl _heli select 1) + ((cos _direction) * ((_scalenum / fza_ah64_rangesetting) * (_ownship distance[fza_ah64_mousehorpos, fza_ah64_mousevertpos])));
    _wpadd = [_heli, [_wpposx, _wpposy]] execvm "\fza_ah64_controls\scripting\nav\wp_position.sqf";
};

//RIGHT MPD PFZ CREATE

if (fza_ah64_tsdmode == "ATK" && fza_ah64_pr_mpd == "tsd" && fza_ah64_pfz_count > 0 && (_ownship select 0) > 0.3 && (_ownship select 0) < 0.7 && (_ownship select 1) > 0.3 && (_ownship select 1) < 0.9) then {
    _scalenum = 5;
    if (_rmpdllc distance _rmpdurc > 0.45) then {
        _scalenum = 2.5;
    };
    _direction = ((0.5) - (_ownship select 0)) atan2((_ownship select 1) - (0.5));
    _direction = _direction + getdir _heli;
    if (_direction < 0) then {
        _direction = _direction + 360;
    };
    if (_direction > 360) then {
        _direction = _direction - 360;
    };
    _wpposx = (getposatl _heli select 0) + ((sin _direction) * ((_scalenum / fza_ah64_rangesetting) * (_ownship distance[fza_ah64_mousehorpos, fza_ah64_mousevertpos])));
    _wpposy = (getposatl _heli select 1) + ((cos _direction) * ((_scalenum / fza_ah64_rangesetting) * (_ownship distance[fza_ah64_mousehorpos, fza_ah64_mousevertpos])));
    fza_ah64_curpfzarea = fza_ah64_curpfzarea + [
        [_wpposx, _wpposy]
    ];
    fza_ah64_pfz_counter = fza_ah64_pfz_counter + 1;
};