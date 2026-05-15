#ifndef FZA_AH64_FUEL_HEADERS_FUELCONSTANTS_HPP
#define FZA_AH64_FUEL_HEADERS_FUELCONSTANTS_HPP

// Fuel cell low-level thresholds
#define FWD_FUEL_LOW_VAL_KG     109.0
#define AFT_FUEL_LOW_VAL_KG     118.0
#define FUEL_FLOW_LBS_PER_HOUR  7936.64

// XFER pump and AUTO mode thresholds
#define XFER_RATE_KGS           0.378   // ~50 lb/min pump transfer rate
#define AUTO_FILL_THRESH_KG     369.0   // ~814 lb (Table 2-6 AUTO trigger)
#define AUTO_FWD_MIN_SRC_KG     127.0   // ~280 lb min FWD source for AUTO TO AFT
#define AUTO_SPLIT_STOP_KG      9.1     // ~20 lb
#define AUTO_SPLIT_50_KG        22.7    // ~50 lb
#define AUTO_SPLIT_100_KG       45.4    // ~100 lb
#define AUTO_500_KG             226.8   // ~500 lb

// Leak and advisory thresholds
#define TANK_LEAK_START_DMG         0.50
#define TANK_LEAK_MAX_RATE_KGS      0.0168  // ~133.3 lb/hr per tank; ~400 lb/hr total for 3 tanks at full damage
#define EXT_EMPTY_ADV_THRESH_KG     10      // kg below which EXT# EMPTY advisory fires

#endif
