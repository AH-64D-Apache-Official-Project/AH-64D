/////////////////////////////////////////////////////////////////////////////////////////////
// Engine ////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Engine Data      /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    engSimTime  = 8.0;

    engIdleTQ   = 0.055;
    engFlyTQ    = 0.18;
    engMaxTQ    = 1.50;
    engOvrspdTQ = 1.50;

    engStartNG  = 0.23;
    engIdleNG   = 0.679;
    engFlyNG    = 0.834;
    engMaxNG    = 1.04;

    engStartNP  = 0.10;
    engIdleNP   = 0.57;
    engFlyNP    = 1.01;
    engOvrspdNP = 1.196;

    //--------------------0-NG-----1-TGT----2-TQ----3-NP----4-Oil
    //Power, governing and limits used by the engine2 / BET models
    engContPwrKW   = 1066.0;   //kW per engine, continuous
    engCntgncyPwrKW= 1447.0;   //kW per engine, single-engine contingency
    engDesignRPM   = 20900;    //100% Np
    engFriction    = 0.0;
    engGovGain     = 6.0;      //governor response rate
    engRunNG       = 0.52;     //Ng above which the engine is running
    engMaxTGT_DE   = 867;      //deg C, dual engine
    engMaxTGT_SE   = 896;      //deg C, single engine

    engBaseTable[] =    {{0.000,      0,    0.00,     0.00,    0.00}, //Off - 0 sec
                         {0.010,      0,    0.00,     0.00,    0.00}, //5 sec
                         {0.178,      0,    0.00,     0.00,    0.00}, //10 sec
                         {0.240,     95,    0.00,     0.00,    0.01}, //15 sec
                         {0.317,    390,    0.00,     0.00,    0.08}, //20 sec
                         {0.395,    515,    0.00,     0.02,    0.22}, //25 sec
                         {0.584,    656,    0.00,     0.08,    0.48}, //31 sec
                         {0.670,    487,    0.00,     0.18,    0.73}, //35 sec
                         {0.671,    478,    0.00,     0.33,    0.90}, //45 sec
                         {0.672,    474,    0.11,     0.43,    0.87}, //60 sec
                         {0.674,    460,    0.06,     0.58,    0.54}, //Idle - 120 sec
                         {0.688,    459,    0.06,     0.58,    0.54},
                         {0.752,    501,    0.07,     0.59,    0.56},
                         {0.792,    508,    0.13,     0.61,    0.58},
                         {0.837,    521,    0.27,     0.70,    0.63},
                         {0.856,    532,    0.18,     1.01,    0.69}}; //Fly

    //Governor PID, {kp, ki, kd, ki_clamp} - one per engine
    pidEngine[]    = {0.7000, 0.0000, 0.0005, 0.0000};

    /////////////////////////////////////////////////////////////////////////////////////////////
    // Engines - the gas turbine model  /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    //Runs beside the flat scalars above until the old model is deleted at 1.1.0's switchover.
    //numEngines is declared at the top of bmkhs_ah64_config.hpp, beside useSystems - it is
    //the airframe's count, not an engine's property.
    class Engines {
        class Engine01 {
            name            = "eng01";
            damageRole      = "engines";
            damageRoleIndex = 0;

            //Whole-assembly properties - not owned by any one section.
            engineType  = "turboShaftEngine";   //dispatches to bmkhs_fnc_turboShaftEngine
            designRpm   = 20900;                //100% Np, the shaft reference
            npFly       = 1.01;                 //governed Np in FLY, as a fraction of designRpm
            maxFuelFlow = 0.12;                 //kg/s at full fuel - the gauge boundary

            //Hard shutdowns - both CUT FUEL rather than restricting it.
            maxNg = 1.10;                       //mechanical fly weights
            maxNp = 1.196;                      //electrical trip

            //Compressor and spool - Ng from a torque balance.
            class ColdSection {
                compressorInertia = 5.0; //how fast Ng answers a torque change
                compressorLoad    = 1.7; //what the compressor absorbs, as cl * ng^2
                airCoef           = 0.1219;//cold air it pushes over the power turbine

                //Spooling down only - an unfired compressor is pure load, and that stops it.
                compDragMult  = 3.0;     //compressor drag multiplier with the fire out
                compDragFloor = 0.10;    //finishes the stop - ng^2 alone only asymptotes

                //Start thresholds - discrete events the model branches on.
                lightOffNg = 0.15;       //fuel introduced
                selfSustNg = 0.52;       //starter cuts out
                //Where the start fuel ramp reaches full and residual heat has faded. Raise it
                //to hold fuel lean longer and peak cooler.
                idleNg     = 0.679;
            };

            //Combustor - fuel burn, TGT as state, gas power out.
            class HotSection {
                massFlowExp = 1.772;     //mass flow rises faster than speed, as ng^this
                tgtK        = 288.6;     //deg C per unit of fuel-to-massflow ratio

                thermalMassCoef = 0.30;  //how fast TGT chases its target when heating
                coolingCoef     = 0.70;  //and when cooling, sized on the shutdown
                stillAirFlow    = 0.0012;//airflow floor once the spool has stopped
                ramAirCoef      = 0.00065;//ram cooling per m/s of forward speed

                maxTgt      = 867;      //deg C - the hot section's limit
                startTgt    = 851;       //deg C - the transient START limit, not the peak
                startMinTgt = 80;        //deg C - below this before the power lever is moved

                //How violently an un-purged engine runs away, latched from TGT at the lever.
                residualHeatGain = 0.003;
            };

            //The free turbine - Np is state with its own torque balance.
            class PowerTurbine {
                ptEfficiency  = 0.92;    //gas power reaching the shaft
                ptInertia     = 0.60;    //the free turbine's own inertia
                ptDrag        = 0.60;    //drag on a released turbine, as ptDrag * np^2
                ptDragFloor   = 0.05;    //finishes the stop - windmilling only
            };

            //The ECU - what it schedules, and the ceilings it will not pass.
            class Governor {
                //Minimum fuel the power lever schedules. Each is
                //compressorLoad * ng^2 + tq / ptEfficiency at that detent.
                fuelIdle = 0.784;        //settles Ng at 0.679
                fuelFly  = 3.136;        //WIDE OPEN - the governor cuts back from here

                //Fuel metered at light-off as a fraction of idle fuel. Sets the start PEAK.
                startFuelBase = 0.22;

                ffwdGain = 0.30;         //collective anticipation

                //Np governor, {kp, ki, kd, ki_clamp}.
                pid[] = {0.7000, 0.0000, 0.0005, 0.0000};

                gate[] = {};             //what the ECU needs to keep metering fuel
            };

            //Air turbine or electric, and what it needs available before the spool turns.
            class Starter {
                type   = "pneumatic";
                torque = 0.30;                  //what it puts on the spool, normalised
                gate[] = {{"PNEU", 0.85}};      //the pneumatic circuit's own minValue
            };

            //Author-named tiers, worst-first. The first is the torque reference everything
            //scales from.
            class PowerRatings {
                class MaximumContinuous {
                    displayName = "MC";
                    powerKw     = 1066;
                    maxTgt      = 810;
                    maxNg       = 0.950;
                    maxOilPsi   = 0.91;
                    timeLimit   = 1800;     //30 min
                };
                class DualEngine : MaximumContinuous {
                    displayName = "MTA DE";
                    maxTgt      = 867;
                    maxNg       = 0.990;
                    maxOilPsi   = 0.94;
                    timeLimit   = 600;      //10 min
                };
                class SingleEngine : MaximumContinuous {
                    displayName   = "MTA SE";
                    powerKw       = 1447;
                    maxTgt        = 896;
                    maxNg         = 0.997;
                    maxOilPsi     = 0.99;
                    timeLimit     = 150;    //2.5 min
                    unlockBelowTq = 0.51;   //unlocks when a sibling falls below 51% torque
                };
            };
        };
        class Engine02 : Engine01 {
            name            = "eng02";
            damageRoleIndex = 1;
        };
    };
