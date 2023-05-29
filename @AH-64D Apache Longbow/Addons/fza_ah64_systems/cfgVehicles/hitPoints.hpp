#define HIT_RADIUS_01 0.14
#define HIT_RADIUS_02 0.05
#define ARMOR_SCALAR  0.067

class HitPoints
{
    class hit_apu
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.30;
        name = "hit_apu";
        material = 51;
        passThrough = 0;
    };
    class hit_drives_intermediategearbox
    {
        armor = 1.62 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.34;
        name = "hit_drives_intermediategearbox";
        material = 51;
        passThrough = 0;
    };
    class hit_drives_noseGearbox1
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.24;
        name = "hit_drives_noseGearbox1";
        material = 51;
        passThrough = 0;
    };
    class hit_drives_noseGearbox2
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.24;
        name = "hit_drives_noseGearbox2";
        material = 51;
        passThrough = 0;
    };
    class hit_drives_tailrotorgearbox
    {
        armor = 1.62 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.34;
        name = "hit_drives_tailrotorgearbox";
        material = 51;
        passThrough = 0;
    };
    class hit_drives_transmission
    {
        armor = 2.88 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.30;
        name = "hit_drives_transmission";
        material = 51;
        passThrough = 0;
    };
    class hit_elec_battery
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.24;
        name = "hit_elec_battery";
        material = 51;
        passThrough = 0;
    };
    class hit_elec_generator1
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.09;
        name = "hit_elec_generator1";
        material = 51;
        passThrough = 0;
    };
    class hit_elec_generator2
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.09;
        name = "hit_elec_generator2";
        material = 51;
        passThrough = 0;
    };
    class hit_elec_rectifier1
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.10;
        name = "hit_elec_rectifier1";
        material = 51;
        passThrough = 0;
    };
    class hit_elec_rectifier2
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.10;
        name = "hit_elec_rectifier2";
        material = 51;
        passThrough = 0;
    };
    class hitEngine
    {
        armor = 1.80 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.30;
        name = "hitengine1";
        material = 51;
        passThrough = 0;
    };
    class hitEngine1
    {
        armor = 1.80 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.30;
        name = "hitengine2";
        material = 51;
        passThrough = 0;
    };
    class hit_fuel_aft {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.15;
        name = "hit_fuel_aft";
        material = 51;
        passThrough = 0;
    };
    class hit_fuel_forward {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.15;
        name = "hit_fuel_forward";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_magandrobbie {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.15;
        name = "hit_msnEquip_magandrobbie";
        material = 51;
        passThrough = 0;
    };
    class hit_hyd_prireservoir
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.20;
        name = "hit_hyd_prireservoir";
        material = 51;
        passThrough = 0;
    };
    class hit_hyd_priPump
    {
        armor = 0.90 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.15;
        name = "hit_hyd_priPump";
        material = 51;
        passThrough = 0;
    };
    class hit_hyd_utilreservoir
    {
        armor = 0.72 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.20;
        name = "hit_hyd_utilreservoir";
        material = 51;
        passThrough = 0;
    };
    class hit_hyd_utilPump
    {
        armor = 0.90 * ARMOR_SCALAR;
        radius = HIT_RADIUS_02;
        minimalHit = 0.1;
        explosionShielding = 0.15;
        name = "hit_hyd_utilPump";
        material = 51;
        passThrough = 0;
    };
    class hithrotor
    {
        armor = 5.76 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hithrotor";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_gun_turret
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_gun_turret";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pnvs_flir
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pnvs_flir";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pnvs_turret
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pnvs_turret";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pylon1
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pylon1";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pylon2
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pylon2";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pylon3
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pylon3";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_pylon4
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_pylon4";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_tads_dtv
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_tads_dtv";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_tads_flir
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_tads_flir";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_tads_turret
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_tads_turret";
        material = 51;
        passThrough = 0;
    };
    class hit_msnEquip_fcr
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_msnEquip_fcr";
        material = 51;
        passThrough = 0;
    };
    class hit_stabilator
    {
        armor = 1.44 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hit_stabilator";
        material = 51;
        passThrough = 0;
    };
    class hitvrotor
    {
        armor = 5.76 * ARMOR_SCALAR;
        radius = HIT_RADIUS_01;
        minimalHit = 0.1;
        explosionShielding = 0.80;
        name = "hitvrotor";
        material = 51;
        passThrough = 0;
    };
};
