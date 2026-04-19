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
    class fza_cannon_limit: fza_safe{displayName="$STR_FZA_AH64_BURST_LIMIT";magazines[]={"fza_cannon_limit"};};
    class fza_ma_safe: fza_cannon_limit{ displayName="$STR_FZA_AH64_MASTER_ARM_SAFE";magazines[]={"fza_safe"};};
    class fza_gun_inhibit: fza_cannon_limit {displayName = "$STR_FZA_AH64_CANNON_INHIBIT";magazines[]={"fza_gun_inhibit"};};
    class fza_hydra_limit: fza_cannon_limit {displayName = "$STR_FZA_AH64_SALVO_LIMIT";magazines[]={"fza_hydra_limit"};};
    class fza_pylon_inhibit: fza_cannon_limit {displayName = "$STR_FZA_AH64_PYLON_INHIBIT";magazines[]={"fza_pylon_inhibit"};};
};
