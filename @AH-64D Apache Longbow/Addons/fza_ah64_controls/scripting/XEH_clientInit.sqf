#include "\a3\ui_f\hpp\definedikcodes.inc"
#define MOD_NAME "AH-64D Apache"

#define ENSURE_IN_APACHE(expr) if(vehicle player isKindOf "fza_ah64base") then { expr };

#define CALL_ENSURE_IN_APACHE(func) ENSURE_IN_APACHE( [vehicle player] call func; )

[MOD_NAME, "crosshairAction", "Crosshair Action", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleCrosshairAction)
}, {}, [DIK_GRAVE, [false, false, false]]] call CBA_fnc_addKeybind;

[MOD_NAME, "cycleMPDLeft", "Cycle Left MPD", {
	ENSURE_IN_APACHE([vehicle player] execvm "\fza_ah64_controls\scripting\plmpdcycle.sqf")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "cycleMPDRight", "Cycle Left MPD", {
	ENSURE_IN_APACHE([vehicle player] execvm "\fza_ah64_controls\scripting\prmpdcycle.sqf")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "gunTracking", "Gun Tracking", {
	ENSURE_IN_APACHE([vehicle player] execvm "\fza_ah64_controls\scripting\guncontrol.sqf")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "was", "Weapon Action Switch", {
	CALL_ENSURE_IN_APACHE(fza_ah64_wepactionswitch)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "armLaserDesig", "Arm Laser Designation System", {
	CALL_ENSURE_IN_APACHE(fza_fnc_laserArm)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "targFilter", "TSD/FCR Filter", {
	ENSURE_IN_APACHE([vehicle player] exec "\fza_ah64_controls\scripting\tsd_targfilter.sqs")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "tsdRange", "TSD Range", {
	ENSURE_IN_APACHE([vehicle player] execVM "\fza_ah64_controls\scripting\tsd_range.sqf")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "tsdMode", "TSD Mode", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleTSDMode)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "pfzSelect", "PFZ Select", {
	CALL_ENSURE_IN_APACHE(fza_fnc_targetingPFZCycle)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "disarmLaserDesig", "Disarm Laser Designation System", {
	CALL_ENSURE_IN_APACHE(fza_fnc_laserArm)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "toggleIHADSS", "IHADSS Toggle", {
	ENSURE_IN_APACHE([vehicle player] exec "\fza_ah64_controls\scripting\ihadss.sqs")
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "toggleHDUPNVS", "HDU/PNVS Toggle", {
	ENSURE_IN_APACHE(fza_ah64_ihadss_pnvs_cam = !fza_ah64_ihadss_pnvs_cam;)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "jammersToggle", "Manual/Automatic Jammers Toggle", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleJammersToggle)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "aseAutopage", "ASE Autopage", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleASEAutopage)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "modeIHADSS", "IHADSS Mode", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleIHADSSMode)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "waypointNext", "Cycle Waypoint Forwards", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandleNextWaypoint)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "waypointPrev", "Cycle Waypoint Backwards", {
	CALL_ENSURE_IN_APACHE(fza_fnc_controlHandlePrevWaypoint)
}, {}] call CBA_fnc_addKeybind;

[MOD_NAME, "toggleHeadtracking", "Toggle Head Tracking", {
	ENSURE_IN_APACHE(fza_ah64_tiron = !fza_ah64_tiron;)
}, {}] call CBA_fnc_addKeybind;