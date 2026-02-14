#define QUOTE(x) #x
#define COMMA ,

class CfgPatches
{
    class fza_ah64_ihadss
    {
        units[] = {};
        author = "AH-64D Development Team";
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"fza_ah64_controls"};
    };
};

#ifdef CMD__FZA_IHADSS_LIVE_URL
class CfgCommands {
    allowedHTMLLoadURIs[] += {QUOTE(CMD__FZA_IHADSS_LIVE_URL)};
};
#endif

#include "cfgFunctions.hpp"
#include "uiConfig\defines.hpp"
#include "uiConfig\baseClasses.hpp"
#include "uiConfig\monocle.hpp"
#include "uiConfig\rscTitles.hpp"
#include "uiconfig\welcome.hpp"