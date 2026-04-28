class CfgAmmo
{
    class fza_30x113{};
    class fza_trigger: fza_30x113 {
        // Invisible, inert trigger round - deleted immediately in the Fired EH.
        timeToLive              = 0.1;
        model                   = "\A3\weapons_f\empty";
        hit                     = 0.0001;
        indirectHit             = 0.0001;
        indirectHitRange        = 0.0001;
        visibleFire             = 0.0001;
        audibleFire             = 0.0001;
        visibleFireTime         = 0.0001;
        submunitionAmmo[]       = {};
        effectsMissile          = "";
        effectsMissileInit      = "";
        effectsSmoke            = "";
        soundHit1[]             = {"", 0, 0};
        soundHit2[]             = {"", 0, 0};
        soundHitArmor1[]        = {"", 0, 0};
        soundHitArmor2[]        = {"", 0, 0};
        soundHitWater1[]        = {"", 0, 0};
        soundHitWater2[]        = {"", 0, 0};
        soundsetbulletfly[]         = {""};
        soundsetsoniccrack[]        = {""};
        soundsetexplosion[]         = {""};
        class CamShakeExplode {};
        class CamShakeHit {};
        class CamShakeFire {};
    };
};
