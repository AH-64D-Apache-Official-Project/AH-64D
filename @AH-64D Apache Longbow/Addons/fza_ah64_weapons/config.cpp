class CfgPatches
{
    class fza_ah64_weapons
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
    };
};
#include "\fza_ah64_controls\config\defines.hpp"

#include "CfgAmmo.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
/*
class CfgVehicles {
    class LandVehicle;
    class StaticWeapon: LandVehicle {
        class Turrets;
    };
    class StaticMGWeapon: StaticWeapon {
        class Turrets: Turrets {
            class MainTurret;
        };
    };
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
    class fza_ah64_pylon_base: StaticMGWeapon {
        scope = 1;
        displayName = "Pylon";
        author = "Ampersand";
        mapSize = 0;
        side = 1;
        faction = "BLU_F";
        crew = "";
        model = "fza_ah64_hellfire\data\pylon\fza_rail_ul.p3d";
        icon = "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa";
        hasDriver = 0;
        destrType = "DestructDefault";
        getInRadius = 0;
        cost = 0;
        threat[] = {0.2, 0.2, 0.2};
        radarTargetSize = 0.05;
        visualTargetSize = 0.05;
        irTargetSize = 0;
        reportRemoteTargets = 0;
        reportOwnPosition = 0;
        maximumLoad = 0;

        class AnimationSources {};
        class Attributes;
        class Components;
        class Exhausts {};
        class Sounds {};
        class TransportItems {};
        class TransportMagazines {};
        class TransportWeapons {};
        class UserActions {};
        class HitPoints {};
        class Turrets{};

        ace_cargo_space = 0;
        ace_cargo_hasCargo = 0;
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 1;
    }; // pylon_base
};