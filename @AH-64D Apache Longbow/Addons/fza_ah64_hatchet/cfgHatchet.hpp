#include "\fza_ah64_hatchet\components\cfgHatchet.hpp"
class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class vxf_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\pilot\cfgEnginePanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgMfdPilot.hpp"
            };
        };
        class vxf_gunner: vxf_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\Gunner\CfgMfdGunner.hpp"
            };
        };
    };
};