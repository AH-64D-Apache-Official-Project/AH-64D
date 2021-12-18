class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
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
    };
};