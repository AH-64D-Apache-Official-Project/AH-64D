
#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions {
    class fza_ah64_weapons {
        tag = "fza_weapons";
        class functions {
            file = "\fza_ah64_weapons\functions";
            class controller {R;};
            class handleControl {R;};
            class init {R;};
            class pylonCheckValid {R;};
            class pylonController {R;};
            class sightData {R;};
        };
        class cannon {
            file = "\fza_ah64_weapons\functions\cannon";
            class cannonPylonController {R;};
            class fireCannon {R;};
            class SwapM230Mag {R;};
        };
        class hellfire {
            file = "\fza_ah64_weapons\functions\hellfire";
            class fireHellfire {R;};
            class hellfirePylonController {R;};
            class MissileCycle {R;};
            class MissileGetSelected {R;};
            class MissileInventory {R;};
            class TrajectoryChange {R;};
        };
        class rocket {
            file = "\fza_ah64_weapons\functions\rocket";
            class fireRocket {R;};
            class RocketInventory {R;};
            class RocketPylonController {R;};
            class RocketSetSelected {R;};
        };
        class was {
            file = "\fza_ah64_weapons\functions\was";
            class weaponActionSwitch {R;};
        };
    };
};