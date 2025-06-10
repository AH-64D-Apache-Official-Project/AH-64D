class cfgVehicles {

    class Box_NATO_Equip_F;
    class Land_WoodenCrate_01_F;
    class fza_ah64_ObjectBase: Land_WoodenCrate_01_F {
        author                              = "Snow(Dryden)";
        displayName                         = "Apache Object Base";
        scope                               = 1;
        ace_cargo_canLoad                   = 1;
        ace_dragging_canCarry               = 1;
        ace_cargo_size                      = 4;
        ace_cargo_noRename                  = 1;
        ace_dragging_carryDirection         = -90;
        editorCategory                      = "EdCat_fza_ah64_Parts";
        editorSubcategory                   = "EdSubcat_fza_ah64_Components";
        maximumLoad                         = 0;
        vehicleClass                        = "Objects";
        simulation                          = "thingX";
        class SimpleObject
        {
            eden                            = 1;
            animate[]                       = {};
            hide[]                          = {};
            verticalOffset                  = 0.348;
            verticalOffsetWorld             = 0;
            init                            = "''";
        };
    };
    class fza_ah64_FireControlRadar: fza_ah64_ObjectBase {
        displayName                         = "AH-64 Fire Control Radar";
        model                               = "\fza_ah64_model\fza_longbow.p3d";
        editorSubcategory                   = "EdSubcat_fza_ah64_Components";
        scope                               = 2;
    };
    class fza_ah64_IAFS: fza_ah64_ObjectBase {
        displayName                         = "AH-64 IAFS";
        editorSubcategory                   = "EdSubcat_fza_ah64_Components";
        scope                               = 2;
    };
    class fza_ah64_1200Magazine: fza_ah64_ObjectBase {
        displayName                         = "AH-64 1200 Magazine";
        editorSubcategory                   = "EdSubcat_fza_ah64_Magazines";
        scope                               = 2;
    };

    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class ACE_Actions;
    };
    class fza_ah64base : Helicopter_Base_F {
        #include "CfgAce.hpp"
    };
};