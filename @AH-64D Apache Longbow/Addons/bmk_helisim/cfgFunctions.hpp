#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
	class bmk_helisim
	{
        tag = "bmk_helisim";
		class aeroGroundEffect {
			file = "\bmk_helisim\functions\aero";
			class aeroGroundEffect {R;};
			class aeroStabilator   {R;};
			class aeroWing {R;};
		};
		class core {					
			file = "\bmk_helisim\functions\core";
			class coreConfig {R;};
			class coreUpdate {R;};
		};
		class debug {
			file = "\bmk_helisim\functions\debug";
			class debugDrawLine {R;};
			class debugDrawCircle {R;};
		};
		class drivetrain {
			file = "\bmk_helisim\functions\drivetrain";
		};
		class engine {
			file = "\bmk_helisim\functions\engine";
			class engine {R;};
			class engineInit {R;};
			class engineStateOff {R;};
			class engineStateOn {R;};
			class engineStateStart {R;};
			class engineVariables {R;};
		};
		class environment {
			
		};
		class fuselage {
			file = "\bmk_helisim\functions\fuselage";
			class fuselageDrag {R;};
		};
		class interact {
			file = "\bmk_helisim\functions\interact";
			class interactSetThrottle {R;};
			class interactStartSwitch {R;};
		};
		class rotor {					
			file = "\bmk_helisim\functions\rotor";
			class rotor {R;};
			class rotorBodyAngularVelocityToControlAxes {R;};
			class rotorCalculateBodyForces {R;};
			class rotorCalculateBodyMoments {R;};
			class rotorCalculateConingAngles {R;};
			class rotorCalculateDragAndSideForces {R;};
			class rotorCalculateFlappingAngles {R;};
			class rotorCalculateThrust {R;};
			class rotorCalculateTorque {R;};
			class rotorHubVelocityToControlAxes {R;};
			class rotorUpdate {R;};
			class rotorUpdateControlAngles {R;};
			class rotorVariables {R;};
		};
		class utility {
			file = "\bmk_helisim\functions\utility";
			class utilityGetAngularVelocities {R;};
			class utilityGetArea {R;};
			class utilityGetInput {R;};
			class utilityGetLinearVelocities {R;};
			class utilityGovernor {R;};
			class utilityModelToArma {R;};
			class utilityRotateVector {R;};
		};
		class xmsn {
			file = "\bmk_helisim\functions\xmsn";
			class xmsn {R; };
			class xmsnVariables {R; };
		};
    };
};