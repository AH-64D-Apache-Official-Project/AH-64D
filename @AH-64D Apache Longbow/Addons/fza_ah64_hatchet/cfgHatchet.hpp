class CfgVehicles
{
    class Helicopter;
    class Helicopter_Base_F : Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class vxf_driver {
            class interaction {
                #include "components\CfgEnginePanel.hpp"
            };
        };
    class vxf_copilot: vxf_driver {};
    };
};