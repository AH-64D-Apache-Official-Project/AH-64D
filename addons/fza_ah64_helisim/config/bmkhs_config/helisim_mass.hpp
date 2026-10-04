/////////////////////////////////////////////////////////////////////////////////////////////
// Mass and Balance /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    //Empty airframe, without the FCR
    emptyMass         = 6314; //kg
    emptyMom          = 32877.000;   //-> 205.00 in

    //Fitted equipment that changes the empty mass, each selected by one of the aircraft's own
    //animations at a given phase. The first that matches applies.
    class EmptyMassVariants {
        class FCR {
            animation = "fcr_enable";
            phase     = 1;
            mass      = 6609;        //kg
            moment    = 34245.000;   //-> 204.00 in
        };
    };

    //Maximum gross mass - bounds the fixed test weight
    maxGrossMass      = 10433; //kg, 23,000 lb

    //Fuselage station datum and CG limits
    fsDatum             = 6.4;      //m, station 0 reference
    fwdCgLimit          = 1.295;    //m, 201 in
    aftCgLimit          = 1.142;    //m, 207 in
    comCorrection[]     = {0.0, 0.0, 0.224};
    //Casual mode center of mass
    casualModeCom[]     = {0.0, 2.06, -0.075};

/////////////////////////////////////////////////////////////////////////////////////////////
// Indexed mass items ///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    //Every mass item is {arm, mass}: arm[] is {lateral, longitudinal, vertical} in metres,
    //right-positive / nose-positive, measured in the same surveyed frame as fsDatum.
    //Counts drive the loops in Core, so an airframe with no wing stations sets numStations = 0
    //and one with nine troop seats declares nine Seat classes.

    //SEATS. Occupancy is resolved against fullCrew, so an empty seat adds no mass and the CG
    //shifts to match who is actually aboard.
    //  role       - "driver" | "gunner" | "commander" | "turret" | "cargo"
    //  turret[]   - turret path for gunner/commander/turret seats; {} for the driver
    //  cargoIndex - cargo slot for role = "cargo"; -1 otherwise. NOTE: Arma assigns cargo
    //               indices by proxy order in the P3D, so the modeller must confirm which
    //               index is which physical seat - Core cannot verify this.
    numSeats = 2;
    class Seats {
        class Seat01 {  //CPG, front
            arm[]      = {0.000, 4.312, 0.000};
            mass       = 100.0;
            role       = "gunner";
            turret[]   = {0};
            cargoIndex = -1;
        };
        class Seat02 {  //PLT, rear
            arm[]      = {0.000, 2.760, 0.000};
            mass       = 100.0;
            role       = "driver";
            turret[]   = {};
            cargoIndex = -1;
        };
    };

    //FUEL TANKS are defined in helisim_fuel.hpp - a tank's arm, capacity and caution
    //threshold belong together, so the mass model reads that table rather than keeping
    //a second copy of the arms here.

    //WING STATIONS. pylons[] lists the Arma pylon indices this station carries, so Core can
    //total the ammo without hardcoded index ranges. Indices are 1-BASED, matching the
    //"pylonsN" names ammoOnPylon takes; getPylonMagazines is 0-based, so Core subtracts one
    //when looking a magazine up by index.
    numStations = 4;
    class Stations {
        class Station01 { arm[] = {-2.160, 1.345, 0.000}; pylons[] = { 1,  2,  3,  4}; };
        class Station02 { arm[] = {-1.500, 1.345, 0.000}; pylons[] = { 5,  6,  7,  8}; };
        class Station03 { arm[] = { 1.500, 1.345, 0.000}; pylons[] = { 9, 10, 11, 12}; };
        class Station04 { arm[] = { 2.160, 1.345, 0.000}; pylons[] = {13, 14, 15, 16}; };
    };

    //INTERNAL MAGAZINES. Rounds carried inside the airframe rather than on a pylon.
    //  match - substring tested against the magazine class name
    numMagazines = 1;
    class Magazines {
        class Mag01 {  //M230 30mm
            match       = "m230";
            arm[]       = {0.000, 0.944, 0.000};
            massPerRound = 0.35;
        };
    };

/////////////////////////////////////////////////////////////////////////////////////////////
// Store masses /////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    //What the aircraft's stores weigh. This is aircraft business, not flight-model business -
    //Core reads the table and matches, it does not know what a Hellfire is.
    //  match          - substring tested against the pylon magazine class name
    //  launcherMass   - kg of the launcher/rail itself, counted once if the station carries it
    //  massPerRound   - kg per remaining round
    //  isTank         - 1 if the store is a fuel tank, whose fuel mass comes from Tanks above
    numStores = 3;
    class Stores {
        class Store01 {  //M299 launcher + AGM-114 Hellfire
            match        = "agm114";
            launcherMass = 64.90;
            massPerRound = 46.71;   //103lbs (99-106lbs, average 102.5)
            isTank       = 0;
        };
        class Store02 {  //M261 pod + 2.75in Hydra
            match        = "275";
            launcherMass = 39.40;
            massPerRound = 10.40;   //23lbs M151; M255A1 27.5, M261 27.4, M257/M278 24.3
            isTank       = 0;
        };
        class Store03 {  //230gal auxiliary tank
            match        = "auxTank";
            launcherMass = 63.50;   //empty tank
            massPerRound = 0.00;
            isTank       = 1;
        };
    };
