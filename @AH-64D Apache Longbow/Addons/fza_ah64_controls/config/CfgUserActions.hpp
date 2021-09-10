class CfgUserActions
{
	class fza_ah64_crosshairAction
	{
		displayName = "Crosshair Action";
		tooltip = "Interact with item in the cockpit under the crosshair";
		onActivate = "['fza_ah64_crosshairAction', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_crosshairAction', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_crosshairAction', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_cycleMPDLeft
	{
		displayName = "Cycle Left MPD";
		tooltip = "Cycle between all values on the left MPD";
		onActivate = "['fza_ah64_cycleMPDLeft', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_cycleMPDLeft', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_cycleMPDLeft', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_cycleMPDRight
	{
		displayName = "Cycle Right MPD";
		tooltip = "Cycle between all values on the right MPD";
		onActivate = "['fza_ah64_cycleMPDRight', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_cycleMPDRight', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_cycleMPDRight', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_was
	{
		displayName = "Weapons Action Switch";
		tooltip = "Cycle between all weapons on the aircraft";
		onActivate = "['fza_ah64_was', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_was', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_was', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_radarMode
	{
		displayName = "Radar Mode";
		tooltip = "Cycle the radar between air and ground mode";
		onActivate = "['fza_ah64_radarMode', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_radarMode', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_radarMode', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_laserDesig
	{
		displayName = "Laser Designate";
		tooltip = "When held down, activates the laser designator";
		onActivate = "['fza_ah64_laserDesig', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_laserDesig', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_laserDesig', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_targFilter
	{
		displayName = "Cycle Target Filter";
		tooltip = "Cycle what targets will appear on the FCR / TSD";
		onActivate = "['fza_ah64_targFilter', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_targFilter', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_targFilter', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_tsdRange
	{
		displayName = "TSD Range";
		tooltip = "Cycle between TSD ranges";
		onActivate = "['fza_ah64_tsdRange', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_tsdRange', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_tsdRange', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_tsdMode
	{
		displayName = "TSD Mode";
		tooltip = "Switches between ATK and NAV mode";
		onActivate = "['fza_ah64_tsdMode', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_tsdMode', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_tsdMode', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_pfzSelect
	{
		displayName = "PFZ Cycle";
		tooltip = "Cycles the selected PFZ";
		onActivate = "['fza_ah64_pfzSelect', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_pfzSelect', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_pfzSelect', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_toggleIHADSS
	{
		displayName = "IHADSS Toggle";
		tooltip = "Toggle the IHADSS being on or off (requires monocle to be on)";
		onActivate = "['fza_ah64_toggleIHADSS', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_toggleIHADSS', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_toggleIHADSS', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_toggleNVS
	{
		displayName = "Toggle NVS";
		tooltip = "Toggles the night vision system being shown in the IHADSS";
		onActivate = "['fza_ah64_toggleNVS', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_toggleNVS', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_toggleNVS', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_modeIHADSS
	{
		displayName = "IHADSS Mode";
		tooltip = "Cycles between all IHADSS modes";
		onActivate = "['fza_ah64_modeIHADSS', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_modeIHADSS', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_modeIHADSS', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_jammersToggle
	{
		displayName = "Toggle Jammers";
		tooltip = "Toggles both RF and IR jammers (independently)";
		onActivate = "['fza_ah64_jammersToggle', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_jammersToggle', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_jammersToggle', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_autopage
	{
		displayName = "ASE Autopage";
		tooltip = "Cycles ASE Autopage modes";
		onActivate = "['fza_ah64_autopage', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_autopage', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_autopage', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_laserCycle
	{
		displayName = "Cycle Laser";
		tooltip = "Cycles the currently targeted laser";
		onActivate = "['fza_ah64_laserCycle', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_laserCycle', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_laserCycle', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_headTrackingToggle
	{
		displayName = "Toggle Head Tracking";
		tooltip = "Toggles head tracking mode (cursor freelook)";
		onActivate = "['fza_ah64_headTrackingToggle', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_headTrackingToggle', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_headTrackingToggle', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
	class fza_ah64_lockCameraToTarget
	{
		displayName = "Image Auto Track";
		tooltip = "Locks TADS onto the target being looked at";
		onActivate = "['fza_ah64_lockCameraToTarget', true] call fza_fnc_coreControlHandle";
		onDeactivate = "['fza_ah64_lockCameraToTarget', false] call fza_fnc_coreControlHandle";
		onAnalog = "['fza_ah64_lockCameraToTarget', _this > 0.5] call fza_fnc_coreControlHandle";
		analogChangeThreshold = 0.1;
	};
};