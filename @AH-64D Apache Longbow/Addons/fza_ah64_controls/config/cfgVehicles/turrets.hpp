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
        gunnerOpticsModel = "\fza_ah64_ihadss\sight\apache_heads_down_mask.p3d";
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
        class OpticsIn {
            //////////////////////////////////////////////////
            //FLIR       /////////////////////////////////////
            //////////////////////////////////////////////////
            class Flir_Wide {
                gunnerOpticsModel = "\fza_ah64_ihadss\sight\apache_heads_down_mask.p3d";
                initfov = 0.4;  //0.4 = 1x mag
                minfov  = 0.4;  //0.4 = 1x mag
                maxfov  = 0.4;  //0.4 = 1x mag
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
                thermalResolution[] = {0.0, 360, 1.0, 360};
                //intensity, sharpness, grainSize, intensityX0, intensityX1, monochromatic, static, blurCoef
                //ix0 and ix1 effect the intensity of the grain pattern
                //----------------inten-sharp-grain--ix0---ix1---mono--stat--blur
                thermalNoise[] = { 0.50, 0.25, 0.25, 0.05, 0.15, 1.00, 0.00, 0.50}; // {0.04,0.04,0.04,0.04,0.04,0,0,1};
            };
            class Flir_Medium: Flir_Wide {
                initfov = 0.0702;   //0.4 / 5.7x mag 
                minfov  = 0.0702;   //0.4 / 5.7x mag 
                maxfov  = 0.0702;   //0.4 / 5.7x mag 
                opticsdisplayname = "M";
            };
            class Flir_Narrow: Flir_Wide {
                initfov = 0.0222;   //0.4 / 18x mag
                minfov  = 0.0222;   //0.4 / 18x mag
                maxfov  = 0.0222;   //0.4 / 18x mag
                opticsdisplayname = "N";
            };  
            class Flir_Zoom: Flir_Wide {
                initfov = 0.0111;   //0.4 / 36x mag
                minfov  = 0.0111;   //0.4 / 36x mag
                maxfov  = 0.0111;   //0.4 / 36x mag
                opticsdisplayname = "Z";
                thermalResolution[] = {0.0, 180, 1.0, 180};
            };
            class A3ti_Wide: Flir_Wide {
                visionmode[] = {"Normal"};
                opticsdisplayname = "W";
            };
            class A3ti_Medium: Flir_Medium {
                visionmode[] = {"Normal"};
                opticsdisplayname = "M";
            };
            class A3ti_Narrow: Flir_Narrow {
                visionmode[] = {"Normal"};
                opticsdisplayname = "N";
            };  
            class A3ti_Zoom: Flir_Zoom {
                visionmode[] = {"Normal"};
                opticsdisplayname = "Z";
            };
            //////////////////////////////////////////////////
            //DTV       //////////////////////////////////////
            //////////////////////////////////////////////////
            class Dtv_wide: Flir_Wide {
                visionmode[] = {"Normal"};
                initfov = 0.0286;   //0.4 / 14x mag
                minfov  = 0.0286;   //0.4 / 14x mag
                maxfov  = 0.0286;   //0.4 / 14x mag
                opticsdisplayname = "w";
            };
            class Dtv_dummyFOV: Dtv_wide {};
            class Dtv_Narrow: Dtv_wide {
                initfov = 0.0125;   //0.4 / 32x mag (should be 63x)
                minfov  = 0.0125;   //0.4 / 32x mag (should be 63x)
                maxfov  = 0.0125;   //0.4 / 32x mag (should be 63x)
                opticsdisplayname = "N";
            };
            class Dtv_Zoom: Dtv_wide {
                initfov = 0.0063;   //0.4 / 63x mag (should be 126x)
                minfov  = 0.0063;   //0.4 / 63x mag (should be 126x)
                maxfov  = 0.0063;   //0.4 / 63x mag (should be 126x)
                opticsdisplayname = "Z";
            };
            //////////////////////////////////////////////////
            //DVO       //////////////////////////////////////
            //////////////////////////////////////////////////
            class Dvo_Wide: Dtv_wide {
                initfov = 0.1143;   //0.4 / 3.5x mag
                minfov  = 0.1143;   //0.4 / 3.5x mag
                maxfov  = 0.1143;   //0.4 / 3.5x mag
                opticsdisplayname = "W";
            };
            class Dvo_Narrow: Dtv_wide {
                initfov = 0.0250;   //0.4 / 16x mag
                minfov  = 0.0250;   //0.4 / 16x mag
                maxfov  = 0.0250;   //0.4 / 16x mag
                opticsdisplayname = "N";
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