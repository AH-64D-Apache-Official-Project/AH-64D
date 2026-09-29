#ifndef BMKHS_HELISIM_SYSTEMS_HPP
#define BMKHS_HELISIM_SYSTEMS_HPP

//Backstop on the dirty walk. A change propagates along its own chain and stops, so this is
//only ever hit by a component pair that keeps dirtying each other - a declaration bug, not
//a deep graph. Generous enough that no real airframe reaches it.
#define SYS_WALK_LIMIT  256

//Damage threshold for any declared component, whatever kind or domain.
#define SYS_COMP_DMG_THRESH  0.85

#define SYS_APU_DMG_THRESH   0.85
#define SYS_BATT_DMG_THRESH  0.85
#define SYS_GEN_DMG_THRESH   0.85
#define SYS_RECT_DMG_THRESH  0.85
#define SYS_ENG_DMG_THRESH   0.85
#define SYS_XMSN_DMG_THRESH  0.85
#define SYS_NGB_DMG_THRESH   0.85
#define SYS_IGB_DMG_THRESH   0.85
#define SYS_TGB_DMG_THRESH   0.85
#define SYS_FCR_DMG_THRESH   0.85
#define SYS_STAB_DMG_THRESH  0.85
#define SYS_HYD_DMG_THRESH   0.85
#define SYS_ASE_DMG_THRESH   0.85
#define SYS_SIGHT_DMG_THRESH 0.85
#define SYS_WPN_DMG_THRESH   0.85

#define SYS_HYD_RES_MIN_DMG 0.50
#define SYS_HYD_RES_MOD_DMG 0.67
#define SYS_HYD_RES_HVY_DMG 0.83
#define SYS_HYD_MIN_RTR_RPM 0.45

#define SYS_MIN_RPM       0.85

#define SYS_MIN_HYD_PSI   1260
#define SYS_MIN_ACC_PSI   1650
//How quickly a store refills once whatever it started is turning.
#define SYS_START_RECHARGE_SEC  1.0
#define SYS_HYD_MIN_LVL   0.1

#define SYS_BATT_TIMER    12.0  //min
#define SYS_ACC_TIMER     1.5   //min
#define SYS_LEAK_TIMER    2.0   //min

//Damage timers
#define DMG_PER_SEC       0.003 //5 minutes total time

//Engine damage ladder, useSystems = 1
#define SYS_ENG_CHIPS_DMG     0.50    //chips
#define SYS_ENG_OIL_DROP_DMG  0.65    //oil pressure falls
#define SYS_ENG_OIL_FAST_DMG  0.75    //oil pressure falls faster
#define SYS_ENG_OIL_ZERO_DMG  0.85    //no oil pressure - starvation
#define SYS_ENG_OIL_DIVISOR   12.1727 //oil tier divisors, D and 2D
#define SYS_ENG_STARVE_RATE   0.00191702 //starvation damage per second at the reference Ng
#define SYS_ENG_STARVE_REF_NG 0.75
#define SYS_ENG_OIL_FIRE_CHANCE 0.65 //engine fire when an oil-starved engine fails
#define SYS_ENG_HOTSTART_DIVISOR 81.339 //above startTgt while starting, per deg C

//Damaged drive torque - a slipping clutch
#define SYS_SLIP_DEPTH        0.20    //largest dip, as a fraction of the reading, times damage
#define SYS_SLIP_DROP_SEC     0.2     //lets go
#define SYS_SLIP_GRAB_SEC     0.7     //grabs again, to the overshoot
#define SYS_SLIP_END_SEC      1.0     //settled
#define SYS_SLIP_OVERSHOOT    0.25    //of the dip, past the true value as it grabs
#define SYS_SLIP_WAIT_LOW_DMG 5.0     //seconds between slips at 0.25 damage
#define SYS_SLIP_WAIT_HIGH_DMG 1.0    //and at 1.0

//Engine damage ladder, useSystems = 0 - one shared hitengine
#define SYS_ENG_SHARED_CHIPS_DMG   0.25    //chips or oil pressure, random engine
#define SYS_ENG_SHARED_FAIL_DMG    0.50    //that engine fails
#define SYS_ENG_SHARED_CHIPS2_DMG  0.75    //chips or oil pressure, operating engine

#endif
