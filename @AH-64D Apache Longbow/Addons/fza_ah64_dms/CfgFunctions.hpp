#ifdef __A3_DEBUG__
#define R recompile = 1
#else
#define R recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_dms {
        tag="fza_dms";
        class functions {
            file = "\fza_ah64_dms\functions";
            class gridToPos{R;};
            class init{R;};
            class latLongToString{R;};
            class posToGrid{R;};
            class posToLatLong{R;};
        };
        class point {
            file = "\fza_ah64_dms\functions\point";
            class pointCreate{R;};
            class pointDelete{R;};
            class pointEditValue{R;};
            class pointGetArrayIndex{R;};
            class pointGetIdentDetails{R;};
            class pointGetValue{R;};
            class pointIsValidIdent{R;};
            class pointNextFree{R;};
            class pointParse{R;};
            class pointToString{R;};
        };
    };
};