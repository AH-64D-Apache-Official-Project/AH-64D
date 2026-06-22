#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_minigames {
        tag = "fza_mg";
        class minigame {
            file = "\fza_ah64_minigames\functions\minigame";
            class minigameReady {RECOMPILE_FLAG;};
            class minigameSetMuted {RECOMPILE_FLAG;};
            class minigameSetPaused {RECOMPILE_FLAG;};
            class minigameReportScore {RECOMPILE_FLAG;};
            class minigameHandleInput {RECOMPILE_FLAG;};
            class minigameHandleControl {RECOMPILE_FLAG;};
            class minigameUiInit {RECOMPILE_FLAG;};
            class minigamePushScores {RECOMPILE_FLAG;};
            class minigamePlaySfx {RECOMPILE_FLAG;};
        };
    };
};
