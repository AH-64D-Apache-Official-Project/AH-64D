// Until ACE's own Doppler seeker handles clutter and chaff against helicopters
class ace_missileguidance_SeekerTypes {
    class DopplerRadar {
        functionName = "fza_ase_fnc_aceDoppler";
    };
};

// How well chaff works on each missile, and its multipath error low over the ground
class ace_missileguidance_type_AMRAAM {
    fza_ase_chaffEffectiveness = 0.1;
};
class ace_missileguidance_type_R77 {
    fza_ase_chaffEffectiveness = 0.2;
    fza_ase_multipathError     = 25;
    fza_ase_multipathMaxSpeed  = 60;
};
class ace_missileguidance_type_ESSM {
    fza_ase_chaffEffectiveness = 0.5;
    fza_ase_multipathError     = 15;
};
class ace_missileguidance_type_Patriot {
    fza_ase_chaffEffectiveness = 0.5;
    fza_ase_multipathError     = 15;
};
class ace_missileguidance_type_S400 {
    minimumSpeedFilter         = 12.5; // ACE's 5 m/s notch is narrower than any SAM radar's
    fza_ase_chaffEffectiveness = 0.5;
    fza_ase_multipathError     = 15;
};
