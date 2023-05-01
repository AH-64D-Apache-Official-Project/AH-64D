class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F: Helicopter {
        class EventHandlers;
    };
    class fza_ah64base : Helicopter_Base_F {
        class EventHandlers: EventHandlers {
            class fza_dms {
                init = "[_this # 0] call fza_dms_fnc_init"; //<-- C51 always is the user positio
            };
        };
    };

    class All;
    class Logic : All {
        class EventHandlers;
    };

    class fza_dms_point_base : Logic {
        scope = private;
        vehicleClass = fza_dms;
        class Attributes {
            class fza_dms_point_index {
                displayName = "Point Index";
                tooltip = "";
                control = "Edit"
                property = "fza_dms_point_index";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "''";
                unique = 0;
                validate = number;
                typeName = NUMBER;
                condition = "1";
            };
            class fza_dms_point_ident {
                displayName = "Point Ident";
                tooltip = "The 2-character IDENT code describing the point";
                control = fza_dms_ident;
                property = "fza_dms_point_ident";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "";
                unique = 0;
                validate = none;
                typeName = STRING;
                condition = "1";
            };
            class fza_dms_point_free {
                displayName = "Point Free Text";
                tooltip = "3 characters of free text describing the point";
                control = "Edit"
                property = "fza_dms_point_free";
                expression =  "_this setVariable ['%s',_value]; _this call fza_dms_fnc_edenPointModify;";
                defaultValue = "''";
                unique = 0;
                validate = none;
                typeName = STRING;
                condition = "1";
            };
        };
    };

    class fza_dms_point_wp_hz : fza_dms_point_base {
        scope = public;
        fza_point_type[] = {POINT_TYPE_WP, POINT_TYPE_HZ};
        displayName = "DMS Waypoint / Hazard";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "Waypoint/Hazards are allowed to range from 1-50";
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
        displayName = "DMS Control Measure";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "Control Measures are allowed to range from 51-99."; //Beware that Present Positions (PPOS) will overwrite CM 93 thru 99.
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
        displayName = "DMS Target / Threat";
        class Attributes : Attributes {
            class fza_dms_point_index : fza_dms_point_index {
                tooltip = "Target/Threats are allowed to range from 1-50";
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