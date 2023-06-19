class CfgMagazines {
    class CA_Magazine;
    class 30Rnd_CMChaffMagazine: CA_Magazine
    {
        count = 60;
        ammo = "fza_ah64_chaff_shot";
        initSpeed = 30;
    };
    class 60Rnd_CMFlareMagazine: 30Rnd_CMChaffMagazine
    {
        count = 60;
        ammo = "fza_ah64_flare_shot";
    };
    class fza_IR_JAMMING: CA_Magazine
    {
        count = 99999999;
        ammo = "fza_IR_JAMMING_shot";
        initSpeed = 30;
    };
};