params ["_heli", "_system", "_control"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _onGnd      = [_heli] call fza_sfmplus_fnc_onGround;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";
private _battBusOn = _heli getVariable "fza_systems_battBusOn";

if !(_battBusOn) exitwith {};

switch (_control) do {
    case "armSafe": {
        if (!_gndOrideOn && _onGnd) exitWith {};
        _heli setVariable  ["fza_ah64_armSafeArmed", !(_heli getVariable "fza_ah64_armSafeArmed"), true];
        [_heli] remoteExec ["fza_fnc_weaponUpdateSelected", [_heli turretUnit [0], Driver _heli]];
    };
    case "gndOride": {
        _heli setVariable ["fza_ah64_gndOrideOn", !(_heli getVariable "fza_ah64_gndOrideOn"), true];
    };
    case "emerHyd": {
        _heli setVariable ["fza_ah64_emerHydOn", !(_heli getVariable "fza_ah64_emerHydOn"), true];
    };
    case "mstrCaut": {
        _heli setVariable ["fza_ah64_mstrCautLightOn", false];
        [_heli] call fza_audio_fnc_delCaution;
    };
    case "mstrWarn": {
        _heli setVariable ["fza_ah64_mstrWarnLightOn", false];
        [_heli] call fza_audio_fnc_delWarning;
    };
};