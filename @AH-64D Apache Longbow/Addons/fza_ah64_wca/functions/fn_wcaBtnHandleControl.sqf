params ["_heli", "_system", "_control"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

switch (_control) do {
    case "armSafe": {
        if (!_gndOrideOn && _onGnd) exitWith {};
        
        _heli setVariable     ["fza_ah64_armSafeArmed", !(_heli getVariable "fza_ah64_armSafeArmed"), true];
        _heli setUserMfdValue [MFD_IND_ARM_SAFE, BOOLTONUM(_heli getVariable "fza_ah64_armSafeArmed")];
        
        [_heli] call fza_fnc_weaponUpdateSelected;
        
        playsound "fza_ah64_switch_flip4";
    };
    case "gndOride": {
        _heli setVariable     ["fza_ah64_gndOrideOn", !(_heli getVariable "fza_ah64_gndOrideOn"), true];
        _heli setUserMfdValue [MFD_IND_GND_ORIDE, BOOLTONUM(_heli getVariable "fza_ah64_gndOrideOn")];
        
        playsound "fza_ah64_switch_flip4";
    };
    case "emerHyd": {
        _heli setVariable     ["fza_ah64_emerHydOn", !(_heli getVariable "fza_ah64_emerHydOn"), true];
        _heli setUserMfdValue [MFD_IND_EMER_HYD, BOOLTONUM(_heli getVariable "fza_ah64_emerHydOn")];

        playsound "fza_ah64_switch_flip4";
    };
    case "mstrCaut": {
        _heli setVariable     ["fza_ah64_mstrCautLightOn", !(_heli getVariable "fza_ah64_mstrCautLightOn"), true];
        _heli setUserMfdValue [MFD_IND_MSTR_CAUT, BOOLTONUM(_heli getVariable "fza_ah64_mstrCautLightOn")];

        playsound "fza_ah64_switch_flip4";
    };
    case "mstrWarn": {
        _heli setVariable     ["fza_ah64_mstrWarnLightOn", !(_heli getVariable "fza_ah64_mstrWarnLightOn"), true];
        _heli setUserMfdValue [MFD_IND_MSTR_WARN, BOOLTONUM(_heli getVariable "fza_ah64_mstrWarnLightOn")];

        playsound "fza_ah64_switch_flip4";
    };
};