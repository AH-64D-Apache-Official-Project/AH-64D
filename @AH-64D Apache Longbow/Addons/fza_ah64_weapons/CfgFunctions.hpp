
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
            class pylonSetHellfire {R;};
            class pylonSetOwner {R;};
            class pylonSetRocket {R;};
        };
        class functions {
            file = "\fza_ah64_weapons\functions";
            class getTadsAimPosASL {R;};
            class WeaponGetWas {R;};
        };
    };
};