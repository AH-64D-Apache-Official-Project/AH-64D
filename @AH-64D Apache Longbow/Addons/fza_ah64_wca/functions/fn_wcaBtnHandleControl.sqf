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