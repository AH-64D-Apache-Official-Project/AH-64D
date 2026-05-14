#ifndef FZA_AH64_SFMPLUS_HEADERS_CORE_HPP
#define FZA_AH64_SFMPLUS_HEADERS_CORE_HPP

#define STABILATOR_MODE_ALWAYSENABLED   2
#define STABILATOR_MODE_JOYSTICKONLY    1
#define STABILATOR_MODE_ALWAYSDISABLED  0

#define HOTAS                   0
#define KEYBOARD                1

#define ISA_STD                 0
#define EUROPE_SUMMER           1
#define EUROPE_WINTER           2
#define MIDDLE_EAST             3
#define CENTRAL_ASIA_SUMMER     4
#define CENTRAL_ASIA_WINTER     5
#define ASIA                    6

#define CASUAL					0
#define REALISTIC				2

#define MIN_TIME_BETWEEN_UPDATES 0.3

#define EPSILON                 0.000001
#define MIN_THRUST              1
#define FEET_TO_METERS          0.3048
#define METERS_TO_FEET          3.28084
#define KG_TO_LBS               2.20462
#define MPS_TO_KNOTS            1.94384
#define MPS_TO_FPM              196.85
#define FPM_TO_MPS              0.00508
#define KNOTS_TO_MPS            0.51444

#define FWD_FUEL_LOW_VAL_KG     109.0
#define AFT_FUEL_LOW_VAL_KG     118.0
#define FUEL_FLOW_LBS_PER_HOUR  7936.64

#define GRAVITY                 9.806
#define MOLAR_MASS_OF_AIR       0.0289644
#define UNIVERSAL_GAS_CONSTANT  8.31432
#define DEG_C_TO_KELVIN         273.15
#define SEA_LEVEL_PRESSURE      29.92
#define STANDARD_TEMP           15
#define IN_MG_TO_HPA            33.8639

#define VEL_ETL                 12.347
#define VEL_VBE                 38.583  //75 kts
#define VEL_VNE                 128.611 //250 kts
#define VEL_VRS                 24.384
#define ISA_STD_DAY_AIR_DENSITY 1.225

#define RAD_ALT_MAX_ALT         435.254 //1428ft
#define ALT_HOLD_SPEED_SWITCH   20.577  //40kts GS

#define POS_HOLD_SPEED_SWITCH         2.572   //5kts GS
#define VEL_HOLD_SPEED_SWITCH_DECEL   15.433  //30kts GS
#define VEL_HOLD_SPEED_SWITCH_ACCEL   20.577  //40kts GS

#define HDG_HOLD_SPEED_SWITCH_DECEL   15.433  //30kts GS
#define HDG_HOLD_SPEED_SWITCH_ACCEL   20.577  //40kts GS
#define HDG_HOLD_BREAKOUT_VALUE       0.05//0.03
#define VEL_HOLD_BREAKOUT_VALUE       0.10//0.06
#define ATT_HOLD_BREAKOUT_VALUE       0.20//0.09

#define CENTER_TRIM_VAL               0.05

// Fuel system — XFER pump and AUTO mode thresholds
#define XFER_RATE_KGS           0.378   // ~50 lb/min pump transfer rate
#define AUTO_FILL_THRESH_KG     369.0   // ~814 lb (Table 2-6 AUTO trigger)
#define AUTO_FWD_MIN_SRC_KG     127.0   // ~280 lb min FWD source for AUTO TO AFT
#define AUTO_SPLIT_STOP_KG      9.1     // ~20 lb
#define AUTO_SPLIT_50_KG        22.7    // ~50 lb
#define AUTO_SPLIT_100_KG       45.4    // ~100 lb
#define AUTO_500_KG             226.8   // ~500 lb

// Fuel system — leak and advisory thresholds
#define TANK_LEAK_START_DMG         0.50
#define TANK_LEAK_MAX_RATE_KGS      0.0168  // ~133.3 lb/hr per tank; ~400 lb/hr total for 3 tanks at full damage
#define EXT_EMPTY_ADV_THRESH_KG     10      // kg below which EXT# EMPTY advisory fires

#endif
