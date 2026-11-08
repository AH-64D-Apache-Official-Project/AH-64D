#define R recompile = 1

class CfgFunctions
{
    class fza_ah64_helisim_project
    {
        tag = "fza_ah64_helisim";
        class functions {
            file = "\fza_ah64_helisim\functions";
            class setup    {R;};
            class perFrame {R;};
        };
        class custom {
            file = "\fza_ah64_helisim\functions\custom";
            class cyclicFade    {R;};
            class perfData      {R;};
            class perfVariables {R;};
        };
    };
    class fza_ah64_suspension_project
    {
        tag = "fza_suspension";
        class suspension {
            file = "\fza_ah64_helisim\functions\suspension";
            class suspensionCastor    {R;};
            class suspensionPlace     {R;};
            class suspensionUpdate    {R;};
            class suspensionVariables {R;};
            class suspensionWheel     {R;};
        };
    };
};
