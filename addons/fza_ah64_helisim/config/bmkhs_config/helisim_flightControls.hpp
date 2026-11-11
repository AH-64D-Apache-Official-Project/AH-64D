/////////////////////////////////////////////////////////////////////////////////////////////
// Flight Controls //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    inputLagValue     = 0.95;
    //Level flight pitch attitude
    autoAttLevelPitch = -5.0;     //deg

/////////////////////////////////////////////////////////////////////////////////////////////
// FMC              /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//Field reference: \bmkhs_helisim\fmc.hpp. PID gains {kp, ki, kd, limit}. These are the
//tuning that defines how the aircraft handles - one set does not carry across airframes.
//Every feature works while the flight controls have pressure - primary, or utility down to
//the accumulator - and the computer has DC.
    class FMC {
        class Sas {
            gate[]      = {"bmkhs_fltCtrlsSupplied", "bmkhs_dcBusOn"};
            pitch[]     = {0.010, 0.0000, 0.000035, 0.00};
            roll[]      = {0.010, 0.0000, 0.000035, 0.00};
            yaw[]       = {0.0052, 0.00087, 0.00044, 0.002523};
        };
        class AttitudeHold {
            gate[]      = {"bmkhs_fltCtrlsSupplied", "bmkhs_dcBusOn"};
            subModes[]  = {"pos", "vel", "att"};
            posPitch[]  = {0.077, 0.0036, 0.062, 0.1};     //position / velocity hold
            posRoll[]   = {0.028, 0.0036, 0.046, 0.1};
            attPitch[]  = {0.0925, 0.0025, 0.0450, 0.1};
            attRoll[]   = {0.0400, 0.0015, 0.0180, 0.1};
        };
        class AltitudeHold {
            gate[]      = {"bmkhs_fltCtrlsSupplied", "bmkhs_dcBusOn"};
            rad[]       = {0.015, 0.00003, 0.0015, 0.05};
            bar[]       = {0.015, 0.00003, 0.0015, 0.05};
        };
        class HeadingHold {
            gate[]      = {"bmkhs_fltCtrlsSupplied", "bmkhs_dcBusOn"};
            subModes[]  = {"hdg", "yaw", "trn"};
            hdg[]       = {0.0750, 0.0200, 0.0050, 0.1};
            //Turn coordination. Error is lateral g and the output is clamped to the hold's
            //authority (0.1), so size these against that rather than the +-1 gauge.
            trn[]       = {0.2500, 0.0600, 0.3000, 0.1};
        };
    };

    //Keyboard rate command, sized to this aircraft's control authority: cyclic per deg/s of rate error
    pidRateCommandPitch[] = {0.0300, 0.1500, 0.00030, 1.0};
    pidRateCommandRoll[]  = {0.0150, 0.0750, 0.00015, 1.0};
    //Auto-pedal
    pidAutoPedalHdg[]   = {0.0100, 0.0020, 0.0100, 0.15};
    pidAutoPedalNtt[]   = {0.0300, 0.0080, 0.0100, 0.15};
    pidAutoPedalAero[]  = {0.6000, 0.5000, 0.4000, 0.1};
    pidAutoPedalTaxi[]  = {0.0100, 0.0020, 0.0020, 0.15};
