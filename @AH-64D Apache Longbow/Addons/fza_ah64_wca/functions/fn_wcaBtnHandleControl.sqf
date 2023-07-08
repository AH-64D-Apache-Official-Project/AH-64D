params ["_heli", "_system", "_control"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";
private _battBusOn = _heli getVariable "fza_systems_battBusOn";

if !(_battBusOn) exitwith {};

switch (_control) do {
    case "armSafe": {
        if (!_gndOrideOn && _onGnd) exitWith {};
        _heli setVariable  ["fza_ah64_armSafeArmed", !(_heli getVariable "fza_ah64_armSafeArmed"), true];
        [_heli] remoteExec ["fza_fnc_weaponUpdateSelected", [_heli turretUnit [0], Driver _heli]];
        playsound "fza_ah64_switch_flip4";
    };
    case "gndOride": {
        _heli setVariable ["fza_ah64_gndOrideOn", !(_heli getVariable "fza_ah64_gndOrideOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
    case "emerHyd": {
        _heli setVariable ["fza_ah64_emerHydOn", !(_heli getVariable "fza_ah64_emerHydOn"), true];
        playsound "fza_ah64_switch_flip4";
    };
    case "mstrCaut": {
        _heli setVariable ["fza_ah64_mstrCautLightOn", false, true];
        [_heli] call fza_audio_fnc_delCaution;

        playsound "fza_ah64_switch_flip4";
    };
    case "mstrWarn": {
        _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
        [_heli] call fza_audio_fnc_delWarning;
        playsound "fza_ah64_switch_flip4";
    };
};