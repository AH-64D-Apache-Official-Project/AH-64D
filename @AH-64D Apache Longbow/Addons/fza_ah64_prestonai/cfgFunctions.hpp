#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
    class fza_ah64_project_prestonai
    {
        tag = "FZA_prestonai";
        class actions {
            file = "\fza_ah64_prestonai\functions\actions";
            class actionsAPUOff {R;};
            class actionsAPUOn {R;};
            class actionsEnginesOn {R;};
        };
        class actionsHover {
            file = "\fza_ah64_prestonai\functions\actions\hover";
            class actionsHvrClimb {R;};
        };
        class core {
            file = "\fza_ah64_prestonai\functions\core";
            class coreContextMenu {R;};
            class coreGetInput {R;};
            class coreUpdate  {R;};
            class coreVariables {R;};
        };
    };
};