/////////////////////////////////////////////////////////////////////////////////////////////
// Hitpoints ////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    //Every damageable component in one place: what Arma calls it, how tough it is, and which
    //HeliSim system it damages. The aircraft owns all three - Core reads the roles back out
    //rather than declaring any hitpoint itself.
    //
    //  class       - the config class name. Conventionally the same as the selection name.
    //  name        - the selection in the p3d. Arma matches this EXACTLY, case included.
    //  armor       - hit points before destruction
    //  radius      - hit sphere size, m
    //  minimalHit  - smallest hit that registers
    //  expShielding- blast resistance
    //  role        - the HeliSim system this damages, or "" for none. Core asks by role, so
    //                a component with no role is still a hitpoint - it just does not feed the
    //                flight model. Roles that take several members (engines, generators,
    //                pylons) are ordered by roleIndex.
    //  roleIndex   - position within a multi-member role; 0 for single-member roles.
    //
    //An aircraft without an FCR, pylons or a second generator simply omits those classes.
    //Only mainRotor and transmission are required; Core reports a missing one at load.
    class HitPoints
    {
        //--- Powerplant ----------------------------------------------------------
        BMKHS_HITPOINT(hitengine1, "hitengine1", 0.1206, 0.14, 0.05, 0.3, "engines", 0)
        BMKHS_HITPOINT(hitengine2, "hitengine2", 0.1206, 0.14, 0.05, 0.3, "engines", 1)
        //Neutralise Arma's own engine hitpoint so the two above drive engine damage.
        BMKHS_HITPOINT_ENGINE_PASSTHROUGH("0.5 * (HitEngine1 + HitEngine2)")

        //--- Drivetrain ----------------------------------------------------------
        BMKHS_HITPOINT(hit_drives_intermediateGearbox, "hit_drives_intermediateGearbox", 0.10854, 0.14, 0.05, 0.34, "intermediateGearbox", 0)
        BMKHS_HITPOINT(hit_drives_noseGearbox1, "hit_drives_noseGearbox1", 0.09648, 0.14, 0.05, 0.24, "noseGearboxes", 0)
        BMKHS_HITPOINT(hit_drives_noseGearbox2, "hit_drives_noseGearbox2", 0.09648, 0.14, 0.05, 0.24, "noseGearboxes", 1)
        BMKHS_HITPOINT(hit_drives_tailRotorGearbox, "hit_drives_tailRotorGearbox", 0.10854, 0.14, 0.05, 0.34, "tailRotorGearbox", 0)
        BMKHS_HITPOINT(hit_drives_transmission, "hit_drives_transmission", 0.19296, 0.14, 0.05, 0.3, "transmission", 0)

        //--- Rotors --------------------------------------------------------------
        BMKHS_HITPOINT(hithrotor, "hithrotor", 0.38592, 0.14, 0.05, 0.8, "mainRotor", 0)
        BMKHS_HITPOINT(hitvrotor, "hitvrotor", 0.38592, 0.14, 0.05, 0.8, "tailRotor", 0)

        //--- Electrical ----------------------------------------------------------
        BMKHS_HITPOINT(hit_elec_battery, "hit_elec_battery", 0.09648, 0.05, 0.05, 0.24, "batteries", 0)
        BMKHS_HITPOINT(hit_elec_generator1, "hit_elec_generator1", 0.04824, 0.05, 0.05, 0.09, "generators", 0)
        BMKHS_HITPOINT(hit_elec_generator2, "hit_elec_generator2", 0.04824, 0.05, 0.05, 0.09, "generators", 1)
        BMKHS_HITPOINT(hit_elec_rectifier1, "hit_elec_rectifier1", 0.04824, 0.05, 0.05, 0.1, "rectifiers", 0)
        BMKHS_HITPOINT(hit_elec_rectifier2, "hit_elec_rectifier2", 0.04824, 0.05, 0.05, 0.1, "rectifiers", 1)

        //--- Hydraulics ----------------------------------------------------------
        BMKHS_HITPOINT(hit_hyd_priReservoir, "hit_hyd_priReservoir", 0.04824, 0.05, 0.05, 0.2, "priReservoir", 0)
        BMKHS_HITPOINT(hit_hyd_priPump, "hit_hyd_priPump", 0.0603, 0.05, 0.05, 0.15, "priPump", 0)
        BMKHS_HITPOINT(hit_hyd_utilReservoir, "hit_hyd_utilReservoir", 0.04824, 0.05, 0.05, 0.2, "utilReservoir", 0)
        BMKHS_HITPOINT(hit_hyd_utilPump, "hit_hyd_utilPump", 0.0603, 0.05, 0.05, 0.15, "utilPump", 0)

        //--- Fuel ----------------------------------------------------------------
        BMKHS_HITPOINT(hit_fuel_aft, "hit_fuel_aft", 0.2412, 0.14, 0.15, 0.3, "fuelTanks", 2)
        BMKHS_HITPOINT(hit_fuel_forward, "hit_fuel_forward", 0.2412, 0.14, 0.15, 0.3, "fuelTanks", 0)
        BMKHS_HITPOINT(hit_msnEquip_magAndRobbie, "hit_msnEquip_magAndRobbie", 0.2412, 0.14, 0.15, 0.3, "fuelTanks", 1)

        //--- Flight controls -----------------------------------------------------
        BMKHS_HITPOINT(hit_stabilator, "hit_stabilator", 0.09648, 0.14, 0.05, 0.8, "stabilator", 0)

        //--- Mission equipment ---------------------------------------------------
        BMKHS_HITPOINT(hit_msnEquip_gun_turret, "hit_msnEquip_gun_turret", 0.09648, 0.14, 0.05, 0.8, "gunTurret", 0)
        BMKHS_HITPOINT(hit_msnEquip_pnvs_flir, "hit_msnEquip_pnvs_flir", 0.09648, 0.14, 0.05, 0.8, "", 0)
        BMKHS_HITPOINT(hit_msnEquip_pnvs_turret, "hit_msnEquip_pnvs_turret", 0.09648, 0.14, 0.05, 0.8, "", 0)
        BMKHS_HITPOINT(hit_msnEquip_pylon1, "hit_msnEquip_pylon1", 0.09648, 0.14, 0.05, 0.8, "pylons", 0)
        BMKHS_HITPOINT(hit_msnEquip_pylon2, "hit_msnEquip_pylon2", 0.09648, 0.14, 0.05, 0.8, "pylons", 1)
        BMKHS_HITPOINT(hit_msnEquip_pylon3, "hit_msnEquip_pylon3", 0.09648, 0.14, 0.05, 0.8, "pylons", 2)
        BMKHS_HITPOINT(hit_msnEquip_pylon4, "hit_msnEquip_pylon4", 0.09648, 0.14, 0.05, 0.8, "pylons", 3)
        BMKHS_HITPOINT(hit_msnEquip_tads_dtv, "hit_msnEquip_tads_dtv", 0.09648, 0.14, 0.05, 0.8, "", 0)
        BMKHS_HITPOINT(hit_msnEquip_tads_flir, "hit_msnEquip_tads_flir", 0.09648, 0.14, 0.05, 0.8, "", 0)
        BMKHS_HITPOINT(hit_msnEquip_fcr, "hit_msnEquip_fcr", 0.09648, 0.14, 0.05, 0.8, "", 0)
        BMKHS_HITPOINT(hit_msnEquip_irJam, "hit_msnEquip_irJam", 0.09648, 0.05, 0.05, 0.24, "", 0)

        //--- Other ---------------------------------------------------------------
        BMKHS_HITPOINT(hit_apu, "hit_apu", 0.09648, 0.14, 0.05, 0.3, "apu", 0)
    };
