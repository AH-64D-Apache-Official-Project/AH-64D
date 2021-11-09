---
title: Head Tracking Mode
tags: [ui]
sidebar: ah64d_sidebar
permalink: ui-headtracking.html
folder: ui
---

Head tracking mode is a modification to the interface to make it easier to use with peripherals that allow for in-game head movement, like [TrackIR](https://www.naturalpoint.com/trackir/). It can be activated by using the action `Toggle Head Tracking On` in your action menu while inside the helicopter. When selected, it adds a few small quality of life improvements:
## PNVS

PNVS movement is conventionally performed using mouse input. However, in head tracking mode the PNVS is directly linked to the user's head tracker - as it is in the aircraft - meaning that it is no longer affected by mouse input and is smoother to operate while flying.

## Cockpit action free-look

Head Tracking Mode can also optionally unlock the central cursor (<img style="height:1em;margin:0 auto" src="images/tex/center-cursor.png">) so that it can be moved around the screen using the mouse.

If you have moved the crosshair while in head tracking mode, and turn off head tracking mode, the crosshair will stay wherever it was last.

{% capture tip %}if you would like to re-center the crosshair, all you need to do is use the "Look Center" action (by default {%include keybind.html name="look-center"%}.) This works both in and out of head tracking mode.{% endcapture %}
{% include tip.html content=tip %}

If you wish to disable this feature for head tracking mode, then it can be disabled through our settings page.