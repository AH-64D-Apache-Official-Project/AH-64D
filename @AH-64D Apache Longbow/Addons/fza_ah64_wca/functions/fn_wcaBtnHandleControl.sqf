params ["_heli", "_system", "_control"];

private _onGnd      = isTouchingGround _heli;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";

switch (_control) do {
    case "armSafe": {
        if (!_gndOrideOn && _onGnd) exitWith {};

        _heli setVariable ["fza_ah64_armSafeArmed", !(_heli getVariable "fza_ah64_armSafeArmed"), true];
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
        systemChat "Master Caution";
        playsound "fza_ah64_switch_flip4";
    };
    case "mstrWarn": {
        systemChat "Master Warning";
        playsound "fza_ah64_switch_flip4";
    };
};