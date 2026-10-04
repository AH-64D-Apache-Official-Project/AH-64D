//AH-64D cockpit control bindings, emitted from the shared row table.
//
//Core's macros come from their own header: requiredAddons orders loading at runtime, not
//the preprocessor, and each config is preprocessed on its own.
#include "\bmkhs_helisim\controlMacros.hpp"

class CfgUserActions {
    #include "..\headers\bmkhs_controls.hpp"
};

//The second view: the same rows, macros redefined to yield just the class names.
//Kept next to the first so a renamed token touches both - a name in the group with no
//matching class is a bind that appears in the menu and does nothing, with no build error.
#define QUOTE(x) #x
#undef BMKHS_CONTROL
#define BMKHS_CONTROL(cname,ptok,pnum,vdisplayName) QUOTE(bmkhs_ctrl_##cname##_##ptok)
#undef BMKHS_CONTROL_SEP
#define BMKHS_CONTROL_SEP() ,

class UserActionGroups {
    //Its own section, separate from flight controls, so the menu stays readable.
    class fza_ah64_cockpit_helisim {
        name = "AH-64D HeliSim Cockpit Controls";
        group[] = {
            #include "..\headers\bmkhs_controls.hpp"
        };
    };
};
