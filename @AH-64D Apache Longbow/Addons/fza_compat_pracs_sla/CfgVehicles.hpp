class CfgVehicles {
    class APC_Tracked_02_base_F;
    class StaticCannon;
    class StaticMGWeapon;
    class Wheeled_APC_F;
    class Tank_F;
    
    class PRACS_SLA_1S91: APC_Tracked_02_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "TR";
    };
    class PRACS_P37_Radar: StaticCannon {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class PRACS_SLA_ZSU23: APC_Tracked_02_base_F {
        fza_aseClass = "ZSU";
        fza_aseIcon = "ZU";
    };
    class PRACS_SLA_Sa2: StaticMGWeapon {
        fza_aseClass = "SA2";
        fza_aseIcon = "SA2";
    };
    class PRACS_SLA_SA6: APC_Tracked_02_base_F {
        fza_aseClass = "RADAR"; //SA6, Audio does not yet exist
        fza_aseIcon = "SA6";
    };
    class PRACS_SLA_SA8: Wheeled_APC_F {
        fza_aseClass = "SA8";
        fza_aseIcon = "SA8";
    };
    class PRACS_SLA_SA9: APC_Tracked_02_base_F {
        fza_aseClass = "RADAR"; //SA9, Audio does not yet exist
        fza_aseIcon = "SA9";
    };
    class PRACS_SLA_SA13: Tank_F {
        fza_aseClass = "RADAR"; //SA13, Audio does not yet exist
        fza_aseIcon = "SA13";
    };
    class PRACS_SLA_SA17: Tank_F {
        fza_aseClass = "SA17";
        fza_aseIcon = "SA17";
    };
    class PRACS_SLA_2S6M_Tunguska: Tank_F {
        fza_aseClass = "2S6";
        fza_aseIcon = "2S6";
    };
};