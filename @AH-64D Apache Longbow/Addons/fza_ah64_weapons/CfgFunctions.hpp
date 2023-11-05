
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
        class pylon {
            file = "\fza_ah64_weapons\functions\pylon";
            class pylonSetOwner {R;};
        };
    };
};