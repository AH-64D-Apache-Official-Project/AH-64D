class CfgPatches
{
	class fza_ah64_weapons
	{
        units[] = {};
		author = "Rosd6(Dryden)";
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
    };
};

#include "config\CfgFunctions.hpp"

class CfgAmmo {
    class Default {};
    class MissileBase {};
    class M_Scalpel_AT: MissileBase {
        class Components;
        class EventHandlers;
    };
    class ammo_Penetrator_Base; {}
    class FlareCore {};
    class Bulletbase {};
    class B_30mm_HE {};
    class GrenadeBase {};
    class B_9x21_Ball {};

    #include "config\ammo\CfgAgm114.hpp"
    #include "config\ammo\CfgHydra275.hpp"
    #include "config\ammo\CfgM789.hpp"
    #include "config\ammo\CfgVehicle.hpp"
};

class CfgMagazines {
    class Default {};
	class CA_Magazine {};
    class VehicleMagazine {};
	class 6Rnd_Missile_AGM_02_F {};
    class PylonRack_4Rnd_ACE_Hellfire_AGM114K {};
    
    #include "config\magazines\CfgCannon.hpp"
    #include "config\magazines\CfgHellfire.hpp"
    #include "config\magazines\CfgRockets.hpp"
    #include "config\magazines\CfgVehicle.hpp"
};

class CfgWeapons {
    class Default {};
    class CannonCore {};
	class RocketPods {};
	class MissileLauncher {};
    class ace_hellfire_launcher {};
    class arifle_SPAR_01_blk_F {};
	class SmokeLauncher {};
    class Mode_SemiAuto {};

    #include "config\weapons\CfgM230.hpp"
    #include "config\weapons\CfgM261.hpp"
    #include "config\weapons\CfgM299.hpp"
    #include "config\weapons\CfgSpar16.hpp"
    #include "config\weapons\CfgVehicle.hpp"
};