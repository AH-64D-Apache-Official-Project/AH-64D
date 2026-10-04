#define QUOTE(x) #x
#undef COCKPIT_CONTROL
#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, moving_point) \
    QUOTE(fza_ah64_cockpit_##system##_##control)
#undef COCKPIT_CONTROL_SEP
#define COCKPIT_CONTROL_SEP() ,
class UserActionGroups {
    class fza_ah64 {// unique classname for your category
        name = "$STR_FZA_AH64_OFFICIAL_PROJECT"; // display name of your category
        group[] = {
            "fza_ah64_sightSelectHMD",
            "fza_ah64_sightSelectTADS",
            "fza_ah64_sightSelectFXD",
            "fza_ah64_sightSelectFCR",
            "fza_ah64_symbologySelectUp",
            "fza_ah64_symbologySelectDown",
            "fza_ah64_symbologySelectPress",
            "fza_ah64_laserDesig",
            "fza_ah64_fcrSingleScan",
            "fza_ah64_targetStoreUpdate",
            "fza_ah64_waypointIncrease",
            "fza_ah64_waypointDecrease",
            "fza_ah64_missileAdvance",
            "fza_ah64_wasGun",
            "fza_ah64_wasRkt",
            "fza_ah64_wasMsl",
            "fza_ah64_fcrModeSwitch_up",
            "fza_ah64_fcrModeSwitch_down",
            "fza_ah64_flare",
            "fza_ah64_tadsLHGFov_W",
            "fza_ah64_tadsLHGFov_M",
            "fza_ah64_tadsLHGFov_N",
            "fza_ah64_tadsLHGFov_Z",
            "fza_ah64_SensorSelect_FLIR",
            "fza_ah64_SensorSelect_DTV",
            "fza_ah64_SensorSelect_DVO",
            "fza_ah64_tadsLHGLmc",
            "fza_ah64_collectiveEmergJett"
        };
    };
    class fza_ah64_cockpit {
        name = "$STR_FZA_AH64_COCKPIT_CONTROLS";
        group[] = {
            #include "\fza_ah64_controls\headers\controls.hpp"
        };
    };
};
