#define PYLON_DEF(PY_ID_1, PY_MAG_1, PY_ID_2, PY_MAG_2, PY_ID_3, PY_MAG_3, PY_ID_4, PY_MAG_4, PY_ID_5, PY_MAG_5, PY_ID_6, PY_MAG_6, PY_ID_7, PY_MAG_7, PY_UI_H) \
    class pylons##PY_ID_1: pylons1 { \
        attachment = PY_MAG_1;\
        UIposition[] = {PY_UI_H, 0.15};\
    };\
    class pylons##PY_ID_2: pylons2 { \
        attachment = PY_MAG_2;\
        UIposition[] = {PY_UI_H, 0.2};\
    };\
    class pylons##PY_ID_3: pylons3 { \
        attachment = PY_MAG_3;\
        UIposition[] = {PY_UI_H, 0.25};\
    };\
    class pylons##PY_ID_4: pylons4 { \
        attachment = PY_MAG_4;\
        UIposition[] = {PY_UI_H, 0.4};\
    };\
    class pylons##PY_ID_5: pylons5 { \
        attachment = PY_MAG_5;\
        UIposition[] = {PY_UI_H, 0.45};\
    };\
    class pylons##PY_ID_6: pylons6 { \
        attachment = PY_MAG_6;\
        UIposition[] = {PY_UI_H, 0.5};\
    };\
    class pylons##PY_ID_7: pylons7 { \
        attachment = PY_MAG_7;\
        UIposition[] = {PY_UI_H, 0.55};\
    };

class TransportPylonsComponent {
    uiPicture = "\A3\Air_F\Heli_Light_01\Data\UI\Heli_Light_01_3DEN_CA.paa";
    class pylons {
        class pylons1 { //Pylon 1 rocket zone alpha
            maxweight = 560;
            hardPoints[] = {"fza_hydra70_zone_AC"};
            attachment = "";
            bay = -1;
            priority = 5;
            UIposition[] = {0.1, 0.15};
        };
        class pylons2:pylons1 { //Pylon 1 rocket zone charlie
            hardPoints[] = {"fza_hydra70_zone_BD"};
            attachment = "";
            UIposition[] = {0.1, 0.2};
        };
        class pylons3:pylons1 { //Pylon 1 rocket zone echo
            hardPoints[] = {"fza_hydra70_zone_E"};
            attachment = "";
            UIposition[] = {0.1, 0.25};
        };
        class pylons4:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ul"};
            attachment = "";
            UIposition[] = {0.1, 0.4};
        };
        class pylons5:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ur"};
            attachment = "";
            UIposition[] = {0.1, 0.45};
        };
        class pylons6:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_ll"};
            attachment = "";
            UIposition[] = {0.1, 0.5};
        };
        class pylons7:pylons1 { //Pylon 1 missile upper left
            hardPoints[] = {"fza_agm114_lr"};
            attachment = "";
            UIposition[] = {0.1, 0.55};
        };
        PYLON_DEF(8,"",9,"",10,"",11,"",12,"",13,"",14,"",0.3)
        PYLON_DEF(15,"",16,"",17,"",18,"",19,"",20,"",21,"",0.5)
        PYLON_DEF(22,"",23,"",24,"",25,"",26,"",27,"",28,"",0.7)
    }
}