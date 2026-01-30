class CfgMagazines {
    class PylonRack_4Rnd_ACE_Hellfire_AGM114K;
    class 6Rnd_Missile_AGM_02_F;
    class fza_agm114k_ur;
    class fza_agm114fa_base : PylonRack_4Rnd_ACE_Hellfire_AGM114K {
        class mfdElements {
            #include "pylons\hellfire_sal1.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };
    class fza_agm114k_base : PylonRack_4Rnd_ACE_Hellfire_AGM114K {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };
    class fza_agm114k2a_base : PylonRack_4Rnd_ACE_Hellfire_AGM114K {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };
    class fza_agm114l_base : PylonRack_4Rnd_ACE_Hellfire_AGM114K {
        class mfdElements {
            #include "pylons\hellfire_rf.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };
    class fza_agm114n_base : PylonRack_4Rnd_ACE_Hellfire_AGM114K {
        class mfdElements {
            #include "pylons\hellfire_sal2.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };
    class fza_agm114_rail : fza_agm114k_ur{
        class mfdElements {
            #include "pylons\hellfire_sal1.hpp"
        };
        mirrorMissilesIndexes[] = {};
    };

    class fza_275_rocket_base : 6Rnd_Missile_AGM_02_F{
        class mfdElements {
            #include "pylons\rocket.hpp"
        };
    };
};