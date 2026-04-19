#include "\fza_ah64_hatchet\components\cfgHatchet.hpp"

class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class hct_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\pilot\CfgDoor.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgEnginePanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgFirePanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgLightPanel.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgMfd.hpp"
                #include "\fza_ah64_hatchet\components\pilot\CfgMisc.hpp"
            };
        };
        class hct_gunner: hct_driver {
            class interaction {
                #include "\fza_ah64_hatchet\components\gunner\CfgDoor.hpp"
                #include "\fza_ah64_hatchet\components\gunner\CfgEnginePanel.hpp"
                #include "\fza_ah64_hatchet\components\gunner\CfgFirePanel.hpp"
                #include "\fza_ah64_hatchet\components\gunner\CfgLightPanel.hpp"
                #include "\fza_ah64_hatchet\components\gunner\CfgMfd.hpp"
                #include "\fza_ah64_hatchet\components\gunner\CfgMisc.hpp"
            };
        };
    };
};
