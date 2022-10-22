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
		};
		class core {					
			file = "\bmk_helisim\functions\core";
			class coreConfig {R;};
			class coreUpdate {R;};
		};
		class mainRotor {					
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
			class utilityArmaToModel {R;};
			class utilityGetInput {R;};
			class utilityModelToArma {R;};
		};
    };
};