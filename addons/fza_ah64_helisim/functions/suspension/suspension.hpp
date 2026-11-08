//Wheel axles at static load, model space. The p3d draws the gear fully extended, and model.cfg
//swings it up as altRadar falls: maingear +15 deg and twsus +10 deg at the ground. These are the
//Memory LOD axles rotated to that stop, less boundingCenter, so the drawn wheels sit on the ground.
#define SUSP_WHEEL_RIGHT        [ 1.00,  3.124, -2.705]
#define SUSP_WHEEL_LEFT         [-1.00,  3.124, -2.705]
#define SUSP_WHEEL_TAIL         [ 0.00, -7.380, -2.827]
#define SUSP_MAIN_RADIUS        0.346
#define SUSP_TAIL_RADIUS        0.155

#define SUSP_GRAVITY            9.81

//Compression at static load, m, and the strut's curve: load = static * (compression / sag) ^ exp.
//Stiffness at static load is exp * load / sag, and frequency sqrt(exp * gravity / sag). Soft
//enough that a frame moves the strut a small part of a cycle: the tail wheel moves about half its
//static load, and at 0.06 it hopped at 5 Hz.
#define SUSP_MAIN_SAG           0.15
#define SUSP_TAIL_SAG           0.25
#define SUSP_SPRING_EXP         1.5

//Damping ratios. Rebound is the higher so a landing does not spring back off the ground.
#define SUSP_ZETA_COMPRESS      0.5
#define SUSP_ZETA_REBOUND       0.7

//Stability limits: stiffness * dt^2 and damping * dt per unit of the wheel's static load. Forces
//are applied a frame late, and a wheel moves about half its static load, so past the frame time
//where these bite the loop has the same gain every frame whatever the frame rate. At these values
//it decays at every frame time tested, 17 to 200 ms; looser and the struts pump at 40 ms.
#define SUSP_SPRING_DT_LIMIT    0.05
#define SUSP_DAMP_DT_LIMIT      0.2
#define SUSP_MAX_RATE           5.0     //m/s, compression rate
#define SUSP_MAX_LOAD           5.0     //multiples of the wheel's static load

//How far friction acts from the height of the centre of mass toward the wheel, 0 to 1. Lower
//keeps grip from tipping the aircraft. Does not change how it turns or stops.
#define SUSP_ROLL_INFLUENCE     0.25

//Friction coefficients.
#define SUSP_MU_MAIN_LAT        0.7     //Main wheels do not slide sideways, so they are the pivot
#define SUSP_MU_TAIL_LOCKED     0.8     //Tail wheel pinned: it cannot swivel, so it grips sideways
#define SUSP_MU_TAIL_SWIVEL     0.1     //Tail wheel free: scrub while it swings round to follow its motion
#define SUSP_MU_BRAKE           0.8     //Main wheels, parking brake on
#define SUSP_MU_ROLL            0.015   //Rolling
//The tyre's grip before it slips, per unit of the wheel's load: its frequency in rad/s and damping.
//Stiffer gives less sideways give at rest. Limited at low frame rates like the strut.
#define SUSP_GRIP_OMEGA         10.0
#define SUSP_GRIP_ZETA          1.0

//Tail wheel swivel.
#define SUSP_CASTOR_TRAIL       0.09    //m, osa_tailwheel behind osa_tw_castor
#define SUSP_CASTOR_PIN_ANGLE   5.0     //deg, the lock pin drops in within this of centre
#define SUSP_CASTOR_ANIM_STEP   0.5     //deg, change needed to update the animation

//The ray starts this far above the wheel's lowest point, so a hard landing cannot start it underground.
#define SUSP_RAY_ABOVE          1.5
//Placing the aircraft at load-in. Ground further than the range from the wheels means it is
//airborne: wide enough for a level aircraft on a steep slope, where the wheels are metres apart in
//height. Moving faster than the speed means it is already rolling, so it is left alone.
#define SUSP_PLACE_RANGE        5.0     //m
#define SUSP_PLACE_MAX_SPEED    3.0     //m/s

//Load-in: held until frames have stayed under the long frame time for this long, or the limit,
//which keeps a machine that never runs that fast from being held for good.
#define SUSP_LOAD_LONG_FRAME    0.09    //s
#define SUSP_LOAD_STEADY_TIME   1.0     //s
#define SUSP_LOAD_MAX_TIME      5.0     //s

//Holding an aircraft at rest: idle with nobody aboard, or crewed with the brake on and the
//collective down, once it has been at rest this long.
#define SUSP_REST_SPEED         0.3     //m/s
#define SUSP_REST_RATE          0.05    //rad/s
#define SUSP_REST_TIME          0.25    //s
//A crewed aircraft sleeps only with the collective at or below this, and wakes above it, when
//the brake comes off, when its mass changes by this fraction, or when something moves it.
#define SUSP_SLEEP_COLLECTIVE   0.1
#define SUSP_WAKE_MASS_FRAC     0.01
#define SUSP_WAKE_SPEED         0.5     //m/s

//One RPT line a frame while a wheel is on the ground, and one a second while held, with Core's
//flight log (the bmkhs_flightLog CBA setting).
#define SUSP_LOG (!isNil "bmkhs_flightLog" && {bmkhs_flightLog})
