/////////////////////////////////////////////////////////////////////////////////////////////
// Rotors - Simple //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//A rotor is a hub at a position turning blades of a given size, so its geometry, its blade
//and what it does with the controls are defined together here. Core reads numSimpleRotors
//and loops; nothing downstream indexes by rotor NUMBER.
//
//The simple model works four fixed blade positions and scales by blade count, so the lift
//and drag tables carry what the rotor does rather than deriving it per blade element.
//
//  type         - "main" or "tail". What the rotor IS, so Core never assumes rotor 0 is
//                 the main one.
//  direction    - "ccw" or "cw", seen from above.
//  numBlades    - the four modelled positions are scaled to this.
//  pivot[]      - hub position, {lateral, longitudinal, vertical} in m,
//                 right-positive / nose-positive / up-positive
//  rotation[]   - disc orientation, {pitch, roll, yaw} in deg
//  mastLength   - m along the disc's own up axis, from pivot to hub
//  gearRatio    - rotor to engine shaft; shared with the transmission model
//  torqueTau    - s, torque filter time constant
//  damageRole   - the hitpoint role that destroys this rotor (helisim_hitpoints.hpp). A rotor
//                 that declares none cannot be destroyed.
//
//  BLADE
//  bladeRadius  - m
//  bladeChord   - m
//  bladeMass    - kg, one blade
//
//  DISC TILT - min / mid / max in deg, interpolated from the centred stick. A rotor whose
//  disc does not tilt declares zeroes.
//
//  coneAngle    - deg at full collective. Coning lifts the tips, so the thrust position
//                 moves inboard and the disc carries a vertical arm.
//  rollLiftCoef / pitchLiftCoef - the cyclic lift coefficient, independent of the
//                 collective's. This is what makes the fore/aft and left/right blades carry
//                 different lift, so the pitch and roll moments come out of real forces at
//                 real positions rather than being applied as a torque. The pack scales both
//                 with collective: see cyclicFade below.
//  gndEffValue  - thrust multiplier on the deck, fading to 1.0 by one rotor diameter up.
//                 A rotor that does not sit in ground effect declares 1.0.
//  reacTqScalar - scales the tangential blade drag that produces the yaw reaction. The same
//                 drag drives the transmission, which this does not touch.
//
//  liftCoefTable / dragCoefTable - rows are the control axis that loads this rotor
//  (collective for a main, pedal for a tail), columns are the airspeeds in the header row,
//  m/s. The drag table carries induced and profile together, and its airspeed columns carry
//  how they vary with speed - that is what the transmission feels.

    numSimpleRotors = 2;
    //Cyclic lift coefficients against collective - {scale at the floor, collective at or below
    //which the floor applies, collective at or above which they are full}. The floor is the
    //authority left in an autorotation. 0.20 is taxi power (30% torque), 0.30 is 48% torque.
    cyclicFade[] = {0.5, 0.20, 0.30};
    //Rotor limits, Nr - {normal low, normal high, high rotor, maximum}; below and above normal is transient.
    nrLimits[] = {0.95, 1.05, 1.06, 1.10};
    class SimpleRotors {
        class SimpleRotor01 {
            type             = "main";
            direction        = "ccw";
            damageRole       = "mainRotor";
            numBlades        = 4;
            pivot[]          = {0.00, 2.06, 0.000};
            rotation[]       = {0.00, 0.00, 0.000};
            mastLength       = 0.70;      //m
            gearRatio        = 72.291;
            torqueTau        = 0.10;      //s

            bladeRadius      = 7.315;     //m
            bladeChord       = 0.533;     //m
            bladeMass        = 72.108;    //kg

            pitchFlapMin     = -10.0;     //deg
            pitchFlapMid     =   0.0;
            pitchFlapMax     =  20.0;
            rollFlapMin      = -10.5;
            rollFlapMid      =   0.0;
            rollFlapMax      =   7.0;

            coneAngle        = 12.0;  //deg at full collective
            rollLiftCoef     = 0.15; //0.19
            pitchLiftCoef    = 0.40; //0.36 > 0.54 > 0.72
            gndEffValue      = 1.225;
            reacTqScalar     = 0.50;
            autoTorque       = 80.0;

            //Fitted by rotortables.py (AIRCRAFT_GUIDE, "Fitting the main rotor tables") at the game's CoM
            //at 18,000 lb: sea level, 15 C, OGE - 18,000 lb 94% at 0.64, 19,200 lb 100%, 20,260 lb 112%,
            //21,000 lb 125% (the peak, 0.766); the AH-64D power curve at 18,000 lb, max range 120 kt,
            //extended past 140 kt along its slope. Trims 10 deg nose low at 130 kt, 5.6 at 90. Full-down
            //collective falls from the 18% idle torque to 0.5% by 60 kt, so power-on autos overrun the engines.
            //------------Coll----0-------10------20------30------40------50------60------70------80------90------100-----110-----120-----130-----140-----150-----160-----180 kt
            liftCoefTable[] = {
                        {"A/S", 0.00, 5.14, 10.29, 15.43, 20.58, 25.72, 30.87, 36.01, 41.16, 46.30, 51.44, 56.59, 61.73, 66.88, 72.02, 77.17, 82.31, 92.60}
                        ,{0.000, 0.0373, 0.0387, 0.0411, 0.0452, 0.0515, 0.0597, 0.0669, 0.0756, 0.0836, 0.0875, 0.0964, 0.0979, 0.0890, 0.0910, 0.0911, 0.0976, 0.1046, 0.1188}
                        ,{0.766, 0.3523, 0.3654, 0.3878, 0.4267, 0.4859, 0.5634, 0.6313, 0.7129, 0.7885, 0.8259, 0.9098, 0.9237, 0.8392, 0.8585, 0.8590, 0.9203, 0.9870, 1.1206}
                        ,{0.844, 0.3372, 0.3497, 0.3712, 0.4083, 0.4650, 0.5392, 0.6042, 0.6822, 0.7546, 0.7903, 0.8707, 0.8840, 0.8031, 0.8216, 0.8221, 0.8807, 0.9446, 1.0724}
                        ,{0.922, 0.3111, 0.3227, 0.3425, 0.3767, 0.4290, 0.4975, 0.5575, 0.6295, 0.6962, 0.7292, 0.8034, 0.8156, 0.7410, 0.7581, 0.7585, 0.8126, 0.8715, 0.9895}
                        ,{1.000, 0.2699, 0.2799, 0.2971, 0.3268, 0.3722, 0.4316, 0.4836, 0.5461, 0.6040, 0.6326, 0.6969, 0.7075, 0.6428, 0.6576, 0.6580, 0.7049, 0.7561, 0.8584}
                        };

            dragCoefTable[] = {
                        {"A/S", 0.00, 5.14, 10.29, 15.43, 20.58, 25.72, 30.87, 36.01, 41.16, 46.30, 51.44, 56.59, 61.73, 66.88, 72.02, 77.17, 82.31, 92.60}
                        ,{0.000, 0.0078, 0.0039, 0.0019, 0.0013, 0.0006, 0.0004, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002, 0.0002}
                        ,{0.640, 0.0435, 0.0431, 0.0425, 0.0417, 0.0413, 0.0413, 0.0413, 0.0413, 0.0413, 0.0413, 0.0413, 0.0413, 0.0413, 0.0429, 0.0445, 0.0461, 0.0477, 0.0477}
                        ,{0.690, 0.0463, 0.0459, 0.0453, 0.0444, 0.0440, 0.0440, 0.0440, 0.0440, 0.0440, 0.0440, 0.0440, 0.0440, 0.0440, 0.0457, 0.0474, 0.0491, 0.0508, 0.0508}
                        ,{0.734, 0.0520, 0.0515, 0.0508, 0.0498, 0.0494, 0.0494, 0.0494, 0.0494, 0.0494, 0.0494, 0.0494, 0.0494, 0.0494, 0.0513, 0.0532, 0.0551, 0.0570, 0.0570}
                        ,{0.766, 0.0583, 0.0578, 0.0570, 0.0559, 0.0554, 0.0554, 0.0554, 0.0554, 0.0554, 0.0554, 0.0554, 0.0554, 0.0554, 0.0575, 0.0597, 0.0618, 0.0639, 0.0639}
                        ,{0.844, 0.0758, 0.0752, 0.0741, 0.0726, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0748, 0.0776, 0.0803, 0.0831, 0.0831}
                        ,{0.922, 0.1050, 0.1041, 0.1026, 0.1006, 0.0997, 0.0997, 0.0997, 0.0997, 0.0997, 0.0997, 0.0997, 0.0997, 0.0997, 0.1036, 0.1074, 0.1112, 0.1150, 0.1150}
                        ,{1.000, 0.1516, 0.1503, 0.1482, 0.1453, 0.1440, 0.1440, 0.1440, 0.1440, 0.1440, 0.1440, 0.1440, 0.1440, 0.1440, 0.1496, 0.1551, 0.1606, 0.1662, 0.1662}
                        };
        };

        class SimpleRotor02 {
            type             = "tail";
            direction        = "ccw";
            damageRole       = "tailRotor";
            numBlades        = 4;
            pivot[]          = {0.00, -6.98, -0.075};
            rotation[]       = {0.00, 90.00,  0.000};
            mastLength       = -0.87;     //m
            gearRatio        = 14.90;
            torqueTau        = 0.10;      //s

            bladeRadius      = 1.402;     //m
            bladeChord       = 0.253;     //m
            bladeMass        = 5.131;     //kg

            //The tail disc does not tilt - pedal changes its pitch, not its plane.
            pitchFlapMin     = 0.0;
            pitchFlapMid     = 0.0;
            pitchFlapMax     = 0.0;
            rollFlapMin      = 0.0;
            rollFlapMid      = 0.0;
            rollFlapMax      = 0.0;

            coneAngle        = 0.0;
            rollLiftCoef     = 0.0;
            pitchLiftCoef    = 0.0;
            gndEffValue      = 1.0;
            reacTqScalar     = 0.25;
            autoTorque       = 0.0;

            //Pedal through controlMap is the table key: the map is the feel (the H-60's), the
            //three rows are left / mid / right, the old full-throw rows. The main rotor turns
            //counter-clockwise, so left pedal carries the torque and the drag rises to the left.
            controlMap[] = {
                {-1.00, -1.0000},
                {-0.75, -0.8875},
                {-0.50, -0.6250},
                {-0.25, -0.2700},
                { 0.00,  0.0000},
                { 0.25,  0.3900},
                { 0.50,  0.7000},
                { 0.75,  0.8900},
                { 1.00,  1.0000}
            };
            //-----------Pedal----0.00---10.29---20.58---36.01---46.30---51.44---61.73---66.88---72.02
            liftCoefTable[] = {
                         {"A/S", 0.00,  10.29,  20.58,  36.01,  46.30,  51.44,  61.73,  66.88,  72.02}
                        ,{-1.00, 1.0672, 1.1730, 1.2662, 1.3892, 1.4628, 1.4976, 1.5640, 1.5956, 1.6262}
                        ,{ 0.00, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000}
                        ,{ 1.00,-1.0672,-1.1730,-1.2662,-1.3892,-1.4628,-1.4976,-1.5640,-1.5956,-1.6262}
                        };
            //-----------Pedal----0.00---10.29---20.58---36.01---46.30---51.44---61.73---66.88---72.02
            dragCoefTable[] = {
                         {"A/S", 0.00,  10.29,  20.58,  36.01,  46.30,  51.44,  61.73,  66.88,  72.02}
                        ,{-1.00, 0.1200, 0.1200, 0.1200, 0.1200, 0.1200, 0.1200, 0.1200, 0.1200, 0.1200}
                        ,{ 0.00, 0.0130, 0.0130, 0.0130, 0.0130, 0.0130, 0.0130, 0.0130, 0.0130, 0.0130}
                        ,{ 1.00, 0.0040, 0.0040, 0.0040, 0.0040, 0.0040, 0.0040, 0.0040, 0.0040, 0.0040}
                        };
        };
    };
