#define CfgUserActionDef(vname, vdisplayName, vtooltip) \
class vname {\
	displayName = vdisplayName;\
	tooltip = vtooltip;\
	onActivate = __EVAL(format["['%1', true] call fza_fnc_coreControlHandle", #vname]);\
	onDeactivate = __EVAL(format["['%1', false] call fza_fnc_coreControlHandle", #vname]);\
}

#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name) \
class fza_ah64_cockpit_##system##_##control {\
	displayName = __EVAL(format["%1: %2", system_name, control_name]);\
	tooltip = "";\
	onActivate = __EVAL(format["['%1', '%2', '%3', '%4', true] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
	onDeactivate = __EVAL(format["['%1', '%2', '%3', '%4', false] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
};
#define COCKPIT_CONTROL_SEP 

class CfgUserActions
{
	CfgUserActionDef(fza_ah64_sightSelectHMD, "Sight Select HMD", "Sets the current sight to HMD");
	CfgUserActionDef(fza_ah64_sightSelectTADS, "Sight Select TADS", "Sets the current sight to TADS");
	CfgUserActionDef(fza_ah64_sightSelectFXD, "Sight Select FXD", "Sets the current sight to FXD");
	CfgUserActionDef(fza_ah64_sightSelectFCR, "Sight Select FCR", "Sets the current sight to FCR");
	CfgUserActionDef(fza_ah64_fcrModeGTM, "FCR Mode Select GTM", "Sets the current FCR mode to GTM (Ground Targeting Mode)");
	CfgUserActionDef(fza_ah64_fcrModeATM, "FCR Mode Select ATM", "Sets the current FCR mode to ATM (Air Targeting Mode)");
	CfgUserActionDef(fza_ah64_symbologySelectUp, "Symbology Select Up", "Cycles the HDU Symbology between Transition and Cruise modes");
	CfgUserActionDef(fza_ah64_symbologySelectDown, "Symbology Select Down", "Cycles the HDU Symbology between Hover and Bobup modes");
	CfgUserActionDef(fza_ah64_symbologySelectPress, "Symbology Select Press", "Brings up the FLT page on the left MPD");
	CfgUserActionDef(fza_ah64_laserDesig, "LRFD Second Detent (Lase)", "Lases the target when held down.");
	CfgUserActionDef(fza_ah64_fcrSingleScan, "FCR Single Scan", "Scans the FCR a single time");
	CfgUserActionDef(fza_ah64_targetStoreUpdate, "Target Store", "Stores the target being currently looked at in the TADS as a waypoint");
	CfgUserActionDef(fza_ah64_crosshairInteract, "Crosshair Action", "Interact with item in the cockpit under the crosshair");
	CfgUserActionDef(fza_ah64_waypointIncrease, "Next Waypoint", "Sets the current waypoint to the next waypoint");
	CfgUserActionDef(fza_ah64_waypointDecrease, "Previous Waypoint", "Sets the current waypoint to the previous waypoint");
	CfgUserActionDef(fza_ah64_laserCycle, "Laser Cycle", "Cycles between all available lasers");
	#include "\fza_ah64_controls\headers\controls.h"
};