/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_handleControl

Description:
    Handles any ihadss-related cockpit controls. The "video" system's
    controls are the crew station's video knobs, <knob>Inc or <knob>Dec
    (ihadssBrt, ihadssCon, symBrt, flirLvl, flirGain), and acm to toggle ACM.

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

// The pilot's VIDEO panel and the CPG's equivalent, each acting on its own crew station's (fza_ihadss_fnc_videoPanel)
if (_system == "video") exitWith {
    private _len   = count _control;
    private _dir   = ["Dec", "", "Inc"] find (_control select [(_len - 3) max 0]);
    private _index = ["ihadssBrt", "ihadssCon", "symBrt", "flirLvl", "flirGain"] find (_control select [0, (_len - 3) max 0]);
    if (_index >= 0 && {_dir in [0, 2]}) exitWith {
        [_heli, _index, (([_heli] call fza_ihadss_fnc_videoPanel) # _index) + (_dir - 1) * VIDEO_PANEL_STEP] call fza_ihadss_fnc_videoPanelSet;
    };
    if (_control == "acm") then {
        [_heli, VIDEO_PANEL_ACM, 1 - (([_heli] call fza_ihadss_fnc_videoPanel) # VIDEO_PANEL_ACM)] call fza_ihadss_fnc_videoPanelSet;
    };
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
