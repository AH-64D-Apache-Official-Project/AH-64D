class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F: Helicopter {};
    class fza_ah64base : Helicopter_Base_F {
        class EventHandlers {
            class fza_dms {
                init = "[_this # 0] call fza_dms_fnc_init"; //<-- C51 always is the user positio
            };
        };
    };

    class All;
    class Logic : All {
    };

    class fza_dms_point_base : Logic {
        scope = private;
        vehicleClass = "fza_dms";
        class Attributes {
            class fza_dms_point_index {
                displayName = "$STR_FZA_AH64_DMS_POINT_INDEX";
                tooltip = "";
                control = "Edit";
                property = "fza_dms_point_index";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "";
                unique = 0;
                validate = "number";
                typeName = "NUMBER";
                condition = "1";
            };
            class fza_dms_point_ident {
                displayName = "$STR_FZA_AH64_DMS_POINT_IDENT";
                tooltip = "$STR_FZA_AH64_DMS_POINT_IDENT_INFO";
                control = "fza_dms_ident";
                property = "fza_dms_point_ident";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "";
                unique = 0;
                validate = "none";
                typeName = "STRING";
                condition = "1";
            };
            class fza_dms_point_free {
                displayName = "$STR_FZA_AH64_DMS_POINT_FREE";
                tooltip = "$STR_FZA_AH64_DMS_POINT_FREE_INFO";
                control = "Edit";
                property = "fza_dms_point_free";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "''";
                unique = 0;
                validate = "none";
                typeName = "STRING";
                condition = "1";
            };
        };
    };

    class fza_dms_point_wp_hz : fza_dms_point_base {
        scope = public;
        fza_point_type[] = {POINT_TYPE_WP, POINT_TYPE_HZ};
        displayName = "$STR_FZA_AH64_DMS_WAYPOINT_HAZARD";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "$STR_FZA_AH64_DMS_WAYPOINT_HAZARD_INFO";
                defaultValue = "[_this, 'fza_dms_point_wp_hz'] call fza_dms_fnc_edenPointNext;";
            };
            class fza_dms_point_ident : fza_dms_point_ident {
                defaultValue = "'WP'";
                fza_point_type[] = {POINT_TYPE_WP, POINT_TYPE_HZ};
            };
            class fza_dms_point_free : fza_dms_point_free {};
            // I know this shouldn't need to be here, but it does
        };
    };
    class fza_dms_point_cm : fza_dms_point_base {
        scope = public;
        fza_point_type[] = {POINT_TYPE_CM};
        displayName = "$STR_FZA_AH64_DMS_CONTROL_MEASURE";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "$STR_FZA_AH64_DMS_CONTROL_MEASURE_INFO"; //Beware that Present Positions (PPOS) will overwrite CM 93 thru 99.
                defaultValue = "([_this, 'fza_dms_point_cm'] call fza_dms_fnc_edenPointNext)+50;";
            };
            class fza_dms_point_ident : fza_dms_point_ident {
                defaultValue = "'CP'";
                fza_point_type[] = {POINT_TYPE_CM};
            };
            class fza_dms_point_free : fza_dms_point_free {};
            // I know this shouldn't need to be here, but it does
        };
    };
    class fza_dms_point_tg : fza_dms_point_base {
        scope = public;
        fza_point_type[] = {POINT_TYPE_TG};
        displayName = "$STR_FZA_AH64_DMS_TARGET_THREAT";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "$STR_FZA_AH64_DMS_TARGET_THREAT_INFO";
                defaultValue = "[ _this, 'fza_dms_point_tg'] call fza_dms_fnc_edenPointNext;";
            };
            class fza_dms_point_ident : fza_dms_point_ident {
                defaultValue = "'TG'";
                fza_point_type[] = {POINT_TYPE_TG};
            };
            class fza_dms_point_free : fza_dms_point_free {};
            // I know this shouldn't need to be here, but it does
        };
    };
};
