---
title: FAQ
tags: [getting_started]
sidebar: ah64d_sidebar
permalink: faq.html
folder: root
---
## Getting Started

### How do I interact with cockpit switches? {#cockpit-switches}

Use the keybind {% include keybind.html name="cockpit-interact" %} with the crosshair over the switches.
### How do I map inputs to my HOTAS {#hotas}

Since v2.1, this should work the exact same as normal keyboard switches.

### How do I start the aircraft? {#aircraft-startup}

1. Rotor Brake Switch - OFF
2. Battery Switch - ON
3. Eng 1 Start Switch - Start
4. Ng - Check 23%
5. Power Lever - Idle
When Ng stabilized at idle (~67.9%), repeat steps 3 through 5
6. Power Levers - Advance to fly when ENG OIL PSI 70 (~1 minute after second reaches idle)

## Weapons
### How do I change the aircraft loadout/re-arm? {#rearm}

The legacy re-arming menu was removed and replaced with the ARMA 3 pylon system.  
- In Eden: Right click on the helicopter and select attributes and locate Pylon Settings.
- In-game: Use an ammo truck to rearm. Zeus Enhanced provides an interface for a zeus to edit loadouts, and pylons 

### What happened to the ATAS-92 Stinger? {#stinger}

The ATAS was removed since there is no open source information on its implementation in the aircraft and it had conflicts with the projects current direction. It will not be re-added.

### Why can't I assign weapons to the pilot? {#pilot-weapons}
- Currently the mod assumes all weapons are handled by the CPG. As a result if you place weapons on the PLT in the Editor, certain key functions, such as the symbology required for aiming will not be present.
## Targeting
### How do I turn on the radar, the salute key doesn't work. {#radar-salute}

The radar now uses the ARMA 3 radar key, Default is LCtrl + R.

### How do I add waypoints to the TSD? {#tsd-waypoints}
1. TSD button - Select
2. NAV Phase (B2) - Verify
3. Add (R1) - Select
4. Go to the ARMA map screen and left click on the map, then exit ARMA map screen.
5. XMIT (R3) - Select to save waypoints
6. ZOOM (L1) - Select appropriate scale to verify WPs saved successfully.

### How do I zoom when using the Pilot Night Vision System (PNVS) camera? {#pnvs-zoom}

Since this isn't a feature of the actual aircraft, it is not a feature in the mod.

## IHADSS / UI
### How do I "attach" (turn on) the Helmet Display Unit (HDU)? {#attach-hdu}

Right panel below the cockpit door handle and directly behind the COM panel is the storage container for the HDU. Click on the container to "attach" (turn on) the HDU.

### My HDU is "attached" but there's no symbology being displayed. {#power-hdu}

On the left side of the instrument panel, below the ARMAMENT panel is the pilot VIDEO panel. Locate and click on the IHADSS BRT CONT to display HDU symbology. NOTE: The HDU symbology will only display when the APU is ON.

### How do I prevent the cursor (green x) from moving while using TrackIR or other head tracking software {#headtracking-cursor-move}
To prevent the cursor from moving go to Options > Addon Options and de-select: Allow cursor movement while in headtracking mode. Conversely if you want it to move, select this option. The cursor can be centered by pressing {% include keybind.html name="look-center" %}.

## Flight model

### I can't start the aircraft and the engine page is displaying values. {#cannot-fly}
You need to ensure only ONE axis is mapped to Collective Raise (Analog) and Collective Lower (Analog). Due to the nature of how ARMA handles throttle input (and with the mods Simple Flight Model (SFM) enhancements), this is required for it to function correctly.