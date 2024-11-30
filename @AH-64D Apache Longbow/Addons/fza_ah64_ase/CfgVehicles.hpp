class CfgVehicles {
    class B_APC_Tracked_01_base_F;
    class AAA_System_01_base_F;
    class SAM_System_01_base_F;
    class SAM_System_02_base_F;
    class LT_01_scout_base_F;
    class LT_01_AA_base_F;
    class StaticMGWeapon;
    class AllVehicles;

    class B_SAM_System_01_F: SAM_System_01_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class B_SAM_System_02_F: SAM_System_02_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class I_LT_01_SCOUT_F: LT_01_scout_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class I_LT_01_AA_F: LT_01_AA_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class Radar_System_02_base_F: StaticMGWeapon {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class B_APC_TRACKED_01_AA_F: B_APC_Tracked_01_base_F {
        fza_aseClass = "2S6";
        fza_aseIcon = "2S6";
    };
    class Radar_System_01_base_F: StaticMGWeapon {
        fza_aseClass = "SA10";
        fza_aseIcon = "SA10";
    };
    class SAM_System_03_base_F: StaticMGWeapon {
        fza_aseClass = "SA10";
        fza_aseIcon = "SA10";
    };
    class SAM_System_04_base_F: StaticMGWeapon {
        fza_aseClass = "SA10";
        fza_aseIcon = "SA10";
    };
    class B_AAA_SYSTEM_01_F: AAA_System_01_base_F {
        fza_aseClass = "GUN";
        fza_aseIcon = "GU";
    };
    class Ship : AllVehicles {
        fza_aseClass = "NAVAL";
        fza_aseIcon = "NV";
    };
};
