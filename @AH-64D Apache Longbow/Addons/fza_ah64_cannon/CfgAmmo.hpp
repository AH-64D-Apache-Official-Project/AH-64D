class CfgAmmo {
    class B_30mm_HE;
    class fza_30x113: B_30mm_HE {
        //Ace Cfg
        ACE_caliber = 30.00;
        ACE_bulletLength = 104;
        ACE_bulletMass = 234;
        ACE_muzzleVelocityVariationSD = 0.37;
        ACE_ammoTempMuzzleVelocityShifts[] = {-27.20, -26.44, -23.76, -21.00, -17.54, -13.10, -7.95, -1.62, 6.24, 15.48, 27.75};
        ACE_ballisticCoefficients[] = {0.151};
        ACE_velocityBoundaries[]={};
        ACE_standardAtmosphere = "ICAO";
        ACE_dragModel = 1;
        ACE_muzzleVelocities[] = {805};
        ACE_barrelLengths[] = {1676};
        ace_vehicle_damage_incendiary = 0.7;

        ace_frag_enabled            = 1;
        ace_frag_skip               = 0;

        hit                         = 60;
        indirectHit                 = 20;
        indirectHitRange            = 3.5;
        typicalSpeed                = 800;
        maxspeed                    = 825;
        explosive                   = 0.8;

        airFriction                 = -0.00036;
        airlock                     = 0;
        irlock                      = 0;
        weaponType                  = "cannon";
        warheadName = "AP";

        //duel purpose warhead
        submunitionAmmo             ="ammo_Penetrator_30mm";
        submunitionDirectionType    ="SubmunitionModelDirection";
        submunitionInitSpeed        =1000;
        submunitionParentSpeedCoef  =0;
        submunitionInitialOffset[]  ={0,0,-0.2};
        triggerOnImpact             =1;
        deleteParentWhenTriggered   =0;
        
        soundsetbulletfly[]         = {"fza_sc_bullet_flyby_soundset"};
        soundsetsoniccrack[]        = {"fza_sc_30x113_soundset"};
        soundsetexplosion[]         = {"fza_20mm_explosion_soundset", "fza_explosion_echo_small_soundset"};

        //AI uasge
        aiAmmoUsageFlags            = "64+128+256";
        allowAgainstInfantry        = 1;
        cost                        = 15;
        visibleFire=32;
        audibleFire=200;
        visibleFireTime=3;
        dangerRadiusBulletClose=20;
        dangerRadiusHit=60;
        suppressionRadiusBulletClose=12;
        suppressionRadiusHit=24;

        aiRateOfFire = 0.109;
        aiRateOfFireDistance = 0;
        minRange = 0;
        minRangeProbab = 0.9;
        midRange = 2400;
        midRangeProbab = 0.8;
        maxRange = 3500;
        maxRangeProbab = 0.6;
        class CamShakeExplode {
            power = 6;
            duration = 1;
            frequency = 20;
        };
        class CamShakeHit {
            power = 30;
            duration = 0.4;
            frequency = 20;
        };
        class CamShakeFire {
            power = 1.8;
            duration = 1;
            frequency = 16;
            distance = 4;
        };
    };
};