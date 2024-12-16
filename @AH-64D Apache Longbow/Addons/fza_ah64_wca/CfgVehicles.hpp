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
            class BTN_EMER_HYD {
                topLeft    = "PLT_BTN_EMER_HYD_TL";
                topRight   = "PLT_BTN_EMER_HYD_TR";
                bottomLeft = "PLT_BTN_EMER_HYD_BL";
                #include "pushbuttons\emerHyd.hpp"
            };
            class BTN_ARM_SAFE {
                topLeft    = "PLT_BTN_ARM_SAFE_TL";
                topRight   = "PLT_BTN_ARM_SAFE_TR";
                bottomLeft = "PLT_BTN_ARM_SAFE_BL";
                #include "pushbuttons\armSafe.hpp"
            };
            class BTN_GND_ORIDE {
                topLeft    = "PLT_BTN_GND_ORIDE_TL";
                topRight   = "PLT_BTN_GND_ORIDE_TR";
                bottomLeft = "PLT_BTN_GND_ORIDE_BL";
                #include "pushbuttons\gndOride.hpp"
            };
            class BTN_MSTR_WARN {
                topLeft    = "PLT_BTN_MSTR_WARN_TL";
                topRight   = "PLT_BTN_MSTR_WARN_TR";
                bottomLeft = "PLT_BTN_MSTR_WARN_BL";
                #include "pushbuttons\mstrWarn.hpp"
            };
            class BTN_MSTR_CAUT {
                topLeft    = "PLT_BTN_MSTR_CAUT_TL";
                topRight   = "PLT_BTN_MSTR_CAUT_TR";
                bottomLeft = "PLT_BTN_MSTR_CAUT_BL";
                #include "pushbuttons\mstrCaut.hpp"
            }; 
        };
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD : MFD {
                    class BTN_EMER_HYD {
                        topLeft    = "CPG_BTN_EMER_HYD_TL";
                        topRight   = "CPG_BTN_EMER_HYD_TR";
                        bottomLeft = "CPG_BTN_EMER_HYD_BL";
                        #include "pushbuttons\emerHyd.hpp"
                    };
                    class BTN_ARM_SAFE {
                        topLeft    = "CPG_BTN_ARM_SAFE_TL";
                        topRight   = "CPG_BTN_ARM_SAFE_TR";
                        bottomLeft = "CPG_BTN_ARM_SAFE_BL";
                        #include "pushbuttons\armSafe.hpp"
                    };
                    class BTN_GND_ORIDE {
                        topLeft    = "CPG_BTN_GND_ORIDE_TL";
                        topRight   = "CPG_BTN_GND_ORIDE_TR";
                        bottomLeft = "CPG_BTN_GND_ORIDE_BL";
                        #include "pushbuttons\gndOride.hpp"
                    };
                    class BTN_MSTR_WARN {
                        topLeft    = "CPG_BTN_MSTR_WARN_TL";
                        topRight   = "CPG_BTN_MSTR_WARN_TR";
                        bottomLeft = "CPG_BTN_MSTR_WARN_BL";
                        #include "pushbuttons\mstrWarn.hpp"
                    };
                    class BTN_MSTR_CAUT {
                        topLeft    = "CPG_BTN_MSTR_CAUT_TL";
                        topRight   = "CPG_BTN_MSTR_CAUT_TR";
                        bottomLeft = "CPG_BTN_MSTR_CAUT_BL";
                        #include "pushbuttons\mstrCaut.hpp"
                    }; 
                };
            };
        };
    };
};