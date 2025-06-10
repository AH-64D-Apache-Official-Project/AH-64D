class CfgVehicles {
    class B_Helipilot_F;
    
    #define REPEAT_2(a) a, a
    #define REPEAT_6(a) a, a, a, a, a, a
    class fza_ah64_pilot: B_Helipilot_F
    {
        author                  = "Snow(Dryden)";
        scope                   = 2;
        scopeCurator            = 2;
        displayName             = "AH-64D Pilot";
        editorPreview           = "\fza_ah64_model\editorPreview\fza_ah64_pilot.jpg";
        uniformClass            = "U_B_CombatUniform_mcam";
        weapons[]               = {"arifle_SPAR_01_blk_MRCO_Flash_F", "hgun_P07_blk_F", "Throw", "Put", "Binocular"};
        respawnWeapons[]        = {"arifle_SPAR_01_blk_MRCO_Flash_F", "hgun_P07_blk_F", "Throw", "Put", "Binocular"};
        Items[]                 = {REPEAT_2(FirstAidKit)};
        RespawnItems[]          = {REPEAT_2(FirstAidKit)};
        magazines[]             = {REPEAT_6(30Rnd_556x45_Stanag), REPEAT_2(16Rnd_9x21_Mag), REPEAT_2(B_IR_Grenade), REPEAT_2(SmokeShell), REPEAT_2(SmokeShellBlue), REPEAT_2(SmokeShellPurple), REPEAT_2(Chemlight_green)};
        respawnMagazines[]      = {REPEAT_6(30Rnd_556x45_Stanag), REPEAT_2(16Rnd_9x21_Mag), REPEAT_2(B_IR_Grenade), REPEAT_2(SmokeShell), REPEAT_2(SmokeShellBlue), REPEAT_2(SmokeShellPurple), REPEAT_2(Chemlight_green)};
        linkedItems[]           = {"V_PlateCarrier1_rgr", "H_PilotHelmetHeli_O", "ItemMap", "ItemGPS", "ItemCompass", "ItemWatch", "ItemRadio", "NVGoggles_OPFOR"};
        respawnLinkedItems[]    = {"V_PlateCarrier1_rgr", "H_PilotHelmetHeli_O", "ItemMap", "ItemGPS", "ItemCompass", "ItemWatch", "ItemRadio", "NVGoggles_OPFOR"};
        faction                 = "fza_usaav";
        vehicleclass            = "fza_Men";
    };
};