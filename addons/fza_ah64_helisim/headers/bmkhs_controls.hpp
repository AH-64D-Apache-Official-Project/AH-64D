#pragma hemtt suppress pw3_padded_arg file
//AH-64D cockpit control bindings - the DATA rows for Core's macros.
//
//Included TWICE: once inside CfgUserActions to emit the classes, once inside a
//group[] with the macros redefined to emit the names. One table, two views, so
//the binds and the group cannot drift apart.
//
//One row per POSITION, because every position is individually bindable - a player
//binds the position they want rather than cycling a switch to reach it.
//
//BMKHS_CONTROL(control,positionToken,positionIndex,displayName)
//   positionToken is an identifier for the class name, positionIndex a number for
//   the dispatch. They must agree; nothing checks them.

BMKHS_CONTROL(battSwitch,p0,0,"Battery - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(battSwitch,p1,1,"Battery - On") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(apuBtn,p0,0,"APU - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(apuBtn,p1,1,"APU - On") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(eng1StartSw,p0,0,"Engine 1 Start - Ignition Override") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng1StartSw,p1,1,"Engine 1 Start - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng1StartSw,p2,2,"Engine 1 Start - Start") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(eng2StartSw,p0,0,"Engine 2 Start - Ignition Override") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng2StartSw,p1,1,"Engine 2 Start - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng2StartSw,p2,2,"Engine 2 Start - Start") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(rotorBrake,p0,0,"Rotor Brake - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(rotorBrake,p1,1,"Rotor Brake - Brake") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(rotorBrake,p2,2,"Rotor Brake - Lock") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(eng1PwrLvr,p0,0,"Engine 1 Power Lever - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng1PwrLvr,p1,1,"Engine 1 Power Lever - Idle") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng1PwrLvr,p2,2,"Engine 1 Power Lever - Fly") BMKHS_CONTROL_SEP()

BMKHS_CONTROL(eng2PwrLvr,p0,0,"Engine 2 Power Lever - Off") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng2PwrLvr,p1,1,"Engine 2 Power Lever - Idle") BMKHS_CONTROL_SEP()
BMKHS_CONTROL(eng2PwrLvr,p2,2,"Engine 2 Power Lever - Fly") BMKHS_CONTROL_SEP()
