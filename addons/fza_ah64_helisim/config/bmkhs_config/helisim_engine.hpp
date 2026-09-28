/////////////////////////////////////////////////////////////////////////////////////////////
// Engine ////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Engines - the gas turbine model  /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
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
            maxFuelFlow = 0.033;                //kg/s per unit of fuel - the gauge boundary
            powerKw     = 1066;                 //maximum continuous - the torque reference, refTq

            //Hard shutdowns - both CUT FUEL rather than restricting it.
            maxNg = 1.10;                       //mechanical fly weights
            maxNp = 1.196;                      //electrical trip

            //Book limits, low to high {limit, seconds, divisor}. Se sets apply single engine.
            //Torque rates the drivetrain, not the engine.
            ngLimits[]    = {{1.022, 12, 10}, {1.051, 0, 20}};
            npLimits[]    = {{1.05, 12, 10}, {1.21, 0, 20}};
            tqLimits[]    = {{1.00, 6, 5}, {1.15, 0, 10}};
            tgtLimits[]   = {{810, 1800, 1000}, {870, 600, 0}, {878, 0, 0}, {949, 0, 2000}};
            tqLimitsSe[]  = {{1.10, 150, 10}, {1.22, 6, 2}, {1.25, 0, 4}};
            tgtLimitsSe[] = {{810, 1800, 1000}, {870, 600, 0}, {878, 150, 0}, {896, 12, 0}, {949, 0, 2000}};

            //Compressor and spool - Ng from a torque balance.
            class ColdSection {
                compressorInertia = 5.0; //how fast Ng answers a torque change
                compressorLoad    = 1.7; //what the compressor absorbs, as cl * ng^2
                airCoef           = 0.1219;//cold air it pushes over the power turbine

                //Running only - the load the spool settles against, cl * compRunMult * ng^compRunExp.
                compRunMult = 1.7132;
                compRunExp  = 3.3898;

                //Spooling down only - an unfired compressor is pure load, and that stops it.
                compDragMult  = 3.0;     //compressor drag multiplier with the fire out
                compDragFloor = 0.10;    //finishes the stop - ng^2 alone only asymptotes

                //Start thresholds - discrete events the model branches on.
                lightOffNg = 0.15;       //fuel introduced
                selfSustNg = 0.52;       //starter cuts out
                //Where the start fuel ramp reaches full and residual heat has faded. Raise it
                //to hold fuel lean longer and peak cooler.
                idleNg     = 0.679;

                //Ng limiter - ngLimitMax min (ngLimitBase + ngLimitSlope * FAT).
                ngLimitMax   = 1.022;
                ngLimitBase  = 1.01436;
                ngLimitSlope = 0.0019091;
            };

            //Combustor - fuel burn, TGT as state, gas power out.
            class HotSection {
                massFlowExp = 1.772;     //mass flow rises faster than speed, as ng^this
                tgtK        = 288.6;     //deg C per unit of fuel-to-massflow ratio

                thermalMassCoef = 0.30;  //how fast TGT chases its target when heating
                coolingCoef     = 0.70;  //and when cooling, sized on the shutdown
                stillAirFlow    = 0.0012;//airflow floor once the spool has stopped
                ramAirCoef      = 0.00065;//ram cooling per m/s of forward speed

                maxTgt      = 867;      //deg C - TGT limiter, twin engine
                maxTgtSe    = 896;      //deg C - TGT limiter, single engine
                startTgt    = 851;       //deg C - the transient START limit, not the peak
                startMinTgt = 80;        //deg C - below this before the power lever is moved

                //How violently an un-purged engine runs away, latched from TGT at the lever.
                residualHeatGain = 0.003;
            };

            //The free turbine - Np is state with its own torque balance.
            class PowerTurbine {
                ptEfficiency  = 0.92;    //gas power reaching the shaft
                ptInertia     = 0.60;    //the free turbine's own inertia
                ptDrag        = 0.06;    //drag on a released turbine, as ptDrag * np^2
                ptDragFloor   = 0.05;    //finishes the stop - windmilling only
            };

            //The ECU - what it schedules, and the ceilings it will not pass.
            class Governor {
                //Minimum fuel the power lever schedules. Each is
                //compressorLoad * ng^2 + tq / ptEfficiency at that detent.
                fuelIdle = 0.784;        //settles Ng at 0.679
                fuelFly  = 3.136;        //WIDE OPEN - the governor cuts back from here

                //Fuel metered at light-off as a fraction of idle fuel. Sets the start PEAK.
                startFuelBase = 0.42;

                ffwdGain = 1.00;         //collective anticipation - the load demand spindle

                leverTravelTime = 8.0;   //seconds, idle to fly - the fuel ramp, Np and the lever animation
                loadShareGain   = 8.0;   //how hard an engine below its matched partners trims up to them

                //Np governor, {kp, ki, kd, ki_clamp}.
                pid[] = {10.0000, 40.0000, 0.0000, 0.0750};

                gate[] = {};             //what the ECU needs to keep metering fuel
            };

            //Air turbine or electric, and what it needs available before the spool turns.
            class Starter {
                type   = "pneumatic";
                torque = 0.30;                  //what it puts on the spool, normalised
                gate[] = {{"PNEU", 0.85}};      //the pneumatic circuit's own minValue
            };
        };
        class Engine02 : Engine01 {
            name            = "eng02";
            damageRoleIndex = 1;
        };
    };
