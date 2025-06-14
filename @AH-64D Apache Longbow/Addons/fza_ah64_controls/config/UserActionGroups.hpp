#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, moving_point) \
    fza_ah64_cockpit_##system##_##control

#define COCKPIT_CONTROL_SEP ,
class UserActionGroups
{
    class fza_ah64 // unique classname for your category
    {
        name = "AH-64D Apache Official"; // display name of your category
        group[] = {
            fza_ah64_sightSelectHMD,
            fza_ah64_sightSelectTADS,
            fza_ah64_sightSelectFXD,
            fza_ah64_sightSelectFCR,
            fza_ah64_symbologySelectUp,
            fza_ah64_symbologySelectDown,
            fza_ah64_symbologySelectPress,
            fza_ah64_laserDesig,
            fza_ah64_fcrSingleScan,
            fza_ah64_targetStoreUpdate,
            fza_ah64_crosshairInteract,
            fza_ah64_waypointIncrease,
            fza_ah64_waypointDecrease,
            fza_ah64_missileAdvance,
            fza_ah64_wasGun,
            fza_ah64_wasRkt,
            fza_ah64_wasMsl,
            fza_ah64_forceTrimHoldModeSwitch_up,
            fza_ah64_forceTrimHoldModeSwitch_right,
            fza_ah64_forceTrimHoldModeSwitch_down,
            fza_ah64_forceTrimHoldModeSwitch_left,
            fza_ah64_fcrModeSwitch_up,
            fza_ah64_fcrModeSwitch_down,
            fza_ah64_flare,
            fza_ah64_freeCursor,
            fza_ah64_tadsLHGFov_W,
            fza_ah64_tadsLHGFov_M,
            fza_ah64_tadsLHGFov_N,
            fza_ah64_tadsLHGFov_Z,
            fza_ah64_SensorSelect_FLIR,
            fza_ah64_SensorSelect_DTV,
            fza_ah64_SensorSelect_DVO,
            fza_ah64_tadsLHGLmc,
            fza_ah64_stickyControlInterupt,
            fza_ah64_forceTrimPanicButton,
        };
    };
    class fza_ah64_cockpit
    {
        name = "AH-64D Apache Official: Cockpit Controls";
        group[] = {
            #include "\fza_ah64_controls\headers\controls.h"
        };
    };
    class fza_ah64_input
    {
        name = "AH-64D Apache Official: Input Controls";
        group[] = {
            fza_ah64_cyclicForward,
            fza_ah64_cyclicBackward,
            fza_ah64_cyclicLeft,
            fza_ah64_cyclicRight,
            fza_ah64_pedalLeft,
            fza_ah64_pedalRight,
            fza_ah64_collectiveUp,
            fza_ah64_collectiveDn
        };
    };
};