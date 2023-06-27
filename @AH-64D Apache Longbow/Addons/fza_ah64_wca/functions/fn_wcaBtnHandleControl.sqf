params ["_heli", "_system", "_control"];

systemChat "WCA Button Handle Control!";

switch (_control) do {
    case "armSafe": {
        systemChat "Arm/Safe";
        playsound "fza_ah64_switch_flip4";
    };
    case "gndOride": {
        systemChat "Gnd Oride";
        playsound "fza_ah64_switch_flip4";
    };
    case "emerHyd": {
        systemChat "Emer Hyd";

        if (!(_heli getVariable "fza_systems_accOn")) then {
            _heli setVariable ["fza_systems_accOn", true, true];
        } else {
            _heli setVariable ["fza_systems_accOn", false, true];
        };

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