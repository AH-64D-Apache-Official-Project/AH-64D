class ace_MissileGuidance_SeekerTypes {
	class SALH;
	class Fza_SALH : SALH {
		onFired = "fza_hellfire_fnc_salFired";
	};
	class Fza_ARH {
		functionName  = "fza_hellfire_fnc_arhSeeker";
		onFired = "fza_hellfire_fnc_arhFired";
	};
};