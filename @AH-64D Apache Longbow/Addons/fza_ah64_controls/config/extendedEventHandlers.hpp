class Extended_PreInit_EventHandlers {
	class fza_ah64_PreInits {
		init = "call compile preprocessFileLineNumbers 'fza_ah64_controls\scripting\XEH_preInit.sqf';";
		clientInit = "call compile preprocessFileLineNumbers 'fza_ah64_controls\scripting\XEH_clientInit.sqf';";
	};
};