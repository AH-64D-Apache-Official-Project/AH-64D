#define SIGHT_FCR  0
#define SIGHT_HMD  1
#define SIGHT_TADS 2
#define SIGHT_FXD  3

#define FCR_MODE_OFF           0
#define FCR_MODE_ON_SINGLE     1
#define FCR_MODE_ON_CONTINUOUS 2
#define FCR_MODE_FAULT     3

#define WAS_WEAPON_NONE 0
#define WAS_WEAPON_GUN  1
#define WAS_WEAPON_RKT  2
#define WAS_WEAPON_MSL  3

//FCR
#define FCR_LIMIT_MIN_RANGE              500  //For FCR/TSD display presentation only!
#define FCR_LIMIT_FORCE_LOBL_RANGE       1000
#define FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE 1500 //For FCR/TSD display presentation only!
#define FCR_LIMIT_STATIONARY_RANGE       6000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_RANGE           8000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_MIN_SPEED_KMH   6
//--FCR Priority
#define FCR_TYPE_UNKNOWN    0
#define FCR_TYPE_FLYER      1
#define FCR_TYPE_HELICOPTER 2
#define FCR_TYPE_TRACKED    3
#define FCR_TYPE_WHEELED    4
#define FCR_TYPE_ADU        5

//ASE
#define ASE_LSR 5   //Laser
#define ASE_MSL 4   //Missile
#define ASE_LNC 3   //Launch
#define ASE_TRK 2   //Track
#define ASE_ACQ 1   //Acquisition
#define ASE_SRH 0   //Search
//--Detection ranges
#define ASE_DETECT_RANGE_M 8000

//--RLWR
#define ASE_RLWR_STATE_OFF 0
#define ASE_RLWR_STATE_ON  1

//--IR Jammer
#define ASE_IRJAM_STATE_OFF   0
#define ASE_IRJAM_STATE_WARM  1
#define ASE_IRJAM_STATE_OPER  2
#define ASE_IRJAM_PWR_ON_TIME 2 //sec
//--Autopage
#define ASE_AUTOPAGE_SRH 1
#define ASE_AUTOPAGE_ACQ 2
#define ASE_AUTOPAGE_TRK 3
#define ASE_AUTOPAGE_OFF 0
//--Chaff dispenser
#define ASE_CHAFF_STATE_SAFE 0
#define ASE_CHAFF_STATE_ARM  1