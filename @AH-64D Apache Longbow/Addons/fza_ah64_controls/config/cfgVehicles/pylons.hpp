#define PYLON_UI_ZONEA_Y 0.15
#define PYLON_UI_ZONEB_Y 0.2
#define PYLON_UI_ZONEE_Y 0.25
#define PYLON_UI_UL_Y 0.4
#define PYLON_UI_UR_Y 0.45
#define PYLON_UI_LL_Y 0.5
#define PYLON_UI_LR_Y 0.55
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
            hardPoints[] = {"fza_hydra70_zone_AC"};
            attachment = "fza_275_m229_zoneA";
            bay = -1;
            priority = 5;
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_ZONEA_Y};
        };
        class pylons2:pylons1 { //Pylon 1 rocket zone bravo
            hardPoints[] = {"fza_hydra70_zone_BD"};
            attachment = "fza_275_m229_zoneB";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_ZONEB_Y};
        };
        class pylons3:pylons1 { //Pylon 1 rocket zone echo
            hardPoints[] = {"fza_hydra70_zone_E"};
            attachment = "fza_275_m229_zoneE";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_ZONEE_Y};
        };
        class pylons4:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ul"};
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_UL_Y};
            priority = 8;
        };
        class pylons5:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ur"};
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_UR_Y};
            priority = 7;
        };
        class pylons6:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ll"};
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_LL_Y};
            priority = 6;
        };
        class pylons7:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_lr"};
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_1, PYLON_UI_LR_Y};
            priority = 5;
        };

        class pylons8: pylons1 { //Pylon 2 rocket zone charlie
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_ZONEA_Y};
        };
        class pylons9: pylons2 { //Pylon 2 rocket zone delta
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_ZONEB_Y};
        };
        class pylons10: pylons3 { //Pylon 2 rocket zone echo
            attachment = "";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_ZONEE_Y};
        };
        class pylons11: pylons4 { //Pylon 2 missile upper left
            attachment = "fza_agm114k_ul";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_UL_Y};
            priority = 4;
        };
        class pylons12: pylons5 { //Pylon 2 missile upper right
            attachment = "fza_agm114k_ur";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_UR_Y};
            priority = 3;
        };
        class pylons13: pylons6 { //Pylon 2 missile lower left
            attachment = "fza_agm114l_ll";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_LL_Y};
            priority = 2;
        };
        class pylons14: pylons7 { //Pylon 2 missile lower right
            attachment = "fza_agm114k_lr";
            UIposition[] = {PYLON_UI_PYLON_2, PYLON_UI_LR_Y};
            priority = 1;
        };
        
        class pylons15: pylons8 { //Pylon 3 rocket zone charlie
            mirroredMissilePos = 8;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_ZONEA_Y};
        };
        class pylons16: pylons9 { //Pylon 3 rocket zone delta
            mirroredMissilePos = 9;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_ZONEB_Y};
        };
        class pylons17: pylons10 { //Pylon 3 rocket zone echo
            mirroredMissilePos = 10;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_ZONEE_Y};
        };
        class pylons18: pylons11 { //Pylon 3 missile upper left
            mirroredMissilePos = 11;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_UL_Y};
            priority = 4;
        };
        class pylons19: pylons12 { //Pylon 3 missile upper right
            mirroredMissilePos = 12;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_UR_Y};
            priority = 3;
        };
        class pylons20: pylons13 { //Pylon 3 missile lower left
            mirroredMissilePos = 13;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_LL_Y};
            priority = 2;
        };
        class pylons21: pylons14 { //Pylon 3 missile lower right
            mirroredMissilePos = 14;
            UIposition[] = {PYLON_UI_PYLON_3, PYLON_UI_LR_Y};
            priority = 1;
        };

        class pylons22: pylons1 { //Pylon 4 rocket zone alpha
            mirroredMissilePos = 1;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_ZONEA_Y};
        };
        class pylons23: pylons2 { //Pylon 4 rocket zone bravo
            mirroredMissilePos = 2;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_ZONEB_Y};
        };
        class pylons24: pylons3 { //Pylon 4 rocket zone echo
            mirroredMissilePos = 3;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_ZONEE_Y};
        };
        class pylons25: pylons4 { //Pylon 4 missile upper left
            mirroredMissilePos = 4;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_UL_Y};
            priority = 7;
        };
        class pylons26: pylons5 { //Pylon 4 missile upper right
            mirroredMissilePos = 5;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_UR_Y};
            priority = 8;
        };
        class pylons27: pylons6 { //Pylon 4 missile lower left
            mirroredMissilePos = 6;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_LL_Y};
            priority = 7;
        };
        class pylons28: pylons7 { //Pylon 4 missile lower right
            mirroredMissilePos = 7;
            UIposition[] = {PYLON_UI_PYLON_4, PYLON_UI_LR_Y};
            priority = 6;
        };
    }
}