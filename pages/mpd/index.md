---
title: MPDs
tags: [mpd]
sidebar: ah64d_sidebar
permalink: mpd.html
folder: mpd
---

The MPDs, or multi-purpose-displays, are your primary method of interacting with the aircraft's avionics and weapons systems. There are two of them, the left and right side. Around them there are a series of buttons, which can be used to interact with the menus on the screen.

{% capture tip_cpg_seat %}
If you are in the CPG seat and your view of one of the MPDs is obstructed by the ORT, then you can adjust your seating position with {% include keybind.html name="head-left"%} and {% include keybind.html name="head-right"%}. To go back to your original position just press {% include keybind.html name="look-center"%}
{% endcapture %}

{% include tip.html content=tip_cpg_seat %}

## Buttons

Since the buttons are unlabelled, they are hard to describe when explaining what to do. The standard is to describe them using a 2 character code, like T2 or R4. The letter is the side, so either Top, Bottom, Left or Right. The numbering is done either from top to bottom or from left to right depending on the side. We will be using this explanation from here on.

{% include image.html file="mpd/button_layout.png" alt="" caption="Figure 1: MPD Button Layout" %}

## Navigation

There are a few ways to get to each MPD page:

* Some MPDs have a quick-select button in the bottom left (TSD,FCR,WPN.) You can click on these to get access.
* All pages are available on the DMS that is accessible by pressing M button that is to the bottom left of the MPD.
* Some pages have their multi-purpose buttons as links to page, as shown by the presence of a small green arrow and the page name next to the button. You can click the respective button to go to that page<sup>1</sup>


## Main Menu Screen

{% include image.html file="mpd/mpd-main-menu.png" alt="" caption="Figure 2: Main Menu Screen for MPDs" %}

The main menu screen has all the subpages except the DTU and WCA pages. Mission and Aircraft pages can be accessed from here and the sidebar is also split up to reflect that.

The DTU page is accessed from the [DMS](./mpd-dms) page. The WCA page is accessed from the [ENG](./mpd-eng) page and the [DMS](./mpd-dms) page.

Blocked pages are represented with vertical or horizontal thick lines next to their name. These pages are either not simulated or not present in the mod.