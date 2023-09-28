---
title: FCR
tags: [targeting, radar]
summary: Fire Control Radar operation
sidebar: ah64d_sidebar
permalink: targeting-fcr.html
folder: targeting
---

The Fire Control Radar (FCR) is a system that uses MMW radar to automatically detect, locate, classify and prioritize targets. It can scan up to 1024 radar signatures, prioritizing the top 16 for the operator (why only 16, because the apache can only carry 16 hellfires).

FCR specifications can be found in the [FCR MPD](mpd-fcr.html)
## Difference between Longbow and FCR

AH-64D Apaches without an FCR still have the Longbow name, as they are called such not because of the radar, but instead the communication network between aircraft. The FCR is just a system that also works with the Apache and the Longbow net.

![](images/screenshots/FCR_dipiction.png)

## Radar Modes

### Ground Targeting Mode (GTM)

GTM is the most commonly used radar mode. In it, it scans for targets in a 90° sector from the nose of the aircraft. It will only find ground, and maybe low flying air targets.

To select GTM, press {% include keybind.html name="radar-gtm"%}.

### Air Targeting Mode (ATM)

ATM is less commonly used, but can be used to scan in the air 336° around the aircraft. This is not conventionally used for targeting as the Apache is an air to ground platform but can be useful to maintain situational awareness of other nearby air assets.

To select ATM, press {% include keybind.html name="radar-atm"%}.

## Scanning

The FCR can scan in either a single-scan or continuous-scan mode. To single scan, press {% include keybind.html name="radar-singlescan"%} once. To continuously scan, press {% include keybind.html name="radar-toggle"%} once to enable, and once again to disable.


## Target Acquisition

Targets detected by the FCR will be visible both on the FCR page, as well as the TSD when it is in ATK mode. With these pages, they can be cycled via pressing {% include keybind.html name="targeting-next"%}.

The targets will be displayed with different icons according to their classification, and a highlighted with different markings to indicate status.

| Aircraft | Helicopter | Air Defence Unit | Generic/Unknown | Tracked | Wheeled
| :-- |  :-: |  :-: |  :-: |  :-: |  :-:
![](images/tex/icons/flyer_ca.png) | ![](images/tex/icons/heliLOBL_ca.png) | ![](images/tex/icons/aduLOBL_ca.png) | ![](images/tex/icons/unkLOBL_ca.png) | ![](images/tex/icons/trackLOBL_ca.png) | ![](images/tex/icons/wheelLOBL_ca.png)

| LOBL | LOAL | Moving | NTS | NTS(No MSL) | ANTS
| :-- |  :-: |  :-: |  :-: |  :-: |  :-:
![](images/tex/icons/trackLOBL_ca.png) | ![](images/tex/icons/trackLOAL_ca.png) | ![](images/tex/icons/trackMOVE_ca.png) | ![](images/tex/icons/nts_ca.png) | ![](images/tex/icons/nts_noMSL_ca.png) | ![](images/tex/icons/ants_ca.png)