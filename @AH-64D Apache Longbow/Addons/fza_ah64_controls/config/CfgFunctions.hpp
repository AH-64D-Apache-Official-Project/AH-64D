
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
            file = "\fza_ah64_controls\functions\anim";
            class animSetValue {R;};
            class animReset {R;};
            class probes {R;};
        };
        class avionics
        {
            file = "\fza_ah64_controls\functions\avionics";
            class avionicsSlipIndicator {R;};
        };
        class core
        {
            file = "\fza_ah64_controls\functions\core";
            class coreDraw3Dscheduler {R;};
            class coreEachFrameScheduler {R;};
            class coreFixedUpdateScheduler {R;};
            class coreGetObjectsLookedAt {R;};
            class coreGetWCAs {R;};
            class coreCockpitControlHandle {R;};
            class coreCockpitInteract {R;};
            class coreControlHandle {R;};
        };
        class damage {
            file = "\fza_ah64_controls\functions\damage";
        };
        class engine
        {
            file = "\fza_ah64_controls\functions\engine";
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
            file = "\fza_ah64_controls\functions\event";
            class eventFired {R;};
            class eventGetIn {R;};
            class eventGetOut {R;};
            class eventInit {R;};
            class eventPreInit {R;};
        };
        class fx {
            file = "\fza_ah64_controls\functions\fx";
            class fxMuzzle {R;};
            class fxLoops {R;};
        };
        class laser
        {
            file = "\fza_ah64_controls\functions\laser";
            class laserArm {R;};
            class laserDisarm {R;};
        };
        class targeting
        {
            file = "\fza_ah64_controls\functions\targeting";
            class targetingAcqVec {R;};
            class targetingCurAcq {R;};
        };
        class ui
        {
            file = "\fza_ah64_controls\functions\ui";
            class uiMouseMove {R;};
            class uiShowIntro {R;};
        };
        class weapon
        {
            file = "\fza_ah64_controls\functions\weapon";
            class weaponActionSwitch {R;};
            class weaponMissileGetSelected {R;};
            class weaponMissileCycle {R;};
            class weaponMissileInventory {R;};
            class weaponPylonCheckValid {R;};
            class weaponRocketInventory {R;};
            class weaponRocketSetSelected {R;};
            class weaponSwapM230Mag {R;};
            class weaponTrajectoryChange {R;};
            class weaponTurretAim {R;};
            class weaponUpdateSelected {R;};
        };
        class functions
        {
            file = "\fza_ah64_controls\functions";
            class setPitchBank {R;};
            class getPitchBank {R;};
            class relativeDirection {R;};
            class velocityVector {R;};
            class compensateSafezone { R;};
            class targetisADA {R;};
            class doortoggleP {R;};
            class doortoggleG {R;};
            class bearingClock {R;};
            class loadoutImportJson {R;};
            class setTailNumber {R;};
            class configToHashMap {R;};
        };
    };
};