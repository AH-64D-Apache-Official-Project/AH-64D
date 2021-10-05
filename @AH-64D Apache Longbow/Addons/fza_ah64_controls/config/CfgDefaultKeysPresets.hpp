class CfgDefaultKeysPresets {
	class Arma2 {
		class Mappings {
			/*
				dik[] = 0xaaBBccDD
				aa		= combo KB key (second key of combo always keyboard)
				BB		= device type of first key (joy, mouse, KB,...) (or in case of combo, first half secondary combo type, second half main combo type)
				cc		= offset for joys or double tap info for KB
				DD		= key/button/axis identification

				BBccDD	= whole info about first key
				ccDD		= button info (doubleTap or joyID+btnID)
				DD		= button local ID
			*/	
			fza_ah64_sightSelectHMD[] = {0x1D130002}; //Ctrl+1
			fza_ah64_sightSelectTADS[] = {0x1D130003}; //Ctrl+2
			fza_ah64_sightSelectFXD[] = {0x1D130004}; //Ctrl+3
			fza_ah64_sightSelectFCR[] = {0x1D130005}; //Ctrl+4
			fza_ah64_fcrModeGTM[] = {0x1D130023}; //Ctrl+H
			fza_ah64_fcrModeATM[] = {0x2A130023}; //Shift+H
			fza_ah64_symbologySelectUp[] = {0x2A130030}; //Shift+B
			fza_ah64_symbologySelectDown[] = {0x1D130030}; //Ctrl+B
			fza_ah64_symbologySelectPress[] = {0x30}; //B
			fza_ah64_laserDesig[] = {0x22}; //G
			fza_ah64_fcrSingleScan[] = {0x2A130013}; //Shift+R
			fza_ah64_targetStoreUpdate[] = {0x2A130022}; //Shift+G
			fza_ah64_crosshairInteract[] = {0x56}; // Backslash (\)
			fza_ah64_waypointIncrease[] = {0x2A130006}; //Shift+5
			fza_ah64_waypointDecrease[] = {0x1D130006}; //Ctrl+5
			fza_ah64_laserCycle[] = {0x38130014}; //Alt+T
		};
	};
};