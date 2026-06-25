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
            class minigameNetJoin {RECOMPILE_FLAG;};
            class minigameNetLeave {RECOMPILE_FLAG;};
            class minigameNetLeaveAll {RECOMPILE_FLAG;};
            class minigameNetSend {RECOMPILE_FLAG;};
            class minigameFindDisplay {RECOMPILE_FLAG;};
            class minigameOwnerToUnit {RECOMPILE_FLAG;};
            class minigameRestart {RECOMPILE_FLAG;};
            class minigameAux {RECOMPILE_FLAG;};
            class minigameEscapeJsString {RECOMPILE_FLAG;};
            class minigameReportResult {RECOMPILE_FLAG;};
            class minigamePushJsToGame {RECOMPILE_FLAG;};
            class minigameSyncScores {RECOMPILE_FLAG;};
        };
    };
};
