---
title: ASE Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-ase.html
folder: mpd
---


{% include image.html file="mpd/ase_page_notracks_nojam.png" alt="Image of ASE MPD with no track" caption="Figure 1: The ASE mpd with no active jammers and no tracks" %}
{% include image.html file="mpd/IR_jam_panel.png" alt="Image of ASE MPD with no track" caption="Figure 2: The Jammer pannel for the IR Jammer" %}
{% include image.html file="mpd/RF_jam_panel.png" alt="Image of ASE MPD with no track" caption="Figure 3: The Jammer pannel for the RF Jammer" %}


## Introduction

The ASE, or aircraft survival equipment, is the page in which you manage outside threats to the airframe. On this page you will find information about active radar threats both airborne and grounded, this information is gathered by the RWR and processed onto the display with information about the type of threat, its distance & its actions.

You can also control the infrared & Radar Jammers using the modes available standby & operational.

{% include important.html content="In reality in the real aircraft the Jammer do not have the different modes as standby is to warm the jammers up ready for activation & operation would be the equivilant of standby currantly in which it jammes when it detects a threat." %}

{% include warning.html content="The ASE can only show up to 32 targets due to technical limitations of the engine. If you have more targets than that known to you, you may not be able to view them all.." %}

## Info

### ASE (Figure 1)

1. Autopage. Will open the ASE page on the right Mpd under the set conditions of Track or Launch.
2. Range setting on the ASE page, Range is defined as Radius.
3. Flare counter Identical to what can be seen on the WPN MPD page.
4. IR Jammer Control.
5. RF Jammer Control.
6. Ownership icon.

### Jammers (Figure 2 & 3)

1. OFF. jammers are Off.
2. STBY. In this mode Jammers will Automaticaly switch to OPER after Missile is detected.
3. OPER. The Jammers are Jamming, They have 120 seconds of operation before overheat & require 60 seconds cooldown, OPER can be interrupted.

{% include warning.html content="Switching the Jammers from OFF to OPER & STBY to OPER has a 1.5 second activation delay, so STBY mode will Be less Successfull to activate in time at short range, If heading into close proximity to known anti air its recommended to manualy activate OPER jammers Before doing so." %}

## RWR Icons

{% include important.html content="Currantly in the aircraft there are only three Types of anti air identifiers, In the upcoming MPD update we hope to be able to have a seperate identifier for all Anti-airs from vanilla and the most common community mods like RHS & CUP." %}

| Type | Detected | Tracking | Firing | Description
| :- | :-: | :-: | :-: | :- |
| SA9 | ![](images/tex/icons/9D.png) | ![](images/tex/icons/9T.png) | ![](images/tex/icons/9L.png) | SA9 Are classified as R-750 Cronus, S-750 Rhea, MIM-145 Defender, AN/MPQ-105
| SA19 | ![](images/tex/icons/19D.png) | ![](images/tex/icons/19T.png) | ![](images/tex/icons/19L.png) | SA19 Are classified as IFV-6a Cheetah, ZSU-39 Tigris, CUP 2S6M Tunguska    
| SA23 | ![](images/tex/icons/23D.png) | ![](images/tex/icons/23T.png) | ![](images/tex/icons/23L.png) | SA23 Are classified as RHS & CUP ZSU-23-4