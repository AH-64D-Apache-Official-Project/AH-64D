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
[_heli, _seat] call fza_fcr_fnc_releaseOwner;
// The seat left holds no weapon
if (_seat != "") then {[_heli, WAS_WEAPON_NONE, _seat] call fza_fnc_weaponActionSwitch};
// The CPG's seat is left on its defaults: the HMD as sight, the IAT off, the FLIR in wide, FXD as acquisition source,
// deslaved
if (_seat == "cpg") then {
    _heli setVariable ["fza_ah64_sight_cpg", SIGHT_HMD, true];
    if (CPG_LINK(_heli)) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
    [_heli] call fza_ihadss_fnc_iatDisengage;
    _heli setVariable ["fza_ah64_tadsSelectedSensor", "FLIR", true];
    _heli setVariable ["fza_ah64_tadsSelectedFov", 0, true];
    _heli setVariable ["fza_ah64_acq_cpg", "FXD", true];
    _heli setVariable ["fza_ah64_cpgSlaved", false, true];
};
// Leaving with the TADS turned as this seat's NVS sensor, it is set back to the turret now (fza_ihadss_fnc_tadsNvsControl)
if (_heli getVariable ["fza_ihadss_tadsNvsDriving", false]) then {[_heli] call fza_ihadss_fnc_tadsNvsReset};
// The DTV camera ends itself once the DTV is no longer shown (fza_ihadss_fnc_dtvCamera)
fza_ihadss_dtvShownAt = -1e6;
[_heli] call fza_ihadss_fnc_controller;
[_unit] call fza_ihadss_fnc_hduUpdate;
