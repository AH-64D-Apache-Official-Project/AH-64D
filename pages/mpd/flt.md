---
title: FLT Page
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd-flt.html
folder: mpd
---

{% include image.html file="mpd/flt_numbered.png" alt="Image of the FLT page with all elements numbered" caption="Figure 1: The FLT page" %}


## Introduction

The FLT page displays a large quantity of information from major flight instruments, such as the attitude indicator, altimeter, radar altimeter, heading, trim etc. While a lot of this information is provided in the HDU, it is also available from this page in the event of HDU failure or if the crew loses visual references.

Unlike other MPD pages, the FLT page has a shortcut to quickly open it, which is {% include keybind.html name="symbology-select"%}.

## Info

1. Engine torque.
2. True air speed.
3. Barometric altitude.
4. Radar altitude.
5. Radar altitude (HI & LO). HI shows above 1000ft and LO shows below 20ft.
6. Attitude indicator (pitch and bank)
7. Waypoint status window
8. [Heading tape](#heading-tape)
9. [VSI](#vsi)
10. Skid / Slip indicator.

### VSI

The VSI, or Vertical Situation Indicator, shows more information about both the aircraft's vertical speed and radar altitude, on the left and right respectively. Each side has its own scale.

{% include image.html file="mpd/vsi.png" alt="Labelled image of the VSI" caption="Figure 2: The VSI labelled with its scale." %}

### Heading Tape

The Heading tape shows you the current heading of the aircraft, as well as the bearings of items of interest. Currently, the only two implemented are the Command Heading (the next waypoint) and the FCR Centerline Bearing (moves when the FCR is scanning.)

{% include image.html file="mpd/heading_tape.png" alt="Labelled image of the Heading Tape" caption="Figure 3: The heading tape" %}

## Operations

You cannot perform any tasks through this page, it just provides information from the flight instruments to the pilot. To change a value on the page, change the flight controls appropriately