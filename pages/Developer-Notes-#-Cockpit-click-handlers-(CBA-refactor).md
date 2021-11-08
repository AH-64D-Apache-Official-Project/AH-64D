As part of the CBA refactor, the way that cockpit actions are handled internally was rewritten for performance, modularity and readability.

# Old system.

The old system was handled by a monolith `call_click_this.sqf` function, which essentially worked in the following way:

1. [poll](https://en.wikipedia.org/wiki/Polling_(computer_science)) to check if the user action 20 has been pressed.
2. Find the position of all the cockpit control points.
3. For each position, check if the crosshair is within a certain distance of the point.
    3.5 If it is, perform the related action

This worked well, although polling was slightly inefficient but the main issue was scalability. It was lots of repeated code and by the end of it, the single file was 2k lines long.

# New system

Information about each point is gathered, namely:
* Memory point for the gunner and pilot seats.
* System the control is a part of (used later for sorting out which control handler should handle the action.
* Name of the control in short-form (can be thought of as an ID)
* The range that the crosshair has to be within to press it.
* A long-form description of the button (used for hints)

The new system has broken it up into different functions:

When someone presses the crosshair action button, `fza_fnc_controlHandleCrosshairAction` is run, which in turn runs `fza_fnc_coreGetObjectsLookedAt` to work out what controls are being pressed. It then, using the name of the system that the control is part of, chooses which handler function to execute.

Each part of the aircraft (engines, MPDs, fire safety) then has its own function that handles all controls for that system.