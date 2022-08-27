class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F: Helicopter {
        class EventHandlers;
    };
    class fza_ah64base : Helicopter_Base_F {
        class EventHandlers: EventHandlers {
            class fza_dms {
                init = "[_this # 0] call fza_dms_fnc_init"; //<-- C51 always is the user positio
            };
        };
    };
};