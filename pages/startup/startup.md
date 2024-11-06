---
title: Aircraft startup procedure
tags: [flight_model]
sidebar: ah64d_sidebar
permalink: startup.html
folder: startup
---

{% capture FS %}{% include badge.html content="FS"%}{% endcapture%}
{% capture BS %}{% include badge.html content="BS"%}{% endcapture%}
{% capture FSBS %}{% include badge.html content="FS/BS"%}{% endcapture%}

In the following checks, {{BS}} denotes Back Seat and {{FS}} denotes Front Seat.

Use the following procedures when starting up the aircraft:

## Interior Check
1. {{BS}} RTR BRK switch - OFF
2. {{FSBS}} HDU - On

## Before Starting APU
1. {{BS}} MSTR IGN switch - BATT
2. FIRE DET/EXTG panel TEST switch - Test as follows:
    1. {{BS}} Position 1: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning systems activated.
    2. {{FS}} Position 2: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE and DISCH buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning system is activated. 

## Starting APU
1. {{BS}} APU exhaust area clear - Check
2. {{BS}} APU - Start as follows:
    1. APU button - Press and release
    2. UFD - Monitor for APU advisories

## Before Starting Engines
1. {{FSBS}} NVS MODE switch - As desired
2. {{BS}} Perform control sweep and trim check

## Starting Engines
1. {{BS}} Area - Clear

{% include note.html content="Rotor lock starts are not currently simulated, ensure RTR BRK is OFF to start the engines."%}

2. {{BS}} RTR BRK switch - OFF or ~~LOCK~~
3. {{BS}} EXT LT - As required
4. {{BS}} First engine - Start as follows:
    1. START switch - Start
    2. POWER lever - IDLE, at first indication of NG increase
    3. ENGINE OIL PSI - Monitor
    4. TGT - Monitor
    5. NG - Monitor
    6. MSTR WARN, MSTR CAUT, and UFD - Monitor
5. {{BS}} Second engine - Start:
    1. Same as first - Start
6. {{BS}} RTR BRK switch - OFF
7. {{BS}} POWER levers - Advance both POWER levers smoothly to FLY and ensure that both torque indications increase simultaneously.
8. {{BS}} NP and NR - Verify 101%
9. {{BS}} MSTR WARN, MSTR CAUT, and UFD - Monitor
10. {{BS}} APU - Off


## Before Takeoff Check
1. {{FSBS}} Weapons subsystem - Check the following:
    1. A/S button - SAFE
    3. Weapons not actioned - Verify
2. {{BS}} POWER levers - FLY
3. {{FSBS}} Systems - Check as follows:
    1. Fuel quantity - Check
    2. UFD - Check
    3. Engine and flight instruments - Check
    4. ASE - As required
    5. Avionics - As desired:
        1. NAV - As desired

