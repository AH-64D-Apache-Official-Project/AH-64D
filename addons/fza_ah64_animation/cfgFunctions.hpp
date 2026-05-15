#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
    class fza_ah64_project_animation
    {
        tag = "FZA_anim";
        class animation
        {
            file = "\fza_ah64_animation\functions";
            class animationUpdate  {R;};
            class controlsAnim     {R;};
            class probesAnim       {R;};
            class rotorAnim        {R;};
            class updateAnimations {R;};
        };
    };
};
