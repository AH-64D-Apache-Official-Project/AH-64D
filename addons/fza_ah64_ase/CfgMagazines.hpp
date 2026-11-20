class CfgMagazines {
    class CA_Magazine;
    class fza_chaff_30_mag: CA_Magazine
    {
        count = 60;
        ammo = "fza_ah64_chaff_shot";
        initSpeed = 30;
    };
    class fza_flare_30_mag: fza_chaff_30_mag
    {
        count = 60;
        ammo = "fza_ah64_flare_shot";
    };
    // HIDAS: an 8x4 flare pod a side, chaff on the left, one cartridge a round
    class fza_flare_32L_mag: fza_chaff_30_mag
    {
        count = 32;
        ammo = "fza_ah64_flare_shot";
    };
    class fza_flare_32R_mag: fza_flare_32L_mag {};
    class fza_chaff_64_mag: fza_chaff_30_mag
    {
        count = 64;
    };
    class fza_IR_JAMMING: CA_Magazine
    {
        count = 99999999;
        ammo = "fza_IR_JAMMING_shot";
        initSpeed = 30;
    };
};
