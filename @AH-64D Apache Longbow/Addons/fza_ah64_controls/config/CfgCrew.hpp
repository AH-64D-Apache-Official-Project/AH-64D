class B_Helipilot_F;
#define MAG_2(a) a, a
#define MAG_6(a) a, a, a, a, a, a
class fza_ah64_pilot: B_Helipilot_F
{
    author                  = "Rosd6(Dryden)";
    scope                   = 2;
    scopeCurator            = 2;
    displayName             = "AH-64D Pilot";
	editorPreview           = "\fza_ah64_us\editorPreview\fza_ah64_pilot.jpg";
    uniformClass			= "U_B_CombatUniform_mcam";
    weapons[]               = {"arifle_SPAR_01_blk_MRCO_Flash_F", "hgun_P07_blk_F", "Throw", "Put", "Binocular"};
    respawnWeapons[]        = {"arifle_SPAR_01_blk_MRCO_Flash_F", "hgun_P07_blk_F", "Throw", "Put", "Binocular"};
    Items[]                 = {"FirstAidKit", "FirstAidKit", "ToolKit"};
    RespawnItems[]          = {"FirstAidKit", "FirstAidKit", "ToolKit"};
    magazines[]             = {MAG_6(30Rnd_556x45_Stanag), MAG_2(16Rnd_9x21_Mag), MAG_2(B_IR_Grenade), MAG_2(SmokeShell), MAG_2(SmokeShellBlue), MAG_2(SmokeShellPurple), MAG_2(Chemlight_green)};
    respawnMagazines[]      = {MAG_6(30Rnd_556x45_Stanag), MAG_2(16Rnd_9x21_Mag), MAG_2(B_IR_Grenade), MAG_2(SmokeShell), MAG_2(SmokeShellBlue), MAG_2(SmokeShellPurple), MAG_2(Chemlight_green)};
    linkedItems[]           = {"V_PlateCarrier1_rgr", "H_PilotHelmetHeli_O", "ItemMap", "ItemGPS", "ItemCompass", "ItemWatch", "ItemRadio", "NVGoggles_OPFOR"};
    respawnLinkedItems[]    = {"V_PlateCarrier1_rgr", "H_PilotHelmetHeli_O", "ItemMap", "ItemGPS", "ItemCompass", "ItemWatch", "ItemRadio", "NVGoggles_OPFOR"};
    faction					= "fza_usaav";
    vehicleclass			= "fza_Men";
};