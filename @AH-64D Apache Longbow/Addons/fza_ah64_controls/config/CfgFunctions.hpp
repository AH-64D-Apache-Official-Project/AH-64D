#define R recompile = 1
class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
		class avionics
		{
			file = "\fza_ah64_controls\scripting\functions\avionics";
			class avionicsSlipIndicator {R;};
		}
		class controlHandlers
		{
			file = "\fza_ah64_controls\scripting\functions\controlHandlers";
			class controlHandleASEAutopage {R;};
			class controlHandleCrosshairAction {R;};
			class controlHandleIHADSSMode {R;};
			class controlHandleJammerToggle {R;};
			class controlHandlelaserchange {R;};
			class controlHandleLookCenter {R;};
			class controlHandleNextWaypoint {R;};
			class controlHandlePrevWaypoint {R;};
			class controlHandleToggleHeadtracking {R;};
			class controlHandleTSDMode {R;};
		};
		class core
		{
			file = "\fza_ah64_controls\scripting\functions\core";
			class coreGetObjectsLookedAt {R;};
			class coreGetWCAs {R;};
			class coreScheduler {R;};
		};
		class damage {
			file = "\fza_ah64_controls\scripting\functions\damage";
			class damageSystem {R;};
			class damageM230 {R;};
		}
		class engine
		{
			file = "\fza_ah64_controls\scripting\functions\engine";
			class engineAPUOn {R;};
			class engineEventHandler {R;};
			class engineGetData
			{ R; description = "Gets the engine-related data for display"; };
			class engineGetTarget
			{
				R;
				description = "Get what engine's target RPM and time is";
			};
			class engineGovernor
			{
				R;
				description = "Sets the engine's target RPMs";
			};
			class engineHandleControl {R;};
			class engineInit
			{
				R;
				description = "Sets up the engine states";
			};
			class engineSetPosition
			{
				R;
				description = "Sets up engine to be at Off, Idle, Fly";
			};
			class engineUpdate
			{ R; description = "Updates internal engine state"; };
		};
		class event
		{
			file = "\fza_ah64_controls\scripting\functions\event";
			class eventFired {R;};
			class eventGetIn {R;};
			class eventGetOut {R;};
			class eventInit {R;};
		}
		class fcr
		{
			file = "\fza_ah64_controls\scripting\functions\fcr";
			class fcrlongbow{R;};
		}
		class fire
		{
			file = "\fza_ah64_controls\scripting\functions\fire";
			class fireHandleControl {R;};
		};
		class fx {
			file = "\fza_ah64_controls\scripting\functions\fx";
			class fxMuzzle {R;};
		}
		class ihadss
		{
			file = "\fza_ah64_controls\scripting\functions\ihadss";
			class ihadssHandleControl {R;};
			class ihadssDraw {R;};
			class ihadssToggle {R;};
			class monocleToggle {R;};
		};
		class laser
		{
			file = "\fza_ah64_controls\scripting\functions\laser";
			class laserArm {R;};
			class laserDisarm {R;};
		}
		class lighting
		{
			file = "\fza_ah64_controls\scripting\functions\lighting";
			class lightHandleControl {R;};
		}
		class mpd
		{
			file = "\fza_ah64_controls\scripting\functions\mpd";
			class mpdGetCurrentDisplay {R;};
			class mpdHandleControl {R;};
			class mpdHandleZoom {R;};


			class mpdLDMSDestruct {R;};
			class mpdLDMSDraw {R;};
			class mpdLDMSHandleControl {R;};
			class mpdLDMSInit {R;};
			class mpdLFLTDestruct {R;};
			class mpdLFLTDraw {R;};
			class mpdLFLTHandleControl {R;};
			class mpdLFLTInit {R;};
			class mpdLFUELDestruct {R;};
			class mpdLFUELDraw {R;};
			class mpdLFUELHandleControl {R;};
			class mpdLFUELInit {R;};
			class mpdLWCADestruct {R;};
			class mpdLWCADraw {R;};
			class mpdLWCAHandleControl {R;};
			class mpdLWCAInit {R;};
			class mpdLWPNDestruct {R;};
			class mpdLWPNDraw {R;};
			class mpdLWPNHandleControl {R;};
			class mpdLWPNInit {R;};

			class mpdRASEDestruct {R;};
			class mpdRASEDraw {R;};
			class mpdRASEHandleControl {R;};
			class mpdRASEInit {R;};
			class mpdRDMSDestruct {R;};
			class mpdRDMSDraw {R;};
			class mpdRDMSHandleControl {R;};
			class mpdRDMSInit {R;};
			class mpdRENGDestruct {R;};
			class mpdRENGDraw {R;};
			class mpdRENGHandleControl {R;};
			class mpdRENGInit {R;};
			class mpdRFCRDestruct {R;};
			class mpdRFCRDraw {R;};
			class mpdRFCRHandleControl {R;};
			class mpdRFCRInit {R;};
			class mpdRTSDDestruct {R;};
			class mpdRTSDDraw {R;};
			class mpdRTSDHandleControl {R;};
			class mpdRTSDInit {R;};
			class mpdRWCADestruct {R;};
			class mpdRWCADraw {R;};
			class mpdRWCAHandleControl {R;};
			class mpdRWCAInit {R;};
			
			class mpdSetDisplay {R;};
			class mpdUpdateDisplays {R;};
			class mpdUpdateMap {R;};
			class mpdUpdatePoints {R;};

			class mpdcycleL {R;};
			class mpdcycleR {R;};
			class ufd {R;};
		};
		class navigation {
			file = "\fza_ah64_controls\scripting\functions\navigation";
			class navigationWaypointEta {R;};
		}
		class pfz {
			file = "\fza_ah64_controls\scripting\functions\pfz";
			class pfzCreate {R;};
			class pfzReceive {R;};
			class pfzSend {R;};
		}
		class targeting
		{
			file = "\fza_ah64_controls\scripting\functions\targeting";
			class targetingFilterType {R;};
			class targetingGetAcquisitionSource {R;};
			class targetingPFZCycle {R;};
			class targetingPNVSControl {R;};
			class targetingSched {R;};
			class targetingSetAcquisitionSource {R;};
			class targetingUpdate {R;};
			class targetingVariable {R;};
		};
		class tsd
		{
			file = "\fza_ah64_controls\scripting\functions\tsd";
			class tsdFilter {R;};
			class tsdMap {R;};
			class tsdRange {R;};
		};
		class ui
		{
			file = "\fza_ah64_controls\scripting\functions\ui";
			class uiMouseMove {R;};
		};
		class weapon
		{
			file = "\fza_ah64_controls\scripting\functions\weapon";
			class weaponActionSwitch {R;};
			class weaponGunControl {R;};
			class weaponM230CycleBurst {R;};
			class weaponMissileGetSelected {R;};
			class weaponMissileInventory {R;};
			class weaponMissileSlowDown {R;};
			class weaponMissileTrajectory {R;};
			class weaponPylonCheckValid {R;};
			class weaponRocketInventory {R;};
			class weaponRocketSalvo {R;};
			class weaponSelectFireMode {R;};
			class weaponSubmunition {R;};
			class weaponTurretAim {R;};
		};
		class functions
		{
			file = "\fza_ah64_controls\scripting\functions";
			class linearInterp { R; description = "Linear interpolate a 2d array of keyframe values"; };
			class displayTime {R;};
			class drawNumberSelections {R;};
			class setPitchBank {R;};
			class getPitchBank {R;};
			class relativeDirection {R;};
			class velocityVector {R;};
			class addKeybind {R;};
			class playAudio { R; description = "Plays audio file"; };
			class compensateSafezone { R;};
			class targetisADA {R;}
			class doortoggleP {R;};
			class doortoggleG {R;};
			class loops {R;};
		};
		class ase
		{
			file = "\fza_ah64_controls\scripting\functions\ase";
			class aseJammer {R;};
			class aseFlaredeploy {R;};
			class aseHandleRfcontrol {R;};
			class aseHandleIrcontrol {R;};
		};
	};
};