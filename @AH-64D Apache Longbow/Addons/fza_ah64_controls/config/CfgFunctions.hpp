
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
			class targetingsensorCycle {R;};
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
		class hellfire {
			file = "\fza_ah64_controls\Scripting\functions\hellfire";
			class hellfireAceController {R;};
			class HellfireGetAttackProfile {R;};
			class hellfireSALFired {R;};
			class hellfireARHSeeker {R;};
			class hellfireARHFired {R;};
			class hellfireLimaLoblCheck {R;};
			class hellfireSALShouldStartLobl {R;};
			class hellfireCheckSeekerAngle {R;};
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
			class laserDisarm {R;};
		};
		class light
		{
			file = "\fza_ah64_controls\scripting\functions\light";
			class lightHandleControl {R;};
			class lightSetCockpitLight {R;};
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
			class targetingFCRUpdate {R;};
			class targetingFilterType {R;};
			class targetingGetSightSelect {R;};
			class targetingLockCamToTarget {R;};
			class targetingPFZCycle {R;};
			class targetingPNVSControl {R;};
			class targetingSched {R;};
			class targetingSetSightSelect {R;};
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
			class compensateSafezone { R;};
			class targetisADA {R;};
			class doortoggleP {R;};
			class doortoggleG {R;};
			class cycle {R;};
			class bearingClock {R;};
			class padString {R;};
			class loadoutImportJson {R;};
			class setTailNumber {R;};
			class configToHashMap {R;};
		};
		class ase
		{
			file = "\fza_ah64_controls\scripting\functions\ase";
			class aseAdaClassification {R;};
			class aseAudioController {R;};
			class aseMissileWarning {R;};
			class aseChaff {R;};
			class aseGunnerFlare {R;};
			class aseController {R;};
			class aseIRJam {R;};
			class aseRFJam {R;};
			class aseRLWR {R;};
		};
	};
};