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

// NVS MODE switch per crew station, fza_ah64_nvsMode_plt / _cpg (fza_ihadss_fnc_nvsState)
#define NVS_MODE_OFF   0
#define NVS_MODE_NORM  0.5
#define NVS_MODE_FIXED 1
// NVS MODE FIXED: fixed forward, the aircraft centerline 4.9 deg below the airframe datum
#define NVS_FIXED_EL -4.9
// The TADS as an NVS sensor slews noticeably slower in azimuth than the PNVS, deg/s
#define TADS_NVS_SLEW_RATE 60
// The PNVS turret's slew rate, deg/s
#define PNVS_SLEW_RATE 120
// Correction added to the night vision sensor a crew station drives in NVS MODE NORM, by its azimuth
// [az, az bias, el bias], so its picture lines up with the world from where its head is; measured in game
// (fza_ihadss_fnc_nvsBias). The pilot's is on top of the PNVS turret's own (fza_ihadss_fnc_pnvsControl); the CPG's
// with the controls is for its head moving with the aircraft
#define NVS_BIAS_PLT        [[-90, 0, -0.4], [-67.5, 0, -0.3], [-45, 0, 0.1], [-22.5, 0, -0.4], [0, 0, -0.25], [22.5, 0, -0.4], [45, 0, 0.1], [67.5, 0, -0.25], [90, 0, -0.45]]
#define NVS_BIAS_CPG        [[-90, 0, 0.1], [-67.5, 0, -1.79], [-45, 0, -3.35], [-22.5, 0, -4.37], [0, 0, -4.7], [22.5, 0, -4.37], [45, 0, -3.35], [67.5, 0, -1.79], [90, 0, 0.1]]
#define NVS_BIAS_CPG_FLYING [[-90, -1.55, -2.85], [-45, -1.4, -2.9], [0, -1.55, -1.28], [45, -1.3, 1.03], [90, -1.25, 2.74]]
// A TADS turned as an NVS sensor that its crewmember has not reported for this long (s) is set back by the other
#define TADS_NVS_REPORT_TIMEOUT 2

// Missile drag (BIKI CfgAmmo airFriction): a = 0.002 x airFriction x speed squared, which the Hellfire TOF estimate
// matches in game within half a second
#define MISSILE_DRAG_SCALE 0.002
// Hellfire TOF (fza_hellfire_fnc_tofEstimate): approximate climb above the launch for the LO and HI trajectories, m
#define HELLFIRE_CLIMB_LO 100
#define HELLFIRE_CLIMB_HI 300
// Rockets (fza_hydra_fnc_aimSolve): where they leave the pods, in model space, which the pylon solution is measured from:
// the tubes' centre is 0.33 m below the pylon pivot axis (osa_pylon) and 0.02 m ahead of it
#define HYDRA_LAUNCH_POS(heli) (((heli) selectionPosition ["osa_pylon", "Memory"]) vectorAdd [0, 0.02, -0.33])
// The rocket's flight as recorded in game: it leaves the pod at rest along the pod line and its body
// keeps that direction; the motor gives 0.86 of the config thrust; drag is 0.00192 x airFriction x the speed along the
// body squared, and side friction sideAirFriction x the speed across it squared (none in the rockets' config). These
// reproduce the recorded speeds within 2 m/s and, with sideAirFriction 0.004, the velocity's angle off the body within
// 0.05 deg over 17 s of flight.
#define HYDRA_INIT_SPEED   0
#define HYDRA_THRUST_SCALE 0.86
#define HYDRA_DRAG_SCALE   0.00192
#define HYDRA_SIDE_SCALE   1
// Pylon articulation (PYLON LIMIT): +4 to -15 deg in the air, +4 to -5 deg on the ground
#define HYDRA_PYLON_MIN_AIR    -15
#define HYDRA_PYLON_MIN_GROUND -5
#define HYDRA_PYLON_MAX        4
// ACCEL LIMIT: below this vertical load factor the rotor may obstruct the rockets
#define HYDRA_ACCEL_LIMIT_G 0.5

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
#define FCR_DISPLAY_LOAL_LOBL_RANGE      1500 //FCR/TSD symbols: stationary targets LOBL at or inside, LOAL beyond; nothing to do with the missile
#define ARH_LOAL_LOBL_SWITCH_RANGE       2500 //Hellfire RF: LOBL/LOAL engagement switch range; nothing to do with the FCR symbols
#define FCR_LIMIT_STATIONARY_RANGE       6000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_RANGE           8000 //For FCR/TSD display presentation only!
#define FCR_LIMIT_MOVING_MIN_SPEED_KMH   6
#define FCR_SCAN_RATE_DEGS               60 //antenna azimuth rate — constant across modes, smaller sectors scan faster
#define FCR_TPM_SCAN_RATE_DEGS           120 //TPM antenna rate — faster than targeting modes for rapid terrain refresh
#define FCR_TPM_ANTENNA_EL               [-0.5, -3] //TPM antenna elevation, ELEV FAR / NEAR
#define FCR_TPM_BEAM_HALF_EL             5.5 //Assumed: terrain further below the antenna elevation than this is not measured
#define FCR_BURST_SCANS                  [2, 2, 3, 4] //Scans per scanburst W/M/N/Z (GTM/RMAP; ATM is 2): the looks a target gets
#define FCR_TARGET_FILE                  256  //Targets the radar tracks, in priority order: the TSD shows all in its attack phase
#define FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS 16 //The top targets the FCR formats, the IHADSS and the TSD nav phase show, and the NTS cycles through
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
