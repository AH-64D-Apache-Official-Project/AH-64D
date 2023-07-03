---
title: ASE Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-ase.html
folder: mpd
---


{% include image.html file="mpd/MPD-ASE.png" alt="Image of ASE MPD with no track" caption="Figure 1: The ASE MPD With Acitve IR jammer, No tracks" %}

## Introduction

The ASE page allows for the operator to operate the aircraft's Aircraft Survivability Equipment. The central portion of the page displays all detected threats to the airframe, both airborne & grounded. The outer sections allows for the operator to operate the aircraft's countermeasures & decide how the aircraft should react to threats.

## Info
The ase Page will only Show 7 Threats at one time, if there are more than 7 it is ordered by detection order.
### ASE

1. Autopage. This sets what situations this page will be automatically shown if not already open. It has 4 Modes.
    * `SRH` - A new radar has been detected in search mode.
    * `ACQ` - A radar is Aquiring(Marked) you.
    * `TRK` - A radar is actively tracking you.
    * `OFF` - Never autopage.
    {% include note.html content="In addition to this, the ASE page will Always autopage when launched upon." %}
3. Countermeasure count.
    * `American Mission Equipment` - Chaff Count.
    * `British Mission Equipment`  - Chaff & Flare Count.
4. RLWR Counter. - This will show how many Radar and laser threats there are total
5. IRJam Control. - This will toggle the Infra Red Jammer On & Off, when turning on it may display "WARM", during which it is not functioning
6. Ownship icon. - This represents the Apache.
7. CHAff Control. Toggle Between ARM & SAFE.
8. ASE Bezel. Unboxing this Takes you to the TSD Page.

### IR JAMMER

1. OFF. IR jammer are Off.
2. WARM. The IR Jammer Is warming up & non Operational, takes 2 seconds to warm up.
3. OPER. The IR Jammer Is operating and actively Jamming, The Jammer Does not have an operational limit.
    {% include note.html content="The IR Jammer is a proactive system, working to stop anything locking you evan before launch" %}

## RLWR Icons

{% include important.html content="Currently in this new implementation of the Ase page there is only one Icon Type, You get distinction between them from the Audio which Will call out the type of radar." %}

*  `*` Means the icons Flash

| Searching | Aquiring `*`| Tracking `*`
| :-: | :-: | :-: |
| ![](images/tex/icons/MPD-ASE-Radar-Searching.png) | ![](images/tex/icons/MPD-ASE-Radar-Aquiring.png) | ![](images/tex/icons/MPD-ASE-Radar-Tracking.png) |