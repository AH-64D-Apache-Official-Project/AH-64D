---
title: MPD System Documentation
tags: [contributing]
sidebar: ah64d_sidebar
permalink: dev-mpds.html
folder: contributing
---

During the CBA compat, I have rewritten how MPDs are run in this aircraft for improvements in performance, reliability, structure and reusability. Before we can have a discussion on what this system does right, we must first discuss the old system and its pitfalls.

# Old MPD system.

What page is currently opened was stored in two variables, `fza_ah64_pr_mpd` and `fza_ah64_pr_mpd` that were global.

Each MPD page had its own script, and was sometimes intermingled with code that managed parts of the aircraft. As an example `page_ase.sqf` historically drew the ASE page, as well as handling other ASE areas, like managing the list of ASE targets and running the jammers when a threat was detected. It would forever check the `fza_ah64_pr_mpd` variable and if it was set to `"ase"`, it would run code to execute the necessary texture animation / draw pages. If it wasn't set it would repeatedly run code to hide every texture related to the MPD page.

There are a few disadvantages to this system:
* MPD page scripts were decentralised, meaning that you would find the code intermingled with other bits of code, along with being in different places across the codebase. This made things harder to debug and read.
* If two pages needed a texture in the same location, it was normally impossible for them to share a named selection as whatever script wasn't in use would be repeatedly clearing it.
* You could potentially have side effects of things working or not depending on if the MPD page is open if logic and display code were mixed up improperly.
* Each apache had many scripts that at times were doing nothing but repeatedly clearing already cleared textures. I don't need to explain why this is wasteful performance-wise.
* Say a texture like a background only had to be set once at the start of an MPD page running and never again, it would still be applied repeatedly with no changes. Again this is just wasteful.

# New system design

Due to this, I built a new structure for implementing MPDs that took inspiration from a few other areas of programming:

* Limitation of state mutation from functional programming
* Class life cycles in programming languages like C++ (Constructors and [Destructors](https://en.cppreference.com/w/cpp/language/destructor) used to manage resources.)

Essentially, MPDs are in a separate area of the codebase to other logic, and are intended to be drawn only by the function `fza_fnc_mpdUpdateDisplays`. Each MPD is made up of 4 sub-functions - an Init, Draw, Destruct and HandleControl.

* The Init function is run **only once** when the MPD is first initialised. It should generally be used to set up things that are not going to be changed once they are set, like aforementioned backgrounds.
> :heavy_exclamation_mark: You do not need to include changing information from a Draw function in this Init, a Draw is always run immediately after a display has been initialised.
* The Draw function is run **throughout** the lifecycle to update the visuals of the displays. This should be where your code to read values from the avionics and display them should be.
* The Destruct function is run **only once** when a certain MPD page is closed. It should put each texture the MPD changes in its Init and Draw back to default values (generally `""`.)
* The HandleControl is run **only once** for each time an MPD button is pressed. It is allowed for only editing

As you can see, this separation out of different parts makes the code easier to read and work with. There are just a few important catches that can cause people to accidentally implement bugs.

* Your Init, Draw and Destruct functions should have no [side-effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science)) other than displaying the MPD. You do not know if / when these will be executed and as such should be careful.
* If your HandleControl is being run, code upstream has already determined that your MPD page is open, you don't need to check if it is.
* Your MPD code should display the MPD on both the CPG and PLT seat, so that if the player switches seats the correct MPD is still up.

## Implementation backend.

It uses two variables to store in each apache what MPDs are open - `"fza_ah64_mpdCurrPage"` and `"fza_ah64_mpdPage"`. The former is used by the system to track which page is currently open in each mpd as an array (e.g. `["flt", "ase"]`, the latter is used to decide if the apache's page should change. If for example `CurrPage` is `["flt", "ase"]` and `Page` is `["flt", "tsd"]` then it knows that it needs to change the right MPD to the TSD page.

It does this by doing the following set of operations:
1. Running the outgoing page's destruct function (`fza_fnc_mpdRASEDestruct`)
2. Running the incoming page's init function (`fza_fnc_mpdRTSDInit`)
2. Running the incoming page's draw function (`fza_fnc_mpdRTSDDraw`)

In those 3 steps, the MPD has been switched from `"ase"` to `"tsd"`.

To handle controls, there is code in `fza_fnc_mpdHandleControl` that checks what MPD is currently open, and runs the HandleControl for that page.

## Adding a new page

You need to modify code in the two following areas:
* Add your MPD's Init, Destruct and Draw to `fza_fnc_mpdUpdateDisplays`.
* Add your MPD's HandleControl to `fza_fnc_mpdHandleControl`

## API

To learn information about the MPDs, the following interfaces are available:

| Function | Description |
| :-- | :-- |
| `fza_fnc_mpdGetCurrentDisplay` | Gets which display is currently open. |
| `fza_fnc_mpdSetDisplay` | Changes the MPD on a given interface. |

There are also some helper functions that are available to simplify the code in your MPD Page's functions:

| Function | Description |
| :-- | :-- |
| `fza_fnc_mpdUpdateMap` | Does the necessary maths and animation to line up the moving map on the TSD. |
| `fza_fnc_updatePoints` | Does the necessary maths and animation to display a point on the TSD map. |
| `fza_fnc_drawNumberSelections` | Does the necessary maths and texturing to display a number on a series of named selections. |

> :information_source: Each of these have documentation in the comment in their file, check there to learn how to use them.