---
title: Changelog (Dev)
tags: [changelogs, contributing]
sidebar: ah64d_sidebar
permalink: changelogs-dev.html
folder: changelogs
---

These are the changes that have been made to the dev version on Github since the last steam release

{% include warning.html content="These changes are **not currently merged into steam**." %}
## SFM+
 - Added damage when aircraft torque limits are exceeded
 - Rewrote how torque is handled to make it more stable and 'true to life'
 - Rewrote how engine starts are handled so that the start is no longer bound to hard times, but can be initiated at any point after the start switch is taken to start.
 - Enabled split power lever operations (a.k.a. single-engine operations)
 - Added APU fuel burn (175pph)
 - Stabilisation Fix means it continues running when in map and spectator

## Fire extinguisher system
 - The fire bottle is now rearmed by repairing the engines (left engine refills primary, Right the secondary)
 - the fire system can now be used by either crew member
 - Engine fire can be put out by shutting down that specific engine
 - Engine Fire is now visible for all players

## Fire Control Radar And Aircraft survival equipment
 - Updated Experimental FCR to Stable FCR using the Arma 2.06 Scripting functions To grab What the vanilla Radar Sees
 - Updated The ASE to show what the Sens Page shows Minus the Radar targets and incoming missiles.
 - Vanilla MPD pages have been removed
 - Jammers now use the vanilla countermeasure system for dynamic Jamming capabilities
 - updated Identification system of Anti-air threats
 - Standby jammers will automatically turn on Operational Jammers 1.5 seconds after an incoming missile warning and will leave it on
 - Operational Jammers will Proactively jam for 120 seconds before overheating

## Default Crew Kit
 - A Default Crew kit had been made for the Apache using the available vanilla kit, The kit consists of the following items.
    - Weapons: Spar-16 Equipped with an MRCO & Flashlight, P07 sidearm.
    - Clothes: Combat Fatigues (MTP), Carrier Lite (Green), Heli Pilot Helmet (CSAT)
    - Equipment: Black NVG, Binoculars, Map, GPS, Radio, Compass & watch
    - Ammo: 6x 5.56mm 30RND Yellow Tracer Mag, 2x 9mm 16Rnd Mag, 6x Smoke Grenades (White, Blue & Purple) & 2x IR Grenade

## Misc Changes
 - Apache Armor Has been boosted 20%
 - Rocket salvo fire rates have been increased
 - Updated Flare visuals (Flares sourced from USAF AC-130 BETA, Credit to Pingopete)

## Fixes 
 - 30mm ace rearm Bug When not Rearming the entire magazine
 - rocket salvo Has been reactivated
 - Hellfire stability Has been improved and is now smooth
 - The TADS shaking when the heli was damaged
 - Floodlighting, No longer jumps around, either Seat can now activate it in multiplayer
 - PNVS jitteriness with head tracking

## Todo
 - Rename of hit point for easier zeus damage 
 - Redone keybindings