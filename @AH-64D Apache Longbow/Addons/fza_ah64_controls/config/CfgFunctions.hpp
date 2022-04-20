
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
		class anim {
			file = "\fza_ah64_controls\scripting\functions\anim";
			class animSetValue {R;};
			class animReset {R;};
		};
		class avionics
		{
			file = "\fza_ah64_controls\scripting\functions\avionics";
			class avionicsSlipIndicator {R;};
		};
		class core
		{
			file = "\fza_ah64_controls\scripting\functions\core";
			class coreDraw3Dscheduler {R;};
			class coreEachFrameScheduler {R;};
			class coreGetObjectsLookedAt {R;};
			class coreGetWCAs {R;};
			class coreCockpitControlHandle {R;};
			class coreCockpitInteract {R;};
			class coreControlHandle {R;};
		};
		class damage {
			file = "\fza_ah64_controls\scripting\functions\damage";
			class damageSystem {R;};
			class damageM230 {R;};
			class damageEnginefire {R;};
		};
		class engine
		{
			file = "\fza_ah64_controls\scripting\functions\engine";
			class engineAPUOn {R;};
			class engineHandleControl {R;};
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
			class eventIncomingMissile {R;};
			class eventInit {R;};
		};
		class Sensor
		{
			file = "\fza_ah64_controls\scripting\functions\Sensor";
			class targetingSensorUpdate {R;};
			class targetingAseUpdate {R;};
		};
		class fire
		{
			file = "\fza_ah64_controls\scripting\functions\fire";
			class fireHandleControl {R;};
			class fireHandleRearm {R;};
			class fireHandlepanel {R;};
		};
		class fx {
			file = "\fza_ah64_controls\scripting\functions\fx";
			class fxMuzzle {R;};
			class fxLoops {R;};
		};
		class ihadss
		{
			file = "\fza_ah64_controls\scripting\functions\ihadss";
			class ihadssHandleControl {R;};
			class ihadssDraw {R;};
			class monocleToggle {R;};
		};
		class laser
		{
			file = "\fza_ah64_controls\scripting\functions\laser";
			class laserArm {R;};
			class laserCycle {R;};
			class laserDisarm {R;};
		};
		class light
		{
			file = "\fza_ah64_controls\scripting\functions\light";
			class lightHandleControl {R;};
			class lightSetCockpitLight {R;};
		};
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
			class navigationWaypointCycle {R;};
		};
		class pfz {
			file = "\fza_ah64_controls\scripting\functions\pfz";
			class pfzCreate {R;};
			class pfzReceive {R;};
			class pfzSend {R;};
		};
		
		class targeting
		{
			file = "\fza_ah64_controls\scripting\functions\targeting";
			class targetingFilterType {R;};
			class targetingGetSightSelect {R;};
			class targetingLockCamToTarget {R;};
			class targetingPFZCycle {R;};
			class targetingPNVSControl {R;};
			class targetingSched {R;};
			class targetingSetSightSelect {R;};
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
			class uiShowIntro {R;};
		};
		class weapon
		{
			file = "\fza_ah64_controls\scripting\functions\weapon";
			class weaponActionSwitch {R;};
			class weaponMissileGetSelected {R;};
			class weaponMissileCycle {R;};
			class weaponMissileInventory {R;};
			class weaponMissileSlowDown {R;};
			class weaponPylonCheckValid {R;};
			class weaponRocketInventory {R;};
			class weaponRocketSalvo {R;};
			class weaponRocketSetSelected {R;};
			class weaponSwapM230Mag {R;};
			class weaponTrajectoryChange {R;};
			class weaponTurretAim {R;};
			class weaponUpdateSelected {R;};
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
			class targetisADA {R;};
			class doortoggleP {R;};
			class doortoggleG {R;};
			class cycle {R;};
			class bearingClock {R;};
			class loadoutImportJson {R;};
		};
		class ase
		{
			file = "\fza_ah64_controls\scripting\functions\ase";
			class aseBetty {R;};
			class aseGunnerFlare {R;};
			class aseHandleRfcontrol {R;};
			class aseHandleIrcontrol {R;};
		};
	};
};