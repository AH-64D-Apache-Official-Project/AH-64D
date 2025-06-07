#define CfgUserActionDef(vname, vdisplayName, vtooltip) \
class vname {\
    displayName = vdisplayName;\
    tooltip = vtooltip;\
    onActivate = __EVAL(format["['%1', true] call fza_fnc_coreControlHandle", #vname]);\
    onDeactivate = __EVAL(format["['%1', false] call fza_fnc_coreControlHandle", #vname]);\
}

class CfgUserActions {
    CfgUserActionDef(fza_ah64_sightSelectHMD, "Sight Select HMD", "Sets the current sight to HMD");
    CfgUserActionDef(fza_ah64_sightSelectTADS, "Sight Select TADS", "Sets the current sight to TADS");
    CfgUserActionDef(fza_ah64_sightSelectFXD, "Sight Select FXD", "Sets the current sight to FXD");
    CfgUserActionDef(fza_ah64_sightSelectFCR, "Sight Select FCR", "Sets the current sight to FCR");
    CfgUserActionDef(fza_ah64_symbologySelectUp, "Symbology Select Up", "Cycles the HDU Symbology between Transition and Cruise modes");
    CfgUserActionDef(fza_ah64_symbologySelectDown, "Symbology Select Down", "Cycles the HDU Symbology between Hover and Bobup modes");
    CfgUserActionDef(fza_ah64_symbologySelectPress, "Symbology Select Press", "Brings up the FLT page on the left MPD");
    CfgUserActionDef(fza_ah64_laserDesig, "LRFD Second Detent (Lase)", "Lases the target when held down.");
    CfgUserActionDef(fza_ah64_fcrSingleScan, "FCR Single Scan", "Scans the FCR a single time");
    CfgUserActionDef(fza_ah64_targetStoreUpdate, "Target Store", "Stores the target being currently looked at in the TADS as a waypoint");
    CfgUserActionDef(fza_ah64_missileAdvance, "Missile Advance", "Advances through all missile types");
    CfgUserActionDef(fza_ah64_wasGun, "WAS Gun", "Action the gun in your crew station");
    CfgUserActionDef(fza_ah64_wasRkt, "WAS Rockets", "Action the rockets in your crew station");
    CfgUserActionDef(fza_ah64_wasMsl, "WAS Missiles", "Action the missiles in your crew station");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_up, "Force Trim/Hold Mode Switch Up", "When momentarily interupted, Updates the flight control reference position for Attitude Hold and de-activates Heading and Attitude Hold when held.");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_right, "Force Trim/Hold Mode Switch Right", "Activates Altitude Hold");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_down, "Force Trim/Hold Mode Switch Down", "De-Activates both Attitude and Altitude Hold");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_left, "Force Trim/Hold Mode Switch Left", "Activates Attitude Hold");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_up, "Ground Targeting Mode (GTM)", "Sets the Fire Control Radar To Ground Targeting Mode");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_down, "Air Targeting Mode (ATM)", "Sets the Fire Control Radar To Air Targeting Mode");
    CfgUserActionDef(fza_ah64_flare, "Deploy Flare", "Deploy a single Flare countermeasure");
    CfgUserActionDef(fza_ah64_tadsLHGFov_W, "TADS LHG FOV Switch - W", "Sets the Tads FOV to Wide");
    CfgUserActionDef(fza_ah64_tadsLHGFov_M, "TADS LHG FOV Switch - M", "Sets the Tads FOV to Medium");
    CfgUserActionDef(fza_ah64_tadsLHGFov_N, "TADS LHG FOV Switch - N", "Sets the Tads FOV to Narrow");
    CfgUserActionDef(fza_ah64_tadsLHGFov_Z, "TADS LHG FOV Switch - Z", "Sets the Tads FOV to Zoom");
    CfgUserActionDef(fza_ah64_SensorSelect_FLIR, "LHG Sensor Select Switch - FLIR", "Sets the Tads Sensor to FLIR");
    CfgUserActionDef(fza_ah64_SensorSelect_DTV, "LHG Sensor Select Switch - DTV", "Sets the Tads Sensor to DTV");
    CfgUserActionDef(fza_ah64_SensorSelect_DVO, "LHG Sensor Select Switch - DVO", "Sets the Tads Sensor to DVO");
    CfgUserActionDef(fza_ah64_tadsLHGLmc, "LHG LMC Button", "Toggles Tads Linear Motion Compensator");
    CfgUserActionDef(fza_ah64_stickyControlInterupt, "Sticky Control Interupt", "When using sticky cyclic, disables sticky cyclic for enhanced maneuvering.");
    CfgUserActionDef(fza_ah64_forceTrimPanicButton, "Force Trim Panic Button", "Zeroes out the force trim values.");
};