---
title: PERF Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-perf.html
folder: mpd
---

{% include image.html file="mpd/page_perf.jpg" alt="Image of ASE MPD with no track" caption="Figure 1: The PERF MPD" %}

## Introduction

This page will explain the PERF MPD display for the Apache helicopter. It primarily displays range, torque required for hover, maximum gross weight for flight and true air speed for various stages of flight.

It currently only shows for the current gross weight and weather conditions. The MAX and PLAN sub-pages do not work as of now

## Information
There are 5 main blocks of information displayed starting from the top left and going row by row.

### Hover Q
This page displays the amount of torque required for holding a hover in IGE and OGE. It also displays the go/no-go criteria for being able to enter a hover. The current torque is also shown as indicated.

### Cruise
This displays the required torque (Q) and fuel flow (FF) values for maximum range (RNG) and maximum loiter time (END) for the helicopter. These values will change as the gross weight of the helicopter will change

### Max GWT
This block displays the maximum gross weight of the chopper to maintain a stable flight in IGE and OGE. The first row is for dual engine (DE) and the second row for single engine (SE) operations.

### TAS
This block displays the ideal speed for different flight regimes.
1. VNE: Velocity to never exceed. Maximum speed/velocity for the helicopter, above this and helicopter may break apart from under you.
2. VSSE: Safe speed for single engine operations. Do not exceed this if only running with one engine.
3. RNG: Ideal speed for maximum range depending upon current conditions.
4. END: Ideal speed for loitering over the AOI depending upon current conditions.

### Max Q
This block displays the maximum torque for the helicopter in dual engine (DE) and single engine (SE) usage.

## Other Information
The PERF page also displays more information than just operating conditions for the helicopter.
1. PA : Outside pressure
2. FAT : Free air temperature. The current temperature of the air surrounding the helicopter.
3. GWT : Current gross weight of the helicopter. This takes into account munitions and fuel load.

CG : Displays the location of the center of gravity of the helicopter. Is useful when entering a hover.

## Operations

The page can access FLT, ENG, FUEL and UTIL pages. To access the ENG page, click on the PERF page button.