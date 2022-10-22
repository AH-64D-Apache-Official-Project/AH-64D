#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name) \
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
			fza_ah64_laserCycle,
			fza_ah64_missileAdvance,
			fza_ah64_wasGun,
			fza_ah64_wasRkt,
			fza_ah64_wasMsl,
			fza_ah64_masterSafe,
			fza_ah64_forceTrimSwitchUp
		};
	};
	class fza_ah64_cockpit
	{
		name = "AH-64D Apache Official: Cockpit Controls";
		group[] = {
			#include "\fza_ah64_controls\headers\controls.h"
		};
	}
};