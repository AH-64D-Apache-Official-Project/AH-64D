class Extended_PreInit_EventHandlers {
    class fza_ah64_helisim_preInit {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_helisim\XEH_preInit.sqf';";
    };
};

//The pack starts itself. Nothing outside it calls in.
class Extended_Init_EventHandlers {
    class fza_ah64base {
        class fza_ah64_helisim_init_eh {
            init = "_this call fza_ah64_helisim_fnc_setup";
        };
    };
};

class Extended_GetIn_EventHandlers {
    class fza_ah64base {
        class fza_ah64_helisim_getin_eh {
            getIn = "_this call bmkhs_fnc_eventGetIn";
        };
    };
};
