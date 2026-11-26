#ifndef FZA_AH64_ASE_HEADERS_RADARDECOY_H
#define FZA_AH64_ASE_HEADERS_RADARDECOY_H

// ACE Doppler radar seeker (fza_ase_fnc_aceDoppler)
#define ASE_RADAR_POLL_TIME         (1 / 7) //sec, ACE's ACTIVE_RADAR_POLL_FREQUENCY
#define ASE_RADAR_MIN_SCAN_AREA     30   //m, ACE's ACTIVE_RADAR_MINIMUM_SCAN_AREA
#define ASE_RADAR_TERRAIN_STEP      5000 //m, lineIntersectsSurfaces' limit
#define ASE_RADAR_CHAFF_CELL        50   //m, the least the cell is across the beam
#define ASE_RADAR_CHAFF_RANGE_GATE  150  //m either side of the target's range
#define ASE_RADAR_CHAFF_SEEKER_BEAM 7.5  //deg, a missile seeker's beam half angle
#define ASE_RADAR_CHAFF_CHANCE      0.2  //each chaff round, each check, at an effectiveness of 1
#define ASE_RADAR_CHAFF_SEDUCE_TIME 0.4  //sec
#define ASE_RADAR_CHAFF_DOPPLER_LIMIT 80 //m/s along the line of sight: no chance from here
#define ASE_RADAR_ROTOR_CHANCE      0.1  //each check in clutter
#define ASE_RADAR_BEAM_HALF_ANGLE   2    //deg
#define ASE_RADAR_MULTIPATH_RATE    180  //deg/s, the aim wandering between target and reflection

// Defaults: per missile in its ace_missileguidance class as fza_ase_chaffEffectiveness,
// fza_ase_multipathError, fza_ase_multipathMaxSpeed and fza_ase_multipathMaxHeight
#define ASE_RADAR_CHAFF_EFFECTIVENESS 0.5 //chaff chance multiplier, 0 immune
#define ASE_RADAR_MULTIPATH_ERROR   20   //m, the most the aim drops
#define ASE_RADAR_MULTIPATH_SPEED   50   //m/s along the line of sight: no error from here
#define ASE_RADAR_MULTIPATH_HEIGHT  300  //m above the ground: no error from here

// Engine-guided radar missiles (fza_ase_fnc_decoyFired)
#define ASE_DECOY_CHAFF_CHANCE    0.25 //each chaff round, each missile
#define ASE_DECOY_RJAM_MULT       2
#define ASE_DECOY_RJAM_STALE      2.5  //sec without the jammer's refresh
#define ASE_DECOY_MISSILE_RANGE   8000 //m
#define ASE_DECOY_CHAFF_SLOW      10   //m/s along the line of sight
#define ASE_DECOY_CHAFF_FAST      60   //m/s along the line of sight
#define ASE_DECOY_CHAFF_SLOW_MULT 1.5
#define ASE_DECOY_CHAFF_FAST_MULT 0.5

#endif
