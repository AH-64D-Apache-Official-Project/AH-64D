class CfgDefaultKeysPresets {
    class Arma2 {
        class Mappings {
            /*
                dik[] = 0xaaBBccDD
                aa      = combo KB key (second key of combo always keyboard)
                BB      = device type of first key (joy, mouse, KB,...) (or in case of combo, first half secondary combo type, second half main combo type)
                cc      = offset for joys or double tap info for KB
                DD      = key/button/axis identification

                BBccDD  = whole info about first key
                ccDD    = button info (doubleTap or joyID+btnID)
                DD      = button local ID
            */
            fza_ah64_v30_sightSelectHMD[] = {0x2A130002}; //Shift+1
            fza_ah64_v30_sightSelectTADS[] = {0x2A130003}; //Shift+2
            fza_ah64_v30_sightSelectFCR[] = {0x2A130004}; //Shift+3
            fza_ah64_v30_sightSelectLink[] = {0x2A130005}; //Shift+4
            fza_ah64_sightSlave[] = {0x2A130021}; //Shift+F
            fza_ah64_symbologySelectUp[] = {0x2A130030}; //Shift+B
            fza_ah64_symbologySelectDown[] = {0x1D130030}; //Ctrl+B
            fza_ah64_symbologySelectPress[] = {0x30}; //B
            fza_ah64_laserDesig[] = {0x22}; //G
            fza_ah64_fcrSingleScan[] = {0x2A130013}; //Shift+R
            fza_ah64_cpgStoreUpdate[] = {0x2A130022}; //Shift+G
            fza_ah64_missileAdvance[] = {}; //Unbound: only works in MAN missile MODE
            fza_ah64_wasGun[] = {0x02}; // 1
            fza_ah64_wasRkt[] = {0x03}; // 2
            fza_ah64_wasMsl[] = {0x04}; // 3
            // Z is the FCR layer key (Alt is the TADS layer): Z+5..8 mode. FCR scan size and TADS FOV are on the
            // radial menu, so they are unbound
            fza_ah64_fcrScanSize_W[] = {};
            fza_ah64_fcrScanSize_M[] = {};
            fza_ah64_fcrScanSize_N[] = {};
            fza_ah64_fcrScanSize_Z[] = {};
            fza_ah64_fcrModeGTM[]  = {0x2C130006}; //Z+5
            fza_ah64_fcrModeATM[]  = {0x2C130007}; //Z+6
            fza_ah64_fcrModeRMAP[] = {0x2C130008}; //Z+7
            fza_ah64_fcrModeTPM[]  = {0x2C130009}; //Z+8
            fza_ah64_flare[] = {0x2D}; // X — R is the vanilla radar toggle (FCR continuous scan)
            fza_ah64_tadsLHGFov_W[] = {};
            fza_ah64_tadsLHGFov_M[] = {};
            fza_ah64_tadsLHGFov_N[] = {};
            fza_ah64_tadsLHGFov_Z[] = {};
            fza_ah64_tadsLHGLmc[] = {0x1D130014};
            fza_ah64_SensorSelect_FLIR[] = {0x38130006}; //Alt+5
            fza_ah64_SensorSelect_DTV[]  = {0x38130007}; //Alt+6
            fza_ah64_SensorSelect_DVO[]  = {0x38130008}; //Alt+7
            fza_ah64_collectiveEmergJett[] = {};
            fza_ah64_lstAuto[]     = {};
            fza_ah64_lstOff[]      = {};
            fza_ah64_lstManual[]   = {};
            fza_ah64_radialMenu[]  = {};
            fza_ah64_radialUp[]    = {};
            fza_ah64_radialDown[]  = {};
            fza_ah64_radialLeft[]  = {};
            fza_ah64_radialRight[] = {};

            // MPD minigame input - arrow keys, since the numpad is Arma's freelook
            fza_minigame_up[]     = {0xC8}; // Up arrow
            fza_minigame_down[]   = {0xD0}; // Down arrow
            fza_minigame_left[]   = {0xCB}; // Left arrow
            fza_minigame_right[]  = {0xCD}; // Right arrow
            fza_minigame_fire[]   = {0x1C}; // Enter - generic confirm/fire/shoot; not Space, which HeliSim uses for sticky interrupt

        };
    };
    class Arma3: Arma2 {
        class Mappings: Mappings {};
    };
};
