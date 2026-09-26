class CfgVehicles {
    class Helicopter_Base_F;
    class fza_ah64base : Helicopter_Base_F {
        class FzaMpdPages {
            class DOOM {
                index = 28; // reserved slot for external compat addons, see fza_ah64_mpd's mfdConstants.h
                minigameUrl = "\fza_ah64_doom\ui\minigame\games\doom\game.html";
                minigameClass = "RscFzaMinigameDoom";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
        };
    };
};
