params ["_heli", "_system", "_control"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

switch (_control) do {
    case "armSafe": {
        if (!_gndOrideOn && _onGnd) exitWith {};
        _heli setVariable     ["fza_ah64_armSafeArmed", !(_heli getVariable "fza_ah64_armSafeArmed"), true];
        _turret = [1,0] select _heli unitTurret player;
        [_heli] remoteExec ["fza_fnc_weaponUpdateSelected", _turret]
        playsound "fza_ah64_switch_flip4";
    };
    case "gndOride": {
        _heli setVariable     ["fza_ah64_gndOrideOn", !(_heli getVariable "fza_ah64_gndOrideOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
    case "emerHyd": {
        _heli setVariable     ["fza_ah64_emerHydOn", !(_heli getVariable "fza_ah64_emerHydOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
    case "mstrCaut": {
        _heli setVariable     ["fza_ah64_mstrCautLightOn", !(_heli getVariable "fza_ah64_mstrCautLightOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
    case "mstrWarn": {
        _heli setVariable     ["fza_ah64_mstrWarnLightOn", !(_heli getVariable "fza_ah64_mstrWarnLightOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
};