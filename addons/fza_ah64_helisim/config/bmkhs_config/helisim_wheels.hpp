/////////////////////////////////////////////////////////////////////////////////////////////
// Wheels ///////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//  brakeControl    - the control whose On brakes every braked wheel
//  weightOnWheels  - the wheel, by name, whose strut carries the squat switch
//  muRoll / muBrake - along a wheel, rolling and braked
//  muSide          - across a wheel that cannot swivel
//  muCastorFree / muCastorLocked - across a castoring wheel, swivelling and pinned
//  castorTrail     - m, a castoring wheel behind its swivel axis
//  castorPinAngle  - deg, the lock pin drops in within this of centre
//
//  WHEEL
//  position[]      - axle at static load, model frame: the Memory LOD axle swung to the static stop,
//                    maingear +15 deg and twsus +10 deg about their pivots
//  extended[]      - axle at full extension, model frame: the Memory LOD axle as drawn
//  radius          - m
//  castors         - 1 swivels
//  braked          - 1 the brake control holds it
//  lockControl     - the control whose On pins a castoring wheel; "" for none
//  animationSource - swivel angle in degrees; "" for none
//  compressionSource - strut stroke as a fraction of sag, 0 extended, 1 static; "" for none

    class Wheels {
        brakeControl   = "parkBrake";
        weightOnWheels = "left main";
        muRoll         = 0.015;
        muBrake        = 0.8;
        muSide         = 0.7;
        muCastorFree   = 0.1;
        muCastorLocked = 0.8;
        castorTrail    = 0.09;
        castorPinAngle = 5.0;

        class Wheel01 {
            name            = "right main";
            position[]      = { 0.998,  2.399, -1.310};
            extended[]      = { 0.998,  2.654, -1.582};
            radius          = 0.346;
            castors         = 0;
            braked          = 1;
            lockControl     = "";
            animationSource = "";
            compressionSource = "gearRight";
        };
        class Wheel02 {
            name            = "left main";
            position[]      = {-1.002,  2.399, -1.310};
            extended[]      = {-1.002,  2.654, -1.582};
            radius          = 0.346;
            castors         = 0;
            braked          = 1;
            lockControl     = "";
            animationSource = "";
            compressionSource = "gearLeft";
        };
        class Wheel03 {
            name            = "tail";
            position[]      = {-0.002, -8.105, -1.432};
            extended[]      = {-0.002, -8.026, -1.568};
            radius          = 0.155;
            castors         = 1;
            braked          = 0;
            lockControl     = "tailWheelLock";
            animationSource = "tailWheelCastor";
            compressionSource = "gearTail";
        };
    };
