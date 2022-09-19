class Extended_PreInit_EventHandlers {
	class fza_systems_ah64_PreInits {
		init = "call compile preprocessFileLineNumbers 'fza_ah64_systems\functions\event\fn_eventPreInit.sqf';";
	};
};

class Extended_GetIn_EventHandlers {
	class fza_ah64base {
		class fza_systems_ah64base_getin_eh {
			getIn = "_this call fza_systems_fnc_eventGetIn";
		};
	};
};