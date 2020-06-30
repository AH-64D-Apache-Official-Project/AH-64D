#define R recompile = 1
class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
		class controlHandlers
		{
			file = "\fza_ah64_controls\scripting\functions\controlHandlers";
			class controlHandleASEAutopage {R;};
			class controlHandleCrosshairAction {R;};
			class controlHandleIHADSSMode {R;};
			class controlHandleJammerToggle {R;};
			class controlHandleLookCenter {R;};
			class controlHandleNextWaypoint {R;};
			class controlHandlePrevWaypoint {R;};
			class controlHandleToggleHeadtracking {R;};
			class controlHandleTSDMode {R;};
		};
		class core
		{
			file = "\fza_ah64_controls\scripting\functions\core";
			class coreGetObjectsLookedAt {R;};
		}
		class engine
		{
			file = "\fza_ah64_controls\scripting\functions\engine";
			class engineGetData
			{
				R;
				description = "Gets the engine-related data for display"
			};
			class engineInit
			{
				R;
				description = "Sets up the engine states";
			};
			class engineSetPosition
			{
				R;
				description = "Sets up engine to be at Off, Idle, Fly"
			};
			class engineUpdate
			{
				R;
				description = "Updates internal engine state"
			};
			class engineGovernor
			{
				R;
				description = "Sets the engine's target RPMs"
			};
			class engineHandleControl {R;};
			class engineGetTarget
			{
				R;
				description = "Get what engine's target RPM and time is"
			};
		};
		class fire
		{
			file = "\fza_ah64_controls\scripting\functions\fire";
			class fireHandleControl {R;};
		};
		class ihadss
		{
			file = "\fza_ah64_controls\scripting\functions\ihadss";
			class ihadssHandleControl {R;};
		};
		class laser
		{
			file = "\fza_ah64_controls\scripting\functions\laser";
			class laserArm {R;};
			class laserDisarm {R;};
		}
		class lighting
		{
			file = "\fza_ah64_controls\scripting\functions\lighting";
			class lightHandleControl {R;};
		}
		class mpd
		{
			file = "\fza_ah64_controls\scripting\functions\mpd";
			class mpdHandleControl {R;};
			class mpdHandleZoom {R;};

			class mpdLDMSHandleControl {R;};
			class mpdLFUELHandleControl {R;};
			class mpdLWCAHandleControl {R;};
			class mpdLWPNHandleControl {R;};

			class mpdRACEHandleControl {R;};
			class mpdRDMSHandleControl {R;};
			class mpdRENGHandleControl {R;};
			class mpdRFCRHandleControl {R;};
			class mpdRTSDHandleControl {R;};
			class mpdRWCAHandleControl {R;};
		}
		class functions
		{
			file = "\fza_ah64_controls\scripting\functions";
			class findPlayer
			{
				R;
				description = "Find player controled unit";
			};
			class linearInterp
			{
				R;
				description = "Linear interpolate a 2d array of keyframe values";
			};
			class displayTime {R;};
			class playAudio
			{
				R;
				description = "Plays audio file, usage: [_firstAudioFile, _delay1, _secondAudioFile, _delay2, _thirdAudioFile, _delay3]";
			};
		};
	};
};