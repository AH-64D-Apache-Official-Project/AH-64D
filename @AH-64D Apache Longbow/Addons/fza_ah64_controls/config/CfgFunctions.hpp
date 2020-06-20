class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
		class controlHandlers
		{
			file = "\fza_ah64_controls\scripting\functions\controlHandlers";
			class controlHandleASEAutopage {};
			class controlHandleCrosshairAction {};
			class controlHandleIHADSSMode {};
			class controlHandleJammerToggle {};
			class controlHandleLookCenter {};
			class controlHandleNextWaypoint {};
			class controlHandlePrevWaypoint {};
			class controlHandleToggleHeadtracking {};
			class controlHandleTSDMode {};
		};
		class core
		{
			file = "\fza_ah64_controls\scripting\functions\core";
			class coreGetObjectsLookedAt {};
		}
		class engine
		{
			file = "\fza_ah64_controls\scripting\functions\engine";
			class engineGetData
			{
				description = "Gets the engine-related data for display"
			};
			class engineInit
			{
				description = "Sets up the engine states";
			};
			class engineSetPosition
			{
				description = "Sets up engine to be at Off, Idle, Fly"
			};
			class engineUpdate
			{
				description = "Updates internal engine state"
			};
			class engineGovernor
			{
				description = "Sets the engine's target RPMs"
			};
			class engineHandleControl {};
			class engineGetTarget
			{
				description = "Get what engine's target RPM and time is"
			};
		};
		class fire
		{
			file = "\fza_ah64_controls\scripting\functions\fire";
			class fireHandleControl {};
		};
		class ihadss
		{
			file = "\fza_ah64_controls\scripting\functions\ihadss";
			class ihadssHandleControl {};
		};
		class laser
		{
			file = "\fza_ah64_controls\scripting\functions\laser";
			class laserArm {};
			class laserDisarm {};
		}
		class lighting
		{
			file = "\fza_ah64_controls\scripting\functions\lighting";
			class lightHandleControl {};
		}
		class mpd
		{
			file = "\fza_ah64_controls\scripting\functions\mpd";
			class mpdHandleControl {};
			class mpdHandleZoom {};

			class mpdLDMSHandleControl {};
			class mpdLFUELHandleControl {};
			class mpdLWCAHandleControl {};
			class mpdLWPNHandleControl {};

			class mpdRACEHandleControl {};
			class mpdRDMSHandleControl {};
			class mpdRENGHandleControl {};
			class mpdRFCRHandleControl {};
			class mpdRTSDHandleControl {};
			class mpdRWCAHandleControl {};
		}
		class functions
		{
			file = "\fza_ah64_controls\scripting\functions";
			class findPlayer
			{
				description = "Find player controled unit";
			};
			class linearInterp
			{
				description = "Linear interpolate a 2d array of keyframe values";
			};
		};
	};
};