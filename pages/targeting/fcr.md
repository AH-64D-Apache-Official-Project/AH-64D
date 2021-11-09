---
title: FCR
tags: [targeting, radar]
summary: Fire Control Radar operation
sidebar: ah64d_sidebar
permalink: targeting-fcr.html
folder: targeting
---

The FCR, or Fire Control Radar is a system that uses MMW radar to automatically detect, locate, classify and prioritize targets. It can scan up to 1024 radar signatures, prioritizing the top 16 for the operator. It has a range of up to 8km.

## Difference between Longbow and FCR

AH-64D Apaches without an FCR still have the Longbow name, as they are called such not because of the radar, but instead the communication network between aircraft. The FCR is just a system that also works with the Apache and the Longbow net.

## Radar Modes

### GTM

GTM, or Ground Tracking Mode, is the most commonly used radar mode. In it, it scans for targets in a 90° sector from the nose of the aircraft. It will only find ground, and maybe low flying air targets.

To select GTM, press {% include keybind.html name="radar-gtm"%}.

### ATM

ATM, or Air Tracking Mode, is less commonly used, but can be used to scan in the air 360° around the aircraft. This is not conventionally used for targeting as the Apache is an air to ground platform but can be useful to maintain situational awareness of other nearby air assets.

To select ATM, press {% include keybind.html name="radar-atm"%}.

## Scanning

The FCR can scan in either a single-scan or continuous-scan mode. To single scan, press {% include keybind.html name="radar-singlescan"%} once. To continuously scan, press {% include keybind.html name="radar-toggle"%} once to enable, and once again to disable.

![](https://i.imgur.com/vUKmRmW.png)

## Target Acquisition

Targets detected by the FCR will be visible both on the FCR page, as well as the TSD when it is in ATK mode. With these pages, they can be cycled via pressing {% include keybind.html name="targeting-next"%}.

The targets will be displayed with different icons according to their classification, and a highlighted if it is the NTS (Next-To-Shoot)

| Type | Icon | Icon (selected) |
| :-- |  :-: | :-: |
| Aircraft | ![](images/tex/icons/ah64_ac.png) | ![](images/tex/icons/ah64_ac_trk.png)
| Helicopter | ![](images/tex/icons/ah64_hc.png) | ![](images/tex/icons/ah64_hc_trk.png)
| Air Defence Artillery (AA) | ![](images/tex/icons/ah64_ada.png) | ![](images/tex/icons/ah64_ada_trk.png)
| Generic (Unknown type) | ![](images/tex/icons/ah64_gen.png) | ![](images/tex/icons/ah64_gen_trk.png)
| Tracked | ![](images/tex/icons/ah64_tnk.png) | ![](images/tex/icons/ah64_tnk_trk.png)
| Wheeled | ![](images/tex/icons/ah64_whl.png) | ![](images/tex/icons/ah64_whl_trk.png)