class Extended_PreInit_EventHandlers {
    class fza_ah64_audio_preInit {
        init = "call compile preprocessFileLineNumbers 'fza_ah64_audio\XEH_preInit.sqf';";
    };
};

class Extended_Init_EventHandlers {
    class fza_ah64base {
        class fza_ah64_audio_init_eh {
            init = "if (!isNil 'fza_audio_soundHelis') then {fza_audio_soundHelis pushBackUnique (_this select 0)};";
        };
    };
};

class Extended_GetIn_EventHandlers {
    class fza_ah64base {
        class fza_ah64_audio_getin_eh {
            getIn = "_this call fza_audio_fnc_getIn;";
        };
    };
};
