class CfgOO
{
	class fza_ah64_engine {
		class Attributes
		{
			class state { type = "STRING"; };
			class timeStarted { type = "SCALAR"; };
		}
		class Methods
		{
			class fza_ah64_engine
			{
				parameterTypes[] = { "OBJECT", "SCALAR"};
				script = "\fza_ah64_controls\scripting\fza_ah64_engine\fn_fza_ah64_engine.sqf";
			};
			class canSetPosition
			{
				parameterTypes[] = { "OBJECT", "SCALAR" };
				returnType = "BOOL";
				script = "\fza_ah64_controls\scripting\fza_ah64_engine\fn_canSetPosition.sqf";
			};
			class setPosition
			{
				parameterTypes[] = { "OBJECT", "SCALAR" };
				returnType = "BOOL";
				script = "\fza_ah64_controls\scripting\fza_ah64_engine\fn_setPosition.sqf";
			};
			class getData
			{
				parameterTypes[] = { "OBJECT" };
				returnType = "ARRAY";
				script = "\fza_ah64_controls\scripting\fza_ah64_engine\fn_getData.sqf";
			};
			class update
			{
				parameterTypes[] = { "OBJECT" };
				returnType = "ARRAY";
				script = "\fza_ah64_controls\scripting\fza_ah64_engine\fn_update.sqf";
			};
		};
	};
};