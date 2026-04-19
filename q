[33mcommit 719475fe303b5ac250f5ae6db2cd23854d17f9ec[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mfeature-canvas-ihadss[m[33m, [m[1;31mupstream/feature-canvas-ihadss[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jan 31 16:19:48 2026 +0000

    Remove redundant parameter changes

[33mcommit 6154722b2f8a34e534b9cc3cc167c1b4ac500c7d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 27 21:18:50 2025 +0100

    Link ihadss canvas to arma

[33mcommit 2f1bd581f710b6f06d76c87da58db706274a58e4[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Wed May 14 09:27:40 2025 -0400

    Update
    
    + Add Bob-up box
    + Add attitude hold indicator
    + Size/Scaling tweaks

[33mcommit b1d1ec776d7565eb14b343e1243d7ae91991896e[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Tue May 13 10:22:35 2025 -0400

    Update
    
    + Update font
    + Add HI altitude alert
    + Add LO altitude alert
    + Add waypoint status window info
    + Add FCR centerlines to HAD
    + Add FCR centerline to heading tape
    + Add alternate sensor bearing
    + Add Flight Path Vector
    + Add transition horizon line
    + Add navigation fly to cue

[33mcommit b7d879e77222be3cfe6d77cdc80dc129f444d463[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Sun May 11 19:27:14 2025 -0400

    Update
    
    + Added VSI text fields
    + Added Owner Cue
    + Added WPN Inhibit
    + Corrected VSI indexer
    + Corrected Altitude hold indication

[33mcommit 384aa3dd05b4f28a6f9833fddd7a520cdffb6088[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Sun May 11 15:55:03 2025 -0400

    Update
    
    + Added Cued LOS
    + Added FOR cued LOS dot
    + Added VSI indexer
    + Added Radar Altimeter Scale
    + Renamed functions for clarity and consistency

[33mcommit ecfafc655dfa68d4fb627d7f598edc0f686ba6ce[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Sun May 11 11:14:09 2025 -0400

    Update
    
    + Add TAS
    + Add Radar Altitude
    + Add Heading Tape
    + Add Velocity Vector
    + Add Cueing Dots
    + Add Acceleration Cue
    + Add HAD Fields
    + Add Pilot Format FOR tick marks
    + Add FOV box

[33mcommit 0a60f58c40d2934f68d1d70da4c478f549873217[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 10 23:17:32 2025 +0100

    Initial canvas structure

[33mcommit 9b84385e100d2b3013fa532fef18abedb6a216bc[m[33m ([m[1;33mtag: [m[1;33mV2.2.3[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 5 13:53:35 2025 -0400

    HeliSim Bug Fixes for v2.2.2 (#753)
    
    * HeliSim Bug Fixes for v2.2.2
    
    + Fix SAS PID error that resulted from improper trimming
    + Add central position trimmer mode to cyclic and pedals
    + Update FMC variable names to enhance debugging
    
    * Update
    
    + Added config entry to prevent value mismatches for central trimmer zone
    
    * Update config.cpp

[33mcommit 8549091a93fb96ec4b738df9d218b01184e9b007[m[33m ([m[1;33mtag: [m[1;33mV2.2.2[m[33m)[m
Merge: d61e5d03f a678aa801
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun May 4 14:04:38 2025 +0100

    Merge pull request #751 from Ollieollieolllie/Addon-options-Server-lock-prevention
    
    prevent server locking client addon option settings

[33mcommit a678aa8016c52832c8b538236202e2c527f240c7[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Addon-options-Server-lock-prevention[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun May 4 14:03:59 2025 +0100

    prevent server locking client addon option settings

[33mcommit d61e5d03f05d6c45c8259bc4edcc2eb989aa7287[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun May 4 08:50:19 2025 -0400

    Alternate M&KB Control (#749)
    
    * Alternate M&KB Control
    + Re-added collective auto switching: Regardless of input mode (HOTAS/MNKB) the collective will now respond to either keyboard or analog input and auto switch accordinly.
    + Fixed indestructible rotor bug
    + rename fza_ah64_sfmplusKeyboardOnly
    + Simplified collectiveInput handling
    + Attempt to fix throttle/keyboard jumping
    + Fix cyclic input to read -1 to 1
    + Add addon options for sticky pitch, roll, yaw
    + Revert collective check
    + Remove systemChat
    + Remove control scheme
    + Add collective input selection
    + Remove all references to controlScheme
    + Remove un used code
    + Ensure sticky pitch/roll/yaw aren't effected by force trim
    + Updated addon option descriptions
    + Update force trim switch description
    + Re-add Auto Pedals (will not work if Auto Pedals and Sticky Yaw are selected at the same time)
    + Added sticky input interrupt
    + Modified sticky inputs to allow full authority when modifier is held down, sticky input will return to its previous position
    + Remove stickyYaw from Auto Pedal
    + Fix collective output so that it stays stable
    + Tune auto pedal sideslip PID
    + Hide system chat
    + Hide systemChat
    + Reduce sticky control sensitivity
    + Adjust autopedal breakout sensitivity
    + Revert sticky control direct input sensitivity
    * Update Mod version
    
    ---------
    
    Co-authored-by: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>

[33mcommit 4e03429536fb599680c17c83ef49e92cc4d5e31a[m
Merge: 8a03bfbcd 236e3dd5d
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 3 22:26:08 2025 +0100

    Merge pull request #748 from Ollieollieolllie/Flight-Tone-Audio-overlap
    
    Flight tone Audio overlap

[33mcommit 236e3dd5dddb19166c2ca3d22ea19aff489a782c[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Flight-Tone-Audio-overlap[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri May 2 21:23:34 2025 +0100

    Flight tone Audio overlap

[33mcommit 8a03bfbcd1a1a6c4f561f39749bcddf3b3a40a0a[m[33m ([m[1;33mtag: [m[1;33mV2.2-RC6[m[33m, [m[1;32mUpdate-Keyboard[m[33m, [m[1;32mAlternative-M&KB-Control[m[33m, [m[1;32mAlternate-M&KB-Control[m[33m)[m
Merge: 177c4b342 c4314c93a
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 19 14:34:30 2025 +0100

    Merge pull request #744 from Ollieollieolllie/MWS-Bug
    
    MWS audio stacking

[33mcommit 177c4b34265f891b7a06b21fd29cf43b20cd8868[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Apr 19 09:34:07 2025 -0400

    Update (#745)
    
    + Add locality check to prevent opposite player from enabling/disabling hold modes

[33mcommit c4314c93a8ebc3a95ac06ff99349d82803279d79[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 19 13:50:57 2025 +0100

    incorrect logging

[33mcommit e7d440b78ab735c7179f28f1dfb8d2225edd625f[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Apr 19 08:35:39 2025 -0400

    Symbology Fixes (#743)
    
    + Remove Fixed Rocket Symbology
    + Remove Laser Code from TADS HAD

[33mcommit 9617302516427b8ba0edc77eff3d0a91791a5219[m
Merge: e8b1f0ace 99239f73d
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 19 13:35:07 2025 +0100

    Merge pull request #742 from Ollieollieolllie/MWS-Bug
    
    Order of operation bug

[33mcommit 99239f73d3b3e26779ec2bd4de407ba1882aa821[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 19 13:09:08 2025 +0100

    Order of operation bug

[33mcommit e8b1f0ace65c71b17a31458db6ac58bfda98826d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri Apr 18 14:42:28 2025 -0400

    HeliSim Tail Rotor and KB Update (#739)
    
    + Add tail rotor blade pitch induced thrust table
    + Move time check to coreUpdate
    + Update rtrRPMInducedThrustScalar calculation
    + Update tail rotor moment calculation
    + Update tail rotor force calcluation
    * Tail Rotor Tuning
    + Added interpInput to ensure the outptu of the flight controls can always reach -1 or 1
    + Updated tail rotor thrust calculations
    + Re-tuned pid's for HOTAS and Keyboard
    + Added keyboard attitude hold disengage keybind
    + Disengage attitude hold when keyboard disengage key is pressed
    + Reduced tail rotor table complexity
    + Connected keyboard attitude disengage to UFD and audio system
    + Add freelock toggle to addon options
    
    * Update
    
    + Remove system chats
    
    * Update
    
    * Update fn_coreConfig.sqf
    
    * Update
    
    + Adjusted pitch time to 0.3
    + Tuned sideslip pid

[33mcommit 5e239e116a3529bdeb7fbb7b9ef97ac8d5db8690[m
Merge: 473fc56bd 3d7105bf0
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Apr 18 18:26:44 2025 +0100

    Merge pull request #740 from Ollieollieolllie/MWS-Bug
    
    ASE MWS bug

[33mcommit 3d7105bf0aa0fffce94d46ce0bc14d31b4dd0cb8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 17 19:41:33 2025 +0100

    Fix self report

[33mcommit 473fc56bdc98d30de02625e69d51de1b2db13ff4[m
Merge: 9e10e72f9 33922c1c0
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 10 21:55:07 2025 +0100

    Merge pull request #738 from Ollieollieolllie/DMS-Database-Fix
    
    DMS Database Fix

[33mcommit 33922c1c054b8884978fc7c6a365de26f4b9c566[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/DMS-Database-Fix[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 9 19:29:37 2025 +0100

    DMS Database Fix

[33mcommit 9e10e72f950e697f56a0431b44258c52185114bc[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Apr 9 15:50:54 2025 -0400

    HeliSim Tuning (#732)
    
    * HeliSim Tuning
    
    + Removed isPaused from coreUpdate
    + Reverted input update (aircraft would hop on return from pause)
    + Fixed SAS so that it will function when holds are active
    + Re-added fuselage yaw torque
    + Adjusted fuselage torque tables
    + Changed fuselage yaw torque base value from 2500 to 10000
    + Fixed input bug to ensure HOTAS inputs return a value from -1 to 1 instead of -0.5 to 0.5
    
    * Update
    
    + Removed isGameFocused check from coreUpdate to prevent the simulation from stopping when tabbed out
    + Added locality checks for getInput and forceTrimSet to fix MP altitude hold bug
    
    * Update
    
    + Add coreFixedUpdate
    + Moved force generators to coreFixedUpdate
    + FMC outputs changed to setVariables
    + Modified simpleRotorMain and simpleRotorTail to use new FMC outputs
    + Moved sfmplus_coreUpdate to fza_ah64_eachFrameArray
    + Changed the name of sfmplus_coreUpdate in coreFixedUpdateScheduler to sfmplus_coreFixedUpdate
    + Added FMC variables to sfmplus_coreConfig
    + Fixed MP collective bug
    
    * Update
    
    + Added altHoldCollOut to induced_val
    + Fixed smooth average array name
    + Apply smooth average to angular velocities
    
    * Update
    
    + Expanded heading hold break out values
    + Added tail rotor pitch table
    + Added naca 4418 airfoil to config
    + Seperated enviornment from fixedUpdate
    + Fixed wind calculation
    + Added addon options for wind direction, speed and gust speed
    + Modified torque to account for tail rotor movement
    + Fixed incorrect variable assignment for vel2d and vel3d (they were flipped)
    + Adjusted acceleration cue to be less sensitive and thus more useful
    + Fixed breakout value bug that caused an aggressive jolt to the right when right pedal was applied
    + Adjusted fuselage drag tables and base torques
    
    * Update
    
    + Tweaked main and tail rotors to incorporate head/tailwinds
    + Moved fza_sfmplus_velWind to coreConfig
    
    * Tail Rotor Bug Fix
    
    + Removed wind effects from tail rotor as it caused the aircraft to go uncontrollable
    + WIP velocityThrustExponent table added
    
    * Update
    
    + Reverted experimental velocityThrustExpTable
    + Adjusted velocityThrustExponent to 0.386
    + Adjust tailRtrScalar table for new tail rotor thrust min/max values
    + Adjusted tail rotor thrust min/max values
    + Adjusted main rotor cruiseTqTable
    +
    
    * Update
    
    + Removed wind enabled option since winds can now be set in Addon Options
    + Removed systemChat
    
    * Update
    
    + Tuned climb torque table values
    + Changed climbThrust formula to use baseThrust instead of rtrThrust for more predictable results
    + Changed totThrust to make more predictable
    
    * Update fn_simpleRotorMain.sqf
    
    * Finalize RoC table
    
    + Finished the RoC table
    
    * Update
    
    + Adjusted sideslip 0 point from 3 degrees to 0 degrees
    + Re-added angular velocity to the wing and stabilator
    + Tuned turn coordination PID
    + Corrected aero values velocity source to include winds
    
    * Tuning
    
    + Tuned turn coord PID for stability
    
    * Tuning
    
    + Added torque limiter to pitch and roll
    
    * Update
    
    + Updated sticky cyclic to use the force trim button, recommend mapping to L CTRL key.
    + Sticky cyclic now allows the user to set both pitch and roll
    + Udpated tail rotor table
    + Changed logic for hold modes when using mouse and keyboard, heading hold is now always active, even on the ground
    + Set default sensitivity for mouse senitivity to 1. This will ensure there's no effect on the keyboard input.
    + Added worldVelocityNowind
    + Added velWindWorldSpace
    + Added velWindModelSpace
    + Adjusted fuselage sideslip table
    
    * Add Auto Pedals
    
    + Adds auto pedals for mouse and keyboard
    
    * Update
    
    + Remove system chat
    + Comment out PID tuning globals
    + Fix spelling error
    
    * Update
    
    + Spelling and logic fixes
    
    * Update
    
    + Added auto cyclic
    + Disabled ALL fmc functions when control scheme = mouse & keyboard
    + Added logic to WCA att hold so it displays when in mouse & keyboard
    
    * Update
    
    + Revert collective code
    + Add sticky roll
    
    * Udpate
    
    * Update
    
    * Update
    
    * Update
    
    + Re-added altitude hold
    
    * Update
    
    + Re-add position hold
    
    * Update
    
    + Tuned keyboard velocity hold
    
    * Update
    
    + Reconnected ARMA winds
    
    * Update
    
    + Hide systemChat

[33mcommit 4188cb50e50aca90c5a7057a7412a8abba9421e1[m
Merge: b8e337d21 bb34f6793
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 9 19:13:00 2025 +0100

    Merge pull request #735 from Ollieollieolllie/TSD-EDIT-IDENT
    
    TSD EDIT IDENT

[33mcommit bb34f67933f2d57238c7b71565ddfb97897a963d[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/TSD-EDIT-IDENT[m[33m, [m[1;32mpr/735[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 9 19:06:24 2025 +0100

    Review changes

[33mcommit b8e337d21210d3a2f35787a009cb994960465c21[m
Merge: c2787eaa5 c612a5e75
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 9 17:21:43 2025 +0100

    Merge pull request #736 from Ollieollieolllie/Engine-AutoPage

[33mcommit c2787eaa5b95e4be6021bdfd694e8729c73ecefc[m
Merge: cc356f38c 6ab70b275
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 9 17:21:15 2025 +0100

    Merge pull request #737 from Ollieollieolllie/Fire-Panel-Audio-Looping-Bug

[33mcommit 6ab70b275e9fe9c941d0a03470d24bfa5e8469b0[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Fire-Panel-Audio-Looping-Bug[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Apr 8 20:14:14 2025 +0100

    Fire panel Audio Stacking Issuie

[33mcommit c612a5e75d2587e63a3b6d255c75507af58868e9[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Engine-AutoPage[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Apr 8 19:56:31 2025 +0100

    Engine AutoPage

[33mcommit 3801cb84d5c90a767fb2f90e0cab85a29730d37b[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 7 21:28:35 2025 +0100

    EDIT IDENT LIVE

[33mcommit cc356f38cd7dab230ea5d44231149cd5d008483d[m
Merge: 74020d754 331867fd2
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 7 21:01:12 2025 +0100

    Merge pull request #734 from Ollieollieolllie/ABR-PAGE-TEXT
    
    ABR Page Text

[33mcommit dcf07b96ef6f53b627acca6b9bd21177cfc908d7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 7 20:52:17 2025 +0100

    TSD EDIT IDENT

[33mcommit 331867fd2b38310ac7ace81e05cb537d8908e1b2[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/ABR-PAGE-TEXT[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Apr 6 22:12:13 2025 +0100

    Fix Abr page text

[33mcommit 74020d75407a9efcd12d4c961990afecb1f8dfdd[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Mar 29 12:30:22 2025 -0400

    Input Fixes (#730)
    
    + Adds a check to see if the player is tabbed out of the game or not
    + Simplifies collective input handling

[33mcommit 9af037252d4c29877e37f941c1386f601bcf66f8[m
Merge: 4cdc64366 806a858d5
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 29 16:29:02 2025 +0000

    Merge pull request #729 from Ollieollieolllie/Rocket-Steering-cursor-Fix
    
    Fix Rocket steering cursor in MP

[33mcommit 806a858d5f3402a58c0b9eb94dd591b3b225dc39[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Rocket-Steering-cursor-Fix[m[33m, [m[1;32mpr/729[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 29 15:35:32 2025 +0000

    Update fn_steeringCursorDraw.sqf

[33mcommit 149a47ab01ed44fcc5e4b2f1ca9e46f51efd936c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 29 14:39:32 2025 +0000

    Update fn_weaponTurretAim.sqf

[33mcommit 4cdc6436615d363f64de09358b1828d6446a8471[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Mar 29 09:08:46 2025 -0400

    HeliSim Input Adjustments (#727)
    
    + Add Springless Cyclic Option
    + Add Springless Pedal Option
    + Remove Disable Heading Hold Option
    + Add onGround check to VRS shake effect

[33mcommit 77e36492a7f7d4ceadf5350f19186569701feb55[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Mar 24 10:48:22 2025 -0400

    Update VRS Model and Add VRS Warning (#726)
    
    * Update VRS Model and Add VRS Warning
    
    + Update VRS Model to make it more dynamic
    + Add VRS Warning Addon Option
    + Change text output and color

[33mcommit c80e71a419e7bbfa33f46aa6fc6b2571f119122d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Mar 23 19:02:08 2025 -0400

    Rotor Model Update (#725)
    
    + Rotor performance tuned from 0 to 8000ft PA

[33mcommit a63f9db2b5232f4b43610e7d804b8d9542eef236[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Mar 23 14:21:15 2025 -0400

    HeliSim M&K Fix (#724)
    
    * HeliSim M&K Fix
    + Adds sticky cyclic (pitch only)
    + Updates Rotor Model (previous implementation doubled the thrust, however this restricts the FM to Sea Level and Standard day at the moment)
    + Fix stabilator schedule (result of collective range being fixed)
    + Fixes collective input range (due to Updated Rotor Model)
    + Fixes fuselage drag (uses fuselage AoA and updated fuselage torque table)
    + Enables force trim for mouse users
    + Updated autorotation behavior (result of updated rotor model)
    + Fixes power off auto behavior
    + Re-adds angular velocity to wing & stabilator code
    + Adds sticky roll to keyboard cyclic
    + Remove systemChats
    + Adds Addon option to toggle keyboard pitch trim on/off
    + Remove angular velocity from wings and stabilator
    + Correct incorrect _autoNp value

[33mcommit 6b4ce6ae0be334b47104f392780476585c63bac3[m[33m ([m[1;33mtag: [m[1;33mv2.2-rc5[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri Mar 21 07:21:29 2025 -0400

    FM Tuning and Bug Fixes (#723)
    
    * FM Tuning and Bug Fixes
    
    Fixes incorrect tail rotor blade pitch calculation, fixes stabilator (wasn't scheduling before), replaces CL/CD formula with lookup table values, fixes incorrect velocities
    
    * Update fn_aeroStabilator.sqf

[33mcommit e134709dab4f21a67f42814ddcaa197dbc02e7f6[m[33m ([m[1;33mtag: [m[1;33mv2.2-rc4[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Mar 16 12:35:49 2025 -0400

    Update Velocities and General Bug Fixes (#722)

[33mcommit 23a31b8c09f6502b2cb53df31de95ca7b6c794b6[m
Merge: b0f79641d 7c6a15c60
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Mar 16 16:25:46 2025 +0000

    Merge pull request #721 from Ollieollieolllie/Change-Default-Addon-Value

[33mcommit 7c6a15c60e696a731b3296e9163b0bf870d5d1ae[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Change-Default-Addon-Value[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Mar 16 12:20:19 2025 +0000

    Update XEH_preInit.sqf

[33mcommit b0f79641df423a23aac29043fc0531ffc4efb7a8[m
Merge: 8487e1613 852024529
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 15 21:22:00 2025 +0000

    Merge pull request #719 from Ollieollieolllie/Error-Fixes
    
    Hot fix PP effects

[33mcommit 852024529a43fce94f186aa1cc1401bdfd55a81d[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Error-Fixes[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 15 21:20:07 2025 +0000

    Update fn_draw.sqf

[33mcommit 8d575957ff7cf15334c638765252dfd445cf8df7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 15 20:19:44 2025 +0000

    Update fn_controller.sqf

[33mcommit 8487e1613cf52789d432bfed6fed192227bb24c6[m
Merge: ce11b4cb4 94d28f25b
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 15 18:02:47 2025 +0000

    Merge pull request #718 from Ollieollieolllie/Error-Fixes
    
    Error Fixes

[33mcommit 94d28f25bdac510d8348027a87ac86a1c14042e7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 15 17:59:39 2025 +0000

    error fixes

[33mcommit ce11b4cb47f1412ce564b1a0afb70a144017a8d8[m
Merge: 3175fe46e 3f341702d
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Mar 12 23:58:58 2025 +0000

    Merge pull request #717 from Ollieollieolllie/ADD-Thermal-Resolution

[33mcommit 3f341702deafe5fe894bdafbdd7bb159770bc8af[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/ADD-Thermal-Resolution[m[33m, [m[1;32mpr/716[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Mar 12 20:45:56 2025 +0000

    DVO & DTV PPEffects

[33mcommit 3175fe46e343ae397ac128ab02a3cf98879a2a3c[m[33m ([m[1;31morigin/Optics-Update[m[33m, [m[1;32mOptics-Update[m[33m)[m
Merge: 3032278ea 31e568a04
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Mar 10 20:50:23 2025 +0000

    Merge pull request #716 from Ollieollieolllie/ADD-Thermal-Resolution
    
    Add Thermal Resolution

[33mcommit 31e568a042a1a11d02412500ef1e412fc4edbbb9[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Mar 10 20:49:04 2025 +0000

    pr review changes

[33mcommit d4477e648a8c4b8d0e0dd171b66b522e073eb0f5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Mar 10 20:44:21 2025 +0000

    Added Circular sight

[33mcommit 0304e953d8c18b5a97d2b41f53c75b98b01eb6c4[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Mar 10 19:37:16 2025 +0000

    Update A3TI resolution

[33mcommit 90ea47b645a544a496ed5fbcd2bbc2f81cf37d1b[m
Author: BradMick <brad_mick_artist@yahoo.com>
Date:   Mon Mar 10 09:40:18 2025 -0400

    Update turrets.hpp

[33mcommit 318f8f9764bcc4339d43d72b90496bbb8fc3be4d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Mar 7 21:44:11 2025 +0000

    FLIR BLUR

[33mcommit 0563cb5123c29667e70cc6291fcfce2cbfadf8f0[m
Merge: 41b4a5911 3032278ea
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Mar 5 18:45:30 2025 +0000

    Merge branch 'master' into ADD-Thermal-Resolution

[33mcommit 3032278ea1258b8adf4429dd62200db90550eb58[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Mar 5 18:43:52 2025 +0000

    Add DVO Optics (#715)

[33mcommit 41b4a5911086c1e89898bb462e16217b96515616[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Mar 5 18:43:26 2025 +0000

    Add Thermal Resolution

[33mcommit 8d6f46bd566a29d0ec101ee07cf3b495a77afa09[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Mar 2 20:35:01 2025 +0000

    Corrected FLT Page Data input (#713)

[33mcommit 20faf2be439ea0584c069fc000be88a976c1e294[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Mar 2 12:22:39 2025 -0500

    HeliSim Fixes (#712)
    
    * HeliSim Bug Fixes
    
    * Update
    
    * Update fn_simpleRotorMain.sqf
    
    * Update
    
    * Update fn_eventGetIn.sqf

[33mcommit 4d248eb5021fe7703268d54c08f29540c2ddb47f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Feb 18 23:22:48 2025 +0000

    ASE - Bug fixes (#711)

[33mcommit a3ecc34ee29fb1bd99e60a862f1c329e9ae59e5e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Feb 17 12:58:33 2025 -0500

    Heli sim bug fixes (#709)
    
    * Fix velocity hold sign error
    
    * HeliSim Bug Fixes
    
    Fixes altitude source errors, doubles time required to get to full collective

[33mcommit f563d2fdcd22a89caf43a32cb99bdfa5aae49fb8[m[33m ([m[1;33mtag: [m[1;33mv2.2-rc3[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 14 12:09:38 2025 +0000

    Correct Weapon Select Syntax (#706)

[33mcommit 588ba9ecdd4d32ce5dc0484f3dafda94cfcc299d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Feb 10 14:03:53 2025 -0500

    Fix velocity hold sign error (#707)

[33mcommit a6569cb8f341d8a89d43fa0be63b430e5cebd98b[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Feb 9 18:25:58 2025 +0000

    Fix ARH Seeker Lag from Redundant Target Search (#697)

[33mcommit daa51994047098a6942d78f39803c0be95299e86[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Feb 9 13:16:49 2025 -0500

    Add fixedUpdateScheduler (#693)
    
    * Add fixedUpdateScheduler
    
    * Update fn_getDeltaTime.sqf
    
    * Update

[33mcommit a845aa8d6705521b16cdbf484ad174c50991b849[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Feb 9 16:47:12 2025 +0000

    Remove AI Engine Start (#705)
    
    Not Needed Anymore, and it messes some things up

[33mcommit 5dae89a7bd3e6e649abae023b2c0b52c384dde70[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Feb 9 15:56:28 2025 +0000

    Lock Arma Engine When not used (#704)

[33mcommit 41404ffc98f69966b96539d6364b6f66b8a12715[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Feb 9 10:51:56 2025 -0500

    Fix autorotation behavior (#702)
    
    * Fix Autorotation Behavior
    
    * Update fn_engineController.sqf

[33mcommit 8a85e4b21a290105242f4789c4f1d5e8de8d8fab[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Feb 9 15:46:09 2025 +0000

    ASE TEXT CHANGE: "PROGRAM" -> "MANUAL" (#703)

[33mcommit f9422534e69e6740ac4ec51feefc1838f7e72513[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Feb 8 10:43:39 2025 +0000

    Keyboard Unit Change input logic (#700)

[33mcommit 4fe9487d54d24dfb8730281f66a7626b712e8106[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 7 00:01:08 2025 +0000

    Persist State Mishandle (#699)

[33mcommit 67253d24018470a24d36bc306d28e01ac3dcfdb8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 7 00:00:49 2025 +0000

    Ace Map lighting logic (#696)

[33mcommit 12a8009307dd2ea54f64dd72fe485bf9274082f6[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 7 00:00:36 2025 +0000

    Correct Anti-Collision logic (#695)

[33mcommit 141243248ea34da1e29d91c7804ab3844eaac9fc[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Jan 30 18:32:34 2025 +0000

    Bug fix Related To MPD Texture (#692)

[33mcommit 097d4d0425bc7eb03e6c10271de1207be3165588[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jan 20 13:57:09 2025 -0500

    Improve Climb and Auto Performance (#690)
    
    * Improve Climb and Auto Performance
    
    * Update fn_engine.sqf
    
    * Update fn_engine.sqf
    
    * Update fn_engine.sqf

[33mcommit d429a6a03068475fb0a433ea39879d0a13b0f48c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jan 20 17:01:24 2025 +0000

    RTE point init error

[33mcommit 0e314b5594c539cf3491acf05daceb6bc396548f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 19 13:24:13 2025 +0000

    Revert "Update Input Handler (#686)" (#689)
    
    This reverts commit da791682559ea4fe4ce18b4899fe34cc694a295d.

[33mcommit ea5a24030149e06a717cf47e3bc0ee258940288c[m[33m ([m[1;33mtag: [m[1;33mv2.2-rc2[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jan 15 10:07:45 2025 +0000

    Fix Full Cockpit Binding menu (#688)

[33mcommit 3293616a21c53e19a092a76589eea54797b94637[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jan 10 19:31:58 2025 +0000

    IHADSS Tads Alt Sensor Dir (#687)

[33mcommit da791682559ea4fe4ce18b4899fe34cc694a295d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jan 8 19:37:51 2025 -0500

    Update Input Handler (#686)
    
    Changes the cyclic input from animation source to inputActions

[33mcommit e1ecba7fe42f58d346537a845b819ed58faf37a1[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jan 8 17:37:14 2025 +0000

    TSD Fcr foot print conditions (#685)

[33mcommit a418423d1287f06c4b64785974799bc9afe3c662[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 19:09:50 2025 +0000

    Weapon fixes (#682)

[33mcommit 1023bbbc68d71fe7d4ae0f483acc7aeb97570d0b[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 17:24:41 2025 +0000

    Cscope NTS & ANTS Bug (#681)

[33mcommit e98dddd8852fd69f10eddd61a6aa96e48d21b103[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 17:24:13 2025 +0000

    FCR changes (#680)

[33mcommit 7b4392ad91c6c9be34fea6f29476d034a79ac46e[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 5 16:47:33 2025 +0000

    Propagate TADS direction with a variable (#679)
    
    Co-authored-by: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>

[33mcommit b550f451d009f0d5a5e6de293f42e0d7e7d217c4[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 16:23:50 2025 +0000

    Tads Animation Control (#677)

[33mcommit 648e5e23c0e74826a024d6d8251a426d9729e1d8[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 5 11:22:08 2025 -0500

    Fix _deltaTime (#678)

[33mcommit e5392b1edc643f06cdb76b919018242426b01035[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 5 09:36:43 2025 -0500

    MP Synchronization Fix (#673)
    
    * Fix Collective in MP
    
    * Update
    
    * Update fn_fmcForceTrimSet.sqf
    
    * Update fn_fmcForceTrimSet.sqf
    
    * Update fn_getInput.sqf
    
    * Update fn_fmcForceTrimSet.sqf
    
    * Update fn_fmcForceTrimSet.sqf
    
    * Update
    
    * Update
    
    * Update fn_fmcForceTrimSet.sqf
    
    * Update fn_fmcAttitudeHold.sqf
    
    * Replace global deltaTime
    
    * Update
    
    * Update
    
    * Update
    
    * Update fn_simpleRotorTail.sqf
    
    * Update fn_fuelUpdate.sqf
    
    * Update
    
    * Update
    
    * Update fn_setArrayVariable.sqf
    
    * Update
    
    * Update fn_fuelUpdate.sqf
    
    * Update
    
    * Fixes

[33mcommit 5fcf26f4109bff5792545f67645b5e8f1749b1b0[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 14:31:31 2025 +0000

    Change Default Loatout (#675)

[33mcommit 0dce1ad053da78d6634ac79c368fb5b5f0dd0417[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 5 14:10:57 2025 +0000

    BUGFIX FCR Config Enabled Sync (#674)

[33mcommit 6becd37631b6211f65995e97f8f2ad1d419b1007[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 16:12:46 2025 -0500

    CG Locality Fix (#672)

[33mcommit 552ef07c98e83df145cae0ccfc1916d4d7a4ba9c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 15:51:11 2025 -0500

    Fix Velocity Errors (#671)

[33mcommit 8f75e3ff86e217de469c0f66a7f69002845fe3c3[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 14:01:43 2025 -0500

    Fix Gamma isNAN error (#670)
    
    * Fix Gamma isNAN error
    
    * Update

[33mcommit bccc245b9696f220686f810f14776eeeee6ad086[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 13:57:17 2025 -0500

    Accel-Cue-Bug-Fix (#669)

[33mcommit 5a59ffb3634d46f8e66c255899c38f9b01f26701[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 4 18:56:42 2025 +0000

    Cscope Error (#668)

[33mcommit a239a5f3092253e0942e39bd84d85455ed1b80da[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 4 18:56:06 2025 +0000

    BUGFIX FCR (#667)

[33mcommit 8a3855aae1b7da711b7ae3ecb195724aec30ba87[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 4 18:55:56 2025 +0000

    BugFix APR Advisory (#666)

[33mcommit 24320d3b628ee6f9b82566e5ca1244dcdb9cc14d[m[33m ([m[1;33mtag: [m[1;33mv2.2-rc1[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jan 4 16:45:00 2025 +0000

    reset show popup setting

[33mcommit 3fa62c52aad44fbdc26b24f6557e82bc6ce4431c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jan 4 16:41:53 2025 +0000

    Rewrite intro page for v2.2

[33mcommit 730b9cbe5584207f36fa81eec550269b4e5f5a48[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 11:11:04 2025 -0500

    Drag Update (#659)

[33mcommit f88013fb0a83b31e3c5f0ee50e2fc0a29dbcd83a[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 11:07:21 2025 -0500

    FMC SCAS Update (#658)
    
    Fixes bug that allowed hold modes to operate with the FMC off.

[33mcommit 0d17999b7db06a1e2197df117a5e02b499aa73a2[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 11:01:56 2025 -0500

    Airspeed source update (#657)
    
    * Update Acceleration Cue Logic
    
    * Airspeed Source Update
    
    * Update fn_aeroWing.sqf

[33mcommit 396bee623d02e67804f447924be9e5490f5dda8d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 10:53:42 2025 -0500

    Correctly configure acceleration cue for different IHADSS modes (#656)
    
    * Update Acceleration Cue Logic
    
    * Update fn_draw.sqf
    
    * Update fn_draw.sqf

[33mcommit 70ad7d6c16e94340979e6b21d680dd2b38388f0e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 4 15:50:54 2025 +0000

    FCR Rework (#537)

[33mcommit d7dbf8eaedce8d858c76b6c6d581ed6f5dea5c25[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 4 10:46:51 2025 -0500

    Smooth deltaTime using a moving average (#655)
    
    * Update Delta Time
    
    * Update fn_getSmoothAverage.sqf

[33mcommit 17e93ab77c3765698af8c4ad33a977d1c729da8d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jan 3 17:21:40 2025 +0000

    Remove WCA Duplicate (#663)

[33mcommit 5dc8b4f6d6a433ebd073ed1194c6759634b76c1d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Dec 31 16:09:27 2024 +0000

    Pnvs fov tuning (#661)

[33mcommit 16e47913f520adeed6541a723acf4ddd008997ca[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Dec 29 07:42:26 2024 -0500

    Update fn_coreConfig.sqf (#653)
    
    * Update fn_coreConfig.sqf
    
    * Update fn_coreConfig.sqf

[33mcommit b464db12f214f9d53f04f057c7189df26ccdd00a[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Dec 29 07:42:14 2024 -0500

    Hide Acceleration Cue in TADS (#654)

[33mcommit 0ec7fbf3f0f921738bb32d1025c05aa03dd0413a[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 29 12:22:34 2024 +0000

    Remove Weapon UI (#652)

[33mcommit 7332d64d2263c79e445e7cbf6383a548bd05551b[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Dec 28 16:48:44 2024 -0500

    Add Acceleration Cue (#649)

[33mcommit 9a4f015766ae782bd70dc86141f2c5c54e26612e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Dec 28 16:46:34 2024 -0500

    PNVS Bug Fix (#651)

[33mcommit 452c285ead45cb4344a62e00f68ad98a34f16d61[m[33m ([m[1;32mPNVS-Bug-Fix[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Dec 28 21:35:29 2024 +0000

    Cscope NTS & ANTS (#648)

[33mcommit 603cc2a69e5a3c00bc19390b93d5db0d3257b798[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Dec 28 16:34:53 2024 -0500

    PNVS Elevation Corrections (#650)
    
    Fixes incorrect elevation in the PNVS turret

[33mcommit 86c2c42d4a27823833781d1d42296d77a281e284[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Dec 28 18:21:41 2024 +0000

    BUG FIX MP Wca (#647)

[33mcommit 9d6c922407db52f61b7a5f249aaf81bbbf6c67db[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 26 21:27:51 2024 -0500

    Remove Unused SFMPlus Code (#646)

[33mcommit 5d66f2a965f629ae000998f35a581cbedca9a624[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 26 19:00:34 2024 -0500

    Velocity Corrections (#645)
    
    * Velocity Corrections
    
    Fixes ground speed and vel2D
    
    * Fix Stabilator Error

[33mcommit 7e0b729ec17fa55acf5148dfcc46458aa5a53e62[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 26 17:19:15 2024 -0500

    HeliSim Custom DeltaTime (#641)
    
    * HeliSim Custom DeltaTime
    
    * Update fn_getDeltaTime.sqf
    
    * Update fn_getDeltaTime.sqf
    
    * Update fn_getDeltaTime.sqf
    
    * Bug fixes

[33mcommit 20b85a65246760d90c105ee6a4d8439e0208b3e5[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 26 16:31:27 2024 -0500

    Fix Keyboard Input & Remove Unncessary Input Checks (#643)
    
    * Fix Keyboard Input & Remove Unncessary Input Checks
    
    * Update
    
    * Update fn_getInput.sqf

[33mcommit 3507147864ebb90baee1d9387ca2eb073f74ad48[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Dec 24 19:58:10 2024 +0000

    Invisible Hellfire Bugs (#635)

[33mcommit 068bf77a7bd93d714dfeaabed54264626a703db8[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Dec 24 14:56:26 2024 -0500

    Hover Torque Corrections (#634)

[33mcommit af1f41fffc9a331f79996b81b001d065747410d9[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Dec 24 19:28:36 2024 +0000

    Radar hellfire update (#575)

[33mcommit 29ea25aec8561d45956d6fd5f59f67071ed00254[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 20:40:02 2024 +0000

    Move Probe function definition (#632)

[33mcommit ac7e5fd99db49f1be5410870e34ece73df155647[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 20:39:51 2024 +0000

    AH-64D Development Team Author Name (#633)

[33mcommit 760850cfdd1b95dc37437738799f2032aed40753[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 18:51:53 2024 +0000

    Config Base class Cleanup (#625)

[33mcommit 537bbbeebd58b3781433d1432905e178c4772d9e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 13:14:16 2024 +0000

    Ace Map Lighting bugfix

[33mcommit 6cbeb012eff4d0fbfcc89b4411db156a28bfbe47[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 13:14:16 2024 +0000

    Ace Map Lighting bugfix

[33mcommit 3af04894cb3c27e98fa8cbb13f127a44fd2890ae[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 17:54:06 2024 +0000

    Move Probe Function

[33mcommit 5b4e959d54736322f53a233d35721880276e4372[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 18:10:55 2024 +0000

    RTD RPT Error

[33mcommit 4e6bb4358620994b086bb5131d8ea43448fa9038[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 17:28:41 2024 +0000

    FCR Acquisition source error

[33mcommit b837aa8e064f129bf5f6bae5304061f398d4da23[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 15:47:40 2024 +0000

    Geo Lod Errors

[33mcommit 703602b7e8a1e712f08fd1fcd048cdbd0ff2fe15[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri Dec 20 12:48:29 2024 -0500

    Update Sideslip Calculations (#629)

[33mcommit 0a92bb4203bcde639d8cb5a0105924b0ae196b3a[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 20 17:46:28 2024 +0000

    Probe model adjustment (#617)

[33mcommit 68c9463e084977b0f97a412b0a4fb4d97617b9a0[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Dec 16 20:33:17 2024 -0500

    HeliSim Initilization Fix (#627)

[33mcommit a1d10f8b8130e749b509f3e7ebdbe9cb3d77f9a1[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Dec 15 22:28:29 2024 +0000

    Ensure parent directory exists when generating documentation

[33mcommit 700004dbced3d0f8e862e89f6e40a6ecbe0c0f70[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Dec 15 22:19:52 2024 +0000

    Fix RPT error due to invalid definition of side TWest (#622)

[33mcommit d06df0859133667bb4c16e9c52e860472b375d60[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Dec 15 22:19:43 2024 +0000

    Add handle control to the CHAN Page's B1 key to return to WPN (#624)

[33mcommit e7cebdd010f122b590e2e80ee3a72ad3bf4e249c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 15 13:48:35 2024 +0000

    Fix RPT error due to invalid definition of type VAir (#623)

[33mcommit 3f6d8f1eefdb401ba17199d535145b694445bccf[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Dec 15 12:36:19 2024 +0000

    Add empty MFD pylonicon entries to prevent RPT spam caused by missing entries (#619)

[33mcommit 365e71f79132752bf14dd802af51ec6e321d8fb6[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Dec 14 16:26:50 2024 -0500

    Fix Zeus Collective and Baro Altitude (#618)

[33mcommit 89e4759131a789684d4f029debb532c190c07444[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Dec 14 11:59:14 2024 +0000

    Improve padding in radio UFD (#614)

[33mcommit dab122bd37f2410225277b397e936c4ee933da26[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 13 12:59:11 2024 +0000

    Guided hydra bug (#615)

[33mcommit 477c11b91a7c415668634dbc10794c82d1e33878[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 12 20:00:11 2024 +0000

    CBA addon Setting locks (#612)
    
    * Update XEH_preInit.sqf

[33mcommit 3af20d3ea5a137830353a126e5f34371b5edb45c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 12 19:51:21 2024 +0000

    Add vanilla radio channel support to UFD (#613)

[33mcommit a98570cd6926c9c4bd37eeca0b7b57a51d61ded2[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 12 13:31:34 2024 -0500

    Keyboard Simplifications (#608)

[33mcommit 7417d37285c97e577a98b1f78b256e62f240f006[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 12 17:58:51 2024 +0000

    Bugfix ihadss toggle 3rd person (#611)
    
    Fix IHADSS not re-opening when going to third and back to first person

[33mcommit ae620771845220814165744b7534589e58835320[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Dec 11 21:51:55 2024 +0000

    remove unused ihadss variables (#609)

[33mcommit 0a751dc0ad41c17de94902ab81fee2621c0b4d0f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 9 22:11:56 2024 +0000

    Render single ui2t to prevent freezing (#607)

[33mcommit 9df0f5cc34cd4d738bf1fa8798286f3fbf56385d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 8 22:40:49 2024 +0000

    Empty Hellfire pylon & Rocket pod (#605)
    
    * Empty Hellfire pylon & Rocket pod

[33mcommit 71424067f2d44a57a3ad584fe15d0ed6c45b400c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Dec 8 13:26:01 2024 +0000

    Fix invalid function path (#606)

[33mcommit a80f47c4a0cf0fd50ccd84f7914a0eb561d27057[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 6 21:15:21 2024 +0000

    move functions out of subfolder
    
    deleted scripts folder

[33mcommit 84e81966ed559137aa60cdedfbbe34fe11e6e092[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 6 21:12:46 2024 +0000

    Probe animation update
    
    Deleted bladerot script
    moved wip blade sim to new func, but left it unconnected

[33mcommit 8ebe0a82511f2942ed2dc52be7ee0c48c3babd94[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 1 20:57:52 2024 +0000

    Weapon Firing Passenger injury (#601)

[33mcommit b5565c55d284772b0f506a4d8f4a8b3c0a5b6dfa[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Dec 1 15:37:13 2024 -0500

    FM Update (#594)
    
    * Update
    
    Added Roll & Pitch SAS, tweaked Position Hold, Updated Aero values for Alph/Beta/Gamma. Updated velocity function.
    
    * Update fn_fmcSAS.sqf
    
    * update
    
    * update
    
    * Update
    
    * Changes as requested
    
    * Update fn_calculateAeroValues.sqf
    
    * renamed sideslip to beta
    
    * retuned drag
    
    * Update fn_fmcSAS.sqf

[33mcommit 335ae2ffc05581791b87453088bf7af7623c0376[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 1 20:07:52 2024 +0000

    Correct 7.5km Mean impact data point (#600)

[33mcommit 696041cbca1957793ccdccf54b5135cae36581a4[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 1 19:43:52 2024 +0000

    Engine Panel Interact adjustment (#602)

[33mcommit a0cfa16101c935555e2af517d8fc35828aeb7d1e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 24 12:34:14 2024 +0000

    LMC Keybind (#599)

[33mcommit 84dd842f7024ce3a08030b967fca222c5a20d3db[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 22 17:17:52 2024 +0000

    Added LWR (Laser Warning Receiver)

[33mcommit fd282dc9345170b4cdf58a8fa8e5dfc5866698d1[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 22 01:23:52 2024 +0000

    Updated MWS (Missile Warning System)

[33mcommit 79b8a679e26bf0ccfb2908d335b2ee9b740e15c0[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 22 01:21:37 2024 +0000

    Modified Mission Equipment garage option

[33mcommit d3319622dc926219c8cad5c9850b8aabf239f3eb[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Nov 18 16:59:09 2024 +0000

    Ase file/code Structure update
    
    No change to the Ase functionality aside from the removal of the CMWS from the RWR function, to be readded later

[33mcommit ba91e7a71f991e1dcc8fe8a19d39ee960d2aec07[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Nov 23 00:11:32 2024 +0000

    Multi-Player initilisation code error (#596)

[33mcommit aac9922ee8035c9fd91fc7f1ac0920f0accaf561[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 22 17:50:03 2024 +0000

    LMC (Linear motion compensator) (#586)

[33mcommit 2c1329c77bb71ef8fe93fea81c71634bb4f3aee3[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Nov 18 13:31:56 2024 +0000

    Improved Eden Dms Auto Index (#589)

[33mcommit 9b5a814958b0c76a473064cbe5b0ca349f4052a8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Nov 16 17:21:06 2024 +0000

    Fixed rocket steering cursor input (#590)
    
    Fix incorrect steering input added during #569

[33mcommit c26f16302d7eeb68edab0e348c1612a4949419a5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Nov 16 17:16:08 2024 +0000

    Updated PNVS animation logic (#592)

[33mcommit d4aea7158f7ba2d5b59fdfe4b7121b9ce0b83c0a[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Nov 12 23:35:16 2024 +0000

    Ihadss removal code update (#591)

[33mcommit 7d6b17741b080f28eccd6827e430e0620a7cda0b[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 10 01:48:37 2024 +0000

    MPD TSD RTE Subpage (#533)

[33mcommit 0a500735b9bd1402406856069de46d5c99af3439[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Nov 9 18:07:32 2024 +0000

    Update fn_linearInterp.sqf (#588)

[33mcommit ae79e742097117ef599df2eb898037555a961767[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 26 22:10:25 2024 +0100

    coreGetObjectsLookedAt optimise (#578)
    
    GOD SAVE ME

[33mcommit dde13aa24ac45bbd280d9da76a756080c1a710ec[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 26 21:01:37 2024 +0100

    System pylon, Hydraulic, repair connections (#569)
    
    * System connections
    
    * Util Leak
    
    * Error fix
    
    * Updated timer placement
    
    * Fix some stuff
    
    * Fix rocket calculator
    
    * Corrected aiming logic
    
    * Fix Logic error
    
    * update
    
    * update
    
    * review changes

[33mcommit 0f37416e06c8b59b32058b305ea8841c7bc788a1[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Oct 21 23:41:31 2024 +0100

    Error message fix (#584)

[33mcommit 46fc5d1374d656d5c5c6f9c6fd067064f195f798[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Oct 11 14:17:27 2024 +0100

    Pbo init clean-up (#579)

[33mcommit 3bab63c4409232703267fb6571a711baaea6805b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jul 20 12:59:03 2024 +0100

    Adds ability to draw lines on map (#582)

[33mcommit aeabcd81980a44d25372e6eba734ad89f151bd9d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 30 19:35:18 2024 +0100

    Update fn_perfData.sqf (#577)

[33mcommit 8b82cf4e00385a628258140123637ae83490efbc[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 30 12:50:26 2024 +0100

    Remove AFM gauges (#581)

[33mcommit 8d7e7da38e3c107ff215bb372f59454c17eb1f66[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Jun 26 21:35:41 2024 +0100

    Add public variables which show the open page in both seats. (#574)

[33mcommit 4a1707f4dcddd3f37ab5e8a3bd0640a577dcf9bd[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jun 24 23:28:27 2024 +0100

    Implement generic seat variable system and move sights onto that (#573)

[33mcommit a46f8ea5db045bb27ed4d1b31575582778a95074[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 24 18:08:43 2024 -0400

    Fix Collective when in cTab and Chat (#572)

[33mcommit cc0629f49c9390febcdfd0f014d0e03bc3a8dfa0[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 24 10:50:26 2024 +0100

    caution audio timer adjustment (#571)

[33mcommit f28f92505d14203d6cf07d5258e5d67c9818536e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 24 10:50:19 2024 +0100

    Burst limit fix (#568)

[33mcommit 15b16654f2c4b70907fc5c4f3ebd8ef627775ec6[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 24 10:50:08 2024 +0100

    Ihadss Layer error bug (#567)

[33mcommit 937a10cae91d492ab213e28cae7860661942930a[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jun 23 08:26:06 2024 +0100

    Fix flight path vector to be in 3D space (#570)

[33mcommit 8d0c9a4aeea18bdc3fb2317a6966d0d2a03a0d23[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jun 19 19:25:26 2024 -0400

    Tail rotor update (#565)
    
    * Update fn_simpleRotorTail.sqf
    
    * Update fn_simpleRotorTail.sqf

[33mcommit 9a5e8e01941634b7b9face188d4dd16d896eb728[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 16 14:14:34 2024 +0100

    Update fn_draw.sqf (#566)
    
    Fix GUI layering which caused aircraft to be incompatible with CTAB and MicroDAGR along with other HUD elements

[33mcommit 998cad7cd7ed7c8af710b5a4e85817422c621c60[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 27 17:17:19 2024 -0400

    Fuel System Rewrite (#563)
    
    * Fuel System Rewrite
    
    * Update ufd.hpp
    
    * Fix in progress for UFD
    
    * Update ufd.hpp
    
    * Update ufd.hpp
    
    * Adjustments
    
    * Update fn_fuelUpdate.sqf
    
    * Update
    
    * Update fn_fuelUpdate.sqf
    
    * cba version Minor bump
    
    ---------
    
    Co-authored-by: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>

[33mcommit ef40ddbf6e8d70b9aa8eebd57341410a20cac70c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun May 26 17:39:36 2024 -0400

    Adds missing pilot/gunner/cargo proxies, material corrections (#562)

[33mcommit 5af12a3a4901b27f26187c47b3dfc00384258658[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun May 26 17:39:23 2024 -0400

    Updated Rotor Power Calculation (#561)
    
    * Updated Rotor Power Calculation
    
    * Update fn_simpleRotorMain.sqf

[33mcommit 577bec40e7ce670ec93d12b8a3613dc9084c3957[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Apr 28 18:19:37 2024 +0100

    Conflict Merge correction

[33mcommit 216c8189037a021e0674c7b0d751c6ce863c096a[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 27 22:01:45 2024 +0100

    Updated Weapon Limits (3/3) (#553)

[33mcommit 2788f5a61a3fb7a7dd18b88839c29ddd6bc03449[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 27 21:43:39 2024 +0100

    Animation propagation improvement (2/3) (#551)

[33mcommit 7cc1a3398c39bcf5d951c5880463dcc5dde05514[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 27 21:43:19 2024 +0100

    Animation controlled lights (#554)

[33mcommit 2ed93af2d8d32602197466621cfab4c2642e573e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 27 21:09:19 2024 +0100

    Pylon articultion Logic (1/3) (#550)
    
    correction of the sight logic
    added hellfire articulation
    added aux tank +4 articulation

[33mcommit f45ab26ac5673050ae236e16819c91d3515314fd[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Apr 27 15:13:32 2024 -0400

    Update fuselage dynamics (#559)
    
    * Update fn_fuselageDrag.sqf
    
    * Adds fuselage response to flight path angle and sideslip
    
    * Update fn_calculateAlphaAndBeta.sqf

[33mcommit b65d7ba97a32db3528cc75fe965882fc48f7f9ff[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Apr 11 19:20:17 2024 -0400

    Smooths out the transition between submodes (#558)

[33mcommit 2744063c9760d6eb2e44101ddb855b5170bd6606[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Apr 12 00:17:09 2024 +0100

    Eden Dms Auto Cycle (#555)

[33mcommit 0b3feecc208e80196745e6cebd1a31e1b054975d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 11 23:39:36 2024 +0100

    Icon persistency (#556)

[33mcommit ac9450d81748cef4ed5aa9ee5b3350fe06e30851[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Feb 24 21:12:30 2024 +0000

    Model.cfg cleanup (#547)

[33mcommit 81727fe8a020dd8edf4869ce90d40d28ec06cc53[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Feb 24 16:05:07 2024 -0500

    Add dynamic center of mass (#545)
    
    * Add Dynamic Center of Mass
    
    * Added wing station mass function
    
    * Re-added Aux Tank, Created fza_ah64_auxTank
    
    * Started work on massUpdate
    
    * Removed safe fuel fraction
    
    * Update
    
    * Implemented dynamic CG
    
    * Fix pilot mass
    
    * Added debug lines and updated CG correction value
    
    * Added dynamic CG to perf page, re-added safe fuel fraction
    
    * Corrected Aux Tank pos, Added Aux Tank to UpdateStation
    
    * Delete comments

[33mcommit b86e9d937da6a5e272ab21fa001a814cc5da1cb5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 16 22:49:30 2024 +0000

    Fix vanilla guidance (#549)

[33mcommit 37a14fc41ec3b5d6feb1367be0c3fa3c8000ad28[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 16 22:49:19 2024 +0000

    Correct Apu caution condition (#546)

[33mcommit fa3ee2d8b7170d895093381628167a6bd2dc2ed3[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 16 22:49:06 2024 +0000

    Fuel flow sync (#548)

[33mcommit f2319b2691327423ad8796de09c39010692f10c7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jan 29 15:02:57 2024 +0000

    Draw timing bug (#544)

[33mcommit 8be311ff70b5cd48244f1b6153392909b10f22bd[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jan 23 22:59:32 2024 +0000

    Ihadss Electrics and hitpoints (#512)

[33mcommit 3a19e373583a93f6fe4ac5b962cbcd3622790491[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jan 23 14:55:22 2024 +0000

    MPD FLY, FCR Centre line, Sensor direction, waypoint direction (#527)

[33mcommit aa2a1dcbc839a9790f042a306fb05f4a114fe1ba[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 21 12:34:03 2024 -0500

    FM Drag and Main Rotor Torque Adjustments (#543)

[33mcommit 3ed5c61cf1d24ac731ec254f78acf6b290e323df[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 21 11:27:15 2024 -0500

    Rotor Torque Fix (#539)
    
    * Rotor Torque Fix
    
    * Adjusted main rotor torque value, deleted system chat

[33mcommit dc95b75ea53f61f170358a2e1d4e1fb1967a1c42[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 21 11:25:47 2024 -0500

    Flight model adjustments (#542)
    
    * Fix Text Spacing for ASE Icons
    
    * Flight Model Adjustments
    
    Re-added Heading hold and added a CBA Option to turn it on/off based on user preference. Updated the way wings apply forces and torques. Updated fuselage drag model. Corrected vertical stabilizer force direction (was opposite of what it should be).
    
    * Update FzaIconTypes.hpp

[33mcommit 625f237d45d39e8e04c91a2e50e863b4a34d6378[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 21 11:25:36 2024 -0500

    Fix ihadss horizon line and fix fpv naming error (#541)
    
    * Fix Text Spacing for ASE Icons
    
    * Update fn_ihadssDraw.sqf
    
    * Revert Changes

[33mcommit 5bf6a5a7e4af660c787c1b1c73a80e38675b8301[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 20 20:45:38 2024 -0500

    Fix Text Spacing for ASE Icons (#540)

[33mcommit 4652cae5f49f71861e3516dfd8b2f805bd961855[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 21 00:32:06 2024 +0000

    Engine out WCA conditioning  (#530)

[33mcommit 1576290c5de3830d85abac9deae1cf2129d2d80f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 21 00:15:46 2024 +0000

    WCA Fcr Fault Conditioning (#532)

[33mcommit 2fcad0394a4d93ff4724f1f64eaee3c81574ed5e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 21 00:06:48 2024 +0000

    RWR Flashing Icons + Launch Lines (#535)

[33mcommit a02f2e4ce90ce0dfc956003af339429181704d5f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:44:04 2024 +0000

    Correct Mpd Draw timing (#517)

[33mcommit 1dca9c3d4a44472330c4d2584bf875debb89afc7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:32:49 2024 +0000

    RLWR icons in eden dms bug (#534)

[33mcommit e5b73a772994bf24ea7ca8797e9cb0931e5f21ea[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:32:33 2024 +0000

    Mission load error (#536)

[33mcommit 141c847abe4d569a2db38fcd580b8ab10b4836d8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:32:23 2024 +0000

    reduce icon size (#538)

[33mcommit 693770a8cf454488467f49bf10ec611afc399920[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:32:00 2024 +0000

    Chaff electrical connection (#531)

[33mcommit 4a2e36c7ef92f3f6a35f2beec5126bfa25e943b5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:31:46 2024 +0000

    Ihadss Fcr centreline & waypoint chevron (#528)

[33mcommit 4ebfe20fdb435ac9d93721f366b68ea8788bd5b7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 20 23:30:32 2024 +0000

    Engine page emergency mode (#519)

[33mcommit 31e78fad2cef38ef2b983d34e16bc8f0c5fa8461[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 12 18:19:46 2023 +0000

    RPM controller correction (#529)

[33mcommit fd3be1abe68f8c6d3d1ac1981e248fe776e907ac[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 12 18:17:56 2023 +0000

    Light Electrical connections (#520)

[33mcommit d6478f9213a33d899d47297072ad008e17cf3cf4[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 10 11:30:09 2023 +0000

    removed ace hitpoints repair defines (#525)

[33mcommit c411f4758a80f73a3879c0d8a1360848a0442817[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 10 11:29:17 2023 +0000

    Stabilator electrical and hit-point connection (#526)

[33mcommit ab8ecca86870e52a1dda611e1168541432b17a3e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri Nov 10 06:25:05 2023 -0500

    Reverts engine controller and getRtrRPM changes (#524)
    
    * Reverts engine controller and getRtrRPM changes
    
    * Function correction

[33mcommit 1f9a3c46c1cf9714b1aa45ac240a4bd15e25e879[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 18:41:32 2023 +0000

    revert #511 (#523)

[33mcommit 09cb35ea9cde55e7839e542b48785af190b36019[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 18:22:26 2023 +0000

    revert Pr #513

[33mcommit 56a413b1c61ded339020dac629659686a0f8fd02[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 17:26:59 2023 +0000

    Fix old author name (#521)

[33mcommit 4bf6645d6c720102c7171230aacaf4d7953d786f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 17:22:42 2023 +0000

    MPD Cscope button desync (#516)

[33mcommit 11daccc327268fb1cc37a4bd97b93000b81f1a62[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 17:21:36 2023 +0000

    Move functions around & removal of old code (#511)

[33mcommit d35227a2a5f18f480f5b9da2cca3b3147b841fd8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 17:17:14 2023 +0000

    Integrate updateNetworkGlobal Function (#518)

[33mcommit 922240df96662f225eb1b7058fe2c06035586bf8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 5 17:16:10 2023 +0000

    Separation of initial variables into the respective pbos (#513)

[33mcommit 469da84ea72ddea6e76f7abdef7b39d444c3c7f3[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Nov 3 13:56:56 2023 +0000

    Add velocity vector to IHADSS (#503)

[33mcommit d5ec107225e7f655ebae706a3b2cdcfa7ea31451[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Nov 2 22:25:23 2023 +0000

    Correct AI functionality (#506)

[33mcommit fef14f792865c2e98685335f7f324a124f3106c9[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Nov 2 17:30:53 2023 -0400

    Refactor Rotor Forces (#505)
    
    * Rotor smoothing
    
    * Combined thrust/torques to a central point
    
    * Undo global variable

[33mcommit e4350504e2b088789e30b55dd2d95fe264e2259d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Nov 2 17:28:18 2023 -0400

    Update fire Geometry (#509)
    
    * Update fire Geometry
    
    * Added IR Jammer

[33mcommit 1db9e1d95bff49f38b2f6271c7693c704cb7083d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 1 21:06:09 2023 +0000

    Logic flow change (#501)

[33mcommit acd0c645da5c673131437bac7b808e03d7448355[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 1 21:02:24 2023 +0000

    Fire System separation and update (#421)

[33mcommit a550deff4c6ed95fe65f363b621b459008999b2c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 1 20:13:21 2023 +0000

    Split FCR into separate addon (#510)

[33mcommit 62f743a2b2d84aa6d5a3aff66f1f5e1f94625c6b[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Oct 31 18:56:56 2023 +0000

    Aircraft common FCR & RLWR (#504)

[33mcommit 551a384b6d67ac06e6b7454cba47119378506401[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Oct 29 16:52:17 2023 +0000

    APR 39 Audio Sync

[33mcommit 0e567a73a3dedcb63743969e1d546da9cf3127f6[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Oct 29 14:42:27 2023 +0000

    single player gunner Engine sim (#498)

[33mcommit d4537f183a9ef03257bfb0a98c321b4f7a4a2c4c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Oct 29 14:41:40 2023 +0000

    Monocle & Nvs overlay condition (#499)

[33mcommit 97207836244c1cc3df1faa0ad1a76882f73977e1[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Oct 29 12:22:46 2023 +0000

    Rocket and missile effect update (#478)

[33mcommit 151c69feef58f603cbdf45d4bc857d004439b06d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Oct 28 19:04:41 2023 -0400

    Updates pitch/roll torque scalars (#497)

[33mcommit 1e9c405d256e9da019e3bb4aeda592b706d224b5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 22:19:42 2023 +0100

    Logic corrections (#496)

[33mcommit e33eb03850b92520ebe8d8802077aaa6388e70a8[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Oct 28 19:00:10 2023 +0100

    Use uiEx to render TSD icons (#297)

[33mcommit 46004c1f0f7a3e687fd1dc6eae9396b636e5c0f6[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 18:51:23 2023 +0100

    Mpd info propagation (#495)

[33mcommit 798c84658337ec8b0d4a7fcdbe49bdab83e8ec38[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Oct 28 13:13:26 2023 -0400

    Implements RPM Animation Controller in HeliSim (#494)
    
    * Implements RPM Animation Controller in HeliSim
    
    * Remove systemChat

[33mcommit b4959fd8e770fb39ccc64c3b6c8ba843267f6e2a[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 17:22:51 2023 +0100

    Phase 1 Rework (#490)

[33mcommit 7ed55e868827aa4eaae234fc9526855fe9eabddc[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 17:15:04 2023 +0100

    Tads Flir & Dtv Fov update (#486)

[33mcommit e8e98f433607095dab85d66964b1f781a44cdb08[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 17:03:57 2023 +0100

    MPD Ase icon Removal (#493)

[33mcommit 04d91bf865bd301bee4e5eb1069084f3df3029f8[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 17:03:49 2023 +0100

    HDU monocle logic (#492)

[33mcommit 442512e26a480a510e2fa255551822054c225476[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 28 17:03:40 2023 +0100

    WCA Logic Correction (#491)

[33mcommit 3feb6baa1ee7554ad8980aaad234da5b637be0d9[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Oct 25 15:40:58 2023 +0100

    Corrected NVS overlay layering order (#489)

[33mcommit f7e1e59306048459b028c57135c33dfedea12c01[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 21 14:54:11 2023 +0100

    Removal of 3rd POV aiming reticles (#483)
    
    * Removal of 3rd person vanilla aiming reticles

[33mcommit 1a37c3cf81b8f50efee88f13343bf72162acdaae[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Oct 9 06:47:16 2023 -0400

    Tuned ETL Effect to be less exhagerated (#485)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 9e44bec9683dfc1df684961f5239dfa02d8529e5[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:17:55 2023 +0100

    Improve rocket targeting accuracy (#477)
    
    * Steering cursor update

[33mcommit 0cdd4d598c4d3117a35656dfc39a8a0228b9be53[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:11:48 2023 +0100

    HDU Initialization (#471)

[33mcommit 82efaa19588dbb4ad1c967643ac261d73d389f9f[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:05:14 2023 +0100

    Camera shake adjustments (#479)

[33mcommit f34e6c6ec08cd97ec9b49f8803c72caba406a6a3[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:04:45 2023 +0100

    Correct default pylon zones (#480)

[33mcommit aeb164f01a307b0a62dfcc16fdd269579a577995[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:04:24 2023 +0100

    Remove old code (#481)

[33mcommit 3467e29b1d3969272eeb0471bad1bb37643bb2bc[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 25 18:03:41 2023 +0100

    Unguided hydra fix (#482)

[33mcommit 73838abdfa7fd95cf6af0fb82c9cce734d007537[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 4 22:14:33 2023 +0100

    Hud Removing on getout (#474)

[33mcommit 7a977be3d0963b8042839de5c73e0abcbf99f47e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 4 22:14:23 2023 +0100

    zeus helisim selection (#473)

[33mcommit ba50388481994c1adb7aa2ce0402841c6b9354e9[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 4 22:13:59 2023 +0100

    RPT error Fixes (#472)

[33mcommit fc9ba5cf5ed78b914b2c09a0f8e13298eecfc2e1[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Sep 4 19:29:07 2023 +0100

    M255 Deployment Smoke (#457)

[33mcommit 93d8882db9c555d41ce042ff779b41a8cd8191e6[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Aug 28 10:13:43 2023 -0400

    Update Torque Force Output and Retune Hold Mode PIDs (#476)
    
    * Update control inputs, retune PID controllers
    
    * Commented out old torque values
    
    * Further commenting out of old values
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit cffca370d19b9e8d152c1e59fc85111964f57fba[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 27 19:52:09 2023 +0100

    MPD WPN hellfire text (#451)

[33mcommit bd69484c7759300206ac3726f69c1f99502124df[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 26 23:18:17 2023 +0100

    Tail number Eden control 7 to 5 Characters (#465)

[33mcommit f67fafd7a87846ed72f9302c08cc7040f8a522bd[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 26 22:22:40 2023 +0100

    Change available hellfire types (#463)

[33mcommit 8e1cc79b13c0b6f615e4fff73fbe98298f768786[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 26 21:59:21 2023 +0100

    Change available rocket types (#462)

[33mcommit ae717de8cf9189adee8467de544c6bfcd56d1537[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/effect-Rkt-&-Msl-Smoke[m[33m)[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 26 21:47:56 2023 +0100

    MPD WPN RKT Draw Logic (#450)

[33mcommit dd038963328d347e097afe189c3dd66dfb7fcd0a[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Aug 20 14:24:47 2023 -0400

    Adds onGround function and replaces use of isTouchingGround as sole means of determining if the helicopter is on the ground or not (#468)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit b4f66d10260876f7e54dc5689746fdd8fc9fa79d[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 20 19:06:25 2023 +0100

    Dtu date display (#467)

[33mcommit 17dc1253dc7202d3c2012ca21967fa88db854a70[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 20 19:06:00 2023 +0100

    Hide IHADSS when in Zeus (#470)

[33mcommit dd49548850e88b319486e0b75bacf95f18917e2c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 20 18:49:26 2023 +0100

    If IHADSS shouldn't be drawn short-circuit the drawing function

[33mcommit 74d7335fe79d916ce5d88507d923d1e5a157fd6a[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 20 18:48:48 2023 +0100

    Move all non-IHADSS code out of IHADSS draw

[33mcommit dfae0f5aeb0fc30789a4364c19f53b5d6ea27c32[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 20 16:37:33 2023 +0100

    Remove IHADSS UI on respawn if not in aircraft

[33mcommit 53ea8ff556ee7478fa9c8d119f7ed4edaa4abf22[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 20 19:00:52 2023 +0100

    CBA Versioning (#464)

[33mcommit 7043d6b8bac0d155f91929924ba2fd11495696df[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 20 18:41:29 2023 +0100

    Audio flight control tone (#460)

[33mcommit 20b8924070402a749066adc51423634906fdd82e[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 20 18:40:57 2023 +0100

    MWS detection system

[33mcommit 5e0be22a683b0a2ea4fba83a3bc61e6b0616a843[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 22:19:09 2023 +0100

    Connect Show RLWR (#443)
    
    This reverts commit 29831960b6bd79268fe5775773df430329ea6b36.

[33mcommit 3e9bc7436d001eaab39a40f1f99da5b5f51cc8c7[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 21:42:37 2023 +0100

    Fix HDU Rocket cursor and remove gun crosshair (#455)
    
    Fix HDU Rocket cursor and remove gun crosshair
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit 73cd644a262902f2a926aa1d4fe9046a226d5539[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 18:32:40 2023 +0100

    APU Texture Control Shift (#452)

[33mcommit c07998a86c546d0ad2cde1ae70cb086c6887527c[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 18:31:48 2023 +0100

    British mission equipment Fix (#453)

[33mcommit 98326d6eb30bf529bdba589daf8610d85ef3a545[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 18:31:02 2023 +0100

    FCR damage Connection (#445)

[33mcommit 9ac3adc7e36bea79aaf619c81bd3ffb579daec63[m
Author: Snow(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 6 18:12:12 2023 +0100

    HDU bob up mode (#456)
    
    
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit 6b55ff75fa08471a233af77bd0e996ff3baed75c[m[33m ([m[1;31mupstream/remove-pyc-file[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 6 18:09:57 2023 +0100

    remove random .pyc file

[33mcommit 0cf2d7c237a72962dd042d86cfa410bcbe493c98[m
Author: fire-391 <36144022+fire-391@users.noreply.github.com>
Date:   Mon Jul 31 16:46:58 2023 -0400

    CPG LMPD_r2 fix (#454)

[33mcommit b5b783302926739af844c7f147b5d6b06b7a9fdb[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jul 31 16:27:17 2023 +0100

    HDU Headdown Logic correction (#448)

[33mcommit 01721fb0b629f064efe046e37c2ae807190dc3d2[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jul 31 16:26:11 2023 +0100

    MPD TSD show page occlude bleed through (#447)

[33mcommit 11a4df80a89474cddfebae1725ce1d227c2c264f[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jul 31 16:25:59 2023 +0100

    Fixed syntax (#446)

[33mcommit 0bb79be764050c96a736d81bb92b7ebefcb72dee[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jul 24 20:59:42 2023 +0100

    Simple rotor error (#442)

[33mcommit 0e86899e7c2289b2f0ae98277010335a99812dfb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jul 20 01:29:48 2023 +0100

    Setup python in github action (#441)

[33mcommit 9b9e04c983660467aeefa636ef242bd6eb30d2e2[m
Merge: 902e7e825 9137821c9
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jul 20 01:20:15 2023 +0100

    Merge pull request #440 from AH-64D-Apache-Official-Project/documentation-mfd-generate-github-actions
    
    Generate MFD table in github actions

[33mcommit 9137821c979527960dfa4b0e80c69f461846c255[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jul 20 01:18:29 2023 +0100

    Add mfd table to documentation

[33mcommit 902e7e825411a8414a76e6c98d595c169f1f7a26[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jul 20 00:09:58 2023 +0100

    Add automatic documentation for MFD points (#439)
    
    * Implement HTML documentation for MFD Indices
    
    * Fix non-standard MFD names

[33mcommit 102cf26e6f67593a02bf21566146def27476c386[m[33m ([m[1;31mupstream/documentation-mfd-points[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jul 20 00:07:42 2023 +0100

    Fix non-standard MFD names

[33mcommit e377546ce696bf0da4c190b5cb7e11b6daa653c4[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Jun 28 14:01:49 2023 +0100

    Implement HTML documentation for MFD Indices

[33mcommit d3265da658e167645c9df487cad28639390c9691[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 19 23:44:36 2023 +0100

    remove Lod 1.5(#436)

[33mcommit fe000f331bc1174ee90072d8ae623c456da5e0d4[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Jul 19 23:42:52 2023 +0100

    Fix icons drawn on screen sometimes being stuck when leaving page (#437)

[33mcommit 2a430a696c25516988200d060a5316f4dd3ad581[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Jul 19 23:42:43 2023 +0100

    Fix TSD icon scaling not being fetched correctly (#438)

[33mcommit 4e298c06cf660c2f7acfcd42750633deb4eca0d4[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 19 22:37:09 2023 +0100

    Mpd wpn rocket quantity popout (#433)
    
    * MPD Wpn Rocket Quantity Select popout

[33mcommit 56ac6e0a9e2a8ff8e9f4deb5fe40f1c1787b1cb4[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 19 22:25:23 2023 +0100

    RPT error fixes (#435)

[33mcommit e3a86685a543521158de601743d13146f9767341[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 19 12:36:15 2023 +0100

    Fix type error in engine controller (#434)
    
    * Helisim Engine Controller fix

[33mcommit a186f4178aa43ee20b161e52ef43b989004ae563[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 18 23:17:43 2023 +0100

    Fix APU fuel consumption (#429)
    
    * Apu Flameout & fuel consumption fix

[33mcommit 9bb6da035489a4fb3dd0111bbc5cefcbd1396a29[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 18 23:06:12 2023 +0100

    MPD Fly page Torque connected (#432)

[33mcommit 152247a61e2a1e3adf82d143f7c91d1d562b98c6[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 18 23:06:03 2023 +0100

    Engine Requires Apu to start (#431)

[33mcommit 8254fce07dc901e2ebd85f0a945f8d7917709371[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 18 23:05:53 2023 +0100

    Helisim Engine Controller fix (#430)

[33mcommit 36f4e29353ab08fba52189fe141f2abe5bd4e812[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Jul 18 17:04:17 2023 -0500

    Update Graphics, move RLWR indications to MPD draw system (#412)
    
    * Update Graphics, move RLWR indications to MPD draw system
    
    * Changes as requested
    
    * Updated TSD ASE Icon draw and updated RLWR texture
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 271fbc3186c72d5d3d6cde41a1da1cfc2860e1a6[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 16 12:46:34 2023 +0100

    Split out wpn sub-pages code

[33mcommit f1852e4c77e8ff2a32683b6bd858c433b94367af[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 16 12:31:33 2023 +0100

    Mpd Wpn Trajectory pop out menu (#427)
    
    * Wpn Missile Trajectory

[33mcommit 988a5d06f6c74468893693111cf20c3a53b5e82e[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 16 12:08:25 2023 +0100

    MPD Tsd Range Scale Popout (#406)
    
    * MPD TSD Scale Pop-out menu

[33mcommit bd9038e3a066d24aec3c63e3b05149083577cfda[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 15 08:38:57 2023 -0500

    Add Engine Flameout (#423)
    
    * Add Engine Flameout
    
    * Corrected logic to prevent auto issues
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 7abf4184ffdf11cc8f01335738bb4901d23cd9a7[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 12 00:31:20 2023 +0100

    Rotor animation fixes (#420)

[33mcommit ee49f40b7744a16635b8adb8213d5e5c030eaeef[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Jul 11 17:31:02 2023 -0500

    Fix macro formatting errors in controls.h (#419)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit a7e5cfd01ad78a0c4acff8204fd7d60e45c36063[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Jul 11 17:27:41 2023 -0500

    Add Vertical Fin (#415)
    
    * Add Vertical Fin
    
    * Formatting fixes, changed wing rotation angle
    
    * Implemented vertical fin
    
    * Updated static air density value for wings/stabilators to calculated value
    
    * Fixed wing lift line, added vert fin lift force, adjusted vert fin incidence angle
    
    * Retuned FM for addition of vertical fin, corrected ihadss TAS display
    
    * Removed systemChat
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 9c3a8151ec8ede6ee10ae31bd8ac2801a145200e[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 11 21:11:03 2023 +0100

    Core Interact T2 Undefined gunner (#418)

[33mcommit 14afb52929d5c0ff41c66bf0d0b7e58747e90484[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jul 11 21:10:35 2023 +0100

    WCA Low/High Rpm Logic Correction (#416)
    
    * WCA Low/High Rpm Logic Correction

[33mcommit b5976b83ee04b7d53f6a3247ef8b0d9d53683372[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Jul 11 15:04:43 2023 -0500

    Fixed SFM+ Excessive Input Issue (#417)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 0b23c0c0e077643ed297aded6bfe144e87f3893c[m[33m ([m[1;32mSFMPlus-Input-Fix[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jul 10 14:48:42 2023 -0500

    Add Engine Overspeed Failure (#395)
    
    * Add Engine Overspeed Failure
    
    * Added repair handler
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit b57dd19826cd13feeaa8c681f26b964dd90afa0d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jul 10 14:48:27 2023 -0500

    Tune Tail Rotor to Prevent Rotationon Ground (#414)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit dd42cc982ababf783f38f680ff4a078ad77e1273[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 8 17:58:30 2023 -0500

    Delete systemChat (#411)

[33mcommit 3b8ff7b0a805bb6d139784228c667a483e620a18[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 8 17:30:42 2023 -0500

    Adjusted rotor droop mechanic (#409)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 3ead42155aa8f4226c33f8280b446e5890bae63c[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jul 8 23:30:18 2023 +0100

    MPD ABR Fixed Page cap logic (#408)

[33mcommit 981ea63022b8368c769e03d4da23c0e76aff2474[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jul 8 19:29:41 2023 +0100

    Fix Mp briefing error (#399)

[33mcommit 27240d116e6f2e6198d8a1767a407d334540cd38[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jul 8 19:07:55 2023 +0100

    Connect Show page to Icon draw (#404)

[33mcommit c3f8f12562fc674e73ab18d379a10f56b98fbfea[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jul 8 18:04:16 2023 +0100

    TSD Show wind & endurance Logic Correction (#405)
    
    * MPD TSD Show wind & endurance Logic Correction

[33mcommit 51ede0363bad0a773312a84abc5989b80ef2194c[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jul 8 16:53:25 2023 +0100

    Flight Model Hitpoint Corrections (#407)

[33mcommit fd23de1533ba7c483cebbe2849a458b51875ac09[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 7 22:54:23 2023 +0100

    Mpd Tsd Fcr Icons (#396)
    
    * Mpd Tsd Fcr Icons

[33mcommit 2328731677289264489ca07c34df539f6d6a5194[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri Jul 7 16:53:49 2023 -0500

    FM Retune, Perf page update (#403)
    
    * FM Retune, Perf page update
    
    * Removed systemChat
    
    * Fixes autohover interfering with HeliSim force trim
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 1401925448a2ba8a1f2327c418b870ddb09b9825[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 7 22:10:07 2023 +0100

    FCR max show limit (#397)
    
    * FCR max show limit

[33mcommit 6e428776053baf990ee1d6fd1a0070cf8f85af9f[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 7 21:36:23 2023 +0100

    Fixed PBO WCA Logic (#401)

[33mcommit 29831960b6bd79268fe5775773df430329ea6b36[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 7 19:09:45 2023 +0100

    TSD Remove show RLWR toggle option (#398)

[33mcommit 8a69417b5334ec1f545ef0c10ccddfc18014656b[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 7 19:06:15 2023 +0100

    Wpn Page DeWas Fix (#400)

[33mcommit ac16226b00b96532bbd0f308a1829e9a8c861dc7[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/MPD-TSD-show-page-option-connection[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jul 6 11:08:16 2023 -0500

    Fire Geo and Hit Point Fixes (#394)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 803f9926efd0363c9f8329b1c74c7ee1ea74fef4[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jul 6 09:36:43 2023 -0500

    Connect WCA Audio (#386)
    
    * Connect Audio
    
    * Rotor RPM Low is still broken
    
    * Fixed on ground check
    
    * Removed system chat
    
    * Fixed error with rotor rpm low
    
    * Replaced existing audio with newer, more accurate sounds
    
    * Replaced Rotor RPM Low/High w/ better voice file
    
    * Removed duplicated pushback call
    
    * Fixed deleted cfgFunction entry error
    
    * Fixed error
    
    * Replaced APR audio files w/ more accurate voice
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>
    Co-authored-by: Rosd6(Dryden) <Doolieollie@gmail.com>

[33mcommit c771ed4eabb51deb74a996de98c7962f3a237c3b[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jul 6 09:30:05 2023 -0500

    Set RPM to 0 when main rotor destroyed (#393)
    
    * Set RPM to 0 when main rotor destroyed
    
    * Fixed rotor rpm and broken rotor states
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 809ebb79310d62edbdc6ef912c41f61a1ae52c3f[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 5 19:26:47 2023 +0100

    Audio Logic Update & volume control added (#373)
    
    * Added Radio Variables
    * Updated Audio Logic
    * Added Volume control Function
    * Review changes

[33mcommit 2a1c4f3859b5cceacfd6c81f512178775ab322dd[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 5 19:24:45 2023 +0100

    ASE Autopage Launch Logic (#384)
    
    * Missed Launch logic

[33mcommit 68a46951f3f2f3bf46f7132c215d119c7953d188[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 5 19:21:21 2023 +0100

    FCR Filter for priority targets (#392)

[33mcommit ad9bb837f8e9e67e8fc20d7ddd4e654adea6d6ed[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jul 5 13:14:38 2023 -0500

    Update fn_fmcAltitudeHold.sqf (#385)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 5ce17ee380b12da4059d488b4e6790c0afb12b71[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jul 5 13:14:23 2023 -0500

    Simplified fire geo, corrected fire geo component that was not taking any damage (#391)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit d8f88e6562e76c3269687e189ed7e46dfedb39cd[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jul 5 17:24:57 2023 +0100

    Tuning (#390)

[33mcommit f9f0b3682f17d16f6b345db96da5760896bd23c8[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jul 5 11:24:24 2023 -0500

    Set Rotor Brake to Correct Initial State (#387)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 6e04d648f09385c649c79dcafa2e05e21d430e1c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jul 3 16:32:03 2023 -0500

    Add Gnd Oride and Arm Logic (#376)
    
    * Add Gnd Oride and Arm Logic
    
    * Updated names and descriptions
    
    * Completed button logic implementation and config entries
    
    * Changes as reqeusted
    
    * Changes as requested
    
    * Bug fix
    
    * Bug fixes
    
    * Bug fix
    
    * Bug fix
    
    * Bug fix
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 7807c4e81e6d96e2035c8be7badd48f3c080757e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jul 2 08:41:43 2023 -0500

    Fire Geo Non-Convex Error Fix (#375)
    
    * Fire Geo Non-Convex Error Fix
    
    * Update fza_ah64d_b2.p3d
    
    * Update
    
    * Surface fix
    
    * Updated surface materials and non convex objects
    
    * Fixed materials
    
    * Changed side panel materials to plastic since plexiglass doesn't work
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit d207cdc6e83aa2d717c1c48c0288a35dfe3cf200[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 1 20:45:49 2023 -0500

    Fix IHADSS Baro Alt display and FMC Functions (#374)
    
    * Fix IHADSS Baro Alt display and Alt Hold
    
    * Additional fixes to altitude outputs
    
    * Tuned rotor model to better interact with FMC changes
    
    * Fixed Alt Hold bug, tuned rotor to better support FMC updates
    
    * Added sub-mode check logic to attitude hold
    
    * Added getAltitude function to standardize altitude calls
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 722dc7deab4f9a2f277fb0acf4b432c0cd34e808[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jul 2 02:45:00 2023 +0100

    Modify Missile Constraint box to reference the nose of the aircraft (#381)

[33mcommit 9f4a8df67e96c6dc69c53a2132888588b18b9a0b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jul 2 02:44:51 2023 +0100

    Set default Hellfire trajectory to DIR (#382)

[33mcommit 3376c976c653a87cfcc819790fc842764e14588e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 1 20:27:52 2023 -0500

    Disables camera shake in 3rd Person (#380)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 0d14f215364a99273f77d7a119e1af03f019368c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jul 1 20:27:39 2023 -0500

    Update fn_getInput.sqf (#379)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 62c3b5eed6356552a38760c166f0ecfa11f1cae2[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 2 01:23:40 2023 +0100

    AutoPage Logic (#377)
    
    Autopage logic fix
    setcurrentpage undefined var

[33mcommit 3e6513f7e32ce1cfca49bb24ffa9d4a9d890da2e[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 2 01:22:48 2023 +0100

    Cscope selection Box (#378)

[33mcommit 963b54bd502d24da62bf65c533b96251871a2475[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jun 30 19:52:02 2023 +0100

    Mp Power State sync (#369)
    
    * Mp Power State sync
    
    * author name
    
    * Updated code to use Global func
    
    * Flipped Logic

[33mcommit be0adf53803221bdfa4299fb0c401280dd358526[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jun 29 16:28:02 2023 -0500

    MP Input Fix (#365)
    
    * Initial implementation
    
    * Updated implementation
    
    * Update fn_coreUpdate.sqf
    
    * Removes gunner inputs from MP
    
    * Update fn_getInput.sqf
    
    * Enables gunner control and disables pilot inputs
    
    * MP Input fix
    
    * Moved input checks to allow simulation to run but not apply torque and thrust forces
    
    * Quick fix
    
    * Fix
    
    * Fixed extra curly brace error
    
    * Corrected possible rotor thrust issues
    
    * Fixed deltaTime bug causing erroneous thrust outputs
    
    * Fixed deltaTime again
    
    * Deleted systemChat
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit c0a76cad18e672545d9b4f376820f42feccb0259[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Jun 29 21:47:38 2023 +0100

    Rename to make happy (#368)

[33mcommit 01680c516be8421c9ce6d03e1a4065f2638035cb[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jun 29 15:38:31 2023 -0500

    Tuned altitude hold PID (#372)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 1466b273b8a0f20141f7c1597a569bff1fd50bbc[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Jun 29 20:55:01 2023 +0100

    Camera Logic Update (#370)
    
    PNVS stowed logic
    Updated TADS stowed logic
    removed full screen pnvs
    Unmount ihadss on NVG

[33mcommit aa5cedfad0aa86183fffa5918cf1720f56d64756[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jun 29 14:51:28 2023 -0500

    FMC Update (#371)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 1360e298dc7d7565603d12cda75ad299fc39ccc7[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Multiplayer-Power-State-Sync[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Jun 28 16:25:03 2023 -0500

    Add Missing Crewstation Interactions (#363)
    
    * Added Master Warn/Caut, Arm/Safe, Gnd Oride and Emer Hyd buttons in both crewstations
    
    * Created WCA, added push button MFD points, built initial config to use MFD points
    
    * Removed textures from pushbuttons
    
    * Fixed UV and texture issues with regards to the push buttons in both crewstations
    
    * Fixed magnetic compass UV error
    
    * Updated .hpp for pushbuttons to try and get them to draw
    
    * Reformatted pbo structure
    
    * Completed config setup and handle controller
    
    * Adjusted spacing between text
    
    * Connected Emergency Hydraulics
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 4e2163e4137545e684f46d56a4b39deedc25616f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Jun 28 21:14:27 2023 +0100

    Fix UFD fuel indication being incorrect when IAFS is installed (#367)

[33mcommit 70ed7d47c4bfe4c1e48e43c205ee27da3b9daddf[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Jun 28 20:09:06 2023 +0100

    Updated coef (#366)

[33mcommit d7079d4fb74eb75bb3b6ab3fea91688c72fba7c6[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/TSD-Fcr-icons[m[33m)[m
Author: fire-391 <36144022+fire-391@users.noreply.github.com>
Date:   Tue Jun 27 16:07:18 2023 -0400

    Add files via upload (#362)

[33mcommit b3ea11236b3dd3878c6d665c5c5dd9156ad1497e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Jun 27 07:40:01 2023 -0500

    Sideslip function and torque adjustments (4) (#341)
    
    * Added actuator code to the flight model
    
    * Fixed merge conflicts
    
    * Fix merge conflicts
    
    * Fixed merge issues, tuned input lag
    
    * Merged w/ master, fixed merge commit errors, deleted systemChats
    
    * Initial setup for FMC off flight, added torque sim cba setting, added start of A/C UTIL page
    
    * Updated actuator code to work with FMC A/C UTIL selections
    
    * Updated A/C UTIL page
    
    * Fixed SFMPlus torque bug, reverted SFMPlus back to stock arma inputs, fixed advisories depending on FM
    
    * Added Rotor RPM scalar to torque
    
    * Fixed HeliSim single engine torque bug
    
    * Completed A/C UTIL page, various bug and page fixes also
    
    * Initial implementation of the tail rotor...don't fly this yet!
    
    * Implemented Tail Rotor, Added sign function to common, fixed input, fixed sideslip function
    
    * Updated turn coordination, tweaked FMC PIDs, fixed input bug with the pedals
    
    * Reverted turn coordination, deleted systemChats
    
    * Updated torque output from the tail rotor, formatting fixes, removed random text
    
    * Fixed turn coordination, retuned heading and turn coordination PIDs
    
    * Adjusted breakout values, fixed bug that allowed force trim to exceed a -1 to 1 range
    
    * Fixed axis label in sideslip function
    
    * Added sideThrust scalar to better tune translating tendency, implemented autorotation, updated sideslip function
    
    * Adjusted autorotation descent value, fixed scaling for sideslip indication
    
    * Implemented experimental power off autorotation logic
    
    * Fixed merge conflicts
    
    * Fixed incorrect indices
    
    * Fixed SFMPlus rotor bug
    
    * Initial Commit
    
    * Added velocity hold
    
    * Finished tuning attitude hold
    
    * Formatting fix
    
    * Updated attitude hold roll/pitch pid's, fixed side thrust scalar
    
    * Sideslip function fix, torque and side thrust adjustments
    
    * Adjusted beta equation
    
    * Fixed divide by zero check
    
    * Added references
    
    * Changes as requested.
    
    * Updated references
    
    * Update fn_calculateAlphaAndBeta.sqf
    
    * Fixed divide by 0 error in tail rotor
    
    * Corrected fixed pitch logic, Tail Rotor divide by 0 error and loss of tail rotor thrust
    
    * Deleted systemChat
    
    * Corrected miss };
    
    * Update fn_avionicsSlipIndicator.sqf
    
    * Update fn_pageACUtilDraw.sqf
    
    * Update fn_pageENGDraw.sqf
    
    * Fixed divide by 0 error
    
    * Tuned tail rotor sideThrustScalar
    
    * modified input handler to ignore input when freelooking
    
    * Fixed input issue with zeus
    
    * Cleaned up debug code
    
    * Fixes startup bug where the aircraft thinks its autorotating on the ground, but it's not
    
    * Fix for zero division error
    
    * Update core.hpp
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 73b1eaf1343908ba4ce9c65837e778231fda0ffb[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 26 00:56:40 2023 +0100

    MPD Abbreviation page (#359)

[33mcommit 9c6c0e7ae484299efbb6a5b5a5f88ee646fafb1a[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jun 25 15:35:05 2023 -0500

    Sfm plus add attitude hold (3) (#340)
    
    * Added actuator code to the flight model
    
    * Fixed merge conflicts
    
    * Fix merge conflicts
    
    * Fixed merge issues, tuned input lag
    
    * Merged w/ master, fixed merge commit errors, deleted systemChats
    
    * Initial setup for FMC off flight, added torque sim cba setting, added start of A/C UTIL page
    
    * Updated actuator code to work with FMC A/C UTIL selections
    
    * Updated A/C UTIL page
    
    * Fixed SFMPlus torque bug, reverted SFMPlus back to stock arma inputs, fixed advisories depending on FM
    
    * Added Rotor RPM scalar to torque
    
    * Fixed HeliSim single engine torque bug
    
    * Completed A/C UTIL page, various bug and page fixes also
    
    * Initial implementation of the tail rotor...don't fly this yet!
    
    * Implemented Tail Rotor, Added sign function to common, fixed input, fixed sideslip function
    
    * Updated turn coordination, tweaked FMC PIDs, fixed input bug with the pedals
    
    * Reverted turn coordination, deleted systemChats
    
    * Updated torque output from the tail rotor, formatting fixes, removed random text
    
    * Fixed turn coordination, retuned heading and turn coordination PIDs
    
    * Adjusted breakout values, fixed bug that allowed force trim to exceed a -1 to 1 range
    
    * Fixed axis label in sideslip function
    
    * Added sideThrust scalar to better tune translating tendency, implemented autorotation, updated sideslip function
    
    * Adjusted autorotation descent value, fixed scaling for sideslip indication
    
    * Implemented experimental power off autorotation logic
    
    * Fixed merge conflicts
    
    * Fixed incorrect indices
    
    * Fixed SFMPlus rotor bug
    
    * Initial Commit
    
    * Added velocity hold
    
    * Finished tuning attitude hold
    
    * Formatting fix
    
    * Updated attitude hold roll/pitch pid's, fixed side thrust scalar
    
    * Changes as requested.
    
    * Fixed divide by 0 error in tail rotor
    
    * Corrected fixed pitch logic, Tail Rotor divide by 0 error and loss of tail rotor thrust
    
    * Deleted systemChat
    
    * Corrected miss };
    
    * Update fn_avionicsSlipIndicator.sqf
    
    * Update fn_pageACUtilDraw.sqf
    
    * Update fn_pageENGDraw.sqf
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 81b901fbe015f941a0003d11aba5bfca97839a6d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jun 25 13:12:37 2023 -0500

    Sfm plus add velocity hold (2) (#339)
    
    * Added actuator code to the flight model
    
    * Fixed merge conflicts
    
    * Fix merge conflicts
    
    * Fixed merge issues, tuned input lag
    
    * Merged w/ master, fixed merge commit errors, deleted systemChats
    
    * Initial setup for FMC off flight, added torque sim cba setting, added start of A/C UTIL page
    
    * Updated actuator code to work with FMC A/C UTIL selections
    
    * Updated A/C UTIL page
    
    * Fixed SFMPlus torque bug, reverted SFMPlus back to stock arma inputs, fixed advisories depending on FM
    
    * Added Rotor RPM scalar to torque
    
    * Fixed HeliSim single engine torque bug
    
    * Completed A/C UTIL page, various bug and page fixes also
    
    * Initial implementation of the tail rotor...don't fly this yet!
    
    * Implemented Tail Rotor, Added sign function to common, fixed input, fixed sideslip function
    
    * Updated turn coordination, tweaked FMC PIDs, fixed input bug with the pedals
    
    * Reverted turn coordination, deleted systemChats
    
    * Updated torque output from the tail rotor, formatting fixes, removed random text
    
    * Fixed turn coordination, retuned heading and turn coordination PIDs
    
    * Adjusted breakout values, fixed bug that allowed force trim to exceed a -1 to 1 range
    
    * Fixed axis label in sideslip function
    
    * Added sideThrust scalar to better tune translating tendency, implemented autorotation, updated sideslip function
    
    * Adjusted autorotation descent value, fixed scaling for sideslip indication
    
    * Implemented experimental power off autorotation logic
    
    * Fixed merge conflicts
    
    * Fixed incorrect indices
    
    * Fixed SFMPlus rotor bug
    
    * Added velocity hold
    
    * Changes as requested.
    
    * Corrected miss };
    
    * Update fn_avionicsSlipIndicator.sqf
    
    * Update fn_pageACUtilDraw.sqf
    
    * Update fn_pageENGDraw.sqf
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit b0b9d1bbf7d357c60f305b1dd028c6418bcade29[m
Merge: 66c0dd59a e53f1b0eb
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 25 17:07:20 2023 +0100

    Merge pull request #361 from Ollieollieolllie/Variable-Init
    
    Fix locality issues with ASE Variables

[33mcommit e53f1b0eb22814ee0f5f8d4817dfd2e98d3b618d[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Multiplayer-Variable-initilization[m[33m)[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sun Jun 25 16:28:41 2023 +0100

    syntax error

[33mcommit c683f76a5e0b6a3cf382806b6b5d04239a0b24b6[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sun Jun 25 16:28:14 2023 +0100

    MP bug fix

[33mcommit 66c0dd59a3e35c8e0edd9b00559f2e706bd14a17[m
Merge: 14de6a326 ef4ba3f2b
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jun 24 19:35:00 2023 +0100

    Merge pull request #358 from Ollieollieolllie/Fix-Rebase
    
    Readded Removed Rvmats

[33mcommit ef4ba3f2b659a1c2d96648100eda119c64625fea[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Jun 24 19:08:29 2023 +0100

    Readded Removed Rvs

[33mcommit 14de6a32620db4bd6dbf8d5888955b9190c28098[m
Merge: 29bde37a7 804965f1d
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jun 24 18:58:25 2023 +0100

    Merge pull request #357 from Ollieollieolllie/Us-folder-P3D/Rvmats-Deletion-&-edits
    
    Us folder P3D/Rvmats Deletion & edits

[33mcommit 804965f1d2f42c514c31e3f7583806c7b3741e1d[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Jun 23 18:50:18 2023 +0100

    Deletions and edits

[33mcommit 29bde37a78eb93446cb38d1e4f90336cddf3d338[m
Merge: 6459808c2 7548338de
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jun 24 18:20:19 2023 +0100

    Merge pull request #356 from Ollieollieolllie/US-Folder-File-removals
    
    Us Folder unused File Deletion

[33mcommit 6459808c24c8c686e5cf92c958489ec8b0e4f7cc[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 14:25:14 2023 +0100

    Implement flight control actuator delay in damaged aircraft (#352)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit c9dcdbe2e6dc1b50671d95a455b5d359a46a4365[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 13:53:40 2023 +0100

    Improve Helisim's autorotation performance (#351)
    
    * Improve Helisim's autorotation performance
    
    * Adjustments to auto behavior
    
    * Deleted hints and system chats, fixed flight control power logic for power off autos
    
    * Fixed missing variable call
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit fdf0549b2fea53e757dac4b7a90a154fa1ed87eb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:55:05 2023 +0100

    Add more configuration to HDG and TRN hold modes (#350)
    
    * Add more configuration to HDG and TRN hold modes
    
    * Re-added missing inputs
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit a38c7a00a84e26053635f420ecf7058b05775298[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:54:49 2023 +0100

    Reduce tail rotor thrust without affecting anti-torque to modify the translating tendency effect (#348)

[33mcommit c85ec9ef1dabd4ae85dfe788acb002ccd261673b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:54:36 2023 +0100

    fix regressions in SFMPlus which led to 0 torque values to be shown (#347)

[33mcommit 7e692489cdca240bbf3cced4a4f091384b985498[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:54:21 2023 +0100

    Remove unnecessary comments and improve documentation formatting (#346)

[33mcommit bcdef5f81999adc9e3fedba1629ecebc28de2437[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:54:07 2023 +0100

    Limit range of control input trim (#349)

[33mcommit 456b35fee07050b9fd12980ee5cf818f44806f8f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:53:51 2023 +0100

    Unify and correct approach of reading rotor RPM for SFMPlus (#345)

[33mcommit 93341c7f3c3d2da86e2a77cb2e08152a59f6d4c1[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 24 12:53:35 2023 +0100

    Add toggle switch to disable main rotor torque (#344)

[33mcommit 7548338de14175045ae45b325490bcb12e4cbc9e[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/PBO-US-File-Deletion[m[33m)[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Jun 23 18:39:02 2023 +0100

    Us Folder File Deletion

[33mcommit 5d06aac9d87650f85bf2f399389ada78f5c5dede[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 23 17:12:44 2023 +0100

    Fix mod state return type (#355)

[33mcommit 6f05147383c19c7a291d7f746cf5b3fa3f9fe3b4[m
Author: fire-391 <36144022+fire-391@users.noreply.github.com>
Date:   Fri Jun 23 10:17:07 2023 -0400

    Fire Test Interact point fix (#354)

[33mcommit 9741b9b1877edfaa935735ea869d6bd71ac2c426[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 23 13:55:06 2023 +0100

    Add override to mpd state when setting page (#353)

[33mcommit 77960ba7b160ebe083e57c1dc4ad8db102807bbb[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Jun 22 19:16:56 2023 +0100

    Revert "Tsd Scale Pop out menu (#328)" (#343)
    
    This reverts commit 0167136ec5a58e25bec614d83af6419b3c62b20e.

[33mcommit 5689f86b7f72fed0480c541dbb0b6a53c20e3ea0[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 20:24:16 2023 -0500

    Fixes incorrect sideslip call, TSD error as a result of fuelGetData change, removes yawTorque from getInput (#337)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit ed34475e2a3490d4e950cbbb57e5c7d8870f563c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 17:02:06 2023 -0500

    Update Sideslip Function (#336)
    
    * Update Sideslip function
    
    * Pushed unmerged changes
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit e2f7d8e3017e3e1a6a08148d8b807b38cfc14f93[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 16:55:11 2023 -0500

    Added Robbie tank to fuel page (#334)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 2aa90d71ebeab19869b39bf54169fc32ddf34027[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 16:54:52 2023 -0500

    Add Sign Function to Common (#335)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 194962fc95c229c2d04491ea8b5271619621c1c6[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 06:20:38 2023 -0500

    Initial Commit (#319)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 3a9a75bbd6b0ca54c058fe8c2ca7227ff7758d85[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jun 19 06:20:22 2023 -0500

    Add Tail Rotor (#318)
    
    * Initial Commit
    
    * Changes as requested
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit f744dd61033e9a9a580605d95939c5d6b3ee61a1[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 18 19:31:10 2023 +0100

    FCR-ATM (#330)
    
    Added FCR-ATM
    Fixed FCR bugs
    Fixed Cscope Bugs

[33mcommit e5fdd40eee848b078e9f4f0dec368c389eb4d904[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 18 19:24:16 2023 +0100

    Bug Fixes (#332)

[33mcommit 529d35be2d6cf158f75426358bdaf1840a4e3990[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 18 19:22:31 2023 +0100

    Correct autopage logic (#327)

[33mcommit 4e016f26e156f9b537970e15e20f2afde6fe5749[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 18 19:21:32 2023 +0100

    Rpt Error (#323)

[33mcommit 0167136ec5a58e25bec614d83af6419b3c62b20e[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 12 15:45:27 2023 +0100

    Tsd Scale Pop out menu (#328)

[33mcommit ee88d3068b5f77bd4f176f284534b42c63f71885[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Jun 12 15:45:06 2023 +0100

    ASE Countermeasure system Reconfiguration (#324)

[33mcommit 114bcd4d184cb1a62de1fa6d4fb8ccd428b491d0[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Jun 1 07:33:12 2023 -0500

    Add ac util page (#317)
    
    * Initial Commit
    
    * Second Commit
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 89feb3bd4331d1980e34acb131e6652e22582854[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed May 31 22:54:01 2023 +0100

    Implemented basic acquisition sources (#296)

[33mcommit 22a567450af2f89d1fe26f81bb958536de4b6006[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue May 30 15:42:47 2023 -0500

    Fixed velocity name error, made gravity negative, changed velocity to velocityModelSpace for continuity (#316)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 8731bebefc08cec9696df8039d2bd2f6b526dae3[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue May 30 18:37:05 2023 +0100

    added missing icon (#314)

[33mcommit 08a251444f2799bfa1a6fb5d3aa9a33d0e5ceecb[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/3Den-syntax-error[m[33m)[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon May 29 20:11:38 2023 +0100

    FCR Cfg tuning (#309)
    
    * Adding the existance of background noise into the fcr

[33mcommit 6e4a18d1556430c7c66deb87fac5200553ef5451[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon May 29 20:10:00 2023 +0100

    Added Sensor pos Cfg (#312)

[33mcommit 1536bcd2f31cb71c4877247743650839c35a7f19[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon May 29 20:08:29 2023 +0100

    Error Fix for missing nts/ants (#310)

[33mcommit ae63def45834ae19244253f2694d0abee4a7f4e3[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri May 26 00:27:14 2023 +0100

    Sensor Cfg Refactor (#306)

[33mcommit 88e555aed89b207589211dfa80c9739da809bdac[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri May 26 00:27:03 2023 +0100

    Lima Hellfire Guidance Fix (#305)
    
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit 8f72d09a7738562fc28cdff4d03a0763d5f701db[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu May 25 15:27:27 2023 -0500

    SFM Plus Feature Addition - Heading Hold (#302)
    
    * Fixes PID errors, adds altitude hold test
    
    * Implemented Altitude Hold and it's sub-modes: Radar and Barometric hold, also added required inputs for remaining FMC functions
    
    * Added comments, cleaned up spacing
    
    * Moved Attitude hold code to it's own function
    
    * Initial position hold implementation
    
    * Position hold implemented, direction of helicopter effects inputs, sort of works correctly
    
    * Added debugDrawCircle to try and debug position hold, reverted back to using velocity vs. position for position hold
    
    * Removed animation sources for cyclic, updated WCA to use attitude hold status, tuned pitch/roll PIDs,
    
    * Position hold now takes the average velocity and position error to maintain a position
    
    * Added an additional pid for position, disabled position hold
    
    * Fixed PID run math error, tuned attitude hold
    
    * re-tuned altitude hold after PID fix
    
    * deleted pid test values
    
    * formatting fix
    
    * Seperated FMC input from main torque input and assigned a given authority pitch and roll, tuned pitch/roll PIDs, clamped PID output for pitch/roll from -1 to 1
    
    * Added comments for clarity
    
    * Tuned the pitch and roll PIDs for attitude hold
    
    * Added HOVER DRIFT advisory
    
    * Fixed spacing error in UFD
    
    * fixed scope calls
    
    * Fixed UFD spacing...again
    
    * Updated Hover Drift advisory logic, added force trim logic to attitude hold
    
    * Commented out systemChats, will be needed in implementing Velocity Hold
    
    * Changes as requested
    
    * Formatting fixes
    
    * Added calculateSideslip function
    
    * Fixing Sideslip indications for slip ball
    
    * Fixed Advisory call for Att Hold, tuned trim ball, deleted comments from sideslip function
    
    * Added and tuned _rotorTorqueScalar
    
    * Formatting fix
    
    * Initial implementation of heading hold
    
    * Replaced magic number with config value
    
    * Implemented turn coordination
    
    * Added TW LOCK SEL advisory to assist with indicating when heading hold is active.
    
    * Expanded heading hold breakout values, fixed typo
    
    * Fixed sideslip calculation to make it more stable
    
    * Made sideslip error correction more explicit
    
    * Commented out systemChats
    
    * Changes as requested
    
    * Changes as requested
    
    * Reverted breakout value check
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit a22120556ab8eb181a34a0235b8a091132bd3372[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun May 21 23:14:37 2023 +0100

    Changelog Update 07/05/2023 (#274)
    
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit a3eb8740edd65f2d5254bd8e2cd0423c8e7043c5[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun May 21 16:52:01 2023 -0500

    Add Position Hold to SFM+ (#295)
    
    * Fixes PID errors, adds altitude hold test
    
    * Implemented Altitude Hold and it's sub-modes: Radar and Barometric hold, also added required inputs for remaining FMC functions
    
    * Added comments, cleaned up spacing
    
    * Moved Attitude hold code to it's own function
    
    * Initial position hold implementation
    
    * Position hold implemented, direction of helicopter effects inputs, sort of works correctly
    
    * Added debugDrawCircle to try and debug position hold, reverted back to using velocity vs. position for position hold
    
    * Removed animation sources for cyclic, updated WCA to use attitude hold status, tuned pitch/roll PIDs,
    
    * Position hold now takes the average velocity and position error to maintain a position
    
    * Added an additional pid for position, disabled position hold
    
    * Fixed PID run math error, tuned attitude hold
    
    * re-tuned altitude hold after PID fix
    
    * deleted pid test values
    
    * formatting fix
    
    * Seperated FMC input from main torque input and assigned a given authority pitch and roll, tuned pitch/roll PIDs, clamped PID output for pitch/roll from -1 to 1
    
    * Added comments for clarity
    
    * Tuned the pitch and roll PIDs for attitude hold
    
    * Added HOVER DRIFT advisory
    
    * Fixed spacing error in UFD
    
    * fixed scope calls
    
    * Fixed UFD spacing...again
    
    * Updated Hover Drift advisory logic, added force trim logic to attitude hold
    
    * Commented out systemChats, will be needed in implementing Velocity Hold
    
    * Changes as requested
    
    * Formatting fixes
    
    * Added calculateSideslip function
    
    * Fixing Sideslip indications for slip ball
    
    * Fixed Advisory call for Att Hold, tuned trim ball, deleted comments from sideslip function
    
    * Added and tuned _rotorTorqueScalar
    
    * Formatting fix
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit a6fc0c5320f9df2734d2b46eab480d7563b045a2[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 21 19:18:45 2023 +0100

    Rebuild slip indicator (#301)

[33mcommit 247fcb0d309239b9eb93431a4811afcc8ee42f13[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 21 16:33:33 2023 +0100

    Adjust column widths of UFD from 10|13|10 to the correct 9|13|11

[33mcommit 05b33cd4de4674dac39c51dfdd79a73f30b19df6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 21 16:32:28 2023 +0100

    Remove redundant spaces from WCA UFD messages

[33mcommit 56334683d3c5ec0784699dc6df5311f9de748809[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 21 16:28:55 2023 +0100

    Move padding of WCA UFD messages to code rather than the message itself

[33mcommit 287fd1ad0bd61f406830b6750666dbce3725ce8b[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Fri May 19 15:46:37 2023 -0500

    Add Altitude Hold to SFM+ (#293)
    
    * Implemented Altitude Hold and it's sub-modes: Radar and Barometric hold, also added required inputs for remaining FMC functions
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit fd0bafbc19fd6e2288dd680e803881c76c8aa51a[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 22:54:56 2023 +0100

    Change MPDs so acquisition source name can be set by script (#294)

[33mcommit 828f3c514e6fa033b2cf199cfed7ab9bae1626fc[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 8 13:22:51 2023 -0500

    Add Common PBO (#273)
    
    * Moves commonly used utility functions to a central spot. Can eventually break down into categories and move other utility functions here as well.
    
    * Created Util PBO, moved generic and functions useable by all mod assets into it. Not inclusive yet, but will be. Also added PID class start
    
    * changed name to common
    
    * Defined PID functions
    
    * Changed drawLine to debugDrawLine
    
    * Fixed replace error in debugDrawLine
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 2cd3a5c8aac1024e36d1e1edcbd32407c6b233b7[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 8 11:39:06 2023 -0500

    Fixed SFM+ Tabs (#292)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit ef928848fdd2a650fb52a9e9f2330dc67e7169fe[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 16:56:12 2023 +0100

    Remove tabs from fza_ah64_ihadss (#284)

[33mcommit b2cf6d18442a4af8cceee2d915813c9ca07458be[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 16:54:48 2023 +0100

    Fixed bugs in tab removals (#291)

[33mcommit 526592a6d0c85f5410b29d0331eb7c381d1e8cbb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:05:04 2023 +0100

    Remove tabs from fza_ah64_ku (#285)

[33mcommit 136d6967a9f326729cb1a7211da21f7aa34589f9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:04:45 2023 +0100

    Remove tabs from fza_ah64_mpd (#286)

[33mcommit f9a6e77756a29fb1c582501a26173d9f120e9c54[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:04:03 2023 +0100

    Remove tabs from fza_ah64_systems (#287)

[33mcommit b5ed745e97681824d2f924043f80bdacc20076c8[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:03:35 2023 +0100

    Remove tabs from fza_ah64_ufd (#288)

[33mcommit b75c897b1c7cb3e753b790ab26baf0915fbc8f8c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:03:14 2023 +0100

    Remove tabs from fza_ah64_weapons (#289)

[33mcommit d174bb543d00781f725eef09cc59801cc6c3f3ba[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 11:02:53 2023 +0100

    Remove tabs from fza_ah64_us (#290)

[33mcommit b7d9966f15c4d9e102f5888ae6384427bd86bb90[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 8 00:05:23 2023 +0100

    Remove tabs from fza_ah64_hydra (#283)

[33mcommit d3a3733979b21358f48d01dcbcc7c0a53edde8d9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 23:59:11 2023 +0100

    Remove tabs from fza_ah64_customise (#281)

[33mcommit 5478aede193038f8ffe08c0dd7de92f024e34d3f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 23:59:03 2023 +0100

    Remove tabs from fza_ah64_hellfire (#282)

[33mcommit 463974e5b1cf80bb42ab4d94322aae6954946cc3[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 23:22:52 2023 +0100

    Remove tabs from fza_ah64_crew (#280)

[33mcommit 035bff4a062ac115f8b8e29681dce7fc59c2b649[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 23:22:43 2023 +0100

    Remove tabs from fza_ah64_controls (#279)

[33mcommit 440870a6c2653703d995a9135ba7bbe4acac542a[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun May 7 23:22:33 2023 +0100

    Fixed flood lighting logic (#278)

[33mcommit f6a13826447f6a5631fcf359711d07520633ea98[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 22:58:43 2023 +0100

    Remove tabs from fza_ah64_cannon

[33mcommit fbb6b88f79b0eba607e137645805fc32a54a842f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun May 7 22:52:04 2023 +0100

    Remove tabs from fza_ah64_ase

[33mcommit a66bd7609bacfbdeb75d068eaa0b2552aa02ca40[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 19:51:24 2023 +0100

    Added missing semicolons from rpt errors (#270)

[33mcommit 97c29e96a6c6a2932cea301559feffb38a856571[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 19:51:17 2023 +0100

    Fixed missing includes (#269)

[33mcommit 0e01037ea59956f68c6d0c0c3f5610dda0d1975e[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 18:45:16 2023 +0100

    Remove tabs from fza_ah64_aicrew (#268)

[33mcommit 5cf2c25359a2451ad5517ce6be3c7d6e63d8fd21[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:04:36 2023 +0100

    Remove tabs from fza_ah64_controls (#266)

[33mcommit e196c82519121b46c434f06c5f1e5b02c1b79eb9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:03:39 2023 +0100

    Remove tabs from fza_ah64_cannon (#265)

[33mcommit 9b80c5dc9503366434672dd89b01fc51bc1c2391[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:03:33 2023 +0100

    Remove tabs from fza_ah64_audio (#264)

[33mcommit f9c44e6c9bc2229a81cd91d68cb9c85ae745b3b9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:03:26 2023 +0100

    Remove tabs from fza_ah64_ase (#263)

[33mcommit 8fdde06eeefd306973807fa1bd485809499e6461[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:03:20 2023 +0100

    Remove tabs from fza_ah64_aicrew (#262)

[33mcommit 045ac351e6215107737d36af7716c51a27a5985c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat May 6 17:03:06 2023 +0100

    Fix some files being in the 'addons' folder rather than 'Addons' (#267)

[33mcommit 6632b5f06bd136cdbbb1ae5d82635681b9f47918[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 15:29:12 2023 +0100

    Split out crew pbo (#261)

[33mcommit 24d1d116951e59525994f6a178fdbb612659fa3e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat May 6 08:49:44 2023 -0500

    Mpd ASE page update (#259)
    
    * Removes Radar Jammer, replaces existing ASE page w/ vanilla ArmA sensor page presentation
    
    * Deleted unused code, adjusted page display and updated graphics to be more generic
    
    * Changed Acq/Track box to a diamond
    
    * Updated sensor_b2e, systemConstants, replaced all specific ranges with generic ASE_DETECT_RANGE, commented out system classifications temporarily
    
    * Removed comments
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit c4552cab71093097017e80f22dae16f978a66031[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 14:27:53 2023 +0100

    Move misc weapon config to weapon pbo (#260)

[33mcommit 2fb72356651a47774516d684d123d11b1b988dae[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat May 6 08:04:35 2023 -0500

    MPD Add Load Status Page (#252)
    
    * Initial Page Configuration
    
    * Corrected missing headers
    
    * Completed DTU Loading Page
    
    * Changes made as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 0113211e9bedb94c84f358ad5faa0ae001d00555[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 13:52:40 2023 +0100

    Split ASE config into pbo (#258)

[33mcommit 6cf91e5a37e9d862eb5c526b60a119237f5fbcfb[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 13:02:30 2023 +0100

    Separate Hydra rocket config into separate PBO (#256)

[33mcommit 5bb885844aef7cf851622fde48f51cde56c6f94b[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 12:56:17 2023 +0100

    Separate M230 config to separate PBO (#257)

[33mcommit 020281d3a8d5cd5ab1d9abedd9380a594c243130[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat May 6 00:16:12 2023 +0100

    Separate hellfire into separate pbo (#255)

[33mcommit e586d459d3469647f6594224869a9cbccc95a52d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed May 3 09:37:51 2023 -0500

    MPD-ASE-Page Update (#253)
    
    * Removes Radar Jammer, replaces existing ASE page w/ vanilla ArmA sensor page presentation
    
    * Deleted unused code, adjusted page display and updated graphics to be more generic
    
    * Changed Acq/Track box to a diamond
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 5fb3b2a955d0dc6e882742af1fbc3fc97deafa10[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 1 13:57:07 2023 -0500

    Added missing point graphics, corrected default CM graphic, deleted FAA graphic entry (#251)

[33mcommit 3637468a488491920038b9d5ae52463c843b5538[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon May 1 15:32:16 2023 +0100

    Split out IHADSS into separate PBO (#228)

[33mcommit 1433e187ac3aa7c38553547333f2984a44c0b37c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 15:20:25 2023 +0100

    Fixed BR Icon Type not having a colour

[33mcommit 50ecfa95752c5c71d003a142a05cd6422ce0e965[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 15:18:30 2023 +0100

    Created IDENT dropdown for Eden DMS points

[33mcommit 7573ddbc54e343af5b6f813b6e6e888c561d8c46[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 12:31:09 2023 +0100

    Removed mapping for mpd icon colours

[33mcommit 4d808727aa2794eb6fea43d717c51e80ba431d25[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 03:50:24 2023 +0100

    Add the ability to create DMS points in the eden editor (#247)

[33mcommit 79c88ba64412f1042d29d233f90fc677e95359d7[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 30 19:05:57 2023 -0500

    FCR page Icon Draw fix (#244)
    
    * Moved magic numbers to core.hpp and replaced them with config values, added _rtrAirspeedVelocityMod value to replace magic number
    
    * Fixed to now prevent drawing of LOAL flyer icons and to ensure stationary targets don't render beyond 6km
    
    * Deleted blank icon definitions from FzaIconTypes.hpp
    
    * Changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit f951bd3259623541c5a1cdddf2fd32fec674372b[m
Merge: ceea992bd 4722a7901
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 00:57:50 2023 +0100

    Merge pull request #246 from AH-64D-Apache-Official-Project/helisim-seamless-collective-input-swap
    
    Fixed HeliSim Collective position not synchronising between joystick and keyboard and mouse

[33mcommit 4722a7901a426ab975489593348f53c6a4daa26d[m[33m ([m[1;31mupstream/helisim-seamless-collective-input-swap[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 1 00:51:07 2023 +0100

    Fixed HeliSim Collective position not synchronising between joystick and keyboard/mouse

[33mcommit ceea992bd4c90a3b05d748a2529b23cf7544b4c2[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 30 18:36:29 2023 -0500

    HeliSim-MP-Collective-Fix (#242)
    
    Fixes multiplayer collective error when in pause (esc) menu.

[33mcommit 47cd60421a3e117b2275434a9415faf6e5d596c3[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 30 16:56:21 2023 -0500

    Sound Enhancement Add ETL/VRS Sound (#245)
    
    * Added required calls in CfgSounds and added CreakingAirframe.ogg
    
    * Moved sounds to their correct location in config, added sound calls to simpleRotor
    
    * Made changes as requested
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 18d423ec92cd19c044477ee6a80e766acb29dab6[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 30 07:25:02 2023 -0500

    Moved magic numbers to core.hpp and replaced them with config values, added _rtrAirspeedVelocityMod value to replace magic number (#243)
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 147eef4f5efa0a6840c8ff0ab0bf709bf2959109[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 23 14:28:46 2023 -0500

    FCR Page Drawing Error Fix (#238)
    
    * Fixed FCR lobl/loal switchover point for the FCR page, fixed FCR draw error,
    
    * Removed systemChat
    
    * Deleted space
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit d36521371f4ca9a6e07b28e60d413f90d17c17b9[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Apr 23 06:45:23 2023 -0500

    SFMPlus - Simple Rotor (#232)
    
    * First commit
    
    * Updated rotor code
    
    * Simple rotor integration complete
    
    * Added airspeedVelocityScalar
    
    * Adjusted thrust scalar, started on power and torque outputs
    
    * Added induced power, profile power, inducedPowerScalar table, added clamp to induced velocity for ETL, rotor solidity, number of blades, blade chord, blade drag coef
    
    * Fixed induced velocity scalar to allow for 'mushing' and 'vortex ring state' when RoD exceeds 4800fpm (24.384m/s), corrected velXY to return the magnitude of the velocities
    
    * Fixed sign error with VRS value
    
    * Fixed induced power scalar code, adjusted inducedPowerScalar table values
    
    * Added keyboard support
    
    * Removed inducedVelocityScalar limit for testing
    
    * Removed inducedVelocityScalar completely, removed systemChat comments, VRS recovery is now possible
    
    * Added ground effect, added second thrustScalar, thrust and thrustCoef variables to better handle torque
    
    * Simplified thrustCoef to provide stable power output for the torque sim, fixed formula for calculating altitude in SFM+ engine code
    
    * Adjusted inducedPowerTable to get a more accurate cruise torque
    
    * Updated inducedPowerScalarTable to get cruise torque more accuate
    
    * Fixed 0 divisor error, fixed input so that a hydraulic failure will cause the collective to lock out, adjusted inducedPowerScalarTable, added min/max bladeDragCoef and connected them to profilePowerCoef
    
    * Added ETL and VRS camera shake effects
    
    * Added missing recompile flag for the simple rotor
    
    * Adjusted VRS camera shake values
    
    * Added new stabilator table, set gross weight to 18000lbs for testing, updated inducedPowerScalarTable
    
    * Updated heliSimStabTable (WIP), added global MASS, PA and TEMP variables for testing (set these in the console)
    
    * Continuing to tune stabilator and drag models
    
    * HeliSim drag table update completed
    
    * Finished preliminary stabilator table, deleted test variables
    
    * renamed rotor to simpleRotor, connected output to MPDs, added simpleRotorVariables, corrected SFM+ fuselageDrag table error
    
    * Added missing CfgFunctions call
    
    * Added newton raphson solver and replaced engine power calculation code
    
    * Corrected rtrPowerScalar
    
    * Added documentation headers, cleaned up comments and system chats
    
    * Added a check to allow the stabilator to schedule normally while using keyboard in HeliSim
    
    * Adjusted ground effect and airspeed velocity scalar values
    
    * Fixed main rotor rpm sources for electrical, warnings, engine page, etc to read from HeliSim
    
    * Cleaned up systemChats
    
    * Updated airDensityThrustScalar to use _dryAirDensity, added _rtrPwrScalarTable to correct for altitude changes to power,  adjusted _gndEffMod and _rtrThrustScalar_max
    
    * Removed system chats, reset everything back to normal after testing
    
    * Made requested changes
    
    * Corrected incorrect cfg calls and fixed newtonRaphSolver function call names
    
    * Added two new utility functions: getRtrRPM and drawLine
    
    * Fixed function call in fuselageDrag
    
    * Changed flightModel to fza_flightModel, general formatting fixes, fixed missing semi-colon error in fuselageDrag,
    
    ---------
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 5edf1398dfd55c25c28821b6b9f10b6c5e442368[m
Merge: 20e1e6cf9 1354ac334
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Apr 22 21:15:51 2023 -0500

    MPD Graphics Update Merge
    
    Mpd graphics update

[33mcommit 20e1e6cf9d0365831f7ed9c8d9610cc75d791710[m
Merge: 26d40b663 6b71e06e9
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Apr 23 03:14:37 2023 +0100

    Merge pull request #237 from AH-64D-Apache-Official-Project/fix-mpd-heading-tape
    
    Build custom version of the heading tape that doesn't use type=scale

[33mcommit 6b71e06e9fe060cc62129b8f1fc5d868f83e7bd5[m[33m ([m[1;31mupstream/fix-mpd-heading-tape[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Apr 23 02:57:07 2023 +0100

    Build custom version of the heading tape that doesn't use type=scale

[33mcommit 1354ac334eeb764f02fc0c4526bf22096710e2e0[m[33m ([m[1;31morigin/mpd-graphics-update[m[33m, [m[1;32mmpd-graphics-update[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Apr 22 09:54:45 2023 +0100

    Fixed FCR icon rendering

[33mcommit 26d40b6630d22de95105a6ab25933b34b7714229[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Apr 18 22:49:06 2023 +0100

    Forced manual fire mode on before changing magazines (#235)

[33mcommit 9ebf45c238c10e5686ba1f44fa3613c49dd78d70[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 3 01:59:43 2023 +0100

    Ace Interaction & customization integration (#209)
    
    Creating of Misc PBO to House Ace interact & customization additions
    Addition of Ace interact points -
    
    on the tail to set a five-figure tail number
    on the door handles to open the doors
    on the fire control radar to add and remove It
    on the body of the apache to install IAFS or 1200rnd Magazine
    Creation of Empty objects
    
    Internal Auxilary fuel system
    1200 Magazine
    Fire control radar
    Fix for Total fuel on the fuel page fix

[33mcommit 0e5b331311ed9acdeb4e49c75f68febece13790f[m
Author: BradMick <bradMick@example.com>
Date:   Mon Mar 27 07:25:27 2023 -0500

    Tweaks to icon text positioning

[33mcommit abafa90eb97f9590070b79c44660239c865dd6ee[m
Author: BradMick <bradMick@example.com>
Date:   Sun Mar 26 17:38:46 2023 -0500

    Added Artillery Firing Point Graphics, FCR still doesn't render

[33mcommit 4f16e2c42c2ac5ceeabb9290cb2a28fa3fb444eb[m
Author: BradMick <bradMick@example.com>
Date:   Sun Mar 26 17:06:09 2023 -0500

    Finished Texture Update, FCR Icons do not draw!

[33mcommit c559baa539dcb502241455d4d9df3f764e8a116a[m
Author: BradMick <bradMick@example.com>
Date:   Sat Mar 25 14:11:33 2023 -0500

    Texture Update in Progress

[33mcommit fe56931b7962f9b825d7fe8d12f975ceef240066[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Mar 14 22:00:37 2023 +0000

    Ace map flood lighting (#227)
    
    cockpit flood lighting now affects the map lighting

[33mcommit 557a342ddf103aa95be31f43a9326f2b6f95c3bb[m
Author: BradMick <bradMick@example.com>
Date:   Sun Feb 5 19:51:13 2023 -0600

    Replaced textures, updated configs
    
    TO, TU, WL, WS and ALL ASE and FCR Icons need replacing.

[33mcommit 9331ac8ea07aaf9150544532e2abe71c614c32fc[m
Author: BradMick <bradMick@example.com>
Date:   Fri Feb 3 12:22:05 2023 -0600

    Deleted PNG files to save space, replaced IDM, Enemy and Friendly Control Measure icons, Fixed icon scaling and display of text

[33mcommit 631a4b49e885c5f764eb95e9e7a594ae1dbc17d1[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Logic-Flood-Lighting-Fix[m[33m)[m
Merge: 5464b618e 3bd93811d
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Feb 5 10:56:59 2023 -0600

    Merge pull request #226 from BradMick/mpd-enhancement-font
    
    Replaces existing font with BradMicks Custom Apache Font

[33mcommit 3bd93811de613679e266b8084396df4683d6f9fc[m[33m ([m[1;31morigin/mpd-enhancement-font[m[33m, [m[1;32mmpd-enhancement-font[m[33m)[m
Author: BradMick <bradMick@example.com>
Date:   Sun Feb 5 09:47:24 2023 -0600

    Correction to arrow draw code

[33mcommit 948653ef935ec8fbf0db4f9b6d9901f61084e731[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 15:07:41 2023 -0600

    Corrections made to areas needing correction
    
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit cfe57575d1c4e1410f12e93471432d6873d44dba[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 13:46:05 2023 -0600

    Added ignore entries to validator

[33mcommit c7c2c8b7276e761d0c5d767915faece8ca81fc69[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 12:47:03 2023 -0600

    Replaced RSC font with custom font

[33mcommit 08049c87e8986e5b20b210c1c2c32df5d9afb2c7[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 12:42:28 2023 -0600

    Fixed scaling issues with the new font

[33mcommit 689a13617ac7ffa0b1dcf306a24467094e6916de[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 12:23:28 2023 -0600

    Replaced current font with new font

[33mcommit 0a3c7bfccf6a83821e2d641da3b215967542df1e[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 4 12:15:56 2023 -0600

    Adds Custom Apache Font made by BradMick to the Mod

[33mcommit 5464b618e7c5cd6fe4ad6289bba62ffe3855cb3b[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 3 01:55:42 2023 +0000

    Increased the size of button activation (#225)
    
    Increased the size of button activation

[33mcommit f2fb44112885629097820aa01f1fa12e4f468369[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Feb 3 00:56:26 2023 +0000

    Improved description of Menu/B1 key

[33mcommit b4772dfb9790a20d3118023274a2cdb07179ccb9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Feb 3 00:49:10 2023 +0000

    Revert "Fixes #214 Fixed situations where the MPD M key is mistakenly described as B1 (#216)"
    
    This reverts commit 3010b2d04355bc7fed731a8f3f7dce64732b4cbe.

[33mcommit 08ad908c78795fd62b3b7c24b4927ae964820c27[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Feb 3 00:38:16 2023 +0000

    Initial implementation of MP pylon swapping function (#223)

[33mcommit 53e3893f46c05ca860d2da174a3a3b828293d55d[m
Merge: 07847d7da 2e37bc2ef
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Feb 2 00:41:26 2023 +0000

    Merge pull request #222 from BradMick/mpd-pboprefix-fix
    
    Fixed fza_ah64_mpd pboprefix so that it would create a correct symlink

[33mcommit 2e37bc2ef31e756eca4cdb7e161bb0ed5d36e85e[m[33m ([m[1;31morigin/mpd-pboprefix-fix[m[33m, [m[1;32mmpd-pboprefix-fix[m[33m)[m
Author: BradMick <bradMick@example.com>
Date:   Wed Feb 1 18:38:06 2023 -0600

    Fixed fza_ah64_mpd pboprefix so that it would create a correct symlink

[33mcommit 07847d7da2d7f08bc6a64a562e65df83b06b3798[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Feb 1 23:03:02 2023 +0000

    Audio Function Update (#198)
    
    Created audio database of all clips required
    Rebuilt audio prioritisation system
    Simplified audio play system
    ---------
    Co-authored-by: Matthew Smith <mattysmith22@googlemail.com>

[33mcommit 4ed6fb9798fd1b39407ffc372cd46b20f18a7a37[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Feb 1 22:50:56 2023 +0000

    Added MPD, UFD & KU to the Gunner's seat (#221)

[33mcommit 91eb401575428aa86e789d56617e932591a0e02c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Feb 1 22:38:39 2023 +0000

    Moved all setObjectTexture commands to use new v2.10 syntax (string rather than numerical keys) (#220)
    
    Co-authored-by: Rosd6(Dryden) <Doolieollie@gmail.com>

[33mcommit 70686f9a055732d619150a22b41992668a736f46[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 30 21:41:00 2023 +0000

    ACE Laser & Hellfire (#204)
    
    * CODE, CHAN & FREQ pages added to displays
    * Integrated ACE laser
    * Integrated ACE missile guidance
    
    Co-authored-by: Rosd6(Dryden) <Doolieollie@gmail.com>

[33mcommit f8919f6c228249b0405ca9d665e3d15a66f5953d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 30 19:13:15 2023 +0000

    Added r2t tsd icons (#219)
    
    * Rebuilt paa files for MPD icons
    * Initial R2T TSD setup
    * Added a new back face to all four MPDs to support the MPD update
    
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 4df12fa05bbff4695fff22ba9b8f8db928da23e2[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 29 15:35:14 2023 +0000

    Add validation to ensure that all files follow the correct naming scheme (#218)

[33mcommit 9d9b9b34a91f628bbe225d29d22e80798924f82d[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon Jan 9 16:11:03 2023 -0600

    Replaces ARMAs helicopter drag with a custom solution (#213)
    
    * Added custom drag, environment (for air density), adjusted input, ready to tweak and tune the drag model
    * Battery Timer Updated to 12 minutes
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 3010b2d04355bc7fed731a8f3f7dce64732b4cbe[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 8 23:06:02 2023 +0000

    Fixes #214 Fixed situations where the MPD M key is mistakenly described as B1 (#216)

[33mcommit d1d878c16f9bf73eeeb98fa90a0b3b4ae7498a72[m
Merge: f52b26ee7 eab020c5d
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Dec 11 22:48:48 2022 +0000

    Merge pull request #212 from Ollieollieolllie/Weapons-Pbo-Creation
    
    New Weapons Pbo creation

[33mcommit eab020c5dd6c766137010a19b6670c2fba9b47cc[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sun Dec 11 22:46:12 2022 +0000

    Init

[33mcommit f52b26ee70603d2edac1272cd84025f102547887[m[33m ([m[1;32mfeature-addition-newpointsystem[m[33m)[m
Merge: 5c4cbc4b5 49da81084
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Oct 18 19:56:34 2022 -0500

    Merge pull request #207 from BradMick/feature-config-scopeChange
    
    Changed fza_ah64d_b2e_nr scope to Protected

[33mcommit 49da8108411e299523d4babb21a0c114e6d452c5[m[33m ([m[1;31morigin/feature-config-scopeChange[m[33m, [m[1;32mfeature-config-scopeChange[m[33m)[m
Author: BradMick <bradMick@example.com>
Date:   Tue Oct 18 19:40:08 2022 -0500

    Changed fza_ah64d_b2e_nr scope to Protected

[33mcommit 5c4cbc4b5a007d80c64a238df2445073bd0b669a[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue Oct 18 19:07:10 2022 -0500

    Split CfgVehicles Components (#205)
    
    + Broke out CfgVehicles into individual component parts for readability and ease of use.
    + Added required include for hitPoints.hpp to be called from fza_ah64_systems
    + Added HeliSim config
    + Broke out ACE, ITC Air, Marker Lights and Reflectors into their own .hpp files
    + Deleted fza_ic_box.p3d
    + Deleted references to fza_ic_box in model.cfg

[33mcommit 6fdbfc4530eed734bf1ec1e43d86920d4ce63516[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Oct 2 11:13:08 2022 -0500

    Performance Page, Aircraft Performance and Damage Update (#199)
    
    Performance Page, Aircraft Performance and Damage Update #199
    
    * Added British Mission Equipment
    * Complete rebuild of the damage/hit point system
    * Added electrical and hydraulic systems and failures
    * Added performance page and updated tables from -40 to 40 deg C and 0 to 8000ft PA
    * Implemented Hatchet rotor RPM limiter
    * Updated WCA page displays
    * Updated audio system for new WCA's and to prevent constant rotor RPM low annunciations
    * Refreshed textures for all aircraft
    * Added custom tail numbers (settable in the 3DEN editor attributes)
    * Added Indian Air Force Livery
    * Added sensorPos memory point for future FCR update
    * Changed initial rotor positioning to match actual aircraft rotor positioning when at rest

[33mcommit e1299910c2657b3ef0097003bad0c8be9b7e5dc9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Sep 29 14:31:46 2022 +0100

    Improved SCons to autodetect PBOs and be more reliable (#201)

[33mcommit dfd51d7ede401b3bf5a2c6f5b242cb599d036d48[m
Merge: 7fd46ae2e 9c8a56d09
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Sep 18 17:37:50 2022 +0100

    Merge pull request #197 from Ollieollieolllie/Cscope-correction
    
    Addition of NTS & ANTS in Cscope

[33mcommit 7fd46ae2ec7d2c009dc933c62f5e6f0ad47d00e8[m
Merge: e3802cbdd eb9d0a71f
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Sep 2 22:55:01 2022 +0100

    Merge pull request #196 from Ollieollieolllie/Ase-Audio-Controller
    
    ASE Audio Controller

[33mcommit 9c8a56d09ffe1aff6cf3e65c62ab663e99e376a4[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Sep 2 21:51:07 2022 +0100

    Brads enlightenment

[33mcommit eb9d0a71fcf619aa58b02b19b53b7465e9f94bf1[m[33m ([m[1;31mgithub-desktop-Ollieollieolllie/Audio-Ase-Controller[m[33m, [m[1;31mgithub-desktop-Ollieollieolllie/Ase-Audio-Controller[m[33m)[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Wed Aug 31 20:03:42 2022 +0100

    audio update

[33mcommit c5677e418463780c99b9ff5ee22cb82c0a77a40e[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Wed Aug 31 19:38:44 2022 +0100

    Audio additions

[33mcommit ba4e097e23ad5208fe79d40d93e9d4042dfda1c2[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Wed Aug 31 00:07:34 2022 +0100

    Finishing touches

[33mcommit 6fcaa617a1fbff72ca5344624fd297e2d7fe45b2[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Mon Aug 29 23:52:35 2022 +0100

    Initial function

[33mcommit e3802cbdd95b3129f3ac8a3081d7b55942856c70[m
Merge: f36a6a09a fb7de6005
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Aug 28 18:04:04 2022 +0100

    Merge pull request #194 from AH-64D-Apache-Official-Project/feature-tsd-center
    
    Added persistent state to MPDs and TSD Ownship centering

[33mcommit fb7de600513d2ac67b8c26f73fd199b557faf95c[m[33m ([m[1;31mupstream/feature-tsd-center[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Aug 28 17:46:43 2022 +0100

    Added persistent state to MPDs and TSD Ownship centering

[33mcommit cfa676301ad3fa63c6a29ad954c2677acf6b441a[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Aug 27 20:14:53 2022 +0100

    Waiting on betty audio

[33mcommit f36a6a09acd24fb2772cfb6368bc7e5a9a3cd07d[m
Merge: 9939df247 8e11bd00f
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 27 19:58:06 2022 +0100

    Merge pull request #192 from AH-64D-Apache-Official-Project/bugfix-rpt-errors
    
    Removed some RPT errors and an error-popup

[33mcommit 8e11bd00f163b93ab872ba7709d6f94a2aef7fb6[m[33m ([m[1;31mupstream/bugfix-rpt-errors[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Aug 27 19:52:58 2022 +0100

    Removed some RPT errors and an error-popup

[33mcommit 9939df247265e3a1dd4da5e51685be68ff47b387[m
Merge: 6050514da 9f60c07c2
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 27 17:21:03 2022 +0100

    Merge pull request #191 from AH-64D-Apache-Official-Project/feature-tsd-hsi
    
    Added HSI to TSD

[33mcommit 9f60c07c2985cf2c229a091d5f5b9a8379e9d3a6[m[33m ([m[1;31mupstream/feature-tsd-hsi[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Aug 27 17:09:12 2022 +0100

    Added HSI to TSD

[33mcommit 6050514dafafd7d9d7f7f72ddc675a61ce33e1f0[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 27 11:02:05 2022 +0100

    Deleted unused files (#187)

[33mcommit 1b281732bd814fd1eec8cecc51679c5b7e64c169[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 27 01:29:51 2022 +0100

    Correcting pnvs Settings for A3 TI Dev Update (#183)

[33mcommit 546d268af3abbe3661d144b13e7f3cc8df68736b[m
Merge: d87ea5261 1a3d5a04d
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Aug 27 01:27:43 2022 +0100

    Merge pull request #159 from mattysmith22/feature-config-mfd2
    
    Migration to config MFD

[33mcommit 1a3d5a04d846c96e1c79ada1e6996e4cb7185788[m
Merge: 64d8eb782 d87ea5261
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Aug 27 01:24:33 2022 +0100

    Merge branch 'master' into feature-config-mfd2

[33mcommit 64d8eb7827cf4604fea9a8529a8cfb0e4674c86f[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Aug 27 01:13:10 2022 +0100

    Review changes

[33mcommit 5be0f828c54245940aac9559f65e33d5b447c2e0[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Aug 27 00:48:36 2022 +0100

    Updating Missile detection

[33mcommit fea4e256b1207686a78070562d5f1f71feac88f9[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Aug 27 00:42:24 2022 +0100

    prt fixes

[33mcommit de3af4fc483295c6b5fee3bf095a07f86912c84e[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Sat Aug 27 00:11:50 2022 +0100

    Review Changes

[33mcommit 6e989f22475d35caa4f9dd8363d784d9a583112f[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Aug 26 23:29:30 2022 +0100

    PR review Changes

[33mcommit 52e8a06358ae59fb56bc02a1e443924df86f16bd[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Aug 26 05:14:14 2022 +0100

    Flyer Icon, Lima logic v2
    
    The addition of the flyer icons to eleminate errors
    Addition of Advanced Scripted seeker logic for Lima as stand in till ace hellfire is integrated

[33mcommit a30c5b2ae0c93db263e28bb4f2fffd85afb5d3db[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Fri Aug 26 05:12:10 2022 +0100

    Flyer Icon, Lima Logic V2

[33mcommit cff3d63ba3940911f93fa51c7ae1b3efbe0eb4f0[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Tue Aug 23 01:53:26 2022 +0100

    Fixes

[33mcommit d87ea5261e6e60a7843dcf49645e0451ab284346[m[33m ([m[1;33mtag: [m[1;33mv2.1.1[m[33m)[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Aug 22 23:40:42 2022 +0100

    Fixed anti lift issue during autorotation (#186)

[33mcommit 53e49461fe9f00a8c1cd01734574105e57c67b06[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Mon Aug 22 22:37:24 2022 +0100

    Cscope Deleting fix

[33mcommit f749098e59db0202281d0fdf85fecff17644e93e[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Mon Aug 22 20:55:44 2022 +0100

    System chat removal

[33mcommit 57b0a33aae44d76c6c6a6921b26545fdc11432ca[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Thu Jul 14 03:34:15 2022 +0100

    fix

[33mcommit 424f8e906b37fd85b487876fb776a423ff67a3bb[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Mon Aug 22 22:15:38 2022 +0100

    Lima Loal Logic

[33mcommit 56acc496d442f89480ac33bd9722a7336fe0ecf9[m
Author: Rosd6(Dryden) <Doolieollie@gmail.com>
Date:   Mon Aug 22 00:32:14 2022 +0100

    Cscope & FCR page
    
    Creation of the cscope coding
    fix for the fcr page icons persistancy

[33mcommit 0fc3437a13fb23b5083a8185daba1dfc45aae44d[m[33m ([m[1;33mtag: [m[1;33mv2.1.1-rc2[m[33m)[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Jun 28 10:53:16 2022 +0100

    Syntax fix (#184)

[33mcommit 56c71baa9e520ab12b1170801c48586275b80eeb[m[33m ([m[1;33mtag: [m[1;33mv2.1.1-rc1[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue May 17 00:55:56 2022 +0100

    Allow user to set non-default fuel if they manually override

[33mcommit f73ac564bff22ee04f9081df3bc3987dee38a898[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Mon May 16 18:36:34 2022 -0500

    Initial Commit (#182)
    
    -Removed damage incurred from flying around with the power levers at idle.
    -Implemented a negative lift force to prevent the player from taking off (leaving the throttle maxed for appx 3 seconds will cause a 'spring board' effect and cause the aircraft to crash)
    -Added forcePos to enable antiLift function

[33mcommit 8a7c11e96ea07dc415e77d7d026a0b6826867f67[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon May 16 23:41:41 2022 +0100

    Website loadout configuration import (#181)

[33mcommit ba2a55b8df498ccfa03f44e2354cbd944f2ac75a[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 11 23:26:11 2022 +0100

    Missile warning fix

[33mcommit bc498b63e970d52ce2ca95418d992973a816e88c[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 11 23:25:06 2022 +0100

    Weapon Action Switch System fix

[33mcommit d2f24fd600a70c1a15684c0f0b2278f117496eff[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 11 23:22:26 2022 +0100

    Ace Hitpoint System

[33mcommit 88cf41883b93fb98251b914ae5f598712eed93d8[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 9 13:19:41 2022 +0100

    New AAC Textures (#167)

[33mcommit abc4abf446421198c3dce3c1e474ab5a29d5dc01[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 9 13:13:09 2022 +0100

    Analogue Flight instruments calibration. (#165)
    
    * speedometer, barometer now calibrated
    * artificial horizon bank limited due to weirdness. might need removing
    * texture fix for the compass.

[33mcommit dca1bc30ba7432bff8d04bba8a9b3cd3b4ca7264[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 9 12:39:28 2022 +0100

    Changelog update (#176)

[33mcommit 609cf216abd367776f83a4636bfcf9d9cad2b708[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sun Feb 20 19:26:35 2022 -0500

    Update Readme.md (Project title)

[33mcommit 9519bb8f67cd551cc5ee8e84e0087a91df513c0a[m[33m ([m[1;31mMPDUpdate-Merge/feature-config-mfd2[m[33m, [m[1;32mfeature-config-mfd2[m[33m)[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 19 09:30:13 2022 -0600

    Formatting Fix

[33mcommit fea6dca89946f16f972dde6952d306d2a07c73af[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 12 15:41:55 2022 -0600

    Update
    
    Fixed TSD texture issue, TSD objects now display transparency.

[33mcommit f7923a21a5ca5076583a3b992736340835039923[m
Merge: 10a0c1483 6341ca010
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 12 14:16:28 2022 -0600

    Merge branch 'master' into feature-config-mfd2

[33mcommit 10a0c14837e4b30cd9d737fdbd2db40c900e9b33[m
Merge: a661246c1 a2142efc0
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 12 05:54:20 2022 -0600

    Merge branch 'master' into feature-config-mfd2

[33mcommit a2142efc0dad46483a1ad4babbe39ebaf1b12d76[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 11 21:02:43 2022 +0000

    Start switch animation update

[33mcommit 4e1cec412b8c5a4f2dcb951e2772f8b294d9bc44[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Feb 11 19:28:40 2022 +0000

    Service Ceiling adjustment from default
    
    maximum of 19,960 feet ASL

[33mcommit a661246c1403431126a34bb4be5893b53c9ec3ab[m
Author: BradMick <bradMick@example.com>
Date:   Thu Feb 10 08:09:37 2022 -0600

    Fixed aftFuelCellWeight data source

[33mcommit 972eb2203aa616a8e0e402b36eb9ae6444c5b68f[m
Merge: 8db5539ed ffaeb7eaf
Author: BradMick <bradMick@example.com>
Date:   Thu Feb 10 06:32:18 2022 -0600

    Merge branch 'master' into feature-config-mfd2

[33mcommit ffaeb7eaf8165f368127fcb1b9c9b4722a5fc690[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Feb 9 22:06:59 2022 +0000

    IHADSS power Change (#171)
    
    IHADSS automatically powers on

[33mcommit 9fae0d95916dc72d0094a8f2f677fc0d2074a3cd[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Feb 9 21:25:16 2022 +0000

    Incoming missile duplicate warning fix (#170)
    
    Remade check for duplicate IncomingMissile EH

[33mcommit 8e900c43d6e45660d1258d78d6ca2654c1f389c1[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Feb 9 21:16:25 2022 +0000

    Dead CFG Removal

[33mcommit 35c55e7b8d7cad89c98fcbb08d4d04d384bc1a71[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Feb 9 21:09:01 2022 +0000

    Fixed uninitialised aircraft breaking fn_animReset.sqf (#174)

[33mcommit 8db5539edf27b66fff075d0285fdec9368c52c56[m
Author: BradMick <bradMick@example.com>
Date:   Tue Feb 8 09:20:54 2022 -0600

    Updated Magazine Weights

[33mcommit 5ab64f62e1d3ea7e92390183138c396b42e6da05[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 5 20:33:57 2022 -0600

    Update
    
    Fixed merge conflict oversight in coreGetWCAs

[33mcommit 4bfe69e3543e929fe142146f843e3aada144be3b[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 5 20:23:31 2022 -0600

    Update
    
    Fixed merge conflict oversight in cfgVehicles.

[33mcommit cde1b68cefcca51d2fab73ed267a8d1d52111f9b[m
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 5 19:49:27 2022 -0600

    Update
    
    Fixed merge conflict oversight in SFM+ engine and getInput

[33mcommit cca741a314304e8a6526e954a23861751596101d[m
Merge: b9617ae6c a1a26f662
Author: BradMick <bradMick@example.com>
Date:   Sat Feb 5 19:04:25 2022 -0600

    Re-Base
    
    Rebased feature-config-mfd2 to master. Should now be at parity with the current master.

[33mcommit b9617ae6cf2c7352cef04c59883e08a0f9b890b3[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 31 10:48:21 2022 -0600

    Wiper Bar Fix
    
    Fixed an issue where the wiper bar wasn't displaying and when it did, not displaying the right color based on mode.

[33mcommit 0f216602d2400e952dc5a5a4dfa954dcf0024f9f[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 31 07:17:29 2022 -0600

    Update
    
    Fixed the FCR animation. It's still to fast, but that can be adjusted later.

[33mcommit a1a26f662dd21fcb0cbcbd7b63a8ccacc084ea3d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 30 22:16:03 2022 +0000

    Animation state override (#163)
    
    * Migrated important state to variables rather than animations

[33mcommit a66c63c4ae4de041a16558702a0e71c584bd245e[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jan 30 22:12:59 2022 +0000

    Animated Horizontal stabilizer (#156)

[33mcommit 1420f3086f9d25a6c05508f54dd913fc70caf96e[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Jan 30 16:12:38 2022 -0600

    Robbie Tank and Default Magazine change, Default Fuel Adjustment (#162)
    
    * Made 300rnd M230 magazine the default
    * Added Robbie (IAFS) tank
    * Added Robbie fuel amount to fuel page
    * Set default fuel amount with IAFS to 58%

[33mcommit 2d1b1bdcc12349b12f6e4088911ca67683a0c75c[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 29 18:55:17 2022 -0600

    SFM+ Default Fuel, Performance and Damage Locality Update (#158)
    
    * Added a config entry that sets the default fuel fraction for the aircraft to 22%, this ensures the aircraft will always have OGE hover power without modifying the aircrafts existing loadouts.
    * Updated SFM+ Perf Data and added a Performance Class to calculate values.
    * Fixed locality issue where gunner's high simulated torque could cause the aircraft to be damaged
    * Shifted Hover TQ IGE and OGE to the PERF function, since that's where it should be.

[33mcommit 171f78bf49e6b61f738f0fb60a2a1579f05d1ed4[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 29 17:35:58 2022 -0600

    SFM+ weight, damage and torque table fix (#154)
    
    Fixed weights in CfgMagazines so they're accurate, updated damageApply to make it more modular, updated engCruiseTQTables
    Adjusted collectiveOutMod to limit torque after table adjustments.

[33mcommit 6a750816438db57b33f4cc5121942fb5ee455be1[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Jan 29 17:28:46 2022 -0600

    Power Lever Exploit Fix (#146)
    
    If the power levers are at idle, indicated by IDLE rotor RPM, and the aircraft is off the ground, then damage is applied to the transmission.

[33mcommit e309039bf1e9db94a538197927014c1a4573c086[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 24 11:37:12 2022 -0600

    Update
    
    ASE page animations are complete, and new ASE framework is complete.

[33mcommit ef02088cca24aff2551cecfabcb5c461319688f0[m
Author: BradMick <bradMick@example.com>
Date:   Fri Jan 21 22:03:01 2022 -0600

    Update
    
    Created the framework for the updated ASE system, got the RLWR working with MPD input.

[33mcommit 3390fdc13cdfae85ef2c47ec3b08ede26685c92c[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 17 23:53:11 2022 -0600

    Update
    
    Completed ASE page interaction logic.

[33mcommit 038232d35cd4e43e42c2ffda4ea394583095c70c[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 17 19:25:49 2022 -0600

    Update
    
    Renamed textures, approximately 80% complete with FCR page.

[33mcommit fe36f81f9799a02672763a4df5e8dbe89c648467[m
Author: BradMick <bradMick@example.com>
Date:   Sun Jan 16 22:02:23 2022 -0600

    Update
    
    Working on FCR page.

[33mcommit a3e53f7dc0b5dec3f73ba4ccb445ddd16f0e93d5[m
Author: BradMick <bradMick@example.com>
Date:   Sat Jan 15 15:49:27 2022 -0600

    Update
    
    ASE icon drawing is complete.

[33mcommit b9fff92522d6efdb28e4f67c8b9165e02480cfe8[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Jan 15 17:10:21 2022 +0000

    Hide vanilla UI (#152)
    
    Hides all vanilla UI when SFM is not set.

[33mcommit 6b9a623d115e1666b52ed9e91907afa574e1622a[m
Author: BradMick <bradMick@example.com>
Date:   Sat Jan 15 00:43:08 2022 -0600

    Update
    
    Building the ASE page

[33mcommit b03b97b8b1bfa371d6d08f1abf1169a9de823f71[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jan 15 01:41:51 2022 +0000

    Implemented more realistic FCR system

[33mcommit cc983774b43bb7facb15bd2da5827ae5735b95df[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 9 23:15:49 2022 +0000

    Added FCR Icons

[33mcommit f8c82daa564b69dfd188375c9ea1c3b5597dae4b[m
Author: BradMick <bradMick@example.com>
Date:   Thu Jan 13 14:13:20 2022 -0600

    Update
    
    Fixed the color for the lock wedge

[33mcommit 627388042905b2f47ddab4b97b3fcd69150d4628[m
Author: BradMick <bradMick@example.com>
Date:   Thu Jan 13 13:59:20 2022 -0600

    Update
    
    Implemented ASE page

[33mcommit a90db1e0e088b14ad4b47366a7e0bab8e7c2764f[m
Merge: 5fc975125 1625989e8
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 9 19:09:02 2022 +0000

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit 5fc975125ad502340c53b50c2bbec73e210f2dc5[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jan 9 19:08:42 2022 +0000

    Added RTE>DIR funcitonality

[33mcommit 1625989e8ca444d714f6a1f2d5f67132c36353cc[m
Author: BradMick <bradMick@example.com>
Date:   Sat Jan 8 11:09:58 2022 -0600

    Update
    
    Finished ASE page and started implementing the FCR page

[33mcommit 48092ea4ae664a5698576661998c4485ef7297a3[m
Author: BradMick <bradMick@example.com>
Date:   Fri Jan 7 20:33:02 2022 -0600

    Update
    
    Updated weapon weight and added graphics and icon types for the ASE page.

[33mcommit c245fae3d34c13fd152276477d7aa4b85e63e33d[m
Author: BradMick <bradMick@example.com>
Date:   Thu Jan 6 16:01:13 2022 -0600

    Update
    
    ASE page is nearly complete.

[33mcommit 347d4e0df41aeebc29d86d3a7d44faed91c39e10[m
Author: BradMick <bradMick@example.com>
Date:   Wed Jan 5 20:53:54 2022 -0600

    Update
    
    Further integrated SFM+ into the displays.

[33mcommit 540216f4b0e2b35a8559de4301c82ad6d72bf5f5[m
Merge: fa26fa412 c9fad44f8
Author: BradMick <bradMick@example.com>
Date:   Wed Jan 5 07:17:13 2022 -0600

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit fa26fa4121225fa276d06036a7c915ccc851d3f5[m
Author: BradMick <bradMick@example.com>
Date:   Wed Jan 5 07:16:56 2022 -0600

    Update
    
    Fixed bugs in SFM+ engine script.

[33mcommit c9fad44f8700671c453aef51dc2528e783fa227e[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Jan 4 21:40:11 2022 +0000

    Added missing PBOPREFIXes

[33mcommit 15feaf6a5bc12e48cdbf925dac3f05c4c2e6e08c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Jan 4 21:40:00 2022 +0000

    Added rte->dir functionality

[33mcommit 336ab65d75ff16e5c7a857124ac719c22aa30638[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 3 21:54:23 2022 +0000

    Removed debug trace

[33mcommit e9ac45fc1d42abb0a2c9124dfdb310cffe12e223[m
Merge: 861e26cd6 f53eacadb
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 3 21:53:11 2022 +0000

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit f53eacadbc8a7e75de8f311a5ca8c3eee9225566[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 3 15:52:14 2022 -0600

    Update
    
    Moved RTE page to new conditional system

[33mcommit a6eeeaed4cbd6e9c42b963a765e41525489997e0[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 3 15:45:15 2022 -0600

    Debug Fix

[33mcommit 861e26cd66989b1774aaf42d3ad20ee73608e23b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 3 21:44:39 2022 +0000

    Fixed incorrect THRT->WPT transferal on DEL page

[33mcommit df7ba46dea027243c19ad8239611452d8233a927[m
Merge: d60164123 b77479f7b
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 3 15:13:43 2022 -0600

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit d60164123edccd12d412674778a00b16bc3b771d[m
Merge: 5912f2b19 9f2346c64
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 3 15:10:32 2022 -0600

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit 5912f2b19e178812c86885222b4612b94a435ade[m
Author: BradMick <bradMick@example.com>
Date:   Mon Jan 3 15:10:18 2022 -0600

    Update
    
    FCR page is nearly finished

[33mcommit b77479f7bd23caab56867b8228db9ccd5f276a73[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 3 21:08:37 2022 +0000

    Built simpler condition building system

[33mcommit 9f2346c64f3ba6a47aeda4ea49af02a9db81ced2[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jan 3 17:48:19 2022 +0000

    Added additional documentation mpd_defines

[33mcommit 71892e0c6e9fcd98fa2f6b0e900d45fcecd71372[m
Author: BradMick <bradMick@example.com>
Date:   Thu Dec 30 14:09:46 2021 -0600

    Update
    
    Corrected UV issues on right MPD icons, continued work on FCR page, updated HandleControls for RTE, WPT, WCA, and THRT pages

[33mcommit 6d6baae5278af83057e10d39e6bfe70c02db9266[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 30 00:06:46 2021 +0000

    THRT page works

[33mcommit f486e0e76b9f039b5db2c03f0f705fe793f336dc[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Dec 28 16:27:11 2021 +0000

    Fixed bug with DMS data structure
    
    Co-authored-by: BradMick <BradMick@users.noreply.github.com>

[33mcommit bc0d2fa1ff5ddd540874a7c153b2d73fc0a58952[m
Author: BradMick <bradMick@example.com>
Date:   Tue Dec 28 10:00:11 2021 -0600

    Update
    
    Added FCR Page, THRT page and other things.

[33mcommit 37088699fb319af90e22486742ddb442166fba13[m[33m ([m[1;33mtag: [m[1;33mv2.1.0[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 23 22:05:05 2021 +0000

    Updated intro

[33mcommit a1518ee01c2a347931005d34529573ffbe1128b0[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 23 20:52:15 2021 +0000

    Updated hover torque values

[33mcommit d526d70e5f982ce8cdbede412860cbcdc98b6388[m
Author: BradMick <bradMick@example.com>
Date:   Wed Dec 22 16:48:15 2021 -0600

    Update
    
    Added THRT and RTE pages.

[33mcommit 44da7bbbe9e23ae1760b506519cba8fc9cd5b1d4[m
Author: BradMick <bradMick@example.com>
Date:   Wed Dec 22 07:51:20 2021 -0600

    Correction to Icon Types

[33mcommit c37c660a98b2bd8a3487121207f9a2bc341d5ae5[m
Author: BradMick <bradMick@example.com>
Date:   Wed Dec 22 07:28:47 2021 -0600

    Update
    
    Added FCR Icons and Textures

[33mcommit a3254587e71f9640b88ad4fcde417c5b16426006[m
Author: BradMick <bradMick@example.com>
Date:   Tue Dec 21 18:22:21 2021 -0600

    Update
    
    Updated Icons so they display the correct colors, updated the Icon Types and organized them by type, began laying the ground work for correct display of icons also based on the updated Icons.

[33mcommit 3dc725ce7a3933f5febe5ecfad0b8a999a1a02b7[m
Author: BradMick <bradMick@example.com>
Date:   Tue Dec 21 16:48:30 2021 -0600

    Update
    
    Many, many things...

[33mcommit f05da3eb26d5c1c7277c118a97d13f6ffd866f12[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 20 23:38:34 2021 +0000

    Added STO functionality

[33mcommit d5dc607c0ce765821502e805d4a7e702ccea8481[m
Merge: 290274f4c 8e35c9c1c
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 20 23:14:42 2021 +0000

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit 290274f4cc1fae7c7d3112bc2820ae5788128469[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 20 23:09:19 2021 +0000

    Packed together point type and point index to make a more complete "point id" value

[33mcommit 7e5bcb73c76d80981640a0fb5159c20715a2dff6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 20 22:56:51 2021 +0000

    Fix TSD icons being viewed in other pages

[33mcommit 032e4efa5df96951590b1cf8b9ab606499904d35[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Dec 20 22:42:22 2021 +0000

    Implemented WPT functionality

[33mcommit 8e35c9c1cdb09f5ab7457af17dc7392e4f141540[m
Author: BradMick <bradMick@example.com>
Date:   Mon Dec 20 08:00:59 2021 -0600

    Update
    
    Added barrier macros, udpated DMS and DTU pages to use them.

[33mcommit b07209ea12e6486ab5651ac22ca35810a4a2302f[m
Merge: 9a9bf5856 72dbeaa43
Author: BradMick <bradMick@example.com>
Date:   Mon Dec 20 07:13:21 2021 -0600

    Merge branch 'feature-config-mfd2' of https://github.com/mattysmith22/AH-64D into feature-config-mfd2

[33mcommit 9a9bf5856b9ea7182fb8269c831cc7b33f4b854f[m
Author: BradMick <bradMick@example.com>
Date:   Mon Dec 20 07:10:36 2021 -0600

    Update
    
    Added DMS, DTU pages, created cases for Barrier boxes, fixed fuel leak dependency so engine damage doesn't cause a fuel leak

[33mcommit 72dbeaa43aabb0e32082ebc738548dc0820d444b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Dec 19 21:00:00 2020 +0000

    Implemented initial data management system
    :(points storage only)

[33mcommit 4e7bf327eed53a0182538d11f13152dc4b47e79d[m
Author: BradMick <bradMick@example.com>
Date:   Sat Dec 18 08:18:29 2021 -0600

    Update
    
    Fixed TSD issues and corrected MPD power up behavior.

[33mcommit a38417c49552f4086487c3d67c85b1c67a234da3[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Dec 18 02:31:00 2021 +0000

    Implemented both MPDs

[33mcommit 3201442ea9386e97ef554c8fcf3fcb5c7e0604fc[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Dec 18 02:21:55 2021 +0000

    Fixed some RPT spam

[33mcommit 06f7a9838eabb89378802916f1ab2e33fd263a47[m
Author: BradMick <bradMick@example.com>
Date:   Fri Dec 17 20:15:42 2021 -0600

    Memory Point Fix
    
    Fixed the Pilot Right MPD Memory points

[33mcommit 813a9a42e8edea6409afc63a5594d76e0268aea2[m
Author: BradMick <bradMick@example.com>
Date:   Fri Dec 17 09:46:10 2021 -0600

    Update
    
    Completed the WPT sub-pages

[33mcommit 8d03c376eb791550a8c33582873c232f9d158025[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Dec 18 00:48:00 2021 +0000

    Implementation of all arma 3 MFD config up to 2021-12-18

[33mcommit 23de71c79f8c6cadbb113e9a41739ef55cdd2583[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Dec 16 23:56:21 2021 +0000

    Corrected weapon selection logic

[33mcommit de01097d9f838bf8dbd18e51c9344de124df7a7c[m[33m ([m[1;33mtag: [m[1;33mv2.1.0-rc3[m[33m)[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Wed Dec 8 08:19:26 2021 -0600

    SFM+ Engine Update (#143)
    
    # SFM+ Input Fix
    
    Switches the input handler to use the collective animation system. Additionally enables full keyboard use with SFM+ without having to enable keyboard only mode.
    
    Automatically switches between HOTAS and Keyboard input. Provides options for stabilator handling beyond just being on/off.
    
    # Complete re-write of the Engine System
    
    Rewrote the engine simulation, no longer relies so heavily on the input position to fix the start-up issue. Additionally added single engine failure based on engine damage.
    
    Adjusted the engine startup time.
    
    # Stabilator Update
    
    Adjusted the stabilator so that it will assist in maintaining 90 knots when using the keyboard.
    
    Corrects the displayed torque so it matches the airspeed based on gross weight.
    
    # Overtorque fix
    
    Adjusted the output torque to better manage overtorques with the keyboard.
    
    # Code quality
    
    Deleted old code and systemChat
    
    Moved all configurable variables that can be over to sfmplus.hpp in order to separate code and data.

[33mcommit 4246f00efad135b0305d4f3a6029198eef12ff96[m[33m ([m[1;33mtag: [m[1;33mv2.1.0-rc2[m[33m)[m
Author: mattysmith2 <mattysmith22@googlemail.com>
Date:   Fri Dec 3 01:43:21 2021 +0000

    Reduced startup duration from 80 seconds to 45

[33mcommit 7ffa4ad9b598acdc76663537ad5abc6a07ee51e5[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 3 01:24:21 2021 +0000

    Rocket salvo Unreliability fix (#141)

[33mcommit baf5cf86b5d4393164db779aaf91349236d88b38[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Dec 2 11:14:33 2021 -0600

    SFM+ Input Fix (#142)
    
    * Switches the input handler to use the collective animation system. Additionally enables full keyboard use with SFM+ without having to enable keyboard only mode.
    * Provides options for stabilator handling beyond just being on/off.

[33mcommit f6b472c3c7948e98aa6011d2dd9fca8d0cbb5c4c[m[33m ([m[1;33mtag: [m[1;33mv2.1.0-rc1[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Nov 24 16:41:40 2021 +0000

    Revert "30 mm ace frag (#137)"
    
    This reverts commit 8be4b498b1c3d959e20244464138f294d61abb4c.

[33mcommit 8be4b498b1c3d959e20244464138f294d61abb4c[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 24 16:33:26 2021 +0000

    30 mm ace frag (#137)
    
    Added ACE Fragmentation

[33mcommit 3fce8729d70305e4cac9b3d9a3e64b741289b9aa[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Nov 24 16:32:52 2021 +0000

    Move engine simulation to be local but globally synchronised. (#134)
    
    Removed race conditions on engine simulation

[33mcommit 0326382d322c8704d8acf5e67444fc750a6cc456[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 24 12:29:33 2021 +0000

    Updated Hellfire Penetrator (#135)
    
    Updated hellfire penetrator to not be nerfed by ACE vehicle damage

[33mcommit 3f74ea1affa38bb808276c2ce4555376ea3fdd06[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 24 12:27:25 2021 +0000

    Jammer delay fix (#138)
    
    Added small 1.5s delay when moving a jammer from STBY -> OPER

[33mcommit bf6293a7dd69e2bffcc9db6a797c4113acf8424d[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Nov 24 12:26:34 2021 +0000

    removal of outdated setting (#139)
    
    Removed unused "Experimental FCR" setting

[33mcommit e808cbcf6c1d0c35ec5321ecbd97ea9475d6818a[m
Merge: c5d53b79b 7c00be4c3
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Nov 16 01:44:36 2021 +0000

    Merge branch 'feature-vanilla-controls' into master

[33mcommit 7c00be4c367b3eaf2b905159de28648c2eaffd46[m[33m ([m[1;31mMPDUpdate-Merge/feature-vanilla-controls[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Nov 16 01:32:57 2021 +0000

    Added missile advance

[33mcommit 26a24e19e25c1d48a5d790dcf003c51d82ade1bd[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Nov 15 21:05:18 2021 +0000

    Moved sight select to shift
    Fixed error in IHADSS code
    Fixed select fire mode function not being able to find some fire modes.
    Changed WAS code so it doesn't handle activate / deactivate manual fire

[33mcommit 42d49d9b1cc2227526842a696d76ab63b7946248[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Nov 7 00:40:37 2021 +0000

    Remove debug systemChats, fixed selected rocket and missiles not being configured correctly

[33mcommit c5d53b79bcb692b668665acac64b8c25a6ef63b4[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Nov 6 17:01:00 2021 +0000

    Fix flare texture path (#130)

[33mcommit 2367f823cae7f438c937e27d052f67e7d3c11bb2[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Nov 6 16:58:00 2021 +0000

    AI Crew Functionality, New default Gear, Armor Boost & Small fixes (#112)
    
    Engine AI
    ai can turn on engine through zues interface, being ordered to move & taking control and ordering engine on.
    ai turn of engine when commanded through zues interface, getting out & taking control and ordering engine on.
    ai engine start up should halt when the for mentioned engine off senarios occure
    optional AI controls in setting
    ai control of fire panel system
    ai response time to fire warning
    ai control of cockpit lighting (does not work with full ai crew)
    there is a ASE control option, not currantly modelled
    MISC AI
    ai will close cockpit door when getting in if open
    ai can use the 30mm, Radar hellfire & rockets (but ai will be stingy about using rockets)
    ai should know keep a suitable distance from each other when flying formation with another heli
    MISC
    the submunition deployment has been moved to cfg for more reliable results and so ai will use them
    potential fix for pnvs jitteryness @fred#2893
    Engine fires can know be put out by shutting down the relative engine, good for when you run out of fire extinguisher
    
    Firestation fix
    The Fire station know Is replaced by the repair of the engines, Left for Primary, Right for reserve
    the Fire panel arming lights are known synchronised between crew stations
    
    changes
    HELI ARMOUR, has been boosted 20% aswell as individual components getting a smaller increase
    the get in animation for gunner now matches the pilot
    door position can know be set in the garage menu for setting defaults

[33mcommit 1e8a74a56619a91c6bc995d606f053a9410267bc[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Nov 6 13:36:58 2021 +0000

    ARMA 2.06 Update, FCR & ASE Streamlining (#113)
    
    FCR and ASE systems moved across to using V2.06 functions
    Added passive RWR sensors

[33mcommit 2a23f82fd259c27d02b9b9001592d6cb3ba46f74[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Nov 5 17:08:09 2021 +0000

    Fixed:
    * Error when storing targets
    * Script error when hellfire selected
    * Waypoint cycling control
    * Flares not being operational from gunner seat
    * TSD ATK/NAV mode not working as expected

[33mcommit fe00f4580f76bb9b43c7408339d77464f76f8c30[m
Author: R3voA3 <robertseibel@outlook.de>
Date:   Sun Oct 31 16:46:47 2021 +0100

    Update waypointadd.sqf to use map click event handler (#126)
    
    * Update waypointadd.sqf

[33mcommit 6182bc2355ce64d2b961040ed7a30997892ac166[m
Author: Björn Dahlgren <bjorn@dahlgren.io>
Date:   Sat Oct 9 18:00:40 2021 +0200

    Fix texture path for cloudSmall1.p3d (#124)

[33mcommit 59509a0044e0bc36be7dbfb4b14e328b10a711bb[m
Author: Björn Dahlgren <bjorn@dahlgren.io>
Date:   Sat Oct 9 18:00:10 2021 +0200

    Fix config syntax (#125)
    
    fza_ah64_controls and fza_ah64_sfmplus can now be built with pboproject

[33mcommit 73926b7742b9ae10d6234a7e7c032f2ba429b6d0[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Oct 9 10:21:52 2021 -0500

    SFM+ Map Screen Fix (#119)
    
    Fixed helicopter simulation not working when in the map screen

[33mcommit 357f2d8e99b0a7ce69c55883919c7b7665092526[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Oct 9 15:46:40 2021 +0100

    Changelog Update (#122)
    
    * Updated Changelog

[33mcommit 763238d07f0bd5c5e30f47ca0db1f6a5da8d2809[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Oct 5 23:52:34 2021 +0100

    Added new build system
    
    Fixed bugs found from snow:
    
    * Single Scan times are now increased
    * Fixed symbology select down not working
    * Fixed IHADSS symbology not working
    * Fixed Hellfire Cycle
    * Fixed HF Trajectory not working
    * Fixed MSL selection not working on WPN page

[33mcommit 17e0ec743f341000e1c5ffac058285bd64498ab6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Sep 26 21:55:11 2021 +0100

    * Fixed syntax errors in scripts
    * implemented WAS logic
    * added all cockpit controls to individual controls

[33mcommit 9b74c409a1c4777d663f200d7a3e9cb2b40bdd0c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Sep 14 15:27:46 2021 +0100

    Fixes from tests with Bradmick

[33mcommit 39b0c6a625331a29d081b27c03b3986119cf61ba[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Sep 13 21:41:58 2021 +0100

    New readme

[33mcommit 79d1abbcff7e493fac6bffd8fe7a3cf5e20b0d38[m[33m ([m[1;31mmatt/feature-vanilla-controls[m[33m, [m[1;32mfeature-vanilla-controls[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Sep 13 20:30:40 2021 +0100

    Started custom weapons system controls

[33mcommit 4fd2ed9bcb884996f8b75a738b07680d3ab0cb36[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Sep 13 00:09:22 2021 +0100

    Added new keybinds

[33mcommit 129322cee993f106802aa52a70949cbb67a3450c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Sep 12 19:15:56 2021 +0100

    Fix to make it run as expected, after Snow's test run

[33mcommit 7e24d94a050b28e307d97ef4cfc778167379103e[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Sep 10 19:48:01 2021 +0100

    First implementation of v2.06 config controls

[33mcommit fe120adaad1388bc46fb7f14106d041828bd2474[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sun Aug 22 17:26:16 2021 -0500

    Sfm plus damage update (#107)
    
    * Added damage when aircraft torque limits are exceeded
    * Rewrote how torque is handled to make it more stable and 'true to life'
    * Rewrote how engine starts are handled so that the start is no longer bound to hard times, but can be initiated at any point after the start switch is taken to start.
    * Enabled split power lever operations (a.k.a. single engine operations)
    * Added APU fuel burn (175pph)

[33mcommit 249f3f18ee2192e88ddc8c1d865b6e0f395b9bf8[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Aug 9 11:37:15 2021 +0100

    FCR Acquisition & Los Fix (#83)
    
    Optimise and add Line Of Sight checks to the FCR

[33mcommit 94191622ade2e2d7aec989b337736c22d68c2a66[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Aug 6 00:05:15 2021 +0100

    Fire Extinguisher Replaceable (#100)
    
    Turns the fire extinguisher variable into an 2 ammo counts primary & secondary

[33mcommit 25be32d8b3fe0e73e42b4b4ccb617f34ebd1c129[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 23:48:03 2021 +0100

    Flare EFX change (#105)
    
    * Flare Improvement courtesy of Pingopete

[33mcommit 293384ba5faa2389606c9c2fa669ddb1c45a7759[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 23:39:29 2021 +0100

    Flood lighting (#106)
    
    Fixed the cockpit floodlighting using the Arma 3 searchlight which is attached to the gunner seat

[33mcommit 8c9206dc66383ee991c73cdab937691b29a0ae84[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 22:47:43 2021 +0100

    ASE update (#90)
    
    Replaced scripted jammer with invisible vanilla countermeasures for both IR & RF Jamming
    Removed automatic flare deployment
    Added script for gunner control flares ready for Arma 3 keybinding update
    Reintegrated jammer fail systems

[33mcommit 9890d73a6f20e520a04776c80a5f9a05d8aa2c13[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 21:06:34 2021 +0100

    Damage Cam shake fix (#97)
    
    Fixes airframe and camera shake brought on by damage

[33mcommit a2cc5f045a3b6f2468f11d20a7b37bc4ccd67928[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 21:05:15 2021 +0100

    Hellfire Stability (#95)
    
    Fixed hellfire oversteering causing targets to be missed

[33mcommit 596eaeafc8e693245ecc7478e1f7a9b6206dd729[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 21:04:18 2021 +0100

    Rocket salvo (#93)
    
    Fixed bug where when when shooting salvos it fires 1 hydra and 1 hellfire

[33mcommit 52ad984c5c4c9213e2b09ce649cc40c9e3195ad5[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Aug 5 20:41:37 2021 +0100

    Gun overheat breaking rearm fix (#92)
    
    Fixed a bug was caused by the removal of the magazine meaning there was no magazine to rearm

[33mcommit 5f4afdc548b2faca92b4d763a1888b07675ac8db[m[33m ([m[1;33mtag: [m[1;33mv2.0.1[m[33m)[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jul 2 19:45:15 2021 +0100

    Draw3d event handler fix (#85)

[33mcommit 95f8d2f32b295bb540e183058a9be338cd4c68bb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jul 2 19:21:39 2021 +0100

    Update issue templates

[33mcommit 87530fe45ab2c4a525d800d09450d5ae4818523e[m[33m ([m[1;33mtag: [m[1;33mv2.0.0[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jun 20 19:15:54 2021 +0100

    Adjusted rocket icon size on IHADSS
    Fixed some missing semicolons
    Renamed settings group
    Fixed race condition between aircraft initialisation and scheduler
    Removed debug statement

[33mcommit c619228d9e92c6ba0b7fbd62414267e91500d807[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jun 20 13:26:20 2021 +0100

    Fixes for before steam (#82)
    
    Rewritten simulation
    Infinite Variable bug in ASE Track warner
    Targeting fix for Ase Page open

[33mcommit c659dcad8639726d23cf8423dc7a70fa5bdabd90[m
Merge: 190d791be 0552ce5ec
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Jun 18 17:07:00 2021 -0400

    Merge pull request #80 from mattysmith22/bugfix-apu-sound
    
    Fixed APU sound loop.

[33mcommit 0552ce5ece38e2ac5c97abc216edacf4d6f971ca[m[33m ([m[1;31mMPDUpdate-Merge/bugfix-apu-sound[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 18 20:28:54 2021 +0100

    Fixed APU sound loop. Pair programmed with Indigo

[33mcommit 190d791be747db968f133336c97ae146c54c9c82[m
Author: indig0fox <indifox926@gmail.com>
Date:   Fri Jun 18 13:31:42 2021 -0400

    adds Powershell 5.1/7 dev environment management script (#79)
    
    * adds build script for PBO pack, symlink setup

[33mcommit b0cfc204cfe3f2a7218dc27ab687bb690fdef694[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 17 23:44:26 2021 +0100

    Fixed accidental hovering bug

[33mcommit a90dc8af907ff8c751ab06922b672b5f64b8e4b6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 17 19:53:11 2021 +0100

    2.0.0 cleanup (#78)
    
    * Make changes to mod naming as per voodoo's request
    Remove Rotorlib
    
    * Fixed naming of stabilator
    Fixed locality issue of stabilator

[33mcommit ce9b3b227e186ef83d54ec63c37ebf2dc920e6b1[m[33m ([m[1;33mtag: [m[1;33mv2.0.0-rc3[m[33m)[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jun 4 20:18:07 2021 +0100

    Change log Update (#72)

[33mcommit 5ca46222e6d222a178c3fe8fad428ab274312ecf[m
Author: Rosd6(Dryden) <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Jun 4 01:02:20 2021 +0100

    Fix infinitely growing target variable (#75)

[33mcommit ac8c92a8d87375411f1b088ccdecafe4f02417d8[m[33m ([m[1;31mupstream/ModelRefresh[m[33m)[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed May 26 23:35:10 2021 +0100

    Bug fix
    
    Miscellaneous textures

[33mcommit cc0a79feada9cc32eeda87decaf7c85c6bed5ee9[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed May 26 23:15:59 2021 +0100

    Add mod cpp (#73)
    
    * Added mod.cpp, specifying pictures, descriptions, logos etc.
    * Also added editor previews and silouhettes (credit to @Ollieollieolllie and Nodunit respectively)

[33mcommit 81dacd06f4e414c1008505fba92912afe1002ecd[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed May 26 18:16:30 2021 +0100

    Nodunit texture additions (#71)
    
    * Texture additions

[33mcommit 7670162863331b2fcce5b10ece9929dece0c099b[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Tue May 25 05:45:53 2021 -0500

    Stabilator Schedule Change (#67)
    
    Made the stabilator function over a more specific range of airspeed/collective settings to enhance stability.

[33mcommit 1b317f16bb09d12bc98e966fb320cb5351b25092[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon May 24 19:07:01 2021 +0100

    * Fixed help popup in MP appearing on all clients (#68)
    
    * Fixed helicopter self-reporting in FCR
    * Improved laser range symbology
    * Fixed MP bug where gunner's seat would not always turn on MPDs on JIP

[33mcommit 5b3fffe4d6bd0b9236d475d92619c3dff4e913b3[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun May 23 17:39:12 2021 +0100

    Misc Stuff (READY) (#64)
    
    * Move FCR script to work in scheduled environment (improved performance)
    * PNVS keybinding fix
    * Fix gun memory point
    * Fix TSD targeting selection selecting not visible targets
    * Calibrate TSD, ASE and FCR page icon position
    * Switch C-Scope to use a bigger fixed-wing icon
    * Fix JAM OHEAT warning error and others on WCA not appearing
    * Dampened the input of keyboard action on SFM
    * Cockpit glass fix #65

[33mcommit 66c77c8b480f9ab0a0bb69611b028170f29caac8[m[33m ([m[1;33mtag: [m[1;33mv2.0.0-rc2[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Apr 13 00:03:12 2021 +0100

    Fixed missing cockpit model

[33mcommit 5a566c383e912938d17f5eb8a5f1d38030ae231b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Apr 12 23:29:29 2021 +0100

    Fixed M230 reload time

[33mcommit bd5370441985c46a242acf0f35cac51b4a8628ff[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Apr 12 22:37:48 2021 +0100

    Fixed M230 stow position when sight select HMD

[33mcommit b7befcbc5740c292ab58b27f6fd285e9307e42de[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Apr 12 22:01:20 2021 +0100

    Fixed accidentally deleted model

[33mcommit f41ccb94c77001fa3bb35d13b77562499a69d3fa[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 12 21:15:48 2021 +0100

    Cscope Priority by range (#62)

[33mcommit 8ae221bbbd11558d848276bed471acfb4507bd63[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Apr 12 16:16:49 2021 +0100

    Fix typo (#59)

[33mcommit 63743d348befa7c70930e8eae1925c4a1b68b546[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Apr 12 16:08:22 2021 +0100

    Animations and textures (#61)
    
    * Fixed rotors & FCR animations.
    * Fixed death texture

[33mcommit cdfed4005d4cb6f0a61cc17e95c1423b1310bcca[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Sat Apr 10 16:17:32 2021 -0500

    Sfmplus rc (#52)
    
    Implemented proper fuel flow
    Added SFM+ Stabilator
    Improved rigid body inertia

[33mcommit e4cfa50fe008d94c18354f412e1672b32f56baf8[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Apr 10 00:10:51 2021 +0100

    Misc improvements before 2.0.0-RC2 (#57)
    
    * Increase illumination flare duration 30->100
    * Fixed flare memory points
    * Increased landing light strength
    * Added empty loadout
    * Added miscellaneous WCA warnings back
    * Updated target selection system

[33mcommit af5c40bceba3a808ccf85be809dd99ba34432288[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Apr 9 19:22:42 2021 +0100

    PNVS improvements (#58)
    
    Fixed A3TI in PNVS
    Improved PNVS head tracking
    Removed PNVS overlay when in PNVS turret

[33mcommit d349b4c23e8a8987e123411f7c1c466d46ff48eb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Apr 8 16:24:57 2021 +0100

    Image auto track fix (#55)
    
    * Fixed crosshair and image filtering appearing when outside of the aircraft
    * Fixed image auto tracking being interfered with by new sight system
    * Removed old arming menu option
    * Fixed aim position for image auto track

[33mcommit b49493329675ca36adf2b8514c5e995ef2fbfdfe[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Apr 8 15:43:05 2021 +0100

    Simplify pylon menu (#53)
    
    Moved each pylon to use 4 subpylons rather than 7.
    Added more information on limits of pylon system (Credit to BradMick for limits)
    Fixed AH-64D no FCR automatically loading with Longbow missiles
    Added already existing descriptions to pylon menu tooltip

[33mcommit be916476c9d1a613b1cff5ee98341c0d9446b879[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 8 14:16:56 2021 +0100

    Fixing Pr mistakes (#47)
    
    Added compatibility for LESH towing
    Updated PFZ Viewing (map icon and TSD filtering)
    Changed initial sight for both crewstations to HMD

[33mcommit b7877557dfef224e9c7e19c38469733128f60ea6[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Wed Apr 7 13:14:32 2021 +0100

    Changelog (#46)
    
    Updated changelog

[33mcommit e30230f67c61a7c3cf0a6c2cddfa7edfc65e81a3[m[33m ([m[1;33mtag: [m[1;33mv2.0.0-rc1[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Apr 6 15:52:33 2021 +0100

    Added welcome introduction screen (#45)

[33mcommit 9291ef6211348ea62a1407f3dd662145b5aae861[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Apr 6 05:16:42 2021 +0100

    Fixed laser offset/jitter and gun accuracy. (#41)
    
    * Fixed laser jitter in MP
    * Increased cannon accuracy
    * Removed (temporarily) acquisition sources and rewritten sighting system.
    * Fixed PFZs and laser cycling
    * Added inhibits to the weapons system.

[33mcommit ad58010a877ecfb592e43c805a4e36d7a084ad69[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Apr 6 00:43:36 2021 +0100

    Flight timer, Avionics FCR fix & UK Textures (#44)
    
    Added AAC textures to the mod
    Fixed FCR page when FCR not installed
    Fixed hellfire flight timer

[33mcommit 1350956685c5d459c81d8fb00b74f49861618486[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Apr 6 00:40:48 2021 +0100

    Ammo rework & hellfire limit (#19)
    
    * Removed hydras from ace frag
    * Removed 30mm from ace frag
    * Hellfires now limited to 40 degrees left/right
    * Increase M230E1 RPM to reflect 650 RPM in-game (the reload time is not accurate)
    * Added a penetration submunition for the 30mm
    * Added penetrators to hellfires
    * Fixed submunition direction for hydras
    * Re-added Flechette red smoke

[33mcommit 7b95e1a8cad75bac32ddd9c7f4b634381cdc06e2[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Apr 4 18:17:53 2021 +0100

    Updated UFD to use the new damage and fire system (#42)

[33mcommit a9179f76b63a05c5ef018615298bb76d6a889792[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Apr 4 02:12:35 2021 +0100

    single player scripts & removals (#39)
    
    Prevents network intensive scripts (like bladerot) from running in multiplayer, making them SP-only

[33mcommit a7fd6174a5a9b618c80d3f8736f5613b5bb08653[m
Author: sevn10 <justin.marin@gmail.com>
Date:   Sat Apr 3 19:42:45 2021 -0400

    Added 211th Skins

[33mcommit 16c66e31869d2bee738ed9e10502e5a566c8c5a4[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Apr 3 16:40:22 2021 +0100

    Fix CI failing on pull requests

[33mcommit 746adfdb7ca457d336b68b0df43090f531382170[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Apr 2 21:58:10 2021 +0100

    Update changelog (#26)

[33mcommit f3d3ea2a3c0897407937ba5e9844b148aea744a7[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Apr 2 19:39:20 2021 +0100

    Image Auto Tracking fix (#28)

[33mcommit ce5dbfab7bbc20af833df50751ddee66451eb5c4[m
Author: BradMick <16617553+BradMick@users.noreply.github.com>
Date:   Thu Apr 1 15:00:56 2021 -0500

    SFM Engine Page Fix (#23)
    
    Fixed the ENG page so that it works with SFM.

[33mcommit 883f964821b301e5477ef04408bc1137ac0f5700[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 1 20:32:28 2021 +0100

    hellfire models (#24)
    
    Re-added custom hellfire textures and fixed UV unwrapping issues

[33mcommit ae9e4b3b2f94f4c0a5bc4a3cf0be014e0c1d578f[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Apr 1 20:27:23 2021 +0100

    Feature track moving object (#25)
    
    Added Image automatic tracking (IAT)
    
    Credit to AngusLogan and Ollieollieollie

[33mcommit 2b4da584c1f34d146107b66abd97b6d52c08bcd1[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Mar 30 20:52:48 2021 +0100

    FCR vanilla appearance selection patch & ATA Radar fix (#21)
    
    Fixed air-to-air FCR
    Fixed air-to-ground FCR FOV
    Fixed icon positioning on FCR page

[33mcommit 7923e494c58f3364fd650147ba37f8abb89a168b[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Mar 23 01:56:04 2021 +0000

    Slow scheduler & functions (#15)
    
    Added second slower scheduler array that is run less often for performance reasons
    Functionised some remaining `execVM`ed scripts

[33mcommit 4003da00db70632fb781eb97fd314bbba8ec0c46[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Mar 22 00:01:44 2021 +0000

    CI documentation (#20)
    
    Added naturaldocs documentation generation to github actions

[33mcommit 2af956bbfdd7476f9d161718ba97501898fbd660[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sat Mar 20 00:42:28 2021 +0000

    AAC Texture (#16)
    
    Add AAC Skin to available skins

[33mcommit 78f47011ad2359d10111942950b798b82c7c8d0d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Mar 17 15:03:23 2021 +0000

    Feature dynamic loadouts (#13)
    
    * Implemented Dynamic Loadouts for the Apache, credit to BradMick for 3D modelling and design help
    * Removed old loadout system
    * Moved skins and setting FCR to vehicle customization [https://community.bistudio.com/wiki/Arma_3:_Vehicle_Customization]
    * Fixed disappeared textures, moved as many damage handlers off scripts as possible
    * Added new RNLAF skins, courtesy of Houseman
    * Added default presets to loadouts
    
    Thanks to ollieollieollie for his help testing
    Co-authored-by: BradMick <bradMick@example.com>

[33mcommit 80ad0afd63f8da0f26fb3d345bb499241aeba0eb[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Mar 15 14:47:54 2021 +0000

    Update README.md (#12)
    
    Updating the changelog to reflect recent pull requests

[33mcommit 3062d4fd3d7ddaebd413c2a56208a133f9567a29[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Mar 14 12:19:38 2021 +0000

    * Fixed button to allow opening fcr from ase page
    * Decreased radar max detection range from 10km to 8km
    * Temporarily isabled rocket salvo to prevent bug
    * Added vanilla thermal sensor to targeting configs
    * Increased size of fixed-wing cscope icons
    * Fixed bindable jammer toggle
    * Made ase scripts functions rather than `execVm`ed scripts
    * Made jammer activation linked to both seats
    * Fixed tsd & FCR ADA icons * Submunitions activation are now a function
    * Fixed ASE Display on server enviroment
    * Fixed missile warning volume
    * Added a bindable key to switch between self/remote laser

[33mcommit 937cfb27a0478711ed0eedbcbb19f382bcb0f1a2[m
Merge: 9da7980ae 6933f7fd9
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Dec 11 18:52:50 2020 +0100

    Merge pull request #100 from Ollieollieolllie/Improvements-countemeasure-update
    
    Feature Countermeasure Improvement.

[33mcommit 9da7980ae2f0a6b1294051095ff0cf00900da1b8[m
Merge: b1a647f5f 34cbaccca
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Dec 11 18:50:46 2020 +0100

    Merge pull request #101 from Ollieollieolllie/Improve-Hydra-submunition
    
    Feature Fixed hydra Submunition

[33mcommit b1a647f5fbac17699e2e74b890b765055e567395[m
Merge: 001d939ed dc477a3e6
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Dec 11 18:48:43 2020 +0100

    Merge pull request #102 from Ollieollieolllie/Cam-shake-fix
    
    Feature Camshake fix

[33mcommit 34cbacccaf88fcc0466fe0c8f2f076080c2bcc89[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Dec 4 00:24:16 2020 +0000

    Safety update
    
    Added minimum safe activation distance
    400

[33mcommit dc477a3e688357e824a3e37e84c0b1644eed7dc6[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 3 22:38:23 2020 +0000

    init
    
    Init

[33mcommit 1d727c36cadb370e4ec37bc3e9edb878277af0ab[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 3 21:41:49 2020 +0000

    Simplification
    
    Done

[33mcommit d5d2c71bd88e153af8688257328b6a48b8c98169[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 3 21:34:34 2020 +0000

    Fixed Burst distance
    
    Doneish

[33mcommit 6933f7fd9bc0702cf92ecda2133ba4d1272caac3[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 3 18:19:17 2020 +0000

    ASE pilot and gunner link
    
    Links the pilot and gunner ASE settings

[33mcommit f7d10f7d37bbdc27e711a139ba08e675020573f4[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Thu Dec 3 16:10:18 2020 +0000

    Init
    
    Init

[33mcommit c7bcd3f5b9de846e90b6cd95fc29cd3ef2429c15[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Mon Nov 30 19:28:04 2020 +0000

    Countermeasure Improvement
    
    Links the CM systems to teh ase page allowing for them to be toggles
    RF jammer will know control ecm script
    IR jammer will control auto CM deployment

[33mcommit 001d939edf9dad7890fc6edb9c2ddac8ba987207[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Nov 22 22:03:06 2020 +0000

    CBA compat fix (#97)
    
    Changed AGM-114 Hellfire to autolock =0;
    Improved C-Scope range on TADS
    Fixed the filter so it affects FCR/TSD
    Fixed errror code in PFZ (still doesn't work)

[33mcommit 6c38aab719ef98195e4117373a5f0f1c6ea7fad7[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Nov 6 17:59:09 2020 +0100

    Update 06/11
    
    - Update on the AFM (BradMick v5.5)
    - Revert ballistcomputer to 1 on M230 as FCS (16) is inconsistent

[33mcommit 0ce7a128cf314b9ec31f5c0906bccda068b091de[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Nov 6 16:20:53 2020 +0100

    Update 06/11
    
    - Updated AFM (BradMick V5)

[33mcommit 5cefb31735f2b6a2eb8ef91cf5ab0c609f63f8e8[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Fri Nov 6 15:07:41 2020 +0000

    FIX (#86)
    
    - ECM script fixed
    - Changed 30mm to the newer ballistics computer
    - Re-added ADA datebase
    - Re-added correct auto hover detector
    - Tempory fix for the TSD/FCR Radar Icons
    - Re-added missile datebase
    - Fixed the position issue for the gunner seat ENG1 fire button
    - Fixed the broken shadow on the FCR
    - CMimmunity move fix - radar hellfire failing in LO trajectory
    - Disabled part that was breaking ASE and error codes in Targetupdating
    - "Shot at" fixed so it adds target to "shot at" list (BRK still can't remove it from shot at list)

[33mcommit c7f82b0a5319a72fcb0d4c16dd115e52427579c2[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Oct 30 18:47:36 2020 +0100

    Set theme jekyll-theme-midnight

[33mcommit 1b8e1071642210109b64dbea0bccaa61aaf78fc6[m
Merge: b8b2f5667 a183b73db
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sat Oct 24 15:51:14 2020 +0200

    Merge pull request #85 from mattysmith22/fix-cba-compat-1
    
    CBA testing fixes

[33mcommit a183b73db246dab918ebafe3e21922d1d85ba6ea[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Oct 24 14:09:25 2020 +0100

    Removed auto hover detector

[33mcommit 1ea28a9dc0ffce77c82860cda45cd87086700ba7[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Oct 24 13:32:39 2020 +0100

    CBA testing fixes:
    * Fix Editor init issue
    * Fix APU not being on preventing all engine quadrant controls
    * Re-add Head tracking mouse move setting
    * Add vanilla targeting UI toggle setting

[33mcommit b8b2f566781cf345033a7f60e957cc8ddd01dc68[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Oct 23 16:31:24 2020 +0200

    Update 23/10
    
    - Restored PNVS optics turret
    - When enabling TIR, the mouse cursor will remain centered
    - Tweaked RKTs thrust time
    - CBA integration major update (by mattysmith22)
    - Added throttle lever idle sound

[33mcommit be1249877964f579ec6fd1048cc20675164f3bd2[m
Merge: e64e67eb3 d6cc8f30d
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Oct 23 00:26:23 2020 +0200

    Merge pull request #84 from mattysmith22/feature-cba-compat
    
    CBA Integration

[33mcommit d6cc8f30de696e9a0e0cf062d9d036187158e259[m
Merge: 47097647b e64e67eb3
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Oct 22 23:21:16 2020 +0100

    Merge branch 'master' of https://github.com/SachaOropeza/AH64D-Project into feature-cba-compat

[33mcommit 47097647b54aada6ce052ee266b36ca182d846dc[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Oct 22 21:45:18 2020 +0100

    Fixed laser disarm, fixed acquisition source info, removed fza_ah64_hfmode, fixed ASE page

[33mcommit ec5cff7bc2ea3118e1f970384f0f4bf355f21465[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Oct 22 19:39:57 2020 +0100

    Fixed C-scope, FCR & TSD object clipping

[33mcommit e64e67eb35f53376753b8be98f32cba4cee5fe9b[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Oct 22 19:45:32 2020 +0200

    Update 22/10
    
    - Restored PNVS optics turret
    - When enabling TIR, the mouse cursor will remain centered
    - Small edition on RKTs drag

[33mcommit 2c1aace23a4cf2968bc464da5c1410c512a60b2d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Oct 21 23:42:04 2020 +0100

    Fixed problems found in checkride #2

[33mcommit 89d5cfc0fb816582402a0b31d6d7b7bf0816f332[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Oct 21 18:18:01 2020 +0100

    Fixed LO trajectory following DIR within 3k

[33mcommit bd5fb389c2eb13e76f9d436ac261d6dc12555e05[m
Author: BradMick <>
Date:   Wed Oct 21 10:48:27 2020 -0500

    Update fcr_longbow.sqf
    
    Fixed #72 and removed unused variables.

[33mcommit f734350b562bf8fc902fcfc1f549e6ad97275d08[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Oct 21 16:39:51 2020 +0100

    Fixed pfz selection off by 1 error
    Fixed laser viewing
    Fixed missile IHADSS symbology
    Fixed missile TOF indicators
    Fixed WCA page's APU warning
    Removed unused functions / variables

[33mcommit 5ec4b5d736f7acde752e66de379a07a56b30fc08[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Wed Oct 21 11:20:10 2020 +0200

    Fixed texture path
    
    Changed target texture path in RscTitles & targetscanner.sqf.

[33mcommit 13258ae41af9b242dab3dc60a14620750110a5a1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Oct 20 20:53:26 2020 +0200

    Update 20/10
    
    - Removed pilot optic turret; PNVS is now usable trough NVS MODE switch from the frontseat & backseat (LVL knobs need to be rotated for daytime or night time toggle - default: day).
      The PiP HDU PNVS is shared between the front & the backseat
    - Fixed PiP HDU PNVS transparency
    - C-Scope container fix (by Rosd6)
    - ECM script rework (by Rosd6)
    - Added cam shake for MSL & RKTs
    - Renamed waypoints tex files "ah64_wp_act_0" & "ah64_wp_ina_0" to "ah64_wp_act_00" & "ah64_wp_ina_00" (will be reverted once CBA update is out for compatibility)

[33mcommit 68f58e40e8a7168266ce1ad6e1f034b279db7047[m
Merge: 407e32c3d a28977daf
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Tue Oct 20 03:21:31 2020 +0200

    Merge pull request #78 from Ollieollieolllie/master
    
    C-Scope container fix + ECM rework.

[33mcommit 163f45b69b33b037706b8ab3bafd88b1eb4102be[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Oct 15 13:11:44 2020 +0100

    Fixed keybindings and moved to extended event handlers

[33mcommit a28977dafc060b2988d588996b9773bb411091f1[m
Merge: 59c55a3aa 407e32c3d
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Thu Oct 15 13:48:22 2020 +0200

    Merge branch 'master' into master

[33mcommit 59c55a3aa543d1ede2b29f471a3a22b1c51a3f82[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Thu Oct 15 13:42:39 2020 +0200

    PiP HDU PNVS
    
    Edited PNVS PiP transparency. It is now more visible.

[33mcommit f4000cab6c8cfb0c2b3c1472387f9de3caf79a5c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Wed Oct 14 10:28:05 2020 +0100

    Removed old missile targeting scripts, fixed shotat list, fixed missile select buttons on WPN page, fixed laser designator selection

[33mcommit 62374e665b36b04075c0b7c7deb8aedb5827e482[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Oct 13 15:16:31 2020 +0100

    First implementation of new missile system

[33mcommit 64e371503e2a51e6428ee0d492f550c00144649c[m
Merge: de6234e87 407e32c3d
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Oct 12 12:09:39 2020 +0100

    Merge branch 'master' of https://github.com/SachaOropeza/AH64D-Project into feature-cba-compat

[33mcommit de6234e87362492fc5263027c860e73807bdb835[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Oct 11 21:36:49 2020 +0100

    Removed salute as vehicle radar option
    Fixed fuel system being reversed and in metric
    Fixed TADS stowage system
    Fixed misc navigation issues

[33mcommit 407e32c3d1d952f897fae09f0c6a1504ebf6ba0e[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Oct 11 14:58:09 2020 +0200

    Update 11/10
    
    - Improved AFM based on old logic (by BradMick)
    - Fixed alternate sensor icon
    - Added propper 3D M130 flares dispenser on tail
    - Firing the M230 should no longer shake screen for all clients (by Rosd6)

[33mcommit e39a461f44affdfb4a46b42f5abbc26c1b6ddcfe[m
Merge: cce8638ce e0d28021b
Author: msmith <mattysmith22@googlemail.com>
Date:   Sat Oct 10 00:19:33 2020 +0100

    Merge remote-tracking branch 'origin/master' into feature-cba-compat

[33mcommit cce8638ce0374aeec34deda87cea6f776e70fc4e[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Oct 10 00:18:15 2020 +0100

    Fixed laser arming script

[33mcommit 3224bdb8614f2a83eab29dc7c3f38f75628e3169[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Oct 4 17:01:33 2020 +0200

    Update 04/10
    
    - Further CfgVehicles cleaning.
    - Fixed ACRE intercom preventing racks PTT
    - Corrected monocle.hpp forgotten refactoring on a class.

[33mcommit e26da569444de3e932aaec8f45ec94e87c786172[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sat Oct 3 02:15:59 2020 +0200

    Restored green PNVS
    
    Reverted PLT monochrome PNVS to green PNVS.

[33mcommit 87e420e2881ef752fbc07ca3a1e087661e60a66a[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Sep 25 10:50:42 2020 +0200

    Fix CPG blank monochrome TADS
    
    Fix CPG TADS display being accessible and showing no data when middair and monocle is not worn. The monocle has to be worn to trigger the flight data layers which are shared between the TADS & the IHADSS in the current build, so that's a work-around.

[33mcommit 8b0ec2bad8b1b0757bf826e29752b2a81c74dec8[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon Sep 21 00:57:10 2020 +0200

    Fix TADS lacking displays without monocle
    
    The CPG was able to go heads down on the TADS and wouldn't see any display informations but a monochrome filter. Now, the TADS should appear black unless the monocle is worn.

[33mcommit 12861a6eed3ca80fb33d0c02fdbde894928181a0[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Sep 18 22:59:39 2020 +0100

    Implemented variable changes determined to be necessary via variable scope audit

[33mcommit d4d7ca31aeb94379e678406dd15948803a03d85a[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Sep 15 16:44:01 2020 +0100

    Fixed WPN page and positioning of objects in FCR and ASE views

[33mcommit d2931e4ae6bb9381b382738099e9ea86c15e685c[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Sep 15 01:14:34 2020 +0100

    Added naturaldocs configuration

[33mcommit 01766194ce765cdcd45f3c8652734b6dd6ab40f6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Sep 14 23:39:34 2020 +0100

    Fixed transparency issues for TSD objects

[33mcommit 8d2d5342a5a1edc34bc6fb045866a2682774e6fb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Sep 14 21:19:23 2020 +0100

    Moved compiles at init to CfgFunction definitions

[33mcommit 229c7f81ef1921d2d6d0e53b0642f84886c7a04e[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon Sep 14 02:03:24 2020 +0200

    Update call_ihadss.sqf
    
    "SAFE" message does not exist in the selected weapon field trough the IHADSS. However "SAFE" message may pop up in the HAD field if trigger is pulled while master arm is off. "GUN" message remains in the selected weapon field.

[33mcommit e6ddca6fc1da4847355816d7cb5cfff6d1fdd358[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Sep 13 22:43:18 2020 +0100

    Moved things from ah64d_init.sqf to XEH_preInit where possible

[33mcommit 353eb23ab4c9aa00ea97bdb9b4ef3387095ae5af[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Sep 13 22:12:41 2020 +0100

    Removed some unused variables

[33mcommit 22f9e8205f03cdec48e99f1cd3f5a6dd25165293[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Sep 13 17:25:58 2020 +0100

    Update ah64d_init.sqf

[33mcommit 28a2ef3d1e9f02f97e69f2f3047ce968eef79d67[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Sep 13 17:25:02 2020 +0100

    Update CMSmk2.sqf

[33mcommit a4ac125763ffd2122bc569738b2e09df851521e0[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Sep 12 19:17:11 2020 +0100

    Removed unnecessary files

[33mcommit e0d28021b8fed2e3fb1119babfb227d3350a5319[m
Merge: c38f2efff 8d4495f0d
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Wed Sep 9 17:55:13 2020 +0200

    Merge pull request #83 from mattysmith22/fix-issue-82
    
    Fixed config inheritance

[33mcommit 8d4495f0dfdd8915f973ebc2471e83ecc3fe0adf[m
Author: msmith <mattysmith22@googlemail.com>
Date:   Wed Sep 9 16:36:18 2020 +0100

    Fixed config inheritance
    Fixed #82: forced disabling of targeting information is now optional,
    not mandatory

[33mcommit 35f1f7cff19c6bd4225b497c0b08b5bfb8fe726f[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Tue Sep 8 04:45:35 2020 +0100

    Update call_ihadss.sqf

[33mcommit 54330774c5e86c62eeea79248e9460473ee96229[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Aug 20 13:13:50 2020 +0100

    * Fixed object drawing for the TSD
    * Readded cockpit helper

[33mcommit d9a83e506bf04b9e48e9b59ccfbfa09e3902421b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Tue Aug 18 01:18:27 2020 +0100

    Fixed div/0 error in FLT page caused by not lazily evaluating result
    Fixed ENG bars not working correctly in MP
    Simplified TSD and updatePoints code

[33mcommit 432f393f378d23248ad66ca351c18bd11917ac48[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Aug 17 12:57:59 2020 +0100

    Fixed engine, WCAs

[33mcommit 4bfe2f1da56f7dd90fc54b52598754a669172d9f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Aug 15 22:05:24 2020 +0100

    Fixed mpd handler, started fixing MPDs

[33mcommit d650a07934b65c8b0fee4e85a8e023ae3842bc96[m
Author: Matthew Smith <psyms13@nottingham.ac.uk>
Date:   Fri Aug 14 01:18:28 2020 +0100

    Drafted initial MPD handling system

[33mcommit 4d768202c08df0fea900c596a7851afc2323ffdc[m
Merge: 41943a7ad c38f2efff
Author: Matthew Smith <psyms13@nottingham.ac.uk>
Date:   Thu Aug 13 22:55:02 2020 +0100

    Merge in recent changes from master so as to not fragment too far

[33mcommit 41943a7adebd4b8fcc7c81bff646d4924fc2a148[m
Merge: 72fb5200c 715774cc7
Author: Matthew Smith <psyms13@nottingham.ac.uk>
Date:   Tue Aug 11 21:26:55 2020 +0100

    Merge branch 'feature-cba-compat' of https://github.com/mattysmith22/AH64D-Project into feature-cba-compat

[33mcommit 72fb5200cbdd9ac96e1a18a0a96ffd99807b60ba[m
Author: Matthew Smith <psyms13@nottingham.ac.uk>
Date:   Tue Aug 11 21:03:51 2020 +0100

    Rewrote every mpd page to abstract into Init / Draw / Destruct / HandleControl pattern

[33mcommit df8c4a00ca24087b8e2ef6cb75642c039ab455a0[m
Author: oliver <Doolieollie@gmail.com>
Date:   Sat Aug 1 18:19:41 2020 +0100

    Update 01/08/2020
    
    Cscope container fix

[33mcommit c38f2efff2a88a0b30b049f99223d50f33e7b7f5[m
Merge: 456f6c6a6 d6a798c69
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sun Jul 26 23:26:14 2020 +0200

    Merge pull request #77 from Ollieollieolllie/master
    
    - Fixed AGM-114 Hellfire max launch altitude
    - Tweaked ECM success rate (60%)

[33mcommit d6a798c6933cebab0940a2cccc436ec8b0a5330f[m
Author: Ollieollieolllie <60583203+Ollieollieolllie@users.noreply.github.com>
Date:   Sun Jul 26 21:54:31 2020 +0100

    Update CMSmk2.sqf

[33mcommit 8549e6b9c16ab525f3e1fd54dc52d195c47805b3[m
Author: oliver <Doolieollie@gmail.com>
Date:   Sun Jul 26 21:53:13 2020 +0100

    Update CMSmk2.sqf

[33mcommit 1ee296c0af75adf8b24c16d1be2e19e0c22ed665[m
Author: oliver <Doolieollie@gmail.com>
Date:   Sun Jul 26 21:48:34 2020 +0100

    ECM 60% success

[33mcommit 3d8013860132952b745873f60e91d3673b3e5f55[m
Author: oliver <Doolieollie@gmail.com>
Date:   Sun Jul 26 02:07:17 2020 +0100

    26/07/2020
    
    Hellfire  trajectory fix

[33mcommit 456f6c6a67487ceebeb0a5eab12b363e63adb713[m
Merge: 3fd978c87 e72836af9
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Thu Jul 2 10:37:02 2020 +0200

    Merge pull request #71 from AngusLogan02/fix-rotor-brake
    
    Added TKOH rotor brake RTD

[33mcommit e72836af9502d78ec8dc898cb3f6aff153154a1a[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Wed Jul 1 23:08:40 2020 +0100

    added afm rotor brake, fixes issue #53

[33mcommit 3fd978c875fbf73b7a66696f9837b8d129e8ca10[m
Merge: e64d8a687 64025f9f4
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Wed Jul 1 07:18:17 2020 +0200

    Merge pull request #70 from AngusLogan02/fix-aircraft-animation-reset
    
    Fixed aircraft doors and switches animation reset upon JIP players

[33mcommit e64d8a68747ec107d0695d20cd7f52ce4b6f7fde[m
Merge: 5e962503d dccde2d94
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Wed Jul 1 07:13:33 2020 +0200

    Merge pull request #69 from AngusLogan02/fix-skin-locality
    
    Changed custom skin to global

[33mcommit 64025f9f42103a4ab4682ba7d22a21f7a13451ee[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Wed Jul 1 01:40:42 2020 +0100

    reverted broken fcr fix, corrected logic for aircraft animation reset fix

[33mcommit 8764733d316e1f451e7b922a3337afcc3162d0d4[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 23:54:08 2020 +0100

    possible fix for fcr only initialising for first heli

[33mcommit 6e31fc27caedcbfce8dfce52dba739b4bcc3c7b4[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 23:26:22 2020 +0100

    fix for aircraft animations (doors, rotor break, etc) resetting

[33mcommit dccde2d94988df8536e1c610c50f6a94d87e413a[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 20:46:14 2020 +0100

    fixed skin change locality issue

[33mcommit 715774cc7f890ca13a35e527a3518257ea429c72[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 13:11:37 2020 +0100

    added sound to mpd brightness control knob

[33mcommit 5a68338dd610be510b0c90ee4a1a4c3e5a8d82ea[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 12:52:48 2020 +0100

    moved dam_bt_audio to a script in functions, replaced all occurances

[33mcommit 78d446f7c75fa2c7ff53bdc51837cd7e75778dce[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 11:51:03 2020 +0100

    fixed logic error with apu

[33mcommit f27f00e25b1fc1c5781d9a4e2da96240ab4cee9a[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 00:56:55 2020 +0100

    changed skins will now be updated for all clients on MP server

[33mcommit 9dd547769552ce45c720081439eaa51e911488b3[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 00:54:18 2020 +0100

    Revert "changed skins will now be updated for all clients on MP server"
    
    This reverts commit c966f87f9ff0f61e4986ab6e76a2f05f9b47e2dd.

[33mcommit 084c2c9a30f32fe535793bba633841683889a53c[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 00:51:53 2020 +0100

    changed skins will now be updated for all clients on MP server

[33mcommit 9dad29b09e10f66d121832a8e2cb2ea3175536e0[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Tue Jun 30 00:44:49 2020 +0100

    fix for apu shutdown when aircraft already off

[33mcommit 0eee69dc414f24db0b01fd91aea7fcad28bd6984[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 23:25:38 2020 +0100

    fixed ihadss nv toggle switch sound, pnvs day/night toggle sound

[33mcommit a2ac67152a1cc47cb7e3f3f4282d41f2cb99a83b[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 18:02:07 2020 +0100

    fixed fire system test switch sounds

[33mcommit e74bc3c7a910afaf6cfb8acbc7fa854f95a99da0[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 17:55:09 2020 +0100

    fixed backlight button sounds

[33mcommit efa8c7dee1edf2d4cbac3b9be6ec859caae06c57[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 17:54:24 2020 +0100

    removed now deprecated code referring to _clickSound that was causing issues with backlight switch and right mpd brightness switch

[33mcommit fbf9c53b174fd24900469d64d20b5b6d1bd05400[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 17:53:04 2020 +0100

    fixed lack of ihadss sounds

[33mcommit 3609de24985a0abeebcdfc3d87c438679d2d7544[m
Author: Angus Logan <angus.logan@baronsview.com>
Date:   Mon Jun 29 16:54:10 2020 +0100

    fixed audio issues for engine related switches/buttons

[33mcommit 5e962503de6737617e5bcb42e1b0b1df36e6b3c6[m
Merge: 69245233d f8512188d
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon Jun 29 17:16:46 2020 +0200

    Merge pull request #68 from Keplager/pylons
    
    Changed AFM damping, mixing, CG location, and flight model.

[33mcommit f8512188dac1d35325ee0c3fc8837d2435d68db2[m
Author: Keplager <Sapphire823@gmail.com>
Date:   Mon Jun 29 09:57:00 2020 -0400

    @ Changed Flight model damping, mixing, CG location, and flight model force locations. Should be more reponsive, nose should no longer drop when advancing collective into a hover.

[33mcommit 17779ab8e510b37d90689e2af1622afa1e1b5269[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jun 29 01:17:37 2020 +0100

    Added setting for apache rearm time

[33mcommit ce3816c135d002d95f29baebdbee9943318e117f[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jun 28 23:50:16 2020 +0100

    Move selection numbers to header fileHotfix race condation on fuel and engine

[33mcommit 89f3c0cae387865d8ceb21e8da8bbe51ef2390f6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Mon Jun 22 16:49:36 2020 +0100

    Fix CBA control name

[33mcommit 4fb3e06ebd15b40457e3e72aa0b61a2d3ad1ba12[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 20 16:28:47 2020 +0100

    CBA compat fixes:
    Fixed engine startup not working
    Fixed apu being able to be turned on without battery
    Fixed engine control governor issues

[33mcommit 5ddfb0145e2b359defde7d87a0591aa07237cf0d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 20 03:01:14 2020 +0100

    Fix CfgFunctions bug

[33mcommit 083341b3d25845bf5c6609c75d9cfa3aa3cfcd9d[m
Merge: ee1729d44 69245233d
Author: msmith <mattysmith22@googlemail.com>
Date:   Sat Jun 20 02:14:44 2020 +0100

    Merge branch 'master' into feature-cba-compat

[33mcommit ee1729d44505aad10611112996646fa3fb64cc19[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 20 02:13:50 2020 +0100

    CBA A3 Compat start
    Controls added to custom controls

[33mcommit 69245233d688226c44e63a3df53dd79075d95614[m
Merge: a09be172e edd0b4f58
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Tue Jun 16 17:39:49 2020 +0200

    Merge pull request #64 from Ollieollieolllie/master
    
    300 rounds magazine fix.

[33mcommit edd0b4f58c71a93657bac42b1c739182a703005f[m
Author: oliver <Doolieollie@gmail.com>
Date:   Mon Jun 15 21:34:42 2020 +0100

    300 Round mag fix
    
    arming menu fix for 300 round mag

[33mcommit a09be172e9cbada4a5befa124a66dfa0b6492766[m
Merge: 0b3948609 8bf3a10a2
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri Jun 12 14:05:05 2020 +0200

    Merge pull request #62 from mattysmith22/feature-alt-sensor-ihadss
    
    Feature alt sensor ihadss

[33mcommit 8bf3a10a2da3d84c6786fde67ba048c6cd81218b[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 11 18:36:36 2020 +0100

    Added alternate sensor to IHADSS

[33mcommit 84fe88f38bca9c2a64a9160c539bc1ca20db0206[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sun Jun 7 16:01:39 2020 +0100

    Reduced duplication in CfgVehicles

[33mcommit 0b3948609750cf99129b9307993c4931794bab30[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jun 7 16:07:44 2020 +0200

    Ng final value fix + FLIR TADS text

[33mcommit f2d46a90f5580242002fa083233bfdd5421ad430[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jun 6 21:55:21 2020 +0200

    WPN page fix

[33mcommit f795e6285653c6791a31e861fbaab4329a4f0f31[m
Merge: e0952fad4 cf8776259
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sat Jun 6 19:16:33 2020 +0200

    Merge pull request #57 from mattysmith22/fix-sqf-formatting
    
    Ran every SQF file through https://sqf.fini.dev/convert

[33mcommit cf877625975ff0bc0a237c28310b57adf114e2e2[m
Merge: 8f93e5aac e0952fad4
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sat Jun 6 19:15:09 2020 +0200

    Merge branch 'master' into fix-sqf-formatting

[33mcommit e0952fad4a5c1060f4f1ee00114b60fcb39257f2[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jun 6 17:08:09 2020 +0200

    Fixed external view IHADSS

[33mcommit 8f93e5aacce4a0237c375d9e7929f555fe9df1fe[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 15:39:34 2020 +0100

    Ran every SQF file through https://sqf.fini.dev/convert
    Also removed unused CMSmk2_bak.sqf

[33mcommit fae7d4a285108235f908dc6cedb5c44362aaa04d[m
Merge: e1b9300f3 3c3f38f17
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jun 6 16:15:15 2020 +0200

    Merge branch 'master' of https://github.com/SachaOropeza/AH64D-v1.43-

[33mcommit e1b9300f3e27caa94a73affac69098a5d228db31[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jun 6 16:15:08 2020 +0200

    Update README.md

[33mcommit 3c3f38f1702b3e0555f5112c453e1b92aa6bc5f6[m
Merge: 34138eaa6 ff6e01bbd
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Sat Jun 6 16:05:33 2020 +0200

    Merge pull request #56 from mattysmith22/fix-engine-control
    
    Fix engine control

[33mcommit ff6e01bbded831868316cf000360fa15c6ff600b[m
Merge: a0d474f4c 34138eaa6
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 14:59:25 2020 +0100

    Merge branch 'master' into fix-engine-control

[33mcommit 34138eaa6d2592395db16a750b61679ebee76c9c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jun 6 15:41:44 2020 +0200

    A3TI FLIR & PNVS
    
    - PNVS Optics layer fix when getting out
    - Added A3TI full compatibility (CPG FLIR & PLT PNVS)
    - Fixed PNVS color (MPD grey source logic)

[33mcommit a0d474f4cfc94b3317233ed85c16d32dd3b9c565[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 14:39:41 2020 +0100

    IHADSS now turns off when APU is not available

[33mcommit 2c761757066cdffe0f2bb45bd46b5f88f076d8b6[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 02:51:16 2020 +0100

    Fixed hydraulic pressure not being recorded.

[33mcommit c2d2c1ef5b1d2a2b61d8156ad5c3070ac782aff4[m
Merge: dd02a1404 f27d1d57a
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 02:36:30 2020 +0100

    Merge remote-tracking branch 'origin/master' into fix-engine-control

[33mcommit dd02a140471532cf1af5dc6ec3f33f3c5ece23b8[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Sat Jun 6 02:30:10 2020 +0100

    Fixed engine governor not always stopping engines
    Added documentation
    Fixed bug where JIP would cause you to fall out the sky by resetting the ECU
    Extracted out settings to a header file, generally cleaned things up

[33mcommit 992d88368abec43574dc2f271acab1ff80061c04[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 5 20:11:20 2020 +0100

    Fixed rotor rpm being different to Np in some conditions, and bug in engine governor

[33mcommit 424505bd94e8bdbec81cf4b26fa5f9b2fd0f0df8[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 5 19:42:27 2020 +0100

    Engine info now stored on apache rather than in global variable

[33mcommit 0832e3e247a5058353fde0b41616848f7fc903e0[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri Jun 5 17:34:43 2020 +0100

    Updated how engine starter switch operates

[33mcommit acd4884342afb9e98b4d99c787b32f478f4023fb[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 4 20:00:30 2020 +0100

    Fixed engine page torque digits being stuck when page isn't there
    Fixed IHADSS overlay
    TGT, Nr and Np are now scaled more correctly

[33mcommit 2285851948241147fedfd349961ab36a7634dae9[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Jun 4 18:47:05 2020 +0200

    Restored FCR on APU

[33mcommit a30387a6297185a085ba35c09e81c1aa132821bb[m
Merge: d2069c5fc 232ff4db6
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Thu Jun 4 18:31:48 2020 +0200

    Merge pull request #54 from Keplager/pip
    
    + Added Pip Values for longer ranges to Video Options

[33mcommit 232ff4db60cea1142145d4d1ce048666a16d5d00[m
Author: Keplager <Sapphire823@gmail.com>
Date:   Thu Jun 4 12:25:43 2020 -0400

    + Added Pip Values for longer ranges to Video Options

[33mcommit 27cdaf949226968005e5222c938151a550028a9d[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 4 01:11:07 2020 +0100

    Applied torque value fixes

[33mcommit 007ea1899f2d648c0d77229d4d40c485e68fd309[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Thu Jun 4 00:43:23 2020 +0100

    Implemented new engine control

[33mcommit da7e97f08318f2843fb6191e9abd953fd5a65a61[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri May 15 00:42:50 2020 +0100

    Started Engine Class

[33mcommit d2069c5fca4cdfb422d8f6f57ef30b6ac32e22bf[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri May 8 12:39:41 2020 +0200

    Update 08/05
    
    - Removed F_VirtualMan entity
    - Minor weapon sounds tweak

[33mcommit f27d1d57a026a21e74c34dd8e4fdcd4368a1f91a[m
Merge: d620af62e 89a538914
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Fri May 8 03:52:39 2020 +0200

    Merge pull request #46 from mattysmith22/fix-fcr-page-targeting
    
    Fixed targeting on FCR page, IHADSS waypoint crashes & datalink

[33mcommit 89a5389140b08f5aa9fbbd9381f715f8a42ced96[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri May 8 02:47:09 2020 +0100

    Fixed
    * Datalink not being automatically enabled - Credit to Keplager
    * User actions allowing for players to try and access waypoints with a negative index
    * Targeting being limited on FCR page by the scale in TSD - Credit to Keplager & mattysmith22
    
    Co-authored-by: Keplager

[33mcommit d620af62e63dd616dadbd8055ea4e2b9f141a4e9[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon May 4 22:02:03 2020 +0200

    Update 04/05
    
    - Fixed FCR in multiplayer (by Keplager)
    - Resolve missing sound files issues in CfgSoundShaders

[33mcommit 3948892476516186674fa77828203a87d86364bf[m
Merge: 45fa1285c 1da4c721f
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon May 4 19:41:54 2020 +0200

    Merge pull request #45 from SachaOropeza/revert-43-bug/pbo-project-fixes
    
    Revert "Fix issues for pboProject build"

[33mcommit 1da4c721fca6798047f063377799b384e4f9049f[m[33m ([m[1;31mupstream/revert-43-bug/pbo-project-fixes[m[33m, [m[1;31morigin/revert-43-bug/pbo-project-fixes[m[33m, [m[1;31mMPDUpdate-Merge/revert-43-bug/pbo-project-fixes[m[33m)[m
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon May 4 19:39:49 2020 +0200

    Revert "Fix issues for pboProject build"

[33mcommit 45fa1285c6f00a208b5947ce0b5761ff842e8a81[m
Merge: 801fbf7b4 896baf18c
Author: Sacha 'Voodooflies' Oropeza <osacha@free.fr>
Date:   Mon May 4 17:51:07 2020 +0200

    Merge pull request #43 from uksf/bug/pbo-project-fixes
    
    Fix issues for pboProject build

[33mcommit 896baf18cc6c0971434920621f09e90a891c4178[m
Author: Tim Beswick <contact.tim.here@gmail.com>
Date:   Mon May 4 09:57:10 2020 +0100

    Undo whitespace changes in baseClasses

[33mcommit 09ad6a76691db7c4eec98eb894d9c4ba223dffd0[m
Author: Tim Beswick <contact.tim.here@gmail.com>
Date:   Mon May 4 09:37:04 2020 +0100

    Fix issues for pboProject build
    
    - Resolve missing file issues
    - Add PBOPREFIX files
    - Add model.cfg for animations
    - Fix config issues

[33mcommit 801fbf7b4a0710ab3144402caef1360fdaaa9349[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat May 2 02:18:05 2020 +0200

    Update 02/05
    
    - Potential fix for FCR weird behaviour in multiplayer (by Keplager)
    - Minor AFM update (by Keplager)
    - Reduced RKTs smoke clouds
    - Fixed some more ASE related script errors

[33mcommit 6341ca010ed61b1474739279408b9e33dd213624[m[33m ([m[1;31mMPDUpdate-Merge/master[m[33m)[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri May 1 21:19:36 2020 +0100

    Fixed autohover being disengaged when freelooking inside cockpit

[33mcommit 97354575bbe3a35d0717c234fc669f056fcfe536[m
Author: Matthew Smith <mattysmith22@googlemail.com>
Date:   Fri May 1 21:00:11 2020 +0100

    Fixed RF jammer script error

[33mcommit 050f20bcda2548fbcdbfb2979ae635dd3e5b9b7f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri May 1 14:55:32 2020 +0200

    Update 01/05
    
    - Reduced burst limit cooldown to 1 second instead of 3 seconds
    - Expanded M151 & M229 area of effect
    - Potential fix for invisible aircraft on dedicated servers
    - Jammers critical error fix (by mattysmith22)

[33mcommit e2162baae2a0076ee8fbac5934c6f2bbcf53e4ba[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Apr 12 14:56:59 2020 +0200

    Update 12/04
    
    - Complete weapon sounds overhaul based on JSRS shaders
    - Removed MSL & RKTs offset

[33mcommit 7dd6d0b2d6fcb126bd56106793174bc4c46104dd[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Apr 9 15:38:16 2020 +0200

    Update 09/04
    
    - Fixed rotor blur shadow
    - Restored FCR variant of the aircraft (by Keplager)
    - Fixed AGM-114 SAL1 & SAL2 tracking (by Keplager)
    - Changed default loadout for the FCR variant
    - Fixed 3D floor holes for both PLT & CPG
    - Minor 3D adjustement to the ORT

[33mcommit e17d134a8a92b9a282986fa555bb04494f2005dd[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 6 21:12:43 2020 +0200

    Update 06/04
    
    - Fixed TADS animation when shut down or lack of power
    - Fixed M255, M257, M151 & M261 submunitions
    - Changed default loadout based on real AH-64D  operation
    - Fixed turning off engine when player gets in cargo
    - Adjusted landing light strenght and direction

[33mcommit e814e8135dd8759b3a0ec87d26cb58dee0381737[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Apr 3 14:10:06 2020 +0200

    Update 03/04
    
    - Minor external model 3D adjustements
    - Fixed 3D side panels holes in CPG & PLT seats
    - Updated some cockpit switches sound
    - Added CPG BRT and NVS switch animation
    - Added avionics sound upon aircraft power up

[33mcommit 134dce393b25cb3bd7725ab5af645082a9a6b903[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Apr 2 06:43:23 2020 +0200

    Update 02/04
    
    - Corrected a bug where the CPG would loose all IHADSS data while heads down when disabling the laser
    - Added clickable floodlight button for both CPG and PLT
    - Added clickable navigation & anticollision lights button on PLT side

[33mcommit b3bd3cc086908e6ec3d1c34c20243f72757cc422[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Mar 30 13:51:43 2020 +0200

    Update 30/03
    
    - Corrected sonic cracks heard from CPG optic when headsdown
    - Further tweak to AGM-114 family and M230
    - Couple minor sound tweaks
    - Restored full auto on M230, limited by burst limiter setting (WPN page) just like in the real aircraft
    - Hence no more burst firing mode and sounds anymore
    - Ability to lock on TADS target, compatible with most ACQ submodes
    - Added randomization in RKTs flight path
    - AGM-114 SAL2 cannot track targets without laser designation anymore
    - Monocle is finally fixed
    - IHADSS flight data will no longer appear in external view
    - Code cleaning...

[33mcommit a2dd7d6a0edcaf2a4ee1470684bb5357996d6577[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Mar 7 03:53:01 2019 +0100

    Update

[33mcommit 5000f29b91a225d2cfe0cd69fcbfe057151daf78[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 3 04:03:02 2019 +0100

    Update

[33mcommit ea73cf6aa1ba4d1fb8aadf0327c9e8b5ccc4b4b6[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 2 19:20:37 2019 +0100

    Update

[33mcommit b2e41fa39ab61399bca9f802cb329c850a5c013f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 2 18:21:20 2019 +0100

    Update
    
    Removed FCR, latest AFM fixes.

[33mcommit e076fc3fbde24cdfec201955b7a540fa11613f3f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 21 23:29:20 2019 +0100

    Changes list

[33mcommit dfead5294304b38f14d75b4aee39e5f1672f0caa[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 21 23:27:26 2019 +0100

    AFM

[33mcommit 9425ee1600cb65bfa05f9c3d174e91963a84f10a[m
Merge: cc19ac6d3 3dbc1e59e
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 21 23:25:30 2019 +0100

    Merge branch 'master' of https://github.com/SachaOropeza/AH64D-v1.43-

[33mcommit cc19ac6d3dae681af87304fb3fa02bca617354ea[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 21 23:24:51 2019 +0100

    Update
    
    M230 possible performance tweak upon firing. New AFM and couple sounds tweaking.

[33mcommit 3dbc1e59e543d54461c9960f1bd0f14e355402c2[m
Merge: 8709c36e1 97d13e0a9
Author: Sacha 'Voodoo' Oropeza <osacha@free.fr>
Date:   Thu Jan 31 00:17:26 2019 +0100

    Merge pull request #35 from Keplager/master
    
    Changes to IHADSS, eng page, and flight model

[33mcommit 97d13e0a9c26f8c31d0eeacac3ba178e59550d40[m
Author: Keplager <Sapphire823@gmail.com>
Date:   Wed Jan 30 13:10:51 2019 -0500

    Changed total weight, added magazine weight for every weapon, changed drag scalar and some control system biases.
    
    - FM Changed AoA drag scalar
    
    - FM changed gross weight
    
    - FM changed some biases
    
    - Added weights to every magazine
    
    - Added FCR weight to b2e(radar) Apache

[33mcommit e3c5434b942c684e9abe791a16714cd5cdbef719[m
Author: Keplager <Sapphire823@gmail.com>
Date:   Tue Jan 29 20:40:03 2019 -0500

    Changes to IHADSS, eng page, and flight model
    
    - Changed IHADSS torque calculation to reflect changes in FM engine performance.
    
    - Changed FM to reflect updated engine data
    
    - Decreased gain values on SAS rotational dampers.
    
    - Changed math and data sources on "eng" MPD page to reflect actual engine status better.

[33mcommit 8709c36e1eaad8e98d9935164c0ce735760fcf10[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jan 20 00:32:41 2019 +0100

    Update

[33mcommit 04aea2f43e528964cbb44deb114819b285d7f14c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Dec 8 13:41:42 2018 +0100

    Update

[33mcommit 54172ed32593b3b3304801debd324de96a233aa5[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Dec 7 19:38:58 2018 +0100

    Update

[33mcommit 3abae4e49bbf344f1689419ddbe5e1b67e8b8777[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Dec 4 14:20:29 2018 +0100

    Update

[33mcommit 963d9ffed69980418bd6a6cfe8753f024a683cc3[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Dec 2 23:35:26 2018 +0100

    Update

[33mcommit c016fdf17f9cc7d1ec96e7622681cfde3142ca15[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Oct 6 15:06:49 2018 +0200

    Update

[33mcommit d3d194908f8d821d319ef609755fea65170bc90d[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Sep 28 21:39:11 2018 +0200

    Update

[33mcommit 473d5bcefc035d2bbf09f4f3c81b490c1f77b183[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Sep 28 19:23:19 2018 +0200

    Update

[33mcommit d79c332c3d6ef73043f563961d9bc7fbde05f5e1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Sep 17 19:59:27 2018 +0200

    Update AFM

[33mcommit aa51c6fed6a62f7de008265ef7856f5158974ad1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Sep 17 19:58:14 2018 +0200

    Update AFM

[33mcommit 22a11b01a4f0eb61314f5991694bb3adddddad93[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Sep 16 15:22:43 2018 +0200

    Update

[33mcommit 10998bb6b9872cd4f3ce7a404ca91f36193d899c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Sep 2 16:57:13 2018 +0200

    Update

[33mcommit eb8a0386efd6e5c4eacd5040752119a3944fcaf1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Sep 2 04:39:27 2018 +0200

    Update

[33mcommit 21ea3832a1be1a3b522aafb8a5a375ca817004ca[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 26 11:54:27 2018 +0200

    Update

[33mcommit d925d8c2fa8cb86d3f4cf3c9d1dfed150e2acd0e[m
Merge: 31be17a71 d1410d310
Author: Sacha 'Voodoo' Oropeza <osacha@free.fr>
Date:   Fri Aug 10 23:15:18 2018 +0200

    Merge pull request #34 from YannikH/master
    
    config cleanup, fza_ah64_apuon bugfix & monocle fix

[33mcommit d1410d310d8e07d44530acc7fd69f87c4045fb74[m
Author: Yannik Hegge <yannikhegge@gmail.com>
Date:   Fri Aug 10 23:10:19 2018 +0200

    config file cleanup: config.cpp split up in to separate files
    
    fza_ah64_apuon not defined error in ahspawns.sqf fixed
    
    monocle only visible in VIEW==INTERNAL (1st person, no sights)

[33mcommit 31be17a712309959e9e4b4f5a8d7e2e06dee4ca2[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Aug 6 02:01:23 2018 +0200

    Update

[33mcommit f39a550959ff6d2240ef3a527b44e9928607900f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 5 19:27:13 2018 +0200

    Update

[33mcommit 17e0faea093188ae72b57a4a72a74fe7d5a62946[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jul 29 19:01:28 2018 +0200

    Update

[33mcommit 3a3a25bca05b00ceefd30119f505652f126693d7[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Jul 26 19:26:05 2018 +0200

    Update

[33mcommit 2757df8ab583954f39512b149fc38cc7ad6da757[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jul 22 13:25:13 2018 +0200

    Update

[33mcommit f79bc14b69e73462c2fa135b33b72c1e5a05eb5b[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jul 22 12:28:58 2018 +0200

    Update
    
    - Restored ability for CPG to take controls.
    - Fixed CPG POV and hands position.
    - Minor fix to Optical Relay Tube (ORT) 3D model.
    - Added ingame monocle. (w/ Keplager)
    - Removed vanilla UI lock box.
    - Removed green cursor upon 3rd person.
    - Fixed GUN azimuth limit on HMD ACQ. (w/ Jamo)
    - Reworked TADS informations display.
    - Added RKT FXD symbology.
    - Reworked TADS DTV colors.
    - Disabled PNVS view if not enough electrical power.

[33mcommit c612ae4d5405f05fd029dd6222557c97eba4ec41[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Wed Jul 11 22:15:19 2018 +0200

    Update

[33mcommit 593cb579bcf51c9cbc93b63fb69d938d3fc76824[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Jul 10 22:57:12 2018 +0200

    Update

[33mcommit c3b1f4c0a2429f715d6cb8f53d7e8ff742b5c79a[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Jun 11 20:42:31 2018 +0200

    Update

[33mcommit d59d1e2f95417353d3c02082fa96b615c4ff6577[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Jun 11 20:39:28 2018 +0200

    Fixed gun ammo count

[33mcommit 40d092bf623a5251cafba65e377fb45c99d1d50a[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Apr 29 14:02:27 2018 +0200

    Update

[33mcommit bc442acaadc5f1aeaf6024ad049d74c67c7eea55[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Apr 13 23:33:00 2018 +0200

    Update

[33mcommit 9d317b794ca3f4fbefaaaa1783bd8d357759efa1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Apr 13 23:24:02 2018 +0200

    Update

[33mcommit 5b33e93f7a37d40ee6178d3e98435c335fd8f4f2[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Apr 13 23:05:23 2018 +0200

    Update

[33mcommit 0cb975e20f8aadc2a91c5ea99a88c3b034a7ba71[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Apr 8 14:32:51 2018 +0200

    Update

[33mcommit 540b8d11ca907084b6038ef85aa74407e32ee9d3[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Apr 8 04:23:15 2018 +0200

    Update

[33mcommit 78a30ba3c7f6315e82bf0205ba4d1fdecc7abb4f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Apr 8 04:16:57 2018 +0200

    Update

[33mcommit ef8c1afa0f22682e0d45c4e63b4f153af7222036[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Wed Apr 4 23:33:24 2018 +0200

    Added key files

[33mcommit a834315220c46f0243ecf287b04dc036610b83d9[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Wed Apr 4 02:04:36 2018 +0200

    Update

[33mcommit d1e4f15a102ce26ff7094415a8fe00e34d5d1adc[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 2 17:28:29 2018 +0200

    Changelog

[33mcommit e53c11c1c406abe446a9fd18e5dea2d88301637d[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 2 17:24:29 2018 +0200

    ENG page rework

[33mcommit 211814c04a4e3cc59c8adb1e3279d2fc9ebf03ed[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 31 16:50:34 2018 +0200

    Update

[33mcommit ab300a11e1c9440969d7634bc7effac6a9a89d11[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Mar 12 00:36:21 2018 +0100

    Update

[33mcommit b217bd4bf036822c40bac14ab0e455fc62a33f31[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 11 23:08:33 2018 +0100

    Updated

[33mcommit 3e7e8807e26211e1a695a54b3ddf7484b514df7c[m
Merge: 517262864 71948fceb
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Sep 19 18:21:37 2017 +0200

    Merge pull request #32 from blindbat2006/master
    
    CFGMarker error

[33mcommit 71948fcebb82234fdabd8c463caf1f3e9289d8bc[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Tue Sep 19 12:41:04 2017 +0100

    CFGMarker error
    
    When placing an PFZ error on screen ref marker "DOT". Changed to A3 standard "mil_dot".

[33mcommit 517262864a6a25d2794dcd1aec6e7cb7cba3f446[m
Merge: 18acc0efb 5d8aa46bb
Author: Sacha Oropeza <osacha@free.fr>
Date:   Wed Aug 30 00:53:05 2017 +0200

    Merge pull request #31 from blindbat2006/master
    
    Arming Menu (Quick fix).

[33mcommit 5d8aa46bb2256311aa88a132ed67fae20be32664[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Mon Aug 28 10:13:11 2017 +0100

    Engine on startup time.
    
    Increased the engine on starup time from default value to 60 secs. Fully spooled should take approx 60 secs. Just a test for yourself to see if it is worth having a look at.

[33mcommit df8b9e513e4f8f7df43b58d6fcc2b1d382a55fc0[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Mon Aug 28 09:51:47 2017 +0100

    Arming Menu.
    
    Quick fix for the arming menu not showing. Tested by myself but would require further testing.

[33mcommit 18acc0efb5efcce18d06fa873a149da01d1ec6e5[m
Merge: 0d6687985 111dfaf51
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Aug 24 00:02:08 2017 +0200

    Merge pull request #30 from blindbat2006/master
    
    CPG heads down display updated. Laser toggle

[33mcommit 111dfaf516894a1360425bf5edb9c527caf0dffc[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Wed Aug 23 22:49:30 2017 +0100

    CPG heads down display updated. Laser toggle
    
    CPG heads down display updated fov box moved. Laser toggle updated (user key could be removed now but awaiting further testing) In Plt seat user action key to arm laser (in WPN page) then toggle gun control and then scroll wheel "Manual fire" and user key again will toggle laser on/off at this point.
    
    So conditions for laser in PLT is WPN page,Toggle gun contol, Manual fire.
    
    Conditions for CPG laser is just WPN page.

[33mcommit 0d6687985171e6dbd89503e9010a3662f4ccf7d8[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Aug 22 22:18:50 2017 +0200

    Update changelog

[33mcommit 47a3c0604ae5abaa4a48e3d15bba8aa78c120631[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Aug 22 22:15:36 2017 +0200

    Added new interior sounds and various tweaks

[33mcommit 672ac4c4b8ef5c304409029a5cc4a0626b31f231[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Aug 21 21:35:03 2017 +0200

    Update changelog

[33mcommit 8cb719530964d8247c01bb98d7d16c77756a39d0[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Aug 21 21:30:12 2017 +0200

    Overall sounds fix

[33mcommit ef58ed14916adb7628cb0df05ce1ee3b247645d2[m
Merge: 553086e8c 5ea0e1a98
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Aug 21 19:33:27 2017 +0200

    Merge pull request #29 from blindbat2006/master
    
    CPG head down display resize/Predicted Impact Point and Laser toggle updates/APU Sound

[33mcommit 5ea0e1a980a431eb0027b5a36467bb5b104a9464[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Mon Aug 21 13:47:07 2017 +0100

    APU Sound
    
    Reduced levels by -6db and lenght from 4m45sec to 1m30secs

[33mcommit 15cd4fd0c9ffa0d00b5e007f8b69fdd524536786[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Mon Aug 21 13:45:35 2017 +0100

    Predicted Impact Point and Laser toggle updates.
    
    Removed the old PIP with the vanilla. Removed the User key 10 as user key 5 toggles also when laser is turned off a refresh of the ihadss is done to update laser display.

[33mcommit 22a37342b903dd95a20e11fb9068092c20ef10bf[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Mon Aug 21 13:40:00 2017 +0100

    CPG head down display resize
    
    Made the main display when head down bigger and same with laser on display

[33mcommit 553086e8c4f18d437b4d18dfe7676cfbe4890a04[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 20 17:59:32 2017 +0200

    Update README.md

[33mcommit 20b526f8d776439581bbfa7e367fb9205b35d197[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 20 17:53:40 2017 +0200

    Added laser system keybindings

[33mcommit 559319256d89fed0b48b6fdf349e8ff637504204[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 20 17:51:45 2017 +0200

    Added laser system keybindings

[33mcommit 2ed87ecbc5b5486cc0b10f948b42c1ec5deb8f6e[m
Merge: 0138540e3 6e862ff18
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 20 17:45:39 2017 +0200

    Merge pull request #28 from blindbat2006/master
    
    Updated gunnerview optics

[33mcommit 6e862ff1855ab2dbb43b6b5043352bcb64bce7ff[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Sun Aug 20 13:45:52 2017 +0100

    Updated gunnerview optics
    
    FOV box change and added some small tweaks to the crosshairs

[33mcommit 0138540e3d0bef2c061460ce858fc6286f602551[m
Merge: f98868c06 45098031c
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Aug 20 03:42:06 2017 +0200

    Merge pull request #27 from blindbat2006/master
    
    Resize "Laser On" in gunnerview

[33mcommit 45098031cb00e7dad29e08394bb84c4670fb1c9d[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Sun Aug 20 01:13:45 2017 +0100

    Resize "Laser On" in gunnerview

[33mcommit f98868c06611d1769861627f3a25350e7a6de600[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Aug 19 20:43:01 2017 +0200

    Update Changelog

[33mcommit a9df3ba923b1a6708db46975ce6751ad063e6697[m
Merge: e20259549 1756ce0ec
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Aug 19 14:35:26 2017 +0200

    Merge pull request #26 from blindbat2006/master
    
    "laser on" symbology

[33mcommit 1756ce0eca441d0cd4c66b9d3286ac9a35402034[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Sat Aug 19 13:06:45 2017 +0100

    "laser on" symbology
    
    Proper "laser on" symbology display while CPG is head down in RTO.

[33mcommit e202595493c3f02a2e70d25559f1bb531d7ccf56[m
Merge: e88f74ae6 1538dce84
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Jul 23 18:50:56 2017 +0200

    Merge pull request #25 from blindbat2006/master

[33mcommit 1538dce84a7fa796862d800a8064a67fc738da03[m
Author: Jamo [4IB] <walt@blindbats.net>
Date:   Sun Jul 23 13:50:04 2017 +0100

    PNVS mouse control slowed down
    
    When using mouse in the pnvs camera movement decreased.

[33mcommit e88f74ae65aa059dd0a2c120107cc9987b11e099[m
Merge: 063fe2863 04d393661
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Jul 22 20:27:53 2017 +0200

    Merge pull request #24 from blindbat2006/master

[33mcommit 04d393661aef494f85753a94782e6bc862d3ffad[m
Author: Jamo[4IB] <walt@blindbats.net>
Date:   Sat Jul 22 11:43:19 2017 +0100

    Removed vanilla locking display
    
    Removed vanilla locking display. Needs more testing I have only done 4
    hours testing so far.

[33mcommit 063fe2863f450882d35a24c0dcad8a575271b404[m
Merge: 12c42bbc5 47ff475f7
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Jul 11 10:26:35 2017 +0200

    Merge pull request #23 from blindbat2006/master

[33mcommit 47ff475f7a3c6bda58f0d7075bc73c6e3e857d8a[m
Author: Jamo <walt@blindbats.net>
Date:   Tue Jul 11 01:52:38 2017 +0100

    Short term fix for FCR
    
    Changed default "NAV" mode to "ATK" on heli init.

[33mcommit ceb8c533a6e1a94f85213608a6845ae96aea0024[m
Author: Jamo <walt@blindbats.net>
Date:   Tue Jul 11 01:48:55 2017 +0100

    Engine sounds lowered
    
    Lowered int/ext on startup and shutdown. Reduced by about 30%

[33mcommit f857d0b5a7af2cddab15769cb15a9470aeed1538[m
Author: Jamo <walt@blindbats.net>
Date:   Tue Jul 11 01:40:08 2017 +0100

    RPT spam
    
    Added ace_frag_skip to 30mm cannon and all missiles to stop rtp spamming.

[33mcommit 12c42bbc535e301070b8440b31aba9ebf90c5ab9[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 3 22:38:34 2017 +0200

    CPG NVG Update

[33mcommit 1c612ffbe77fd5cb4675b4c33460fc86a97dbbec[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 3 22:27:33 2017 +0200

    CPG NVG Update

[33mcommit a159e8fdb2afeefcf53d1474e723f158b95837d6[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Apr 3 22:23:11 2017 +0200

    CPG NVG Update

[33mcommit 8a5cd35be671c7e59670d7c257a584cec4942837[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Mar 21 22:01:37 2017 +0100

    Updated flares pattern

[33mcommit d545666de359a3d2d53a243afd195e936c27f74e[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Mar 20 23:08:27 2017 +0100

    Changelog update

[33mcommit 40f43ed62e0e92fc7f70f2f28ce7440f7180541d[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Mar 20 23:01:26 2017 +0100

    Added internal lights

[33mcommit 67835217c9e43ba3f652d70cd604d0c3bf96f9ee[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 20:22:57 2017 +0100

    External lights tuning
    
    Strobes intensity + landing lights.

[33mcommit 49bec9f0504a05429aa377387fd8e65a04b7984f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 15:22:10 2017 +0100

    Added 1.43+ files

[33mcommit 74cbfe39624e773dea3683c566f3a62223c39aab[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 15:17:13 2017 +0100

    Removed 1.42+

[33mcommit 4283f5ed18f31c4c515a48ca70080e912c917559[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 15:14:13 2017 +0100

    Test ajouté

[33mcommit df1e5d13517d09e49f4efbc2309cea7614c39ca2[m
Merge: 04d2bf57a b583d7b22
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 14:24:14 2017 +0100

    Merge pull request #13 from SachaOropeza/dev
    
    Delete readme_nod_fza_ah64_v142_source.txt

[33mcommit b583d7b22d1231695f789d160d9b68884a8b7801[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 13:47:52 2017 +0100

    Delete readme_nod_fza_ah64_v142_source.txt

[33mcommit 04d2bf57a82988b728765f73b90513e2f4d72d87[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 13:43:33 2017 +0100

    Delete readme_nod_fza_ah64_v142_source.txt

[33mcommit 40b7fef3442f424732a3f66bb6a8a6b9f9e438c0[m
Merge: fb171ad2d 1ae6d1f54
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 04:22:26 2017 +0100

    Merge pull request #12 from SachaOropeza/dev
    
    Dev

[33mcommit 1ae6d1f5480eadc1b99f189bc00d841ee536bb6a[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 04:05:58 2017 +0100

    Update README.md

[33mcommit 1599408db632254fb4ac4ef4e01201ebf4825e86[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 03:58:58 2017 +0100

    Add files via upload

[33mcommit 3d4ac1f29e00371eb7dba2d83278d9725ba31d71[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Mar 19 03:26:50 2017 +0100

    Add files via upload

[33mcommit fb171ad2d1ff0471c6b05bf67840a866e04fc756[m
Merge: 5b2670ac5 bd21034a2
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:36:21 2017 +0100

    Merge pull request #8 from SachaOropeza/dev
    
    Dev

[33mcommit bd21034a2421f7a2b8b99b860690f568cb107c04[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:31:19 2017 +0100

    Update README.md

[33mcommit 64a9027edbdd7bd830fbd77d13c5084c6494f373[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:26:14 2017 +0100

    Add files via upload

[33mcommit 5d7c042cf2e5e6926f711aafada36e717aa85067[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:25:43 2017 +0100

    Delete ah64_estop2a.ogg

[33mcommit 7fb258d485132279562ee59ebaaf69083bfbca17[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:25:12 2017 +0100

    Delete ah64_estart2a.ogg

[33mcommit cd2335cbfbf756ba2d7669a511114e06bc7a2c35[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:21:52 2017 +0100

    Update ah64d_init.sqf

[33mcommit 80e3d28a1337d312d70ff85d99ce292678723bf0[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 19:20:44 2017 +0100

    Update config.cpp

[33mcommit 5b2670ac5ef09ef41aa9bf0f3524b1d45cfb61a8[m
Merge: bb1c479ef 01386e9f5
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:42:23 2017 +0100

    Merge pull request #7 from SachaOropeza/dev
    
    Dev

[33mcommit 01386e9f5eae7b2b7a586bfac9de021caba33cd9[m
Merge: 36c8c52a8 bb1c479ef
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:42:11 2017 +0100

    Merge branch 'master' into dev

[33mcommit 36c8c52a8622952c67a3ed8a614b06a8bb8b37f0[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:40:04 2017 +0100

    Update config.cpp

[33mcommit c8b962c28c2030b6c8ea496513dfab28ed96cf8c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:28:59 2017 +0100

    Update README.md

[33mcommit dda669d4107531291ce9f6cc58053f4d233d0145[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:21:58 2017 +0100

    Update nextwp2.sqf

[33mcommit ef2df2d7ab7142d4e59d4e290d4cd36779ed571e[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 06:21:09 2017 +0100

    Update config.cpp

[33mcommit bb1c479ef985067b4839e11b7d4078f34bc1afb5[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 02:09:37 2017 +0100

    Update nextwp2.sqf

[33mcommit f81eff414742c59a3f957cfd661600d94de3c35f[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sat Mar 11 02:09:17 2017 +0100

    Update nextwp2.sqf

[33mcommit 07349fae6dd169897d43949a08c38f24c9ccb861[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:49:02 2017 +0100

    Update README.md

[33mcommit 0275befce70e49b4b3c19b8249938ef4722a49e4[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:48:22 2017 +0100

    Update README.md

[33mcommit 47bdee4da98cb2cf7b6037a07be2326d875093a3[m
Merge: aeed11982 26f9aa0bc
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:45:27 2017 +0100

    Merge pull request #6 from SachaOropeza/dev
    
    Dev

[33mcommit 26f9aa0bc3ef81381422932dd387062c6117a112[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:43:21 2017 +0100

    Update README.md

[33mcommit cf852696458452799370d47f616a8e36db842339[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:39:22 2017 +0100

    Update README.md

[33mcommit 360e3f75d066ce208d1801b1836ca42ecf1aa95b[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 16:20:21 2017 +0100

    Update config.cpp

[33mcommit 512a38471dd0f71e2205e258b33fa3c27a10d4db[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:36:48 2017 +0100

    Update arming.sqf

[33mcommit ce138f4edb808f4f8823b5da708875f64db9fee7[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:35:28 2017 +0100

    Add files via upload

[33mcommit d5cd6584892401188acb8c52a26e0bbd52bc5fe2[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:34:33 2017 +0100

    Update ah64d_init.sqf

[33mcommit 24defcbdb2b1621c7e94fe2f1643ee7a3c778bf6[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:33:56 2017 +0100

    Update fcr_longbow.sqf

[33mcommit 4be22a4ab507e86ea9e57c21d2a72b778c15eaab[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:29:26 2017 +0100

    Update config.cpp

[33mcommit 8066bfcda50caa77cf809efb220bd04f68b7d3bc[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:27:01 2017 +0100

    Add files via upload

[33mcommit b827a9de697a4bc1cbc09a697e28060b97f66472[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Mar 10 15:26:43 2017 +0100

    Delete ah64_estart2a.ogg

[33mcommit 6dd832e96ff4daad8db11c5a5e98d7f4772d60ae[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Mar 6 10:38:29 2017 +0100

    Update ah64d_init.sqf

[33mcommit 70c141e9f94ba65222858f76abb0dd245744c34b[m
Author: ShiftyFR <n.chapuis551@gmail.com>
Date:   Thu Mar 2 23:09:59 2017 +0100

    Update ah64d_init.sqf
    
    _heli animate ["tads_stow",0];

[33mcommit aeed11982326fb1657c5096aa4d08ec5b534bdf0[m
Merge: d38c58752 2ac0a4654
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:57:44 2017 +0100

    Merge pull request #5 from SachaOropeza/dev
    
    Dev

[33mcommit 2ac0a4654c9b01e93b3f87e06cf9aab788867d78[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:52:39 2017 +0100

    Update ah64d_init.sqf

[33mcommit a538c0d72abbccd69dd1b01e959815f91b384cc3[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:49:37 2017 +0100

    Update README.md

[33mcommit b2f7e02216cc88bd46a184c0d3bfd258d5a2f0f0[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:35:04 2017 +0100

    Update config.cpp

[33mcommit 7a19e546b6f27dde5f62a22d6df16b712e396731[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:11:01 2017 +0100

    Add files via upload

[33mcommit e4a8f32b04d2a7870ae82bcd3a784e5404b29d28[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:04:46 2017 +0100

    Add files via upload

[33mcommit 4118954a7a828007e55fe58cad17cbf6c339252e[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 22:00:58 2017 +0100

    Add files via upload

[33mcommit 645e2fcede41e94001e41d918dcb4829bfed4651[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 21:52:06 2017 +0100

    Add files via upload

[33mcommit a4627a579f93dbeeb5dfd7a94b7ec7ed8504cc29[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 21:48:28 2017 +0100

    Delete fza_ah64_us.pbo.fza.bisign

[33mcommit f44fb149ed819d0164cdf36e6ad84adcab646186[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 21:48:20 2017 +0100

    Delete fza_ah64_controls.pbo.fza.bisign

[33mcommit f8109cdd53af8b6415884da2d98a6dc1672000d4[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 21:47:43 2017 +0100

    Update fza_ah64d_blockii_exp.xml

[33mcommit a66720863a6c8ca29b31a51d878e69be30f14db5[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Fri Feb 24 21:44:20 2017 +0100

    Update config.cpp

[33mcommit 758045d6b1839d17650675fce65e1823b4407cd1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 23 23:18:56 2017 +0100

    Update README.md

[33mcommit 03f46e71db1a126031d5e37a9ea4570c56b18472[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 23 22:52:53 2017 +0100

    Add files via upload

[33mcommit a269768e3e4863869be88ba25573899b18f433b8[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 23 22:36:13 2017 +0100

    Delete fza_ah64d_blockii.xml

[33mcommit b98b1d2af34a1e173b465a983e7edd07e03e2033[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 23 22:35:15 2017 +0100

    Add files via upload

[33mcommit e2c4a297b8a769ad5656cb5663acb333f1b2a927[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Thu Feb 23 22:33:40 2017 +0100

    Update config.cpp

[33mcommit d38c58752f41ca40a82886999ec6775ef48d37f2[m
Merge: 489d4a98e e7d9caa08
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Feb 21 00:02:41 2017 +0100

    Merge pull request #4 from SachaOropeza/dev
    
    Dev

[33mcommit e7d9caa08e79f9c25728bc299d4f8eb3da4beabf[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Feb 21 00:00:36 2017 +0100

    Update README.md

[33mcommit 773a12ce669362948eca6f59ce4667a5896241c3[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Tue Feb 21 00:00:24 2017 +0100

    Update README.md

[33mcommit ff83f38135b83b51763a7171f6885947c11c771c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Feb 20 23:59:55 2017 +0100

    Update README.md

[33mcommit 36ea68a48de6c3177d14c8ecf880eccab4cab91c[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Feb 20 23:50:44 2017 +0100

    Update config.cpp

[33mcommit 480ca56293f893ee0137327d9361bd465a8a3af1[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Mon Feb 20 23:44:42 2017 +0100

    Add files via upload

[33mcommit e7b47fd732d07ce7e9d6195aeb0a125da39d3f8a[m
Author: ShiftyFR <n.chapuis551@gmail.com>
Date:   Mon Feb 20 23:38:30 2017 +0100

    Add files via upload
    
    Fix error "Cannot load material file fza_ah64_us\tex\in\prime.rvmat"

[33mcommit 489d4a98ee07d18af7e90136b2b12399cc2288cf[m
Merge: 91ec6f795 9344ea340
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 03:09:46 2017 +0100

    Merge pull request #2 from SachaOropeza/dev

[33mcommit 9344ea3405af76eadf12d8957eeea363f25ecee4[m
Merge: c8f328443 91ec6f795
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 03:09:06 2017 +0100

    Merge branch 'master' into dev

[33mcommit 91ec6f795bb4d8e66cca2b519584b651124ea1c9[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 03:07:36 2017 +0100

    Create README.md

[33mcommit 3fc1348e31cb1bcafd5792a2f596c7ed22ab48d4[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 03:04:35 2017 +0100

    Delete README.md

[33mcommit c8f328443ae735779db46a8ed3025ef77a703701[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 03:01:52 2017 +0100

    Update README.md

[33mcommit 2dea9191d39e0f5bcb9cca13ccc9fea6702078dd[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 02:57:58 2017 +0100

    Update README.md

[33mcommit 96dc83f8f6c3c0707d05cd38f30b21b1df64c2cc[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 02:52:47 2017 +0100

    Edited config.cpp - 19/02/2017
    
    External flyby distance sound added.

[33mcommit 5ab3c6bd80e1b42368c1d94540dab4fb8aa41993[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 02:51:27 2017 +0100

    Delete config.cpp

[33mcommit feacfa68dfcce484f4a44db13a461af747f87c55[m
Author: Sacha Oropeza <osacha@free.fr>
Date:   Sun Feb 19 02:50:20 2017 +0100

    Added Rotor_far.ogg + Engine_Far.ogg
    
    External helicopter distance sounds.

[33mcommit 1083ba9740a985b2de3290a3fc22dc83e3a3089c[m
Merge: 3d2e21f6e e500c6e79
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 04:10:36 2017 +0100

    Merge pull request #1 from SachaOropeza/dev
    
    Update README.md

[33mcommit 3d2e21f6ef551d12f033b1ba99b764812be57375[m
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 01:25:06 2017 +0100

    Set theme jekyll-theme-cayman

[33mcommit e500c6e799998b06f4ff6ab4c0383102bbb14e2b[m
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 01:20:51 2017 +0100

    Update README.md

[33mcommit d780939efc950c90c7092e892d1f76d9c723e43e[m
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 01:03:48 2017 +0100

    Create README.md

[33mcommit 14adf3cd27568bba71ef2950518eb01693b45256[m
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 00:33:21 2017 +0100

    Added Source Files

[33mcommit 5e1906f6e373712bd89c618cc0552f6b66134133[m
Author: SachaOropeza <osacha@free.fr>
Date:   Sun Feb 12 00:22:20 2017 +0100

    :tada: Added .gitattributes & .gitignore files
