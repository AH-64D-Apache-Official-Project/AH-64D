#define STABILATOR_MODE_ALWAYSENABLED   2
#define STABILATOR_MODE_JOYSTICKONLY    1
#define STABILATOR_MODE_ALWAYSDISABLED  0

#define HOTAS                   0
#define MNKB                    1

#define ISA_STD                 0
#define EUROPE_SUMMER           1
#define EUROPE_WINTER           2
#define MIDDLE_EAST             3
#define CENTRAL_ASIA_SUMMER     4
#define CENTRAL_ASIA_WINTER     5
#define ASIA                    6

#define MIN_TIME_BETWEEN_UPDATES 0.3

#define EPSILON                 0.000001
#define MIN_THRUST              1
#define FEET_TO_METERS          0.3048
#define METERS_TO_FEET          3.28084
#define IN_MG_TO_HPA            33.8639
#define MPS_TO_KNOTS            1.94384
#define MPS_TO_FPM              196.85
#define FPM_TO_MPS              0.00508
#define KNOTS_TO_MPS            0.51444

#define GRAVITY                 9.806
#define MOLAR_MASS_OF_AIR       0.0289644
#define UNIVERSAL_GAS_CONSTANT  8.31432
#define DEG_C_TO_KELVIN         273.15
#define SEA_LEVEL_PRESSURE      29.92
#define STANDARD_TEMP           15

#define VEL_ETL                 12.347
#define VEL_VBE                 38.583  //75 kts
#define VEL_VNE                 128.611 //250 kts
#define VEL_VRS                 24.384
#define ISA_STD_DAY_AIR_DENSITY 1.225

#define RAD_ALT_MAX_ALT         435.254 //1428ft
#define ALT_HOLD_SPEED_SWITCH   20.577  //40kts GS

#define POS_HOLD_SPEED_SWITCH         2.572   //5kts GS
#define VEL_HOLD_SPEED_SWITCH_DEVEL   15.433  //30kts GS
#define VEL_HOLD_SPEED_SWITCH_ACCEL   20.577  //40kts GS

#define HDG_HOLD_SPEED_SWITCH_DECEL   15.433  //30kts GS
#define HDG_HOLD_SPEED_SWITCH_ACCEL   20.577  //40kts GS
#define HDG_HOLD_BREAKOUT_VALUE       0.05//0.03
#define VEL_HOLD_BREAKOUT_VALUE       0.10//0.06
#define ATT_HOLD_BREAKOUT_VALUE       0.20//0.09