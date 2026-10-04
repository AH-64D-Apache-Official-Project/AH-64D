#include "\bmkhs_helisim\fmOverride.hpp"

class CfgVehicles {
    class Helicopter_Base_F;
    class fza_ah64base : Helicopter_Base_F {
        //Core owns the force coefficients - packs cannot tune them
        BMKHS_FM_OVERRIDE

        //Aircraft-specific
        startDuration = 15;
        fuelCapacity  = 1423;
        maxSpeed      = 298;
        altFullForce  = 1615;
        altNoForce    = 9000;

        //Core's macro first, then the aircraft's own hitpoint declarations that use it
        #include "\bmkhs_helisim\hitPoints.hpp"
        #include "bmkhs_config\helisim_hitpoints.hpp"
        #include "bmkhs_ah64_config.hpp"
    };
};
