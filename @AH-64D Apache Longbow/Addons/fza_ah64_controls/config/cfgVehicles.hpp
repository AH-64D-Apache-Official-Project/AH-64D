class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class CargoTurret;
        class Components;
        class EventHandlers;
        class HeadLimits;
        class NewTurret;
        class Turrets;
        delete PilotCamera;
    };
    class fza_ah64base : Helicopter_Base_F {
        icon        = "fza_ah64_controls\data\icons\b1_topdown_128x128_ca.paa";
        picture     = "fza_ah64_controls\data\icons\b1_silloheutte_128x64_ca.paa";
        displayName = "AH-64 Offical Project Base class";
        model       = "\fza_ah64_model\fza_ah64d_b1.p3d";
        scope       = 0;
        mapSize     = 10;

        A3TI_ThermalSelections[] = {"skin"};
        
        #include "cfgVehicles\acre.hpp"
        #include "cfgVehicles\animationSources.hpp"
        #include "cfgVehicles\itcAir.hpp"
        #include "cfgVehicles\markerLights.hpp"
        #include "cfgVehicles\reflectors.hpp"
        #include "cfgVehicles\sfmplus.hpp"
        #include "cfgVehicles\sounds.hpp"
        #include "cfgVehicles\soundsExt.hpp"
        #include "cfgVehicles\textureSources.hpp"
        #include "cfgVehicles\turrets.hpp"
        #include "hiddenSelections.hpp"

        class Components: Components {
            #include "cfgVehicles\pylons.hpp"
            #include "\fza_ah64_fcr\CfgSensors.hpp"
        };

        class UVAnimations {
            class mpd_pl {
                type     = scale;
                source   = mpd_scale;
                section  = plt_pl_mpd_back;
                minValue = 1;
                maxValue = 1;
                center[] = {0,0};
                scale0[] = {0.5,0.5};
                scale1[] = {0.5,0.5};
            };
            class mpd_pr: mpd_pl {
                center[] = {1,0};
                section = plt_pr_mpd_back;
            };
            class mpd_cl: mpd_pl {
                section = cpg_cl_mpd_back;
            };
            class mpd_cr: mpd_pr {
                section = cpg_cr_mpd_back;
            };
        };

        //Sensors definition
        receiveRemoteTargets    = 1;
        reportRemoteTargets     = 1;
        reportOwnPosition       = 1;

        //lesh tow compatabilty
        LESH_canBeTowed         = 1;
        LESH_towFromFront       = 0;
        LESH_AxisOffsetTarget[] = {0,-9.2,-2};
        LESH_WheelOffset[]      = {0,2.5};

        //HeliSim Variables-------------/
        startDuration          = 15;
        fuelCapacity           = 1423;
        fuelconsumptionrate    = 0.0;
        maxSpeed               = 298;
        altFullForce           = 1615;
        altNoForce             = 9000;
        liftForceCoef          = 0.00;
        bodyFrictionCoef       = 0.00;
        cyclicAsideForceCoef   = 0.00;
        cyclicForwardForceCoef = 0.00;
        backRotorForceCoef     = 0.00;
        //HeliSim Variables-------------/

        accuracy                                    = 5;
        ace_cargo_hasCargo                          = 0;
        ace_cargo_space                             = 0;
        ace_vehicle_damage_canHaveFireRing          = 1;
        ace_vehicle_damage_detonationDuringFireProb = 0.2;
        ace_vehicle_damage_engineDetonationProb     = 0.1;
        ace_vehicle_damage_engineFireProb           = 0;
        ace_vehicle_damage_hullDetonationProb       = 0.1;
        ace_vehicle_damage_hullFireProb             = 0;
        ace_vehicle_damage_turretDetonationProb     = 0.2;
        ace_vehicle_damage_turretFireProb           = 0;
        
        allowTabLock             = 0;
        armor                    = 600;
        attenuationEffectType    = "HeliAttenuation";
        audible                  = 4;
        author                   = "AH-64D Development Team";
        availableForSupportTypes[] = {"CAS_Heli", "Transport"};
        camshakecoef             = 0.3;
        cargoAction[]            = {"fza_ah64_leftcargo","fza_ah64_rightcargo"};
        cargoGetInAction[]       = {"GetInHigh","GetInHigh"};
        cargoGetOutAction[]      = {"GetOutHigh","GetOutHigh"};
        crew                     = "fza_ah64_pilot";
        driveOnComponent[]       = {"Wheels"};
        driverAction             = "fza_ah64_pilot";
        driverCanSee             = 1+2+4+8;
        driverlefthandanimname   = "p_collective";
        driverleftleganimname    = "pedalL";
        driverrighthandanimname  = "p_cyclic";
        driverrightleganimname   = "pedalR";
        ejectDeadCargo           = true;
        ejectdeadgunner          = false;
        enableCopilot            = true;
        explosionShielding       = 8;
        faction                  = "fza_usaav";
        getInAction              = "pilot_Heli_Light_02_Enter";
        getOutAction             = "GetOutHigh";
        gunnerCanSee             = 1+2+4+8;
        gunnerUsesPilotView      = false;
        hasGunner                = 1;
        incomingMissileDetectionSystem = 16;
        insideSoundCoef          = 0.5;
        irTargetSize             = 0.800000;
        landingSoundInt0[]       = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000};
        landingSoundInt1[]       = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open", 1.000000, 1.000000};
        landingSoundInt[]        = {"landingSoundInt0", 0.500000, "landingSoundInt1", 0.500000};
        landingSoundOut0[]       = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
        landingSoundOut1[]       = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1", 1.778279, 1.000000, 10};
        landingSoundOut[]        = {"landingSoundOut0", 0.500000, "landingSoundOut1", 0.500000};
        laserScanner             = 1;
        laserTarget              = 0;
        lockdetectionsystem      = "8+4";
        magazines[]              = {"fza_chaff_30_mag","fza_IR_JAMMING"};
        mainBladeRadius          = 7.3;
        maxFordingDepth          = 0.55;
        memorypointcm[]          = {"flare_1_beg","Flare_2_beg"};
        memorypointcmdir[]       = {"flare_1_end","flare_2_end"};
        nameSound                = "veh_Helicopter";
        nightVision              = 1;
        obstructSoundsWhenIn     = 0.316228;
        occludeSoundsWhenIn      = 0.562341;
        preciseGetInOut          = 1;
        radarTarget              = 1;
        radarTargetSize          = 0.700000;
        rotorDamage[]            = {"rotorDamageInt", "rotorDamageOut"};
        rotorDamageInt[]         = {"\fza_ah64_controls\data\audio\Int_Rotor_Damage.ogg", 1.000000, 1.000000};
        rotorDamageOut[]         = {"\fza_ah64_controls\data\audio\Ext_Rotor_Damage.ogg", 2.511886, 1.000000, 100};
        selectionHRotorMove      = "mr_blur";
        selectionHRotorStill     = "mr_blades";
        selectionVRotorMove      = "tr_blur";
        selectionVRotorStill     = "tr_blades";
        sensorPosition           = "sensorPos";
        side                     = 1;
        simulation               = helicopterRTD;
        soundArmorCrash[]        = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
        soundBuildingCrash[]     = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
        soundBushCollision1[]    = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_1", 1.000000, 1, 10};
        soundBushCollision2[]    = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_2", 1.000000, 1, 10};
        soundBushCollision3[]    = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_3", 1.000000, 1, 10};
        soundBushCrash[]         = {"soundBushCollision1", 0.330000, "soundBushCollision2", 0.330000, "soundBushCollision3", 0.330000};
        soundDammage[]           = {"\fza_ah64_controls\data\audio\Crash.ogg", 3.162278, 1, 100};
        soundCrashes[]           = {"soundGeneralCollision1", 0.330000, "soundGeneralCollision2", 0.330000, "soundGeneralCollision3", 0.330000};
        soundEngineOffExt[]      = {"emptySound",0,0.6,300};
        soundEngineOffInt[]      = {"emptySound", 0};
        soundEngineOnExt[]       = {"emptySound",0,0.6,300};
        soundEngineOnInt[]       = {"emptySound", 0};
        soundenviron[]           = {"", 1, 1};
        soundGeneralCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_1", 1.000000, 1, 10};
        soundGeneralCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_2", 1.000000, 1, 10};
        soundGeneralCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_3", 1.000000, 1, 10};
        soundgetin[]             = {"A3\Sounds_F\vehicles\air\noises\heli_get_in2",1,1,1};
        soundgetout[]            = {"A3\Sounds_F\vehicles\air\noises\heli_get_out2",1,1,1};
        soundLandCrashes[]       = {"soundGeneralCollision1", 0.330000, "soundGeneralCollision2", 0.330000, "soundGeneralCollision3", 0.330000};
        soundWaterCollision1[]   = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_1", 1.000000, 1, 10};
        soundWaterCollision2[]   = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_2", 1.000000, 1, 10};
        soundWaterCrashes[]      = {"soundWaterCollision1", 0.500000, "soundWaterCollision2", 0.500000};
        soundWoodCrash[]         = {"soundGeneralCollision1", 1, "soundGeneralCollision2", 1, "soundGeneralCollision3", 1};
        tailDamage[]             = {"tailDamageInt", "tailDamageOut"};
        tailDamageInt[]          = {"\fza_ah64_controls\data\audio\Tail_Damage.ogg", 1.000000, 1.000000};
        tailDamageOut[]          = {"\fza_ah64_controls\data\audio\Tail_Damage.ogg", 1.000000, 1.000000, 100};
        threat[]                 = {1,1,0.5};
        transportMaxBackpacks    = 2;
        transportMaxMagazines    = 10;
        transportMaxWeapons      = 3;
        transportSoldier         = 2;
        type                     = VAir;
        unitinfotype             = "fza_ah64_rscInfoMinimal";
        unitInfoTypeLite         = "fza_ah64_rscInfoMinimal";
        unitInfoTypeRTD          = "fza_ah64_rscInfoMinimal";
        usePreciseGetInAction    = 1;
        vehicleclass             = "fza_helicopters";
        weapons[]                = {"fza_CMChaffLauncher","fza_AseIRjammer"};
        class Library {
            libTextDesc = "The AH-64D Block I is an anti-tank attack helicopter. Defining characteristics are: Four bladed main rotor, X-shaped tail rotor, a boxy cockpit with two distinct bays on the sides, two stub wings with two pylons each, two main wheels and a tail wheel, a chin mounted turret, and a long rounded tailboom with a stabilizator at the rear. Production began in 1982 and the first unit was deployed in 1986. By 1993, the US Army had over 800 Apaches in service. It was firsted used in combat during Operation Just Cause, the invasion of Panama in 1989 where some drawbacks were encountered (primarily with the avionics). During Desert Storm in 1991, Apaches performed the first strike of that conflict by destroying Iraqi early warning radars. More drawbacks were encountered in Desert Storm, some of which were: limited navigation capabilities, high maintenance, and intolerance to desert conditions. AH-64As went through some modernization upgrades, but the AH-64A has been phased out of active US Army service in favor of the AH-64D, and now only National Guard and Reserve units operate the A model. The AH-64D has two General Electric T700-GE-701C engines producing a total of 3392shp, giving the aircraft a maximum clean speed of about 227mph (365kmh). This speed comes down to about 300kmh loaded. Combat endurance is about 2 hours with standard loads. It is armed with a M230 30mm Chain Gun cannon by default, with provisions for AGM-114 HELLFIRE missiles and 2.75in HYDRA-70 rockets. Experimentally it has used the Stinger missile, Sidearm missile, Sidewinder missile, and Starstreak missile. The US Army has not used any of these weapons operationally with the Apache.";
        };
        class HeadLimits {
            initanglex = 0;
            initangley = 0;
            maxanglex  = 40;
            maxangley  = 90;
            maxanglez  = 45;
            minanglex  = -40;
            minangley  = -90;
            minanglez  = -45;
            rotzradius = 0.2;
        };
        class ViewPilot {
            initFov    = 0.7;
            minFov     = 0.4;
            maxFov     = 0.85;
            initAngleX = 0;
            minAngleX  = -75;
            maxAngleX  = 50;
            initAngleY = 0;
            minAngleY  = -150;
            maxAngleY  = 150;
            maxmovex   = 0.15;
            maxmovey   = 0.1;
            maxmovez   = 0.1;
            minmovex   = -0.15;
            minmovey   = -0.1;
            minmovez   = -0.1;
        };
        class SimpleObject {
            eden                = 1;
            animate[]           = {};
            hide[]              = {"mr_blur","tr_blur","hdam_tr","hdam_rtr"};
            verticalOffset      = 1.785;
            verticalOffsetWorld = 0.006;
            init                = "[this, '', []] call bis_fnc_initVehicle";
        };
        class EventHandlers {
            class fza_ah64 {
                init         = "[_this # 0] spawn fza_fnc_eventInit;";
                handleDamage = "_this call fza_fire_fnc_damageSystem; _this call fza_auxtank_fnc_damage";
            };
        };
        class RenderTargets {
            class driverpnvs2 {
                renderTarget = "fza_ah64_pnvscam2";
                class View01 {
                    pointPosition    = "driverview";
                    pointDirection   = "driverview_dir";
                    renderQuality    = 2;
                    renderVisionMode = 2; //TI HDU
                    fov              = 0.3;
                };
            };
        };
        class Exhausts {
            class Exhaust1 {
                direction = "exhaust1_dir";
                effect    = "ExhaustEffectHeli";
                position  = "exhaust1";
            };
            class Exhaust2 {
                direction = "exhaust2_dir";
                effect    = "ExhaustEffectHeli";
                position  = "exhaust2";
            };
        };
    };

    //- TEST SOUND DUMMY
    class Helicopter_Base_H;
    class Heli_Transport_01_base_F: Helicopter_Base_H {
        #include "cfgVehicles\sounds.hpp"
        #include "cfgVehicles\soundsExt.hpp"
    };
    
    class fza_ah64d_b1: fza_ah64base {
        side            = 1;
        scope           = 2;
        author          = "AH-64D Development Team";
        displayName     = "AH-64D BLOCK I";
        editorPreview   = "\fza_ah64_controls\data\editorpreview\fza_ah64d_b1.jpg";
    };

    class StaticMGWeapon;
    class fza_ah64_pylon_base: StaticMGWeapon {
        scope = 1;
        displayName = "Pylon";
        crew = "";
        model = "\fza_ah64_controls\data\pya_pylon_single.p3d";
        destrType = "DestructDefault";
        threat[] = {0.2, 0.2, 0.2};
        radarTargetSize = 0.05;
        visualTargetSize = 0.05;
        irTargetSize = 0.05;

        class Components {
            class TransportPylonsComponent {
                uiPicture = "";
                class pylons {
                    class pylons1 {
                        maxweight = 560;
                        turret[] = {0};
                        hardPoints[] = {"fza_hydra70_zone_AC", "fza_hydra70_zone_BD", "fza_hydra70_zone_E", "fza_agm114_ul", "fza_agm114_ur", "fza_agm114_ll", "fza_agm114_lr", "fza_railzone"};
                        attachment = "";
                        priority = 1;
                        UIposition[] = {0.1, 0.05};
                    };
                };
            };
        };

        ace_cargo_space = 0;
        ace_cargo_hasCargo = 0;
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 1;
    };

    class fza_ah64d_b2e: fza_ah64base{scope = 0;displayName = "DEPRECATED";};
};
