// Secondary combo types
#define INPUT_DEVICE_COMBO_KB 0x00100000 // keyboard button (key)
#define INPUT_DEVICE_COMBO_MB 0x00300000 // mouse button
#define INPUT_DEVICE_COMBO_JB 0x00500000 // joystick button
#define INPUT_DEVICE_COMBO_JP 0x00600000 // joystick POV
#define INPUT_DEVICE_COMBO_XI 0x00900000 // XBox controller (XInput)

// Main combo types
#define INPUT_DEVICE_MAIN_MB 0x00010000 // mouse button
#define INPUT_DEVICE_MAIN_MA 0x00020000 // mouse axis
#define INPUT_DEVICE_MAIN_KB 0x00030000 // keyboard button (key)
#define INPUT_DEVICE_MAIN_JB 0x00040000 // joystick button
#define INPUT_DEVICE_MAIN_JA 0x00050000 // joystick axis
#define INPUT_DEVICE_MAIN_JP 0x00060000 // joystick POV
#define INPUT_DEVICE_MAIN_XI 0x00070000 // XBox controller (XInput)
#define INPUT_DEVICE_MAIN_TR 0x00080000 // movement tracking device

// Device types
#define INPUT_DEVICE_SOLO_KB 0x00000000 // keyboard button (key)
#define INPUT_DEVICE_SOLO_MB 0x00010000 // mouse button
#define INPUT_DEVICE_SOLO_JB 0x00020000 // stick button
#define INPUT_DEVICE_SOLO_JA 0x00030000 // stick axis
#define INPUT_DEVICE_SOLO_JP 0x00040000 // stick POV
#define INPUT_DEVICE_SOLO_XI 0x00050000 // XInput device
#define INPUT_DEVICE_SOLO_TR 0x00080000 // eyexTracker, trackIR, freeTrack, ... exclusive, in this preference
#define INPUT_DEVICE_SOLO_MA 0x00100000 // mouse axis

#define COMBO_LCTRL  0x1D000000
#define COMBO_LSHIFT 0x2A000000
#define COMBO_LALT   0x38000000

class CfgDefaultKeysPresets {
	class Arma2 {
		class Mappings {
			/*
				dik = 0xaaBBccDD
				aa		= combo KB key (second key of combo always keyboard)
				BB		= device type of first key (joy, mouse, KB,...) (or in case of combo, first half secondary combo type, second half main combo type)
				cc		= offset for joys or double tap info for KB
				DD		= key/button/axis identification

				BBccDD	= whole info about first key
				ccDD		= button info (doubleTap or joyID+btnID)
				DD		= button local ID
			*/	
			fza_ah64_sightSelectHMD = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x02}; //Ctrl+1
			fza_ah64_sightSelectTADS = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x03}; //Ctrl+2
			fza_ah64_sightSelectFXD = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x04}; //Ctrl+3
			fza_ah64_sightSelectFCR = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x05}; //Ctrl+4
			fza_ah64_fcrModeGTM = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x23}; //Ctrl+H
			fza_ah64_fcrModeATM = {COMBO_LSHIFT + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x23}; //Shift+H
			fza_ah64_symbologySelectUp = {COMBO_LSHIFT + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x30}; //Shift+B
			fza_ah64_symbologySelectDown = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x30}; //Ctrl+B
			fza_ah64_symbologySelectPress = {INPUT_DEVICE_SOLO_KB + 0x30}; //B
			fza_ah64_laserDesig = {INPUT_DEVICE_SOLO_KB + 0x22}; //G
			fza_ah64_fcrSingleScan = {INPUT_DEVICE_SOLO_KB + 0x13}; //R
			fza_ah64_targetStoreUpdate = {COMBO_LSHIFT + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x22}; //Shift+G
			fza_ah64_crosshairInteract = {COMBO_LINPUT_DEVICE_COMBO_KB + Ox56}; // Backslash (\)
			fza_ah64_waypointIncrease = {COMBO_LSHIFT + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x06}; //Shift+5
			fza_ah64_waypointDecrease = {COMBO_LCTRL + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x06}; //Ctrl+5
			fza_ah64_laserCycle = {COMBO_LALT + COMBO_LINPUT_DEVICE_COMBO_KB + INPUT_DEVICE_MAIN_KB + 0x14}; //Alt+T
		};
	};
};