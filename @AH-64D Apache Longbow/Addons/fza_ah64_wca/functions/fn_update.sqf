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

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

if (!_gndOrideOn && _onGnd) then {
    _heli setVariable ["fza_ah64_armSafeArmed", false, true];
    [_heli, WAS_WEAPON_NONE] remoteExec ["fza_fnc_weaponActionSwitch", [_heli turretUnit [0], _heli turretUnit [1]]];
};

_heli setUserMfdValue [MFD_IND_ARM_SAFE,  BOOLTONUM(_heli getVariable "fza_ah64_armSafeArmed")];
_heli setUserMfdValue [MFD_IND_GND_ORIDE, BOOLTONUM(_heli getVariable "fza_ah64_gndOrideOn")];
_heli setUserMfdValue [MFD_IND_EMER_HYD,  BOOLTONUM(_heli getVariable "fza_ah64_emerHydOn")];
_heli setUserMfdValue [MFD_IND_MSTR_CAUT, BOOLTONUM(_heli getVariable "fza_ah64_mstrCautLightOn")];
_heli setUserMfdValue [MFD_IND_MSTR_WARN, BOOLTONUM(_heli getVariable "fza_ah64_mstrWarnLightOn")];