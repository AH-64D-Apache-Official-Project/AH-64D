class Extended_PreInit_EventHandlers {
	class bmk_helisim_PreInits {
		init = "call compile preprocessFileLineNumbers 'bmk_helisim\functions\event\fn_eventPreInit.sqf';";
	};
};

class Extended_GetIn_EventHandlers {
	class fza_ah64base {
		class bmk_helisim_getin_eh {
			getIn = "_this call fza_sfmplus_fnc_eventGetIn";
		};
	};
};