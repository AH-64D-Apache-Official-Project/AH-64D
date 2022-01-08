---
title: Engine Startup
tags: [flight_model]
sidebar: ah64d_sidebar
permalink: flight-model-startup.html
folder: flightmodel
---

## Aircraft Startup Procedure
In the following checks, (BS) denotes Back Seat and (FS) denotes Front Seat. Use the following procedures when operating the aircraft:

**Before Starting APU**
1. (BS) MSTR IGN switch - BATT
2. (BS) Searchlight - As required
3. (BS) TAIL WHEEL butotn - Lock **(Not implemented)**
4. FIRE DET/EXTG panel TEST switch - Test as follows:
    a. (BS) Position 1: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning systems activated.
    b. (FS) Position 2: - MSTR WARN, ENG 1, APU, and ENG 2 FIRE and DISCH buttons are illuminated, a DECK FIRE warning is displayed on the UFD and voice warning system is activated.
5. (BS) RTR BRK switch - OFF

**Starting APU**
1. Fire guard (if available) - Posted
2. (BS) APU exhaust area clear - Check
3. (BS) APU - Start as follows:
    a. APU button - Press and release
    b. UFD - Monitor for APU advisories

**After Starting APU**
--NOT CURRENTLY IMPLEMENTED--

**Before Starting Engines**
1. (BS/FS) NVS MODE switch - As desired
2. (BS) Perform control sweep and trim check

**Starting Engines**
1. (BS) Area - Clear
2. Fire guard (if available) - Posted

**NOTE:** Rotor lock starts are not currently simulated, ensure RTR BRK is OFF to start the engines. 

3. (BS) RTR BRK switch - OFF or LOCK
4. (BS) EXT LT - As required
5. (BS) First engine - Start as follows:
    a. START switch - Start
    b. POWER lever - IDLE, at first indication of NG increase
    c. ENGINE OIL PSI - Monitor
    d. TGT - Monitor
    e. NG - Monitor
    f. MSTR WARN, MSTR CAUT, and UFD - Monitor
6. (BS) Second engine - Start:
    a. Same as first - Start
7. (BS) RTR BRK switch - OFF
8. (BS) POWER levers - Advance both POWER levers smoothly to FLY and ensure that both torque indications increase simultaneously.
9. (BS) NP and NR - Verify 101%
10. (BS) MSTR WARN, MSTR CAUT, and UFD - Monitor
11. (BS) APU - Off

**Before Taxi Check**
--NOT CURRENTLY IMPLEMENTED--

**Taxi Check**
--NOT CURRENTLY IMPLEMENTED--

**Before Takeoff Check**
1. (BS/FS) Weapons subsystem - Check the following:
    a. A/S button - SAFE
    b. GND ORIDE button - OFF **(Not implemented)**
    c. Weapons not actioned - Verify
2. (BS) TAIL WHEEL butotn - Lock **(Not implemented)**
3. (BS) PARK BRAKE - As desired **(Not implemented)**
4. (BS) POWER levers - FLY
5. (BS/FS) Systems - Check as follows:
    a. FUEL page options - As desired **(Not implemented)**
    b. Fuel quantity - Check
    c. UFD - Check
    d. Engine and flight instruments - Check
    e. ASE - As required
    f. Avionics - As desired:
        (1) Transponder - As desired **(Not implemented)**
        (2) COMM - As desired **(Not implemented)**
        (3) NAV - As desired
6. (BS/FS) Power check - Perform (Validate PERF page) **(Not implemented)**

**Before Landing Check**
1. (BS/FS) Weapons systems - Safe
    a. A/S button - SAFE
    b. GND ORIDE button - Off **(Not implemented)**
    c. Weapons not actioned - Verify
2. (BS/FS) ASE - As required
3. (BS) TAIL WHEEL button - Locked **(Not implemented)**
4. (BS) PARK BRAKE - As desired **(Not implemented)**
5. (BS/FS) Performance considerations - As required

**After Landing Check**
1. (BS) TAIL WHEEL button - As desired **(Not implemented)**
2. (BS) Exterior lights - As required
3. (BS/FS) Avionics - As required **(Not implemented)**

**Aircraft Shutdown**
1. (BS) APU - Start as follows:
    a. APU button - Press ON
    b. UFD - Monitor for APU advisories
2. (BS) TAIL WHEEL buton - Lock **(Not implemented)**
3. (BS) PARK BRAKE - Set **(Not implemented)**
4. (BS/FS) NVS MODE switch - OFF
5. (BS) POWER LEVERS - OFF (After engines have cooled at idle for 2 minutes)
6. (BS) TGT - Monitor
7. (BS) RTR BRK switch - BRK (Below 50% NR)
8. (BS) Stabilator - Set to zero **(Not implemented)**
9. (BS) Searchlight - OFF **(Not implemented)**
10. (BS) RTR BRK switch - OFF (When rotor stops)
11. (BS) EXT LT/INTR LT panel switches - OFF
12. (BS) APU - OFF
13. MSTR IGN switch - OFF