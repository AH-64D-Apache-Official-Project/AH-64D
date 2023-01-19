class Extended_GetIn_EventHandlers {
	class fza_ah64base {
		class fza_ah64_audioSystem_getin_eh {
			getIn = "_this call fza_audioSystem_fnc_getIn;";
		};
	};
};
class Extended_PreInit_EventHandlers {
	class fza_ah64_PreInits {
		init = "call compile preprocessFileLineNumbers 'fza_ah64_controls\scripting\XEH_preInit.sqf'";
	};
};