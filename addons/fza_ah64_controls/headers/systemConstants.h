#ifndef FZA_AH64_CONTROLS_HEADERS_SYSTEM_CONSTANTS_H
#define FZA_AH64_CONTROLS_HEADERS_SYSTEM_CONSTANTS_H

#define SIGHT_HMD  0
#define SIGHT_TADS 1
#define SIGHT_FCR  2

#define FCR_MODE_OFF           0
#define FCR_MODE_ON_SINGLE     1
#define FCR_MODE_ON_CONTINUOUS 2
#define FCR_MODE_FAULT     3

// Range sources, per crew station (fza_fnc_targetingRange)
#define RANGE_SRC_DEFAULT 0
#define RANGE_SRC_LASER   1
#define RANGE_SRC_RADAR   2
#define RANGE_SRC_NAV     3
#define RANGE_SRC_MANUAL  4
#define RANGE_SRC_AUTO    5

// The crew station with FCR as its sight, the last to select it, or the CPG linked with TADS as its sight: "plt", "cpg" or
// "" for none. Only it scans, slews and slaves the FCR.
#define FCR_OWNER(heli) ((heli) getVariable ["fza_ah64_fcrOwner", ""])

// The CPG's sight select LINK: with TADS the FCR centerline follows the TADS LOS (TADS-L), with FCR the slave switch
// slaves the TADS to the NTS (FCR-L). Off on any sight selection, a second press, or the FCR taken by the pilot.
#define CPG_LINK(heli) ((heli) getVariable ["fza_ah64_cpgLink", false])

// A coordinate point as the acquisition source is its name, W01, C51 or T01; ?01 when no point is stored
#define ACQ_POINT_NONE "?01"
#define ACQ_IS_POINT(acq) ((acq) regexMatch "^[WCT?][0-9]{2}$")

#define RANGE_DEFAULT_PLT     1500
#define RANGE_DEFAULT_CPG     3000
#define RANGE_MANUAL_MIN      100
#define RANGE_MANUAL_MAX      50000
#define RANGE_AUTO_MAX        50000
#define RANGE_NAV_MAX         32000
#define RANGE_LASER_MIN       500
#define RANGE_LASER_MAX       9999

#define WAS_WEAPON_NONE 0
#define WAS_WEAPON_GUN  1
#define WAS_WEAPON_RKT  2
#define WAS_WEAPON_MSL  3

//FCR
#define FCR_LIMIT_MIN_RANGE              500  //For FCR/TSD display presentation only!
#define FCR_LIMIT_FORCE_LOBL_RANGE       2000
#define FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE 2500 //For FCR/TSD display presentation only!
#define FCR_LIMIT_STATIONARY_RANGE       6000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_RANGE           8000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_MIN_SPEED_KMH   6
#define FCR_SCAN_RATE_DEGS               60 //antenna azimuth rate — constant across modes, smaller sectors scan faster
#define FCR_TPM_SCAN_RATE_DEGS           120 //TPM antenna rate — faster than targeting modes for rapid terrain refresh
#define FCR_BURST_SCANS                  [2, 2, 3, 4] //Scans per scanburst W/M/N/Z (GTM/RMAP; ATM is 2): the looks a target gets
#define FCR_TARGET_FILE                  32   //Targets the radar tracks, in priority order: FCR formats show the top 16, the TSD all in its attack phase
//--Scanburst result W/M/N/Z: at the end of each scanburst (FCR_BURST_SCANS cycles, a single scan's length, and each
//  burst-length stretch of a continuous scan) a target is bright, dim, or not shown (the rest) by these chances
#define FCR_STATIONARY_BRIGHT            [0.30, 0.40, 0.50, 0.60]
#define FCR_STATIONARY_DIM               [0.40, 0.35, 0.30, 0.25]
#define FCR_MOVING_BRIGHT                [0.80, 0.85, 0.90, 0.95] //Doppler separates movers from the clutter
#define FCR_MOVING_DIM                   [0.15, 0.11, 0.07, 0.03]
#define FCR_STATIONARY_MEMORY            3    //Scan-to-scan correlation: a stationary target shows its best of this many scanbursts; a mover its latest
//--Clutter (false returns, GTM/RMAP): clutter discretes the radar holds in the scanned sector, uncorrelated: each
//  scanburst shows each afresh by these chances, not shown 0.55
#define FCR_CLUTTER_POOL                 5    //About 2-3 clutter symbols at a time in any scan size
#define FCR_CLUTTER_BRIGHT               [0.20, 0.25, 0.30, 0.35]
#define FCR_CLUTTER_DIM                  [0.25, 0.20, 0.15, 0.10]

//--TPM obstacle derivation (towers/vertical items + RCS + minimum height)
#define FCR_OBST_TOWER_RATIO             1.5  //tower-like: height at least this x the widest footprint dimension
#define FCR_OBST_TOWER_MIN_HEIGHT_M      8    //tower-like structures qualify at this height (lamps, masts, pylons)
#define FCR_OBST_TALL_HEIGHT_M           13   //any shape this tall qualifies (control towers, hangars)

// TADS->RF handoff LOBL scan radius (metres around handoff position)
#define TADS_RF_LOBL_SCAN_RADIUS         3.5

// Shared ARH/RF chaff interaction tuning
#define RF_CM_CHECK_RADIUS               50
#define RF_CM_CHECK_INTERVAL_SEEKER      0.2
#define RF_CM_CHECK_INTERVAL_HANDOFF     0.25
#define RF_CM_PER_CHAFF_CHANCE           0.10
#define RF_REACQUIRE_DELAY               0.7

//--FCR Priority
#define FCR_TYPE_UNKNOWN    0
#define FCR_TYPE_FLYER      1
#define FCR_TYPE_HELICOPTER 2
#define FCR_TYPE_TRACKED    3
#define FCR_TYPE_WHEELED    4
#define FCR_TYPE_ADU        5

// FCR display mode
#define FCR_DISP_MODE_OFF   0
#define FCR_DISP_MODE_GTM   1
#define FCR_DISP_MODE_ATM   2
#define FCR_DISP_MODE_RMAP  3
#define FCR_DISP_MODE_TPM   4

#endif
