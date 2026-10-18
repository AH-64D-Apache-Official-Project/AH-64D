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
[_heli, "fza_ah64_sight", SIGHT_HMD] call fza_fnc_setSeatVariable;
// The seat starts on the HMD, so it no longer owns the FCR
private _seat = [_heli] call fza_fnc_getSeat;
if (!isNil "_seat" && {FCR_OWNER(_heli) == _seat}) then {_heli setVariable ["fza_ah64_fcrOwner", "", true]};
if (_unit == gunner _heli && {CPG_LINK(_heli)}) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
_heli setVariable ["fza_ah64_nvsModeSwitchNorm", 0];
_heli setVariable ["fza_ah64_monocleinbox", true];
[_unit] call fza_ihadss_fnc_hduUpdate;
