/* ----------------------------------------------------------------------------
Function: fza_fnc_eventGetOut

Description:
    Event handler that finishes parts of apache logic when someone gets out.

    Closes HUD UI

Parameters:
    _heli - the helicopter to modify

Returns:
    Nothing

Examples:

Author:
    unknown
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli","_role","_unit"];

if (player != _unit) exitWith {};
// Leaving the seat that owns the FCR, its scan stops; the radar goes off where the aircraft is local
// (fza_fcr_fnc_stateControl, with no owner)
private _seat = ["", "plt", "cpg"] select ((["driver", "gunner"] find _role) + 1);
if (_seat != "" && {FCR_OWNER(_heli) == _seat}) then {
    [_heli] call fza_fcr_fnc_stopScan;
    _heli setVariable ["fza_ah64_fcrOwner", "", true];
};
// Leaving with the TADS turned as this seat's NVS sensor, it is set back to the turret now (fza_ihadss_fnc_tadsNvsControl)
if (_heli getVariable ["fza_ihadss_tadsNvsDriving", false]) then {
    _heli setVariable ["fza_ihadss_tadsNvsDriving", false];
    _heli setVariable ["fza_ihadss_tadsNvsLos", nil];
    [_heli, "tads_nvs_tur", 0, true] call fza_anim_fnc_updateAnimations;
    [_heli, "tads_nvs", 0, true] call fza_anim_fnc_updateAnimations;
};
[_heli] call fza_ihadss_fnc_controller;
[_unit] call fza_ihadss_fnc_hduUpdate;
