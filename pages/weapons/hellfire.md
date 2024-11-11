---
title: Hellfire Missile Operation
tags: [weapons, hellfire, laser, radar]
sidebar: ah64d_sidebar
permalink: weapons-hellfire.html
folder: weapons
---
The flight profile system for the AGM-114 hellfires (SAL and RF) has been re-done with the Ace compat. Both the way you operate laser-guided hellfires and the way the IHADSS displays the missile symbology has changed significantly

## Turning on the LRFD

The laser can be turned on in the following methods:

* WPN page (on the right hand side of the MFD)
* Holding {% include keybind.html name="lrfd-second-detent" %}.

## Missile operation

Missle trajectories are changed by using the TRAJ button on the right hand side of the MPD. The 3 available trajectories are `LO`, `HI` and `DIR`. These modes are only available for the Laser hellfires.

Regardless of Trajectory selected, If a hellfire Is LOBL, it will fly a direct trajectory

### Select target RF missile types

This is as simple as the current system, just select the target on the FCR using the `R` key.

1. Switch to the WPN page
2. Select the missile you would like to use
3. select your target

### Select target for SAL missile types

We now use the Ace laser code system allowing you to buddy laser with any other asset capable of configuring a laser code

1. Switch to the WPN page
2. Select the missile you would like to use
3. Check the LRFD laser codes against the hellfires laser codes
4. Designate your target

### IHADSS Symbology

There are two modes of the missile that should be considered before firing : LOBL/LOAL and whether it is in constraints or not. This state of the missile is shown in the IHADSS by a box. The box is big when it is LOBL, small for LOAL, and the box becomes dashed when it is out of constraints. You should make sure the missile is in constraints before firing.

| | LOBL | LOAL |
| :-- | :-: | :-: |
| In constraints | ![LOBL in bounds](images/tex/hdu/ah64_lobl.png) | ![LOAL out of bounds](images/tex/hdu/f16_rsc_jhmcs_targ.png)
| Out of constraints | ![LOBL out of bounds](images/tex/hdu/ah64_lobl_nolos.png) | ![LOAL in bounds](images/tex/hdu/f16_rsc_jhmcs_targ_nolos.png)

Once you have the correct target selected, and the missile has the correct selected trajectory and is in constraints, then you are ready to fire!

## SAL (Laser) Hellfire Autonomous Engagment Sequence

To engage a target with a SAL Hellfire, use the following sequence, known as SWARM:

1. **S**ight - Select TADS {% include keybind.html name="sight-select-tads"%}
2. **W**eapon - WAS (Weapon Action Switch) the Missiles {% include keybind.html name="was-msl"%}
3. **A**rm - The aircraft by pressing Arm button on the armament panel, verify ARM indication on WPN page
4. **R**ange - Continuous Lase (Second Detent) (G). Verify outside of minimum (500m), within maximum (6000m)
5. **M**essages - Verify trajectory (DIR/LO/HI), Mode (NORM/~~RIPL~~/~~MAN~~) and constraints box

## RF (Radar) Hellfire Autonomous Engagment Sequence

Begin by orienting the aircraft in the threat direction and perform the following to engage a target with an RF Hellfire by using the following sequence, known as SWARM:

1. **S**ight - Select FCR {% include keybind.html name="sight-select-fcr"%}.
    1. Conduct a Single Scan {% include keybind.html name="radar-singlescan"%}
    2. Select the desired NTS (Next to Shoot) {% include keybind.html name="targeting-next"%}.
2. **W**eapon - WAS (Weapon Action Switch) the Missiles {% include keybind.html name="was-msl"%}
3. **A**rm - The aircraft by pressing Arm button on the armament panel, verify ARM indication on WPN page
4. **R**ange - Verify outside of minimum (500m), within maximum (6000m) for Stationary, 8000m for Moving
5. **M**essages - Verify constraints box