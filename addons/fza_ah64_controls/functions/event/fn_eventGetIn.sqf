/* ----------------------------------------------------------------------------
Function: fza_fnc_eventGetIn

Description:
    Event handler that sets up apache when someone gets inside.

Parameters:
    _heli - the helicopter to modify

Returns:
    Nothing

Examples:

Author:
    unknown
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "", "_unit"];

if (player != _unit) exitWith {};
if (fza_ah64_showPopupv2_3 && !fza_ah64_introShownThisScenario && _unit == player && cba_missiontime != 0) then {
    createDialog "RscFzaDisplayWelcome";
};

[_heli,[], 0, 1] call fza_mpd_fnc_drawIcons;
[_heli,[], 1, 1] call fza_mpd_fnc_drawIcons;

[_heli] call fza_mpd_fnc_propagatePage;

//reset values
[_heli, "fza_ah64_sight", SIGHT_HMD, player, false, true] call fza_fnc_setSeatVariable;
// The seat starts on the HMD, so it no longer owns the FCR, and its scan stops
private _seat = [_heli] call fza_fnc_getSeat;
[_heli, _seat] call fza_fcr_fnc_releaseOwner;
// The crew station starts holding no weapon
[_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
if (_unit == gunner _heli && {CPG_LINK(_heli)}) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
// The crew station starts with its NVS MODE switch OFF; a TADS still turned for whoever had it as NVS here is set back
if (!isNil "_seat") then {
    _heli setVariable ["fza_ah64_nvsMode_" + _seat, NVS_MODE_OFF, true];
    _heli animateSource [["cpg_nvsmode", "plt_nvsmode"] select (_seat == "plt"), NVS_MODE_OFF];
    if ((_heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"]) == _seat) then {[_heli] call fza_ihadss_fnc_tadsNvsReset};
};
_heli setVariable ["fza_ah64_monocleinbox", true];
[_unit] call fza_ihadss_fnc_hduUpdate;
