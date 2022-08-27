#ifdef __A3_DEBUG__
#define RECOMPILE_FLAG recompile = 1
#else
#define RECOMPILE_FLAG recompile = 0
#endif
class CfgFunctions
{
    class fza_ah64_mpd {
        tag="fza_mpd";
        class functions {
            file = "\fza_ah64_mpd\functions";
            class currentPage {RECOMPILE_FLAG;};
            class drawIcons {RECOMPILE_FLAG;};
            class drawMap {RECOMPILE_FLAG;};
            class handleControl {RECOMPILE_FLAG;};
            class handleZoom {RECOMPILE_FLAG;};
            class setCurrentPage {RECOMPILE_FLAG;};
            class update {RECOMPILE_FLAG;};
            class init {RECOMPILE_FLAG;};
        };
        class fuel {
            file = "\fza_ah64_mpd\functions\fuel";
            class fuelGetData {RECOMPILE_FLAG;};
        };
        class tsd {
            file = "\fza_ah64_mpd\functions\tsd";
            class tsdRTEDraw {RECOMPILE_FLAG;};
            class tsdRTEHandleControl {RECOMPILE_FLAG;};
            class tsdSHOWDraw {RECOMPILE_FLAG;};
            class tsdSHOWHandleControl {RECOMPILE_FLAG;};
            class tsdTHRTDraw {RECOMPILE_FLAG;};
            class tsdTHRTHandleControl {RECOMPILE_FLAG;};
            class tsdWPTDraw {RECOMPILE_FLAG;};
            class tsdWPTEnterDetails {RECOMPILE_FLAG;};
            class tsdWPTHandleControl {RECOMPILE_FLAG;};
            class tsdWaypointStatusText {RECOMPILE_FLAG;};
        };
        class page {
            file = "\fza_ah64_mpd\functions\page";
            class pageASEDraw {RECOMPILE_FLAG;};
            class pageASEHandleControl {RECOMPILE_FLAG;};
            class pageDMSDraw {RECOMPILE_FLAG;};
            class pageDMSHandleControl {RECOMPILE_FLAG;};
            class pageDTUDraw {RECOMPILE_FLAG;};
            class pageDTUHandleControl {RECOMPILE_FLAG;};
            class pageENGDraw {RECOMPILE_FLAG;};
            class pageENGHandleControl {RECOMPILE_FLAG;};
            class pageFCRDraw {RECOMPILE_FLAG;};
            class pageFCRHandleControl {RECOMPILE_FLAG;};
            class pageFLTDraw {RECOMPILE_FLAG;};
            class pageFLTHandleControl {RECOMPILE_FLAG;};
            class pageFUELDraw {RECOMPILE_FLAG;};
            class pageFUELHandleControl {RECOMPILE_FLAG;};
            class pageMENUHandleControl {RECOMPILE_FLAG;};
            class pageTSDDraw {RECOMPILE_FLAG;};
            class pageTSDHandleControl {RECOMPILE_FLAG;};
            class pageWCADraw {RECOMPILE_FLAG;};
            class pageWCAHandleControl {RECOMPILE_FLAG;};
            class pageWPNDraw {RECOMPILE_FLAG;};
            class pageWPNHandleControl {RECOMPILE_FLAG;};
        };
    };
};