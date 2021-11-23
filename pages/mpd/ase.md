---
title: ASE Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-ase.html
folder: mpd
---


{% include image.html file="mpd/ase_page_notracks_nojam.png" alt="Image of ASE MPD with no track" caption="Figure 1: The ASE mpd with no active jammers and no tracks" %}

## Introduction

The ASE page allows for the operator to operate the aircraft's Aircraft Survivability Equipment. The central portion of the page displays all detected threats to the airframe, both airborne and grounded. The outer sections allows for the operator to operate the aircraft's countermeasures and decide how the aircraft should react to threats.

{% include important.html content="In reality in the real aircraft the Jammer do not have the different modes as Standby is to warm the jammers up ready for activation & operation would be the equivilant of standby currantly in which it jammes when it detects a threat." %}

## Info

### ASE

1. Autopage. This sets what situations this page will be automatically shown. It has 3 Modes
    * `OFF` - Never autopage
    * `TRACK` - Autopage when a threat begins tracking, or when a launch is detected.
    * `LAUNCH` - Autopage when a launch is detected
2. Range to show in the central dsplay
3. Countermeasure count.
4. IR Jammer Control.
5. RF Jammer Control.
6. Ownship icon.

### Jammers

<figure>
    <div style="display:block;width:100%;display:flex;justify-content:center">
    <img class="docimage" style="display:inline-block" src="images/mpd/ir_jam_panel.png"/>
    <img class="docimage" style="display:inline-block" src="images/mpd/rf_jam_panel.png"/>
    </div>
    <figcaption>Figure 2: Jammer controls on the MPD</figcaption>
</figure>

1. OFF. jammers are Off.
2. STBY. In this mode Jammers will Automaticaly switch to OPER after Missile is detected.
3. OPER. The Jammers are Jamming, They have 120 seconds of operation before overheat & require 60 seconds cooldown, OPER can be interrupted.

{% include warning.html content="Switching the Jammers from OFF to OPER & STBY to OPER has a 1.5 second activation delay, so being in either OFF or STBY mode will delay jammer enabling at short range, If heading into close proximity to known anti air it is recommended to have jammers in OPER beforehand." %}

## RWR Icons

{% include important.html content="Currently in the aircraft there are only three types of anti air icons." %}

| Type | Detected | Tracking | Firing | Description
| :- | :-: | :-: | :-: | :- |
| SA9 | ![](images/tex/icons/9D.png) | ![](images/tex/icons/9T.png) | ![](images/tex/icons/9L.png) | SA9 Are classified as R-750 Cronus, S-750 Rhea, MIM-145 Defender, AN/MPQ-105
| SA19 | ![](images/tex/icons/19D.png) | ![](images/tex/icons/19T.png) | ![](images/tex/icons/19L.png) | SA19 Are classified as IFV-6a Cheetah, ZSU-39 Tigris, CUP 2S6M Tunguska    
| SA23 | ![](images/tex/icons/23D.png) | ![](images/tex/icons/23T.png) | ![](images/tex/icons/23L.png) | SA23 Are classified as RHS & CUP ZSU-23-4