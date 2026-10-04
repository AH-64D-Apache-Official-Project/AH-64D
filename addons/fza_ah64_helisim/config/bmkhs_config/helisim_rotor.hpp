/////////////////////////////////////////////////////////////////////////////////////////////
// Rotors - Blade Element Theory ////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//Per-rotor arrays, index 0 = main, 1 = tail. Core reads numRotors and loops.
//Model shaping - inflow, flap dynamics, damping - stays in Core.

    numRotors            = 2;
    rotorType[]          = {0,      1};          //0 = main, 1 = tail
    rotorDirection[]     = {0,      0};          //0 = ccw, 1 = cw
    rotorNumBlades[]     = {4,      4};
    rotorNumElements[]   = {4.0,    4.0};
    rotorMastLength[]    = {0.70,   -0.87};   //m
    rotorGearRatio[]     = {72.291, 14.90};

    //Hub position and disc orientation in model space. Where the mast sits and which way
    //the disc faces is pure airframe geometry.
    rotorPivot[]         = {
                            { 0.00,  2.06,  0.000}    //main hub, m
                          , { 0.00, -6.98, -0.075}    //tail hub, m
                          };
    rotorRotation[]      = {
                            {0.0,  0.0, 0.0}          //main disc, deg
                          , {0.0, 90.0, 0.0}          //tail disc, deg
                          };

    //Flap response time constants, {longitudinal, lateral} per rotor. These follow from
    //blade inertia and hinge offset, so they belong to the airframe.
    rotorFlapTimeConst[] = {
                            {2.0, 3.0}                //main
                          , {0.5, 0.5}                //tail
                          };
    rotorAirfoil[]       = {"NACA 4418", "NACA 0012"};   //section name, see helisim_airfoils.hpp
    rotorBladeCutout[]   = {1.15,   0.15};    //m, root cutout
    rotorBladeLength[]   = {7.315,  1.402};  //m
    rotorBladeChord[]    = {0.533,  0.253};  //m
    rotorBladeTwist[]    = {-9,     -8};        //deg
    rotorBladeMass[]     = {72.108, 5.131}; //kg
    rotorDelta3[]        = {0.5,    0.5};      //pitch-flap coupling

    //Blade pitch ranges - min / mid / max, deg
    rotorPitchMin[]      = {-10,    0};
    rotorPitchMid[]      = {0,      0};
    rotorPitchMax[]      = {20,     0};
    rotorRollMin[]       = {-10.5,  0};
    rotorRollMid[]       = {0,      0};
    rotorRollMax[]       = {7,      0};
    rotorCollMin[]       = {1,      -15};
    rotorCollMid[]       = {0,      0};
    rotorCollMax[]       = {19,     27};

    //Model bindings - the aircraft must provide these selections
    rotorAnimSource[]    = {"rotorH",       "rotorV"};
    rotorHitPoint[]      = {"hithrotor",    "hitvrotor"};
