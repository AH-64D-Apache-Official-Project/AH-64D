#ifndef BMKHS_HELISIM_FUEL_HPP
#define BMKHS_HELISIM_FUEL_HPP


// XFER pump and AUTO mode thresholds
#define XFER_RATE_KGS           0.378   // ~50 lb/min pump transfer rate
#define AUTO_FILL_THRESH_KG     369.0   // ~814 lb (Table 2-6 AUTO trigger)
#define AUTO_MIN_SRC_KG         127.0   // ~280 lb minimum in the source main before AUTO draws it down
#define AUTO_SPLIT_STOP_KG      9.1     // ~20 lb
#define AUTO_SPLIT_50_KG        22.7    // ~50 lb
#define AUTO_SPLIT_100_KG       45.4    // ~100 lb
#define AUTO_500_KG             226.8   // ~500 lb

// Leak and advisory thresholds
#define TANK_LEAK_START_DMG         0.50
#define TANK_LEAK_MAX_RATE_KGS      0.0168  // ~133.3 lb/hr per tank; ~400 lb/hr total for 3 tanks at full damage
#define EXT_EMPTY_ADV_THRESH_KG     10      // kg below which EXT# EMPTY advisory fires

// FUEL CHECK reserve margins, in hours before dry tanks. Regulatory minimums rather than
// aircraft figures, so they are Core's: the check is a service the aircraft opts into.
#define FUEL_CHECK_VFR_RESERVE_HR   (20/60)     // 20 min day VFR
#define FUEL_CHECK_IFR_RESERVE_HR   (30/60)     // 30 min IFR
// Hours in the day, for the Zulu wrap
#define FUEL_HOURS_PER_DAY          24

#endif
