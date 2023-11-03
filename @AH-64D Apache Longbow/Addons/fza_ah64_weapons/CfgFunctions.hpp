
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_weapons
    {
        tag = "fza_weapons";
        class functions {
            file = "\fza_ah64_weapons\functions";
            class loadoutImportJson {R;};
        };
        class pylon {
            file = "\fza_ah64_weapons\functions\pylon";
            class pylonSetOwner {R;};
        };
    };
};