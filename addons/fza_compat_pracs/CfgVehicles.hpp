class CfgVehicles {
    class Tank_F;
    class Radar_System_01_base_F;
    class SAM_System_04_base_F;
    class PRACS_BMR_ATGM;
    class rhsusf_m113_usarmy;

    class PRACS_MPQ64_Sentinel: Radar_System_01_base_F {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class PRACS_m48_chapparal: Tank_F {
        fza_aseClass = "RADAR"; //SAM CHAPPARAL, Audio does not exist
        fza_aseIcon = "CH";
    };
    class PRACS_m48_chapparal_EH: PRACS_m48_chapparal {
        fza_aseClass = "RADAR"; //SAM CHAPPARAL, Audio does not exist
        fza_aseIcon = "CH";
    };
    class PRACS_M548_MPQ64: PRACS_m48_chapparal {
        fza_aseClass = "RADAR";
        fza_aseIcon = "SR";
    };
    class PRACS_BMR_AD: PRACS_BMR_ATGM {
        fza_aseClass = "RADAR"; //CROTALE, Audio does not exist
        fza_aseIcon = "CT";
    };
    class PRACS_M163_PIVADS: rhsusf_m113_usarmy {
        fza_aseClass = "RADAR"; //VULCAN, Audio does not exist
        fza_aseIcon = "VU";
    };
    class PRACS_MiM23_HAWK: SAM_System_04_base_F {
        fza_aseClass = "HAWK";
        fza_aseIcon = "HK";
    };
    class PRACS_M727_IHAWK: PRACS_m48_chapparal {
        fza_aseClass = "HAWK";
        fza_aseIcon = "HK";
    };
    class PRACS_M727_SEM_IHAWK: PRACS_M727_IHAWK {
        fza_aseClass = "HAWK";
        fza_aseIcon = "HK";
    };
    class PRACS_M985_AD: PRACS_m48_chapparal {
        fza_aseClass = "RADAR"; //STINGER, Audio does not exist
        fza_aseIcon = "ST";
    };
};
