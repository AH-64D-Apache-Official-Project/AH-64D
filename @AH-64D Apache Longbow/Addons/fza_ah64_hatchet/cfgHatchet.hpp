class CfgVehicles
{
    class Helicopter;
    class Helicopter_Base_F : Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class vxf_driver {
            class interaction {
                //class groupForEngineOn {
                    //condition = "true";
                    #include "components\CfgEnginePanel.hpp"
                //}; // groupForEngineOn
            }; // interaction
        }; // vxf_driver
    class vxf_copilot: vxf_driver {};
    };
};