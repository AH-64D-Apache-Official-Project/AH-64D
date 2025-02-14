class MFD {};
class Turrets : Turrets
{
    class MainTurret: NewTurret
    {
        class MFD {};
        gunnerAction = "fza_ah64_copilot";
        gunnerGetInAction = "pilot_Heli_Light_02_Enter";
        gunnerGetOutAction = "GetOutHigh";
        preciseGetInOut = 1;
        hideWeaponsGunner = false;
        primary = 1;
        primaryGunner = 1;
        stabilizedInAxes = 3;
        weapons[] = {"fza_ma_safe", "Laserdesignator_mounted","fza_m230", "fza_cannon_limit", "fza_gun_inhibit", "fza_hydra_limit", "fza_pylon_inhibit"};
        magazines[] = {"fza_safe", "LaserBatteries", "fza_m230_300", "fza_cannon_limit", "fza_gun_inhibit", "fza_hydra_limit", "fza_pylon_inhibit"};
        memoryPointsGetInGunner = "pos gunner";
        memoryPointsGetInGunnerDir = "pos gunner dir";
        memoryPointGun = "laserBegin";
        memoryPointGunnerOptics = "gunnerview";
        body = "tads_tur";
        gun = "tads";
        animationsourcebody = "tads_tur";
        animationsourcegun = "tads";
        gunBeg = "laserBegin";
        gunEnd = "laserEnd";
        gunnerOpticsModel = "";
        gunnerOpticsColor[] = {1,1,1,1};
        minElev = -60;
        maxElev = 30;
        initElev= 0;
        maxHorizontalRotSpeed = 1.047;
        maxVerticalRotSpeed = 1.047;
        minTurn = -120;
        maxTurn = 120;
        initTurn = 0;
        minGunElev = -60;
        maxGunElev = 30;
        minGunTurn = -120;
        maxGunTurn = 120;
        minGunTurnAI = -90;
        maxGunTurnAI = 90;
        commanding = -1;
        gunnerForceOptics = 0;
        startEngine=0;
        outGunnerMayFire = 1;
        turretinfotype = "RscUnitInfoNoHUD";
        turretFollowFreeLook = 0;
        discreteDistance[]={100,200,300,400,500,600,700,800,1000,1200,1500,1800,2100,2500,2800,3300};
        discreteDistanceInitIndex=5;
        isCopilot = 1;
        usePiP=1;
        class HitPoints
        {//utilize vanilla turret lock when tads component is destroyed
            class HitTurret
            {
                armor = 1.44 * 0.067;
                radius = 0.14;
                minimalHit = 0.05;
                explosionShielding = 0.80;
                name = "hit_msnEquip_tads_turret";
                material = 51;
                passThrough = 0;
            };
        };
        class OpticsIn
        {
            class Flir_Wide
            {
                gunneropticsmodel = "\fza_ah64_us\fza_ah64_optics_empty";
                initfov = "(46.25 / 120)";
                minfov = "(46.25 / 120)";
                maxfov = "(46.25 / 120)";
                visionmode[] = {"Ti"};
                thermalmode[] = {0,1};
                directionStabilized = 0;
                minanglex = -60;
                maxanglex = 30;
                minangley = -120;
                maxangley = 120;
                initanglex = 0;
                initangley = 0;
                opticsdisplayname = "W";
            };
            class Flir_Medium: Flir_Wide
            {
                initfov = "(9.5 / 120)";
                minfov = "(9.5 / 120)";
                maxfov = "(9.5 / 120)";
                opticsdisplayname = "M";
            };
            class Flir_Narrow: Flir_Wide
            {
                initfov = "(2.75 / 120)";
                minfov = "(2.75 / 120)";
                maxfov = "(2.75 / 120)";
                opticsdisplayname = "N";
            };  
            class Flir_Zoom: Flir_Wide
            {
                initfov = "(1.5 / 120)";
                minfov = "(1.5 / 120)";
                maxfov = "(1.5 / 120)";
                opticsdisplayname = "Z";
            };
            class A3ti_Wide: Flir_Wide
            {
                initfov = "(46.25 / 120)";
                minfov = "(46.25 / 120)";
                maxfov = "(46.25 / 120)";
                visionmode[] = {"Normal"};
                opticsdisplayname = "W";
            };
            class A3ti_Medium: A3ti_Wide
            {
                initfov = "(9.5 / 120)";
                minfov = "(9.5 / 120)";
                maxfov = "(9.5 / 120)";
                opticsdisplayname = "M";
            };
            class A3ti_Narrow: A3ti_Wide
            {
                initfov = "(2.75 / 120)";
                minfov = "(2.75 / 120)";
                maxfov = "(2.75 / 120)";
                opticsdisplayname = "N";
            };  
            class A3ti_Zoom: A3ti_Wide
            {
                initfov = "(1.5 / 120)";
                minfov = "(1.5 / 120)";
                maxfov = "(1.5 / 120)";
                opticsdisplayname = "Z";
            };
            class Dtv_wide: Flir_Wide
            {
                visionmode[] = {"Normal"};
                initfov = "(4.25 / 120)";
                minfov = "(4.25 / 120)";
                maxfov = "(4.25 / 120)";
                opticsdisplayname = "w";
            };
            class Dtv_dummyFOV: Dtv_wide {};
            class Dtv_Narrow: Dtv_wide
            {
                initfov = "(1.5 / 120)";
                minfov = "(1.5 / 120)";
                maxfov = "(1.5 / 120)";
                opticsdisplayname = "N";
            };
            class Dtv_Zoom: Dtv_wide
            {
                initfov = "(0.6 / 120)";
                minfov = "(0.6 / 120)";
                maxfov = "(0.6 / 120)";
                opticsdisplayname = "Z";
            };
        };
        class OpticsOut
        {
            class Monocular //FOV CPG
            {
                gunneropticseffect[] = {};
                gunneropticsmodel = "";
                initfov = 0.7;
                initanglex = 0;
                initangley = 0;
                minfov = 0.4;
                maxfov = 0.7;
                minanglex = -60;
                maxanglex = 30;
                minangley = -120;
                maxangley = 120;
            };
        };
        class Components
        {
            class VehicleSystemsDisplayManagerComponentLeft
            {
                componentType = "VehicleSystemsDisplayManager";
                x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_X"", (safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
                y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_Y"", (safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
                left = 1;
                defaultDisplay = "CrewDisplay";
                class Components
                {
                    class EmptyDisplay // Empty display - hide panel
                    {
                        componentType = "EmptyDisplayComponent";
                    };
                    class MinimapDisplay // GPS
                    {
                        componentType = "MinimapDisplayComponent";
                        resource = "RscCustomInfoMiniMap";
                    };
                };
            };
            class VehicleSystemsDisplayManagerComponentRight : VehicleSystemsDisplayManagerComponentLeft {
                left = 0;
                right = 1;
                x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_X"",((safezoneX + safezoneW) - ((10 * (((safezoneW / safezoneH) min 1.2) / 40)) + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)))])";
                y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_Y"",(safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
            };
        };
    };
};