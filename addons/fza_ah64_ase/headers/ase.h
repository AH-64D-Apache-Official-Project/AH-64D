#ifndef FZA_AH64_ASE_HEADERS_ASE_H
#define FZA_AH64_ASE_HEADERS_ASE_H

#define ASE_LSR 5   //Designating
#define ASE_MSL 4   //Missile
#define ASE_LNC 3   //Launch
#define ASE_TRK 2   //Track
#define ASE_ACQ 1   //Acquisition
#define ASE_SRH 0   //Search

#define ASE_DETECT_RANGE_M 12000 //m, a missile fired with a lock is announced inside

#define ASE_HIDAS(heli)    ((heli) animationPhase "msn_equip_british" > 0.5)
#define ASE_HIDAS_ON(heli) (ASE_HIDAS(heli) && {(heli) getVariable ["bmkhs_dcBusOn", false]})
// One machine decides for the aircraft: where it is local, or the CPG's with no player pilot
#define ASE_OWNER(heli)    (local (heli) || {player == gunner (heli) && {!isPlayer driver (heli)}})

//--MWS
#define ASE_MWS_RANGE     4000 //m
#define ASE_MWS_MISS_DIST 150  //m, predicted closest approach that makes a munition incoming
#define ASE_MWS_MAX_TTG   15   //sec, time to closest approach that makes a munition incoming

//--RLWR
#define ASE_RLWR_STATE_OFF 0
#define ASE_RLWR_STATE_ON  1

//--IR Jammer
#define ASE_IRJAM_STATE_OFF   0
#define ASE_IRJAM_STATE_WARM  1
#define ASE_IRJAM_STATE_OPER  2
#define ASE_IRJAM_PWR_ON_TIME 2 //sec

//--Radar Jammer
#define ASE_RJAM_STATE_OFF  0
#define ASE_RJAM_STATE_STBY 1
#define ASE_RJAM_STATE_OPER 2
#define ASE_RJAM_STATE_WARM_STBY 3 //MPD only: STBY or OPER during the warm-up
#define ASE_RJAM_STATE_WARM_OPER 4
#define ASE_RJAM_WARM_TIME     180 //sec
#define ASE_RJAM_CONE_DEG      45
#define ASE_RJAM_ROLL_INTERVAL 4 //sec
#define ASE_RJAM_BAND          1000 //m, from a band's nearest radar, rolled as one
#define ASE_RJAM_JAM_TIME      (ASE_RJAM_ROLL_INTERVAL + 1) //sec, past the next roll so back-to-back jams don't gap
#define ASE_RJAM_HOLD_TIME     10 //sec after a jam that the RLWR holds the radar for
#define ASE_RJAM_FULL_RANGE    6000 //m
#define ASE_RJAM_BURN_RANGE    1500 //m
#define ASE_RJAM_CHANCE_MAX    0.8
#define ASE_RJAM_CHANCE_MIN    0.4
#define ASE_RJAM_COMMS_FULL    6000 //m, radios jammed at full strength within
#define ASE_RJAM_COMMS_RANGE   9000 //m, fading to nothing at
#define ASE_RJAM_COMMS_GAIN    6 //static volume at full strength and full radio volume
#define ASE_RJAM_COMMS_INTERVAL 0.25 //sec between radio jamming checks, and the time the static takes to reach a new volume
#define ASE_RJAM_COMMS_MAKEUP_MAX 8 //most the static is raised by to undo a vehicle's sound attenuation
#define ASE_RJAM_COMMS_FADE    2 //sec for radio jamming to fade in or out: as terrain stops or starts being in the way, and as it starts or stops transmitting
#define ASE_RJAM_COMMS_STALE   2.5 //sec without its refresh before a jammer is taken as off
#define ASE_RJAM_WARMING(heli) (CBA_missionTime - ((heli) getVariable ["fza_ah64_ase_rJamWarmStart", 0]) < ASE_RJAM_WARM_TIME)

//Mission equipment 
#define ASE_MSNEQUIP_STATE_OFF 0
#define ASE_MSNEQUIP_STATE_ON  1

//--Autopage
#define ASE_AUTOPAGE_SRH 1
#define ASE_AUTOPAGE_ACQ 2
#define ASE_AUTOPAGE_TRK 3
#define ASE_AUTOPAGE_OFF 0

//--Chaff dispenser
#define ASE_CHAFF_STATE_SAFE 0
#define ASE_CHAFF_STATE_ARM  1

//--CMDS (HIDAS)
#define ASE_CMDS_MAN  0
#define ASE_CMDS_SEMI 1
#define ASE_CMDS_AUTO 2
#define ASE_CMDS_FLARES_SIDE   32
#define ASE_CMDS_CHAFF         64
#define ASE_CMDS_REACT_MIN     0.5 //sec from a threat to an AUTO dispense
#define ASE_CMDS_REACT_MAX     0.9
#define ASE_CMDS_BOTH_DEG      30  //threats this close to the nose or tail dispense from both sides
#define ASE_CMDS_SHOT_GAP      0.175 //sec between cartridges from one dispenser
#define ASE_CMDS_HOLD          1.5 //sec after a program ends before AUTO dispenses again, or SEMI asks again, for anything still incoming
// Programs: steps of [sec after the previous step, flares, chaff]. Flares come from the side given, or are split
// between both sides. Radar threats get mostly chaff, so they don't use up the flares.
#define ASE_CMDS_PGM_CHAFF_US  [[0, 0, 1]]
#define ASE_CMDS_PGM_MAN_CHAFF [[0, 0, 1], [0.5, 0, 1]]
#define ASE_CMDS_PGM_MAN_FLARE [[0, 2, 0]]
#define ASE_CMDS_PGM_IR        [[0, 2, 0], [0.45, 2, 0], [0.45, 2, 0]]
#define ASE_CMDS_PGM_RF        [[0, 0, 2], [0.45, 2, 1], [0.45, 0, 2]]
#define ASE_CMDS_PGM_EMERGENCY [[0, 4, 1], [0.525, 4, 1], [0.525, 4, 1], [0.525, 4, 1]]

#endif