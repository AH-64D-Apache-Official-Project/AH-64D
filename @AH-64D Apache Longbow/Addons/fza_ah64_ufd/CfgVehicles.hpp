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
            class UFD {
                topLeft = "PLT_UFD_TL";
                topRight = "PLT_UFD_TR";
                bottomLeft = "PLT_UFD_BL";
                #include "ufd.hpp"
            };
        };
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD : MFD {
                    class UFD {
                        topLeft = "CPG_UFD_TL";
                        topRight = "CPG_UFD_TR";
                        bottomLeft = "CPG_UFD_BL";
                        #include "ufd.hpp"
                    };
                };
            };
        };
    };
};