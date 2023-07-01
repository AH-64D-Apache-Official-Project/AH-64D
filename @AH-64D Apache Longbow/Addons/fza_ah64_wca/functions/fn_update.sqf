/* ----------------------------------------------------------------------------
Function: fza_wca_fnc_update

Description:
    handles the wca buttons
    
Parameters:

Returns:
    Nothing
    
Examples:


Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"


hintsilent format ["Master Arm Armed? %1
                    \nGnd Orid On? %2
                    \nEmer Hyd On? %3",_heli getVariable "fza_ah64_armSafeArmed", _heli getVariable "fza_ah64_gndOrideOn", _heli getVariable "fza_ah64_emerHydOn"];

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

if (!_gndOrideOn && _onGnd) then {
    _heli setVariable ["fza_ah64_armSafeArmed", false, true];
    [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
};