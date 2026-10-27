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
#include "\fza_ah64_controls\headers\engineConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_system", "_control"];

// Each crew station's own NVS MODE switch (fza_ihadss_fnc_nvsState)
private _seat = [_heli] call fza_fnc_getSeat;
private _setNvsMode = {
    params ["_mode"];
    if (isNil "_seat") exitWith {};
    _heli setVariable ["fza_ah64_nvsMode_" + _seat, _mode, true];
    _heli animateSource [["cpg_nvsmode", "plt_nvsmode"] select (_seat == "plt"), _mode];
};

switch(_control) do {
    case "stow": {
        playSound "fza_ah64_monoclebox";
        [_heli] call fza_ihadss_fnc_monocletoggle;
    };
    case "nvsSwitchToggle": {
        // OFF, NORM, FIXED, OFF
        private _next = switch (([_heli] call fza_ihadss_fnc_nvsState) # 0) do {
            case NVS_MODE_OFF:  {NVS_MODE_NORM};
            case NVS_MODE_NORM: {NVS_MODE_FIXED};
            default             {NVS_MODE_OFF};
        };
        [_next] call _setNvsMode;
        playSound "fza_ah64_switch_flip3";
    };
    case (localize "STR_FZA_AH64_NVS_OFF"): {
        [NVS_MODE_OFF] call _setNvsMode;
    };
    case (localize "STR_FZA_AH64_NVS_NORM"): {
        [NVS_MODE_NORM] call _setNvsMode;
    };
    case (localize "STR_FZA_AH64_NVS_FIXED"): {
        [NVS_MODE_FIXED] call _setNvsMode;
    };
};
