class CfgMagazines {
    class 6Rnd_Missile_AGM_02_F;
    class fza_agm114fa_base : 6Rnd_Missile_AGM_02_F {
        class mfdElements {
            #include "pylons\hellfire_sal1.hpp"
        };
    };
    class fza_agm114k_base : 6Rnd_Missile_AGM_02_F {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
    };
    class fza_agm114k2a_base : 6Rnd_Missile_AGM_02_F {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
    };
    class fza_agm114l_base : 6Rnd_Missile_AGM_02_F {
        class mfdElements {
            #include "pylons\hellfire_rf.hpp"
        };
    };
    class fza_agm114n_base : 6Rnd_Missile_AGM_02_F {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
    };
    class fza_agm114_rail : 6Rnd_Missile_AGM_02_F{
        class mfdElements {
            #include "pylons\hellfire_sal1.hpp"
        };
    };

    class fza_275_rocket_base : 6Rnd_Missile_AGM_02_F{
        class mfdElements {
            #include "pylons\rocket.hpp"
        };
    };
};