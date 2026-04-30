#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif

class CfgFunctions
{
    class fza_ah64_project_fuel
    {
        tag = "fza_fuel";
        class fuelMgmt {
            file = "\fza_ah64_fuel\functions";
            class fuelMgmtVariables {R;};
            class fuelMgmtUpdate   {R;};
            class fuelSet          {R;};
            class fuelUpdate       {R;};
            class fuelVariables    {R;};
        };
    };
};
