class cfgVehicles {

    class Land_WoodenCrate_01_F;
    class fza_ah64_ObjectBase: Land_WoodenCrate_01_F {
        author                              = "Snow(Dryden)";
        displayName                         = "$STR_FZA_AH64_OBJECT_BASE";
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
        displayName                         = "$STR_FZA_AH64_FCR";
        model                               = "\fza_ah64_model\fza_longbow.p3d";
        editorSubcategory                   = "EdSubcat_fza_ah64_Components";
        scope                               = 2;
    };
    class fza_ah64_IAFS: fza_ah64_ObjectBase {
        displayName                         = "$STR_FZA_AH64_IAFS";
        editorSubcategory                   = "EdSubcat_fza_ah64_Components";
        scope                               = 2;
    };
    class fza_ah64_1200Magazine: fza_ah64_ObjectBase {
        displayName                         = "$STR_FZA_AH64_1200MAGAZINE";
        editorSubcategory                   = "EdSubcat_fza_ah64_Magazines";
        scope                               = 2;
    };

    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class ACE_Actions;
    };
    class fza_ah64base : Helicopter_Base_F {
        #include "CfgAce.hpp"
        class Attributes{
            class fza_pylonLoadout
            {
                displayName  = "$STR_FZA_AH64_LOADOUT";
                tooltip      = "$STR_FZA_AH64_LOADOUT_INFO";
                property     = "fza_ah64_loadout";
                control      = "Edit";
                expression   = "[_this, _value] call fza_customise_fnc_loadoutImportJson;";
                defaultValue = "''";
                unique       = 0;
                validate     = "none";
                condition    = "1";
                typeName     = "STRING";    
            };
            class fza_ah64_tailNumber {
                displayName  = "$STR_FZA_AH64_TAIL_NUMBER";
                tooltip      = "$STR_FZA_AH64_TAIL_NUMBER_INFO";
                property     = "fza_attribute_tailNumber";
                control      = "Edit";
                expression   = "[_this, _value] call fza_customise_fnc_setTailNumber;";
                defaultValue = "None";
                condition    = "objectVehicle";
            };
        };
    };
};
