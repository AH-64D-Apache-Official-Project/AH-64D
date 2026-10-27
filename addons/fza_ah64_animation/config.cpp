class CfgPatches
{
    class fza_ah64_animation
    {
        units[] = {};
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"fza_ah64_common", "bmkhs_helisim"};
        #include "version.hpp"
    };
};

#include "cfgFunctions.hpp"

class Extended_PreInit_EventHandlers {
    class fza_ah64_animation {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_animation\XEH_preInit.sqf';";
    };
};

// Every Apache, for the blades shown on this machine (fza_anim_fnc_rotorBlades)
class Extended_Init_EventHandlers {
    class fza_ah64base {
        class fza_ah64_animation_init_eh {
            init = "if (!isNil 'fza_anim_rotorHelis') then {fza_anim_rotorHelis pushBackUnique (_this select 0)};";
        };
    };
};
