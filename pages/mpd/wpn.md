---
title: WPN Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-wpn.html
folder: mpd
---

The WPN or Weapon page is one of the most important pages for the Co-Pilot Gunner (CPG). It is used to interact with the weapons and sensors present on the Apache.

The weapon page will give you different options and information depending on the weapon you have selected. It will also show you the quantity of missiles, rockets and 30mm you have onboard. This page has multiple configurations depending on the currently selected weapons systems

## Safe

{% include image.html file="mpd/annot_page_wpn_safe.png"%}

1. Sight shows you which sight is selected (either TADS or FCR)
2. Safety indication of the aircraft (when the safety is on “SAFE” will be shown, otherwise “ARM)
3. ACQ  Acquisition source (what sensor your targeting information is coming from)
4. Selected Countermeasures and quantities

## Gun Page

The M230 Chain Gun is a 30mm cannon firing M789 HEDP (High Explosive Dual Purpose) rounds at a maximum of 650 rounds per minute.
It has an effective firing range of 2.5km.

{% include image.html file="mpd/annot_page_wpn_m230.png"%}

1. Current burst settings - Allows for you to view and select the current burst quantity
2. M230 ammo remaining

## Missile Page

The AGM-114 HELLFIRE (Helicopter Launched Fire and Forget) missiles are the primary weapon of all AH-64 aircraft.
Despite the name, only the AGM-114L is a true fire and forget weapon, all others require constant laser guidance to hit their target.

{% include image.html file="mpd/annot_page_wpn_msl.png"%}

7. Generation of selected Hellfire
8. Missile Icon ( indicates if its an **R**=Radar guided **L**= laser guided Missile)
9. TRAJ allows you to change the missile trajectory  (Dir/Low/Hi)
10. LRFD FIRST  (Laser designator/RangeFinder) allows you to Arm the laser ( NOTE this will only make it selectable)
11. ACQ (R6) used to switch Sights  between TADS and FCR

The AH-64D classifies missiles on-screen using the missile's icons:

| Type | Description | Icon |
| :-- | :-- | :-- |
| SAL1 | Semi active laser generation 1 | ![SAL-1 missile](images/tex/icons/114LINV_ca.png)
| SAL2 | Semi active laser generation 2 | ![SAL-2 missile](images/tex/icons/114LINV2_ca.png)
| RF | Radio frequency - Fire and forget Millimeter-Wave radar | ![SAL-2 missile](images/tex/icons/114RINV_ca.png)

## Rocket Page
The Hydra rocket consists of a basic Mk 66 rocket motor with a selectable warhead and fuse. There are several variations of the rocket motor;The types represented here use the Mod 6 motor, which is designed to reduce combustion of launch gasses in the engines of the firing aircraft. Hydra rockets use a folding fin and are launched from pods, typically either a 7 shot M260 or 19 shot M261 pod.

{% include image.html file="mpd/annot_page_wpn_rkt.png"%}

12. Zone inventory shows you which kind of rockets you have on board in each zone.
13. Selected warhead type Shows you which warhead type you have selected
14. Total Rocket count (Shows you the quantity of rockets left for that zone)
15. Salvo Quantity  (allows you to view the amount of rockets fired in a single trigger pull) press "Salvo". The available quantities are (1,2,4,8,12,24,ALL)