class CfgMagazines
{
    class VehicleMagazine;
    class fza_safe: VehicleMagazine {
        scope = 1;
        displayName="SAFE";
        ammo="fza_master";
        count=1;
        initSpeed=0;
        tracersEvery=0;
        nameSound="";
    };
    class fza_trigger: VehicleMagazine {
        scope        = 2;
        displayName  = "Trigger";
        ammo         = "fza_trigger";
        // High count - each round is deleted immediately; this is purely a firing signal.
        count        = 9999999;
        initSpeed    = 1;
        tracersEvery = 0;
        nameSound    = "";
        weight       = 1;
    };
};
