class Extended_PreInit_EventHandlers {
    class fza_ah64_PreInits {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_controls\XEH_preInit.sqf';";
    };
};

class Extended_FiredBIS_EventHandlers {
    class fza_ah64base {
        class fza_ah64base_fired_eh {
            firedBIS = "_this call fza_fnc_eventFired; _this call fza_fnc_fxMuzzle;";
        };
    };
};
class Extended_GetIn_EventHandlers {
    class fza_ah64base {
        class fza_ah64base_getin_eh {
            getIn = "_this call fza_fnc_eventGetIn;";
        };
    };
};

class Extended_GetOut_EventHandlers {
    class fza_ah64base {
        class fza_ah64base_getout_eh {
            getOut = "_this call fza_fnc_eventGetOut;";
        };
    };
};

class Extended_Killed_EventHandlers {
    class fza_ah64base {
        class fza_ah64base_killed_eh {
            killed = "_this call fza_fnc_eventGetOut; _this call BIS_Effects_EH_Killed;";
        }; // helps remove IHADSS upon dead
    };
};