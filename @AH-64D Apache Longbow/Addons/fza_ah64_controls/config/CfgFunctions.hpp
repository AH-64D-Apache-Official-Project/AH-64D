class CfgFunctions
{
	class fza_ah64_project
	{
		tag = "FZA";
		class functions
		{
			class findPlayer
			{
				file = "\fza_ah64_controls\scripting\functions\fza_findplayer.sqf";
				description = "Find player controled unit";
			};
			class linearInterp
			{
				file = "\fza_ah64_controls\scripting\functions\fn_linearInterp.sqf";
				description = "Linear interpolate a 2d array of keyframe values";
			}
		};
	};
};