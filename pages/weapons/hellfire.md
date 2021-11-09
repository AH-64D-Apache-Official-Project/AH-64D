---
title: Hellfire Missile Operation
tags: [weapons, hellfire, laser, radar]
sidebar: ah64d_sidebar
permalink: weapons-hellfire.html
folder: weapons
---
The flight profile system for the AGM-114 hellfires (SAL and RF) has been re-done with the CBA compat. Both the way you operate laser-guided hellfires and the way the IHADSS displays the missile symbology has changed significantly

## Turning on the LRFD

The laser can be turned on in the following methods:

* Custom control 5 (Arm) and 10 (Disarm)
* WPN page (on the right hand side of the MFD)
* Switching the LRFD using the `F` key and then turning it on the normal way

## Missile operation

Missle trajectories can be changed either using the TRAJ button on the right hand side of the MPD whe, or by cycling using the `F` key. The 3 available trajectories are `LO`, `HI` and `DIR`. The same modes are available for both missile types.

### Select target RF missile types

This is as simple as the current system, just select the target on the FCR using the `R` key.

### Select target for SAL missile types

Lasers are able to be locked on if they are on the friendly side's datalink. To select a target, follow these steps:

1. Switch to the WPN page
2. Select the missile you would like to use
3. Hit the `L1` button on the MPD and the selected laser will be displayed in the chat. It will tell you  whether it is remote or local, and the grid reference that the laser is at

If you haven't selected the right laser, repeat step 3 until the correct lase is displayed.

> :construction: ACE laser integration is being looked into.

### IHADSS Symbology

There are two modes of the missile that should be considered before firing : LOBL/LOAL and whether it is in constraints or not. This state of the missile is shown in the IHADSS by a box. The box is big when it is LOBL, small for LOAL, and the box becomes dashed when it is out of constraints. You should make sure the missile is in constraints before firing.

| | LOBL | LOAL |
| :-- | :-: | :-: |
| In constraints | ![LOBL in bounds](images/tex/hdu/ah64_lobl.png) | ![LOAL out of bounds](images/tex/hdu/f16_rsc_jhmcs_targ.png)
| Out of constraints | ![LOBL out of bounds](images/tex/hdu/ah64_lobl_nolos.png) | ![LOAL in bounds](images/tex/hdu/f16_rsc_jhmcs_targ_nolos.png)

Once you have the correct target selected, and the missile has the correct selected trajectory and is in constraints, then you are ready to fire!
