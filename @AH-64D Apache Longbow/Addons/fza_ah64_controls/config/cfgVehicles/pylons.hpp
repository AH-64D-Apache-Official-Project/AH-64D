#define PYLON_UI_SUBPYLON_1_Y 0.37
#define PYLON_UI_SUBPYLON_2_Y 0.42
#define PYLON_UI_SUBPYLON_3_Y 0.47
#define PYLON_UI_SUBPYLON_4_Y 0.52
#define PYLON_UI_PYLON_1 0.7
#define PYLON_UI_PYLON_2 0.5
#define PYLON_UI_PYLON_3 0.3
#define PYLON_UI_PYLON_4 0.1
class TransportPylonsComponent {
    uiPicture = "\fza_ah64_us\tex\pylonmenu.paa";
    class pylons {
        class pylons1 { //Pylon 1 rocket zone alpha
            maxweight = 560;
            turret[] = {0};
            hardPoints[] = {"fza_hydra70_zone_AC", "fza_agm114_ul"};
            attachment = "fza_275_m151_zoneA";
            bay = -1;
            priority = 8;
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_SUBPYLON_1_Y};
        };
        class pylons2:pylons1 { //Pylon 1 rocket zone bravo
            hardPoints[] = {"fza_hydra70_zone_BD", "fza_agm114_ur"};
            attachment = "fza_275_m151_zoneB";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_SUBPYLON_2_Y};
            priority = 7;
        };
        class pylons3:pylons1 { //Pylon 1 rocket zone echo
            hardPoints[] = {"fza_hydra70_zone_E", "fza_agm114_ll"};
            attachment = "fza_275_m151_zoneE";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_SUBPYLON_3_Y};
            priority = 6;
        };
        class pylons4:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_lr"};
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_SUBPYLON_4_Y};
            priority = 5;
        };
        
        class pylons5: pylons1 { //Pylon 2 missile upper left
            attachment = "fza_agm114k_ul";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_SUBPYLON_1_Y};
            priority = 4;
        };
        class pylons6: pylons2 { //Pylon 2 missile upper right
            attachment = "fza_agm114k_ur";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_SUBPYLON_2_Y};
            priority = 3;
        };
        class pylons7: pylons3 { //Pylon 2 missile lower left
            attachment = "fza_agm114l_ll";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_SUBPYLON_3_Y};
            priority = 2;
        };
        class pylons8: pylons4 { //Pylon 2 missile lower right
            attachment = "fza_agm114l_lr";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_SUBPYLON_4_Y};
            priority = 1;
        };
        
        class pylons9: pylons5 { //Pylon 3 rocket zone charlie
            mirroredMissilePos = 5;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_SUBPYLON_1_Y};
        };
        class pylons10: pylons6 { //Pylon 3 rocket zone delta
            mirroredMissilePos = 6;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_SUBPYLON_2_Y};
        };
        class pylons11: pylons7 { //Pylon 3 rocket zone echo
            mirroredMissilePos = 7;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_SUBPYLON_3_Y};
        };
        class pylons12: pylons8 { //Pylon 3 missile upper left
            mirroredMissilePos = 8;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_SUBPYLON_4_Y};
        };

        class pylons13: pylons1 { //Pylon 4 rocket zone alpha
            mirroredMissilePos = 1;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_SUBPYLON_1_Y};
        };
        class pylons14: pylons2 { //Pylon 4 rocket zone bravo
            mirroredMissilePos = 2;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_SUBPYLON_2_Y};
        };
        class pylons15: pylons3 { //Pylon 4 rocket zone echo
            mirroredMissilePos = 3;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_SUBPYLON_3_Y};
        };
        class pylons16: pylons4 { //Pylon 4 missile upper left
            mirroredMissilePos = 4;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_SUBPYLON_4_Y};
        };
    };
    class presets {
        class cmbt_sprt_fcr {
            attachment[] = {"fza_275_m151_zoneA","fza_275_m261_zoneB","fza_275_m261_zoneE","","fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr","fza_275_m151_zoneA","fza_275_m261_zoneB","fza_275_m261_zoneE", ""};
            displayName = "Combat Support (FCR)";
        };
        class cmbt_sprt {
            attachment[] = {"fza_275_m151_zoneA","fza_275_m261_zoneB","fza_275_m261_zoneE","","fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr","fza_275_m151_zoneA","fza_275_m261_zoneB","fza_275_m261_zoneE",""};
            displayName = "Combat Support";
        };
        class hvy_atk_fcr {
            attachment[] = {"fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114l_ll","fza_agm114l_lr"};
            displayName = "Heavy Attack (FCR)";
        };
        class hvy_atk {
            attachment[] = {"fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr","fza_agm114k_ul","fza_agm114k_ur","fza_agm114k_ll","fza_agm114k_lr"};
            displayName = "Heavy Attack";
        };
        class coin {
            attachment[] = {"fza_275_m151_zoneA","fza_275_m255_zoneB","fza_275_m257_zoneE","","","","","","","","","","fza_agm114k_ul","","","fza_agm114n_lr"};
            displayName = "COIN";
        };
        class Empty {
            attachment[] = {"","","","","","","","","","","","","","","",""};
            displayName = "Empty";
        };
    };
};
