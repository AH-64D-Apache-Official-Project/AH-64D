//AH-64D cockpit controls.
//
//A control is N POSITIONS, each with its own value. The INDEX IS CANONICAL -
//Core tracks an index and publishes the position's value, and whatever gates on
//that value reacts. Core learns no switch semantics.
//
//Field reference: \bmkhs_helisim\controls.hpp

class Controls {
    //Latching, two positions. Publishes bmkhs_battSwitchOn, which the Battery
    //component already gates on. wraps so a toggle-shaped caller stepping past
    //the last position comes back round to the first.
    class BattSwitch {
        variableName = "battSwitch";
        rest         = 0;
        wraps        = 1;
        networked    = 1;
        class Positions {
            class Off { displayName = "Battery - Off"; value = 0; };
            class On  { displayName = "Battery - On";  value = 1; };
        };
    };

    //Latching. The APU component gates on BATT itself, so no enabledBy here - the
    //switch is metal and throws regardless; the APU is what refuses to spool.
    //Declares a zero-valued position because the fire handle forces it off.
    class ApuBtn {
        variableName = "apuBtn";
        rest         = 0;
        wraps        = 1;
        networked    = 1;
        class Positions {
            class Off { displayName = "APU - Off"; value = 0; };
            class On  { displayName = "APU - On";  value = 1; };
        };
    };

    //Three positions. START springs back to centre; ORIDE MAINTAINS - the pilot
    //takes it back to centre themselves, so the engine stays inhibited until they
    //do. The engine reads a LEVEL, and this is the switch it reads.
    class Eng1Start {
        variableName  = "eng1StartSw";
        rest          = 1;
        networked     = 1;
        class Positions {
            class Oride { displayName = "Engine 1 Start - Ignition Override"; value = -1; };
            class Off   { displayName = "Engine 1 Start - Off";               value =  0; };
            class Start { displayName = "Engine 1 Start - Start";             value =  1; springsBack = 1; };
        };
    };

    class Eng2Start {
        variableName  = "eng2StartSw";
        rest          = 1;
        networked     = 1;
        class Positions {
            class Oride { displayName = "Engine 2 Start - Ignition Override"; value = -1; };
            class Off   { displayName = "Engine 2 Start - Off";               value =  0; };
            class Start { displayName = "Engine 2 Start - Start";             value =  1; springsBack = 1; };
        };
    };

    //Three positions, rear-most is lock. BRAKE drags the rotor to a stop; LOCK holds it
    //at zero, which is what makes a locked-rotor start possible.
    class RotorBrake {
        variableName = "rotorBrake";
        rest         = 0;
        wraps        = 1;    //the cockpit toggle steps off -> brake -> lock -> off
        networked    = 1;
        class Positions {
            class Off   { displayName = "Rotor Brake - Off";   value = 0; };
            class Brake { displayName = "Rotor Brake - Brake"; value = 1; };
            class Lock  { displayName = "Rotor Brake - Lock";  value = 2; };
        };
    };

    //Detented, three positions, none spring. The values are the animation fractions.
    class Eng1PowerLever {
        variableName = "eng1PwrLvr";
        rest         = 0;
        networked    = 1;
        class Positions {
            class Off  { displayName = "Engine 1 Power Lever - Off";  value = 0.0;  };
            class Idle { displayName = "Engine 1 Power Lever - Idle"; value = 0.25; };
            class Fly  { displayName = "Engine 1 Power Lever - Fly";  value = 1.0;
                         inhibitedBy[] = {"bmkhs_rotorBrakeOn"}; };
        };
    };

    class Eng2PowerLever {
        variableName = "eng2PwrLvr";
        rest         = 0;
        networked    = 1;
        class Positions {
            class Off  { displayName = "Engine 2 Power Lever - Off";  value = 0.0;  };
            class Idle { displayName = "Engine 2 Power Lever - Idle"; value = 0.25; };
            class Fly  { displayName = "Engine 2 Power Lever - Fly";  value = 1.0;
                         inhibitedBy[] = {"bmkhs_rotorBrakeOn"}; };
        };
    };

    //Latched. Armed shuts off that engine's (or the APU's) fuel while DC is up.
    class Eng1FireHandle {
        variableName = "eng1FireHandle";
        rest         = 0;
        wraps        = 1;
        networked    = 1;
        class Positions {
            class Off   { displayName = "Engine 1 Fire - Disarm"; value = 0; };
            class Armed { displayName = "Engine 1 Fire - Arm";    value = 1; };
        };
    };

    class Eng2FireHandle {
        variableName = "eng2FireHandle";
        rest         = 0;
        wraps        = 1;
        networked    = 1;
        class Positions {
            class Off   { displayName = "Engine 2 Fire - Disarm"; value = 0; };
            class Armed { displayName = "Engine 2 Fire - Arm";    value = 1; };
        };
    };

    class ApuFireHandle {
        variableName = "apuFireHandle";
        rest         = 0;
        wraps        = 1;
        networked    = 1;
        class Positions {
            class Off   { displayName = "APU Fire - Disarm"; value = 0; };
            class Armed { displayName = "APU Fire - Arm";    value = 1; };
        };
    };
};
