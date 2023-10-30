#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
    class fza_ah64_project_sfmplus
    {
        tag = "FZA_sfmplus";
        class actuator {
            file = "\fza_ah64_sfmplus\functions\actuator";
            class actuator {R;};
            class actuatorGetLagCoefA {R;};
            class actuatorGetLagCoefB {R;};
            class actuatorLag {R;};
            class actuatorVariables {R;};
        };
        class aero {
            file = "\fza_ah64_sfmplus\functions\aero";
            class aeroStabilator {R;};
            class aeroWing {R;};
        };
        class core {
            file = "\fza_ah64_sfmplus\functions\core";
            class coreConfig {R;};
            class coreUpdate  {R;};
        };
        class damage {
            file = "\fza_ah64_sfmplus\functions\damage";
            class damageApply {R;};
        };
        class engine {
            file = "\fza_ah64_sfmplus\functions\engine";
            class engine  {R;};
            class engineController {R;};
            class engineReset {R;};
            class engineVariables {R;};
        };
        class fmc  {
            file = "\fza_ah64_sfmplus\functions\fmc";
            class fmc {R;};
            class fmcAttitudeHold {R;};
            class fmcAltitudeHold {R;};
            class fmcAltitudeHoldEnable {R;};
            class fmcAttitudeHoldEnable {R;};
            class fmcForceTrimSet {R;};
            class fmcHeadingHold {R;};
            class fmcHoldModesDisable {R;};
        };
        class fuel {
            file = "\fza_ah64_sfmplus\functions\fuel";
            class fuelSet {R;};
        };
        class fuselage {
            file = "\fza_ah64_sfmplus\functions\fuselage";
            class fuselageDrag {R;};
            class fuselageGetAccelerations {R;};
            class fuselageVariables {R;};
        };
        class interact {
            file = "\fza_ah64_sfmplus\functions\interact";
            class interactPowerLever {R;};
            class interactStartSwitch {R;};
        };
        class mass {
            file = "\fza_ah64_sfmplus\functions\mass";
            class massSet {R;};
        };
        class performance {
            file = "\fza_ah64_sfmplus\functions\performance";
            class perfData {R;};
            class perfVariables {R;};
        };
        class simpleRotor {
            file = "\fza_ah64_sfmplus\functions\simpleRotor";
            class simpleRotorMain {R;};
            class simpleRotorNewtRaphSolver {R;};
            class simpleRotorTail {R;};
            class simpleRotorVariables {R;};
        };
        class utility {
            file = "\fza_ah64_sfmplus\functions";
            class calculateAlphaAndBeta {R;};
            class getAltitude {R;};
            class getInput {R;};
            class getRtrRPM {R;};
            class getwindDirVel {R;};
            class onGround {R;};
        };
    };
};