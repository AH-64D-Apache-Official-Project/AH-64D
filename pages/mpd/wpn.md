---
title: WPN Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-wpn.html
folder: mpd
---

The WPN or Weapon page is one of the most important pages for the Co-Pilot Gunner (CPG). It is used to interact with the weapons and sensors present on the Apache.

The weapon page will give you different options and information depending on the weapon you have selected. It will also show you the quantity of missiles, rockets and 30mm you have onboard. This page has multiple configurations depending on the currently selected weapons systems

## Selecting weapons

To view a weapon's subpage, you select it on the bottom of the MPD (buttons B2,B3,B5). To deselect one, you can click on it again.

When you have a weapon [WAS](weapons-was.html)ed, that weapon's subpage will always be visible on the WPN page. You cannot select one weapon while another is WASed.

{% include warning.html content="Just because a WPN Subpage is selected doesn't mean the respective weapon is ready to fire. You must use the keybinds to WAS a weapon and fire it." %}

## Common information

{% include image.html file="mpd/annot_page_wpn_safe.png"%}

1. The arming indicator shows whether the aircraft is armed or safe.
2. The sight status box, to the left of the arming indicator, shows you which sight is selected
3. The acquisition source status box shows the currently selected acquisition source (not yet implemented)
4. The countermeasures count indication is in the tail of the aircraft, and shows the current armament of countermeasures.

## GUN Subpage

The GUN Subpage allows for the modification of the operating parameters of the M230 chaingun

{% include image.html file="mpd/annot_page_wpn_m230.png"%}

1. The current burst settings on the left allow for the selection of a specific burst limit.
2. M230 ammo remaining is visible inside the highlighted image of the M230.

## MSL Subpage

The MSL Subpage allows for the selection of specific missiles as well as their launch parameters.

{% include image.html file="mpd/annot_page_wpn_msl.png"%}

* Each hellfire has an icon specifying its seeker type. This can be used to decide which missile to shoot.
* The hellfire that will be the next launched will be highlighted in inverse video.
* TRAJ (R3) displays the current trajectory, and pressing it will cycle available hellfire trajectories.
* SAL SEL (L3) will cycle the different missile types.
* PRI (L1) shows the status of the currently selected lase, either `SELF` or `REMT`. Pressing this will cycle between all available lases.

The AH-64D classifies missiles on-screen using the missile's icons:

| Type | Description | Icon |
| :-- | :-- | :-- |
| SAL1 | Semi active laser generation 1 | ![SAL-1 missile](images/tex/icons/114LINV_ca.png)
| SAL2 | Semi active laser generation 2 | ![SAL-2 missile](images/tex/icons/114LINV2_ca.png)
| RF | Radio frequency - Fire and forget Millimeter-Wave radar | ![SAL-2 missile](images/tex/icons/114RINV_ca.png)

## Rocket Page

The RKT Subpage allows for the selection of specific rocket types from the available inventory, along with allowing for specific launch parameters to be set.

{% include image.html file="mpd/annot_page_wpn_rkt.png"%}

* On the left is the aircraft's inventory, which shows all available rocket types. Clicking on a rocket type will select that rocket type
* The selected rocket type is displayed on the pods holding that rocket type.
*  Salvo Quantity (R1) shows the number of rockets that will be fired in a single trigger pull. This can be 1,2,4,8,12,24 or ALL.