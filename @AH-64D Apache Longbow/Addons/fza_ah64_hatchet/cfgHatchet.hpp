#include "\fza_ah64_hatchet\components\CfgHatchet.hpp"

class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class hct_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\pilot\cfgDoor.hpp"
                #include "\fza_ah64_hatchet\components\pilot\cfgEnginePanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\cfgFirePanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\cfgLightPanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgMfd.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgMisc.hpp"
            };
        };
        class hct_gunner: hct_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\Gunner\cfgDoor.hpp"
                #include "\fza_ah64_hatchet\components\Gunner\cfgEnginePanel.hpp"
                #include "\fza_ah64_hatchet\components\Gunner\cfgFirePanel.hpp"
                #include "\fza_ah64_hatchet\components\Gunner\cfgLightPanel.hpp"
                #include "\fza_ah64_hatchet\components\Gunner\CfgMfd.hpp"
                #include "\fza_ah64_hatchet\components\Gunner\CfgMisc.hpp"
            };
        };
    };
};