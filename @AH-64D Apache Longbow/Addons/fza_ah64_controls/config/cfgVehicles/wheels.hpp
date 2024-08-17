
gearRetracting      = 0;
gearMinAlt          = 999999;

turnCoef            = 4; // Rolling Friction, higher stops more quickly
terrainCoef         = 1;
damperSize          = 1;
damperForce         = 10;
damperDamping       = 100;
wheelWeight         = 30;
driveOnComponent[]={
    "wheels"
};
minOmega            = 0;
maxOmega            =2000;
numberPhysicalWheels = 3;

class wheel_base {
    steering                    = false;
    width                       = 0.2;
    mass                        = 30;
    MOI                         = 30;

    dampingRate                 = 0;
    dampingRateDamaged          = 1;
    dampingRateDestroyed        = 1000;
    suspTravelDirection[]       = {0, -1.0, 0.0};

    maxBrakeTorque              = 0;
    maxHandBrakeTorque          = 0;

    maxCompression              = 0.3;
    maxDroop                    = 0.1;

    sprungMass                  = 3000;
    springStrength              = 20000;
    springDamperRate            = 50000;

    longitudinalStiffnessPerUnitGravity = 500;
    latStiffX                   = 2.5;
    latStiffY                   = 18.0;
    frictionVsSlipGraph[]=
    {
        {0,1},
        {0.5,1},
        {1,1}
    };
}
class wheels
{
    class wheel_1: wheel_base {
        side                        = "left";
        boneName                    = "wheel_1_1";
        suspForceAppPointOffset     = "wheel_1_1_axis";
        tireForceAppPointOffset     = "wheel_1_1_axis";
        center                      = "wheel_1_1_axis";
        boundary                    = "wheel_1_1_bound";
    };
    class wheel_2: wheel_base {
        side                        = "right";
        boneName                    = "wheel_1_2";
        suspForceAppPointOffset     = "wheel_1_2_axis";
        tireForceAppPointOffset     = "wheel_1_2_axis";
        center                      = "wheel_1_2_axis";
        boundary                    = "wheel_1_2_bound";
    };
    class wheel_3: wheel_base {
        steering                    = true;
        side                        = "rear";
        boneName                    = "wheel_2_1";
        suspForceAppPointOffset     = "wheel_2_1_axis";
        tireForceAppPointOffset     = "wheel_2_1_axis";
        center                      = "wheel_2_1_axis";
        boundary                    = "wheel_2_1_bound";

        width                       = 0.14;
        maxCompression              = 0.13;
        maxDroop                    = 0.03;
        maxBrakeTorque              = 0;

        sprungMass                  = 200;
        springStrength              = 5000;
        springDamperRate            = 1000;
    };
};