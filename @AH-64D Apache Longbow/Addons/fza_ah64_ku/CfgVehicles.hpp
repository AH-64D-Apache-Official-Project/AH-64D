class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
        class NewTurret;
        class Turrets {
            class MainTurret {
                class MFD;
            };
        };
    };
    class fza_ah64base : Helicopter_Base_F {
        class MFD : MFD {
            class KU {
                topLeft = "PLT_KU_TL";
                topRight = "PLT_KU_TR";
                bottomLeft = "PLT_KU_BL";
                #include "ku.hpp"
            };
        };
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD : MFD {
                    class KU {
                        topLeft = "CPG_KU_TL";
                        topRight = "CPG_KU_TR";
                        bottomLeft = "CPG_KU_BL";
                        #include "ku.hpp"
                    };
                };
            };
        };
    };
};