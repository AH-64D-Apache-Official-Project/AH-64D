class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
        class Turrets;
    };
    class fza_ah64base : Helicopter_Base_F {
        class NewTurret;
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD;
            };
        };
    };
    class fza_ah64d_b2e : fza_ah64base {
        class MFD : MFD {
            class BTN_EMER_HYD {
                topLeft    = "PLT_BTN_EMER_HYD_TL";
                topRight   = "PLT_BTN_EMER_HYD_TR";
                bottomLeft = "PLT_BTN_EMER_HYD_BL";
                #include "emerHyd.hpp"
            };
            class BTN_ARM_SAFE {
                topLeft    = "PLT_ARM_SAFE_TL";
                topRight   = "PLT_ARM_SAFE_TR";
                bottomLeft = "PLT_ARM_SAFE_BL";
                #include "armSafe.hpp"
            };
            class BTN_GND_ORIDE {
                topLeft    = "PLT_GND_ORIDE_TL";
                topRight   = "PLT_GND_ORIDE_TR";
                bottomLeft = "PLT_GND_ORIDE_BL";
                #include "gndOride.hpp"
            };
            class BTN_MSTR_WARN {
                topLeft    = "PLT_MSTR_WARN_TL";
                topRight   = "PLT_MSTR_WARN_TR";
                bottomLeft = "PLT_MSTR_WARN_BL";
                #include "mstrWarn.hpp"
            };
            class BTN_MSTR_CAUT {
                topLeft    = "PLT_MSTR_CAUT_TL";
                topRight   = "PLT_MSTR_CAUT_TR";
                bottomLeft = "PLT_MSTR_CAUT_BL";
                #include "mstrCaut.hpp"
            }; 
        };
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD : MFD {
                    class BTN_EMER_HYD {
                        topLeft    = "CPG_BTN_EMER_HYD_TL";
                        topRight   = "CPG_BTN_EMER_HYD_TR";
                        bottomLeft = "CPG_BTN_EMER_HYD_BL";
                        #include "emerHyd.hpp"
                    };
                    class BTN_ARM_SAFE {
                        topLeft    = "CPG_ARM_SAFE_TL";
                        topRight   = "CPG_ARM_SAFE_TR";
                        bottomLeft = "CPG_ARM_SAFE_BL";
                        #include "armSafe.hpp"
                    };
                    class BTN_GND_ORIDE {
                        topLeft    = "CPG_GND_ORIDE_TL";
                        topRight   = "CPG_GND_ORIDE_TR";
                        bottomLeft = "CPG_GND_ORIDE_BL";
                        #include "gndOride.hpp"
                    };
                    class BTN_MSTR_WARN {
                        topLeft    = "CPG_MSTR_WARN_TL";
                        topRight   = "CPG_MSTR_WARN_TR";
                        bottomLeft = "CPG_MSTR_WARN_BL";
                        #include "mstrWarn.hpp"
                    };
                    class BTN_MSTR_CAUT {
                        topLeft    = "CPG_MSTR_CAUT_TL";
                        topRight   = "CPG_MSTR_CAUT_TR";
                        bottomLeft = "CPG_MSTR_CAUT_BL";
                        #include "mstrCaut.hpp"
                    }; 
                };
            };
        };
    };
};