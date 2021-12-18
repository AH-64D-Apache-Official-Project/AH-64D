class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
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
    };
};