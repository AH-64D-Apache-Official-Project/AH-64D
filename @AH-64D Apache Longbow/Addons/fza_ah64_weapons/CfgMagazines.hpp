class CfgMagazines
{
    class VehicleMagazine;
    class fza_safe: VehicleMagazine
    {
        scope = 1;
        displayName="SAFE";
        ammo="fza_master";
        count=1;
        initSpeed=0;
        tracersEvery=0;
        nameSound="";
    };
    class fza_burstlimit: fza_safe{displayName="SAFE";ammo="fza_master";};
    class fza_cannon_limit: fza_burstlimit {displayName = "Burst Limit";};
    class fza_gun_inhibit: fza_burstlimit {displayName = "Cannon Inhibit";};
    class fza_hydra_limit: fza_burstlimit {displayName = "Salvo Limit";};
    class fza_pylon_inhibit: fza_burstlimit {displayName = "Pylon Inhibit";};
};