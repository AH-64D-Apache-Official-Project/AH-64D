//AH-64D HeliSim configuration.
//Split along system/component lines; Core reads this class.

class BMKHS_HeliSim {
    //Model the aircraft's systems (electrical, APU, hydraulics, drivetrain).
    //Off means vanilla behaviour and Core's optional-input defaults.
    useSystems = 1;

    //How many engines, when no hitpoint declares them. This airframe's hitpoints do, so the
    //count comes from there and this is the fallback.
    numEngines = 2;

    //Drivetrain ratings for useSystems = 0, worst first: {fraction of rated torque, seconds
    //it will hold there, divisor}. 0 seconds damages immediately; the divisor sets how fast
    //once it does. SE sets are used single-engine. With systems on the components carry
    //their own and these are not read.
    xmsnTqLimits[]   = {{2.30, 0, 20}, {2.00, 6, 10}};
    ngbTqLimitsSE[]  = {{1.25, 0, 40}, {1.22, 6, 20}, {1.10, 150, 10}};

    #include "bmkhs_config\helisim_airfoils.hpp"
    #include "bmkhs_config\helisim_components.hpp"
    #include "bmkhs_config\helisim_controls.hpp"
    #include "bmkhs_config\helisim_engine.hpp"
    #include "bmkhs_config\helisim_flightControls.hpp"
    #include "bmkhs_config\helisim_fuel.hpp"
    #include "bmkhs_config\helisim_fuselage.hpp"
    #include "bmkhs_config\helisim_mass.hpp"
    #include "bmkhs_config\helisim_misc.hpp"
    #include "bmkhs_config\helisim_rotor.hpp"
    #include "bmkhs_config\helisim_simpleRotor.hpp"
    #include "bmkhs_config\helisim_wings.hpp"
};
