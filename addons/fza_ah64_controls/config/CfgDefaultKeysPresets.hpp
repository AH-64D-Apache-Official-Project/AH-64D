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
            fza_ah64_sightSelectHMD[] = {0x2A130002}; //Shift+1
            fza_ah64_sightSelectTADS[] = {0x2A130003}; //Shift+2
            fza_ah64_sightSelectFXD[] = {0x2A130004}; //Shift+3
            fza_ah64_sightSelectFCR[] = {0x2A130005}; //Shift+4
            fza_ah64_symbologySelectUp[] = {0x2A130030}; //Shift+B
            fza_ah64_symbologySelectDown[] = {0x1D130030}; //Ctrl+B
            fza_ah64_symbologySelectPress[] = {0x30}; //B
            fza_ah64_laserDesig[] = {0x22}; //G
            fza_ah64_fcrSingleScan[] = {0x2A130013}; //Shift+R
            fza_ah64_targetStoreUpdate[] = {0x2A130022}; //Shift+G
            fza_ah64_waypointIncrease[] = {0x2A130006}; //Shift+5
            fza_ah64_waypointDecrease[] = {0x1D130006}; //Ctrl+5
            fza_ah64_countermeasure[] = {0x2E}; //C
            fza_ah64_missileAdvance[] = {0x21}; //F
            fza_ah64_wasGun[] = {0x02}; // 1
            fza_ah64_wasRkt[] = {0x03}; // 2
            fza_ah64_wasMsl[] = {0x04}; // 3
            // Z is the FCR layer key (Alt is the TADS layer): Z+1..4 scan size, Z+5..8 mode
            fza_ah64_fcrScanSize_W[] = {0x2C130002}; //Z+1
            fza_ah64_fcrScanSize_M[] = {0x2C130003}; //Z+2
            fza_ah64_fcrScanSize_N[] = {0x2C130004}; //Z+3
            fza_ah64_fcrScanSize_Z[] = {0x2C130005}; //Z+4
            fza_ah64_fcrModeGTM[]  = {0x2C130006}; //Z+5
            fza_ah64_fcrModeATM[]  = {0x2C130007}; //Z+6
            fza_ah64_fcrModeRMAP[] = {0x2C130008}; //Z+7
            fza_ah64_fcrModeTPM[]  = {0x2C130009}; //Z+8
            fza_ah64_flare[] = {0x2D}; // X — R is the vanilla radar toggle (FCR continuous scan)
            fza_ah64_tadsLHGFov_W[] = {0x38130002};
            fza_ah64_tadsLHGFov_M[] = {0x38130003};
            fza_ah64_tadsLHGFov_N[] = {0x38130004};
            fza_ah64_tadsLHGFov_Z[] = {0x38130005};
            fza_ah64_tadsLHGLmc[] = {0x1D130014};
            fza_ah64_SensorSelect_FLIR[] = {0x38130006}; //Alt+5
            fza_ah64_SensorSelect_DTV[]  = {0x38130007}; //Alt+6
            fza_ah64_SensorSelect_DVO[]  = {0x38130008}; //Alt+7
            fza_ah64_stickyControlInterupt[] = {0x39};
            fza_ah64_forceTrimHoldModeSwitch_up[]    = {0x9D1300C8}; //RCtrl+Up
            fza_ah64_forceTrimHoldModeSwitch_right[] = {0x9D1300CD}; //RCtrl+Right
            fza_ah64_forceTrimHoldModeSwitch_down[]  = {0x9D1300D0}; //RCtrl+Down
            fza_ah64_forceTrimHoldModeSwitch_left[]  = {0x9D1300CB}; //RCtrl+Left
            fza_ah64_forceTrimPanicButton[] = {};
            fza_ah64_collectiveEmergJett[] = {};
            fza_ah64_cyclicForward[] = {0x11};
            fza_ah64_cyclicBackward[] = {0x1F};
            fza_ah64_cyclicLeft[] = {0x1E};
            fza_ah64_cyclicRight[] = {0x20};
            fza_ah64_pedalLeft[] = {0x10};
            fza_ah64_pedalRight[] = {0x12};
            fza_ah64_collectiveUp[] = {};
            fza_ah64_collectiveDn[] = {};
            fza_ah64_kbCollectiveUp[] = {0x2A};
            fza_ah64_kbCollectiveDn[] = {0x1D};
            fza_ah64_ctrlVisToggle[]  = {0x1D130017};  // Ctrl+I (unassigned by default controls)

            // MPD minigame input - numpad, chosen to minimise collision with existing flight binds
            fza_minigame_up[]     = {0x48}; // Numpad 8
            fza_minigame_down[]   = {0x50}; // Numpad 2
            fza_minigame_left[]   = {0x4B}; // Numpad 4
            fza_minigame_right[]  = {0x4D}; // Numpad 6
            fza_minigame_fire[]   = {0x39}; // Space - generic confirm/fire/shoot, usable by any minigame

        };
    };
    class Arma3: Arma2 {
        class Mappings: Mappings {};
    };
};
