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

private _onGnd      = [_heli] call fza_sfmplus_fnc_onGround;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";
private _battBusOn = _heli getVariable "fza_systems_battBusOn";

if (!_gndOrideOn && _onGnd || !_battBusOn) then {
    [_heli, "fza_ah64_armSafeArmed", false] call fza_fnc_updateNetworkGlobal;
    [_heli, WAS_WEAPON_NONE] call fza_fnc_weaponActionSwitch;
};

[_heli, MFD_IND_ARM_SAFE,  BOOLTONUM(_heli getVariable "fza_ah64_armSafeArmed")] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_IND_GND_ORIDE, BOOLTONUM(_heli getVariable "fza_ah64_gndOrideOn")] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_IND_EMER_HYD,  BOOLTONUM(_heli getVariable "fza_ah64_emerHydOn")] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_IND_MSTR_CAUT, BOOLTONUM(_heli getVariable "fza_ah64_mstrCautLightOn")] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_IND_MSTR_WARN, BOOLTONUM(_heli getVariable "fza_ah64_mstrWarnLightOn")] call fza_mpd_fnc_updateMfdValue;