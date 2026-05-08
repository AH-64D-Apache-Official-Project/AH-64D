class ace_MissileGuidance_SeekerTypes {
    class SALH;
    class Fza_SALH : SALH {
        onFired = "fza_hellfire_fnc_salOnFired";
    };
    class Fza_ARH {
        functionName = "fza_hellfire_fnc_arhSeekerUpdate";
        onFired      = "fza_hellfire_fnc_arhOnFired";
    };
};
