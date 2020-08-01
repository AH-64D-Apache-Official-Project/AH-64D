class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
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
			class engineGetTarget
			{
				description = "Get what engine's target RPM and time is"
			};
		};
		class compensateSafezone
			{
				file = "\fza_ah64_controls\scripting\functions\fn_compensateSafezone.sqf";
			};
		};
	};
};