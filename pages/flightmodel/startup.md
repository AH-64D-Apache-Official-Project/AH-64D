---
title: Aircraft startup procedure
tags: [flight_model]
sidebar: ah64d_sidebar
permalink: flight-model-startup.html
folder: flightmodel
---

{% capture FS %}{% include badge.html content="FS"%}{% endcapture%}
{% capture BS %}{% include badge.html content="BS"%}{% endcapture%}
{% capture FSBS %}{% include badge.html content="FS/BS"%}{% endcapture%}

In the following checks, {{BS}} denotes Back Seat and {{FS}} denotes Front Seat.

Checks that have been ~~struck through~~ are not implemented

Use the following procedures when operating the aircraft:

## Interior Check
1. {{BS}} RTR BRK switch - OFF
2. {{FSBS}} HDU - On

## Before Starting APU
1. {{BS}} MSTR IGN switch - BATT
2. {{BS}} ~~Searchlight - As required~~
3. {{BS}} ~~TAIL WHEEL button - Lock~~
4. FIRE DET/EXTG panel TEST switch - Test as follows:
    1. {{BS}} Position 1: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning systems activated.
    2. {{FS}} Position 2: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE and DISCH buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning system is activated. 

## Starting APU
1. Fire guard (if available) - Posted
2. {{BS}} APU exhaust area clear - Check
3. {{BS}} APU - Start as follows:
    1. APU button - Press and release
    2. UFD - Monitor for APU advisories

## After Starting APU
--NOT CURRENTLY IMPLEMENTED--

## Before Starting Engines
1. {{FSBS}} NVS MODE switch - As desired
2. {{BS}} Perform control sweep and trim check

## Starting Engines
1. {{BS}} Area - Clear
2. Fire guard (if available) - Posted

{% include note.html content="Rotor lock starts are not currently simulated, ensure RTR BRK is OFF to start the engines."%}

3. {{BS}} RTR BRK switch - OFF or ~~LOCK~~
4. {{BS}} EXT LT - As required
5. {{BS}} First engine - Start as follows:
    1. START switch - Start
    2. POWER lever - IDLE, at first indication of NG increase
    3. ENGINE OIL PSI - Monitor
    4. TGT - Monitor
    5. NG - Monitor
    6. MSTR WARN, MSTR CAUT, and UFD - Monitor
6. {{BS}} Second engine - Start:
    1. Same as first - Start
7. {{BS}} RTR BRK switch - OFF
8. {{BS}} POWER levers - Advance both POWER levers smoothly to FLY and ensure that both torque indications increase simultaneously.
9. {{BS}} NP and NR - Verify 101%
10. {{BS}} MSTR WARN, MSTR CAUT, and UFD - Monitor
11. {{BS}} APU - Off

## Before Taxi Check
--NOT CURRENTLY IMPLEMENTED--

## Taxi Check
--NOT CURRENTLY IMPLEMENTED--

## Before Takeoff Check
1. {{FSBS}} Weapons subsystem - Check the following:
    1. A/S button - SAFE
    2. ~~GND ORIDE button - OFF~~
    3. Weapons not actioned - Verify
2. {{BS}} ~~TAIL WHEEL butotn - Lock~~
3. {{BS}} ~~PARK BRAKE - As desired~~
4. {{BS}} POWER levers - FLY
5. {{FSBS}} Systems - Check as follows:
    1. ~~FUEL page options - As desired~~
    2. Fuel quantity - Check
    3. UFD - Check
    4. Engine and flight instruments - Check
    5. ASE - As required
    6. Avionics - As desired:
        1. ~~Transponder - As desired~~
        2. ~~COMM - As desired~~
        3. NAV - As desired
6. ~~{{FSBS}} Power check - Perform (Validate PERF page)~~

## Before Landing Check
1. {{FSBS}} Weapons systems - Safe
    1. A/S button - SAFE
    2. ~~GND ORIDE button - Off~~
    3. Weapons not actioned - Verify
2. {{FSBS}} ASE - As required
3. {{BS}} ~~TAIL WHEEL button - Locked~~
4. {{BS}} ~~PARK BRAKE - As desired~~
5. {{FSBS}} Performance considerations - As required

## After Landing Check
1. {{BS}} ~~TAIL WHEEL button - As desired~~
2. {{BS}} Exterior lights - As required
3. {{FSBS}} ~~Avionics - As required~~

## Aircraft Shutdown
1. {{BS}} APU - Start as follows:
    1. APU button - Press ON
    2. UFD - Monitor for APU advisories
2. {{BS}} ~~TAIL WHEEL buton - Lock~~
3. {{BS}} ~~PARK BRAKE - Set~~
4. {{FSBS}} NVS MODE switch - OFF
5. {{BS}} POWER LEVERS - OFF (After engines have cooled at idle for 2 minutes)
6. {{BS}} TGT - Monitor
7. {{BS}} RTR BRK switch - BRK (Below 50% NR)
8. {{BS}} ~~Stabilator - Set to zero~~
9. {{BS}} ~~Searchlight - OFF~~
10. {{BS}} RTR BRK switch - OFF (When rotor stops)
11. {{BS}} EXT LT/INTR LT panel switches - OFF
12. {{BS}} APU - OFF
13. MSTR IGN switch - OFF