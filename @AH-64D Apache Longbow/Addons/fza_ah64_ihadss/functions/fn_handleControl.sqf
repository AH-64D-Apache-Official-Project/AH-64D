/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_handleControl

Description:
    Handles any ihadss-related cockpit controls.

Parameters:
    _heli - The helicopter to act on
    _system - the name of the system that the touched control belongs to
    _control - the name of the control that has been touched

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "ihadss", "brt"] call ihadssHandleControl
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
    case "stow": {
        playsound "fza_ah64_monoclebox";
        [_heli] call fza_ihadss_fnc_monocletoggle;
    };
    case "nvsSwitchToggle": {
        private _nvsSwitch = (if (driver _heli == player) then {"plt_nvsmode"} else {"cpg_nvsmode"});
        private _nvsState  = _heli getVariable "fza_ah64_ihadss_pnvs_cam";
        if (_nvsState == 0) then {
            _heli animateSource[_nvsSwitch, 0.5];
            _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 0.5];
        };
        if (_nvsState == 0.5) then {
            _heli animateSource[_nvsSwitch, 1];
            _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 1];
        };
        if (_nvsState == 1) then {
            _heli animateSource[_nvsSwitch, 0];
            _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 0];
        };
        playsound "fza_ah64_switch_flip3";
    };
    Case "OFF": {
        _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 0];
    };
    Case "NORM": {
        _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 0.5];
    };
    Case "FIXED": {
        _heli setVariable ["fza_ah64_ihadss_pnvs_cam", 1];
    };
};