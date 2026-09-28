/////////////////////////////////////////////////////////////////////////////////////////////
// Components ///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//What this airframe has and what it is wired to. Field reference, the networking rules
//and what Core does with any of it: bmkhs_helisim/components.hpp

    class Producers {
        //The APU. Needs its button, the battery bus, fuel and accumulator pressure - all
        //four, so losing any one shuts it down. It drives the accessory section and puts
        //out bleed air, and declutches from the drive once the rotor is turning it.
        class Apu {
            damageRole   = "apu";
            variableName = "apuRPM_pct";
            gate[]       = {"bmkhs_apuBtnOn", {"BATT", 0.25}, "bmkhs_apuFuelAvail",
                            "bmkhs_accHydPsiStartOk"};
            nominal      = 1.0;
            rampSeconds  = 5;             //spool to operating RPM
            stateName    = "apuOn";       //running once it is up to speed
            stateAbove   = 0.85;
            networked    = 1;
            class Outputs {
                class Drive {
                    circuit          = "ACCESSORY_DRIVE";
                    disengageAbove[] = {"Nr", 0.95};
                };
                class BleedAir {
                    circuit = "PNEU";
                };
            };
        };
        //Engine bleed air. Same 1.0 the APU puts out, so whichever is up holds PNEU and the
        //handover either way is seamless - highest feeder wins the node.
        class EngineBleed {
            variableName = "engBleed";
            output       = "PNEU";
            gate[]       = {"bmkhs_engBleedAvail"};
            nominal      = 1.0;
            rampSeconds  = 0;
        };
        //The transmission, turned by the engines or by the rotor in an autorotation - same
        //shaft either way, so the accessories keep turning with the engines dead.
        class Transmission {
            damageRole   = "transmission";
            variableName = "xmsnDrive";
            drivenBy[]   = {"Nr"};        //any rotation; the pumps set their own floor
            rampSeconds  = 0;             //no nominal: it carries whatever Nr is doing
            torqueFrom   = "bmkhs_engPctTq";
            torqueSum    = 1;
            tqLimits[]   = {{2.30, 0, 20}, {2.00, 6, 10}};
            jittersTorque = 1;
            breaksOnFailure[] = {"mainRotor", "tailRotor", "generators", "priPump", "utilPump"};
            class Outputs {
                class Accessories { circuit = "ACCESSORY_DRIVE"; };
                class TailDrive   { circuit = "TAIL_DRIVE"; };
            };
        };

        //Pumps hang off the accessory section, not the engines, and need fluid to move.
        class PriPump {
            damageRole   = "priPump";
            variableName = "priHydPsi";
            output       = "PRI_HYD";
            drivenBy[]   = {"ACCESSORY_DRIVE", 0.45};   //below this it loses drive
            requires     = "bmkhs_priLevel_pct";
            requiresAbove = 0.1;          //fraction - below this it loses prime
            nominal      = 3000;         //psi
            increment    = 10;            //gauges move in tens
            networked    = 1;             //MPD and WCA read these in the crew station
            rampSeconds  = 0.5;           //zero to full pressure - builds, does not snap
        };
        class UtilPump {
            damageRole   = "utilPump";
            variableName = "utilHydPsi";
            output       = "UTIL_HYD";
            drivenBy[]   = {"ACCESSORY_DRIVE", 0.45};
            requires     = "bmkhs_utilLevel_pct";
            requiresAbove = 0.1;
            nominal      = 3000;
            increment    = 10;
            networked    = 1;
            rampSeconds  = 0.5;
        };

        //Generators need far more shaft speed than the pumps, so an autorotation costs the
        //electrics but not the flight controls.
        class Generator {
            damageRole   = "generators";  //two hitpoints today -> gen1, gen2
            variableName = "gen";
            output       = "AC";
            drivenBy[]   = {"ACCESSORY_DRIVE", 0.85};
            nominal      = 1;             //on/off, not volts
            rampSeconds  = 0;             //a contactor closes, it does not spool
        };
    };

    //Converters take from one circuit and put onto another. Swap input and output and a
    //rectifier is an inverter, so a DC-generator aircraft needs no new code.
    class Converters {
        //Nose gearboxes take engine torque into the transmission. Rated for less than the
        //transmission is, so they are what an overtorque costs first.
        class NoseGearbox {
            damageRole   = "noseGearboxes";   //two hitpoints -> noseGearbox1, 2
            variableName = "noseGearbox";
            input[]      = {"Nr"};
            torqueFrom      = "bmkhs_engPctTq";  //per member, so engine 2 feeds gearbox 2
            //Single-engine ratings: a nose gearbox only carries enough to hurt it when
            //one engine is doing the work of two.
            tqLimitsSE[]    = {{1.25, 0, 40}, {1.22, 6, 20}, {1.10, 150, 10}};
            jittersTorque   = 1;              //and a damaged gearbox wanders its own
            //A gearbox that has come apart overspeeds the engine driving it.
            breaksOnFailure[] = {"bmkhs_engineOverspeed"};
        };
        //The tail chain. Either gearbox failing takes the tail rotor with it, because
        //nothing downstream of it turns.
        class IntermediateGearbox {
            damageRole   = "intermediateGearbox";
            variableName = "igb";
            input[]      = {"TAIL_DRIVE"};
            output       = "TAIL_DRIVE_IGB";
        };
        class TailRotorGearbox {
            damageRole   = "tailRotorGearbox";
            variableName = "tgb";
            input[]      = {"TAIL_DRIVE_IGB"};
            output       = "TAIL_ROTOR_DRIVE";
        };
        class Rectifier {
            damageRole   = "rectifiers";  //two hitpoints today -> rect1, rect2
            variableName = "rect";
            input[]      = {"AC"};        //any AC at all
            output       = "DC";
            nominal      = 1;
        };
    };

    class Storage {
        //Reservoirs hold fluid rather than pressure - no output and no gate, since nothing
        //draws pressure from them. They only lose contents by leaking, ramping from the
        //onset threshold so a light hit weeps and a bad one dumps.
        class PriReservoir {
            damageRole      = "priReservoir";
            variableName    = "priLevel_pct";
            nominal         = 1.0;         //published as a fraction, which is what reads it
            networked       = 1;
            leakStartDmg    = 0.50;
            leakSeconds     = 120;
        };
        class UtilReservoir {
            damageRole      = "utilReservoir";
            variableName    = "utilLevel_pct";
            output          = "UTIL_HYD_LEVEL";   //so a consumer can read what is left
            nominal         = 1.0;
            networked       = 1;
            leakStartDmg    = 0.50;
            leakSeconds     = 120;
            //The gun and the pylons share the utility system, so hits on either vent it.
            drainedBy[]     = {"gunTurret", "pylons"};
        };

        //Feeds the battery route, and runs down whenever whatever charges it is dead.
        //rechargedBy is the airframe's choice - DC on an aircraft wired that way.
        class Battery {
            damageRole      = "batteries";
            variableName    = "battPower_pct";
            output          = "BATT";
            rechargedBy[]   = {"AC"};
            gate[]          = {"bmkhs_battSwitchOn"};
            nominal         = 1.0;        //published as a fraction
            stopBelow       = 0.25;       //too flat to hold a bus up
            startRecharge   = 60;         //sec off a live bus
            emerDischarge   = 720;        //12 min on the battery alone
        };

        //Discharges to start the APU and is refilled by the pumps it just started. Doubles
        //as emergency flight-control pressure, gated on the crew button.
        class Accumulator {
            //No damageRole - no selection in the p3d, so it cannot be shot out.
            variableName    = "accHydPsi";
            output          = "UTIL_HYD";
            networked       = 1;
            //Off the accessory drive, not UTIL_HYD - a store recharging from the node it
            //feeds would top itself up forever.
            rechargedBy[]   = {"ACCESSORY_DRIVE", 0.45};  //same drive the pumps need
            gate[]          = {"bmkhs_emerHydOn"};
            startedBy       = "bmkhs_apuBtnOn";
            nominal         = 3000;       //psi at full charge
            startAbove      = 2600;       //psi needed to turn the APU over at all
            startRecharge   = 1.0;          //sec to refill, once the pumps are turning
            stopBelow       = 1650;       //psi nitrogen precharge - only what is above it
                                          //is usable, and a start spends that band
            emerDischarge   = 90;         //sec of emergency pressure
        };
    };

    //Circuit states Core publishes. A bus being up is a fact about the node, not something
    //drawing from it - these are what the crew stations and the rest of Core read.
    class Circuits {
        class AcBus {
            variableName = "acBusOn";
            circuit      = "AC";
            minValue     = 1;
            networked    = 1;
        };
        class DcBus {
            variableName = "dcBusOn";
            circuit      = "DC";
            minValue     = 1;
            networked    = 1;
        };
        class BattBus {
            variableName = "battBusOn";
            circuit      = "BATT";
            minValue     = 0.25;
            networked    = 1;
        };
        //Engine starts run off bleed air. Whatever supplies it is the aircraft's business -
        //an APU here, a ground cart or a running engine elsewhere.
        class Pneumatics {
            variableName = "pneuAvail";
            circuit      = "PNEU";
            minValue     = 0.85;   //the APU's running speed
            networked    = 1;
        };
    };

    //Consumers - things that need supply to WORK, as opposed to a circuit reporting
    //itself. These two are read by the flight model on the pilot's machine, so they stay
    //local.
    class Consumers {
        class FlightControls {
            variableName = "fltCtrlsSupplied";
            suppliedBy[] = {{"PRI_HYD", 1260}, {"UTIL_HYD", 1260}};   //psi
        };
        //The tail rotor needs primary pressure OR utility fluid - it is lost only when
        //both are gone, so this one is an AND across two different units.
        //Hydraulic authority to move it - either circuit will do.
        class TailRotor {
            variableName = "tailRtrSupplied";
            suppliedBy[] = {{"PRI_HYD", 1260}, {"UTIL_HYD_LEVEL", 0.1}};
        };
        //Drive turning it, which is the other way to lose it. Separate because one is an
        //either-or and the other is a chain that must be intact.
        class TailRotorDrive {
            variableName = "tailRtrDriven";
            suppliedBy[] = {{"TAIL_ROTOR_DRIVE", 0.01}};
        };
    };
